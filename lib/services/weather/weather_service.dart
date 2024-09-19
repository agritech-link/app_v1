import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WeatherService {
  final String apiKey;
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/forecast';
  static const String CACHE_KEY = 'weather_cache';
  static const Duration CACHE_DURATION = Duration(hours: 2);

  DateTime? _lastLoginDate;

  late SharedPreferences _prefs;
  WeatherForecastData? _cachedData;
  DateTime? _lastFetchTime;

  final SupabaseClient _supabase = Supabase.instance.client;

  WeatherService({required this.apiKey});

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadFromPrefs();
  }

  void _loadFromPrefs() {
    final String? cachedJson = _prefs.getString(CACHE_KEY);
    if (cachedJson != null) {
      final Map<String, dynamic> cached = json.decode(cachedJson);
      _cachedData = WeatherForecastData.fromJson(cached['data']);
      _lastFetchTime = DateTime.parse(cached['timestamp']);
      _lastLoginDate = DateTime.tryParse(cached['lastLoginDate'] ?? '');
    }
  }

  Future<void> _saveToPrefs(WeatherForecastData data) async {
    final String cachedJson = json.encode({
      'data': data.toJson(),
      'timestamp': DateTime.now().toIso8601String(),
      'lastLoginDate': DateTime.now().toIso8601String(),
    });
    await _prefs.setString(CACHE_KEY, cachedJson);
  }

  Future<Map<String, dynamic>> getWeatherForecast() async {
    try {
      Position position = await _getCurrentLocation();
      final response = await http.get(Uri.parse(
          '$baseUrl?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=$apiKey'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather forecast');
      }
    } catch (e) {
      throw Exception('Error getting weather forecast: $e');
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

  Future<WeatherForecastData> getWeatherForecastData() async {
    if (_shouldFetchNewData()) {
      try {
        final weatherData = await getWeatherForecast();
        final newData = WeatherForecastData.fromApiResponse(weatherData);
        _cachedData = newData;
        _lastFetchTime = DateTime.now();
        await _saveToPrefs(newData);
        await _updateFarmWeatherData(newData);
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

  Future<void> _updateFarmWeatherData(WeatherForecastData forecastData) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final farmResponse = await _supabase
          .from('Farms')
          .select()
          .eq('user_id', user.id)
          .single();

      if (farmResponse == null) throw farmResponse.isEmpty;

      final farmId = farmResponse['id'];

      await _supabase.from('weather_data').insert({
        'farm_id': farmId,
        'timestamp': DateTime.now().toIso8601String(),
        'temperature': forecastData.currentTemp,
        'humidity': forecastData.currentHumidity,
        'precipitation': forecastData.currentPrecipitation,
        'wind_speed': forecastData.currentWindSpeed,
        'wind_direction': forecastData.currentWindDirection,
      });
    } catch (e) {
      print('Error updating farm weather data: $e');
    }
  }
}

class WeatherForecastData {
  final List<DailyForecast> dailyForecasts;
  final int currentTemp;
  final int currentHumidity;
  final double currentPrecipitation;
  final int currentWindSpeed;
  final int currentWindDirection;

  WeatherForecastData({
    required this.dailyForecasts,
    required this.currentTemp,
    required this.currentHumidity,
    required this.currentPrecipitation,
    required this.currentWindSpeed,
    required this.currentWindDirection,
  });

  factory WeatherForecastData.fromApiResponse(Map<String, dynamic> json) {
    final List<dynamic> list = json['list'];
    final List<DailyForecast> forecasts = list.take(5).map((item) => DailyForecast.fromJson(item)).toList();

    return WeatherForecastData(
      dailyForecasts: forecasts,
      currentTemp: list[0]['main']['temp'].round(),
      currentHumidity: list[0]['main']['humidity'].round(),
      currentPrecipitation: list[0]['rain']?['3h'] ?? 0.0,
      currentWindSpeed: list[0]['wind']['speed'].round(),
      currentWindDirection: list[0]['wind']['deg'].round(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dailyForecasts': dailyForecasts.map((forecast) => forecast.toJson()).toList(),
      'currentTemp': currentTemp,
      'currentHumidity': currentHumidity,
      'currentPrecipitation': currentPrecipitation,
      'currentWindSpeed': currentWindSpeed,
      'currentWindDirection': currentWindDirection,
    };
  }

  factory WeatherForecastData.fromJson(Map<String, dynamic> json) {
    return WeatherForecastData(
      dailyForecasts: (json['dailyForecasts'] as List).map((item) => DailyForecast.fromJson(item)).toList(),
      currentTemp: json['currentTemp'],
      currentHumidity: json['currentHumidity'],
      currentPrecipitation: json['currentPrecipitation'],
      currentWindSpeed: json['currentWindSpeed'],
      currentWindDirection: json['currentWindDirection'],
    );
  }
}

class DailyForecast {
  final DateTime date;
  final int tempMax;
  final int tempMin;
  final String condition;
  final double precipitation;
  final int windSpeed;

  DailyForecast({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.condition,
    required this.precipitation,
    required this.windSpeed,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      tempMax: json['main']['temp_max'].round(),
      tempMin: json['main']['temp_min'].round(),
      condition: json['weather'][0]['main'],
      precipitation: json['rain']?['3h'] ?? 0.0,
      windSpeed: json['wind']['speed'].round(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'tempMax': tempMax,
      'tempMin': tempMin,
      'condition': condition,
      'precipitation': precipitation,
      'windSpeed': windSpeed,
    };
  }
}
