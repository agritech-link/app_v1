import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherService {
  final String apiKey;
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static const String CACHE_KEY = 'weather_cache';
  static const Duration CACHE_DURATION = Duration(hours: 2);

  late SharedPreferences _prefs;
  WeatherCardData? _cachedData;
  DateTime? _lastFetchTime;

  WeatherService({required this.apiKey});

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadFromPrefs();
  }

  void _loadFromPrefs() {
    final String? cachedJson = _prefs.getString(CACHE_KEY);
    if (cachedJson != null) {
      final Map<String, dynamic> cached = json.decode(cachedJson);
      _cachedData = WeatherCardData.fromJson(cached['data']);
      _lastFetchTime = DateTime.parse(cached['timestamp']);
    }
  }

  Future<void> _saveToPrefs(WeatherCardData data) async {
    final String cachedJson = json.encode({
      'data': data.toJson(),
      'timestamp': DateTime.now().toIso8601String(),
    });
    await _prefs.setString(CACHE_KEY, cachedJson);
  }

  Future<Map<String, dynamic>> getWeatherData() async {
    try {
      Position position = await _getCurrentLocation();
      final response = await http.get(Uri.parse(
          '$baseUrl?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=$apiKey'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error getting weather data: $e');
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<WeatherCardData> getWeatherCardData() async {
    if (_shouldFetchNewData()) {
      try {
        final weatherData = await getWeatherData();
        final newData = WeatherCardData(
          temperature: weatherData['main']['temp'].round(),
          condition: weatherData['weather'][0]['main'],
          humidity: weatherData['main']['humidity'].round(),
          precipitation: weatherData['rain']?['1h'] ?? 0.0,
          windSpeed: weatherData['wind']['speed'].round(),
        );
        _cachedData = newData;
        _lastFetchTime = DateTime.now();
        await _saveToPrefs(newData);
        return newData;
      } catch (e) {
        print('Error fetching weather data: $e');
        if (_cachedData == null) {
          rethrow;
        }
      }
    }
    return _cachedData!;
  }

  bool _shouldFetchNewData() {
    if (_cachedData == null || _lastFetchTime == null) {
      return true;
    }
    return DateTime.now().difference(_lastFetchTime!) > CACHE_DURATION;
  }
}

class WeatherCardData {
  final int temperature;
  final String condition;
  final int humidity;
  final double precipitation;
  final int windSpeed;

  WeatherCardData({
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.precipitation,
    required this.windSpeed,
  });

  factory WeatherCardData.fromJson(Map<String, dynamic> json) {
    return WeatherCardData(
      temperature: json['temperature'],
      condition: json['condition'],
      humidity: json['humidity'],
      precipitation: json['precipitation'],
      windSpeed: json['windSpeed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'condition': condition,
      'humidity': humidity,
      'precipitation': precipitation,
      'windSpeed': windSpeed,
    };
  }
}

