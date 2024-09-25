import 'package:AgriTech_Link/const.dart';
import 'package:AgriTech_Link/custom_widgets/crop_health_card.dart';
import 'package:AgriTech_Link/custom_widgets/custom_bottom_navbar.dart';
import 'package:AgriTech_Link/custom_widgets/marketplace_item.dart';
import 'package:AgriTech_Link/custom_widgets/weather/weather_card.dart';
import 'package:AgriTech_Link/screens/dashboard/crops_screen.dart';
import 'package:AgriTech_Link/screens/dashboard/marketplace/my_store.dart';
import 'package:AgriTech_Link/services/greeting_service.dart';
import 'package:AgriTech_Link/services/payments/pawapay_service.dart';
import 'package:AgriTech_Link/services/weather/notification_service.dart';
import 'package:AgriTech_Link/services/weather/weather_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final WeatherService _weatherService =
  WeatherService(apiKey: OPENWEATHER_API_KEY);
  WeatherForecastData? _weatherData;
  bool _isLoadingWeather = true;
  final GreetingService _greetingService = GreetingService();
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.init();
    _notificationService.triggerTestNotification();
  }

  Future<void> _fetchWeatherData() async {
    setState(() {
      _isLoadingWeather = true;
    });
    try {
      final data = await _weatherService.getWeatherForecastData();
      setState(() {
        _weatherData = data;
        _isLoadingWeather = false;
      });
    } catch (e) {
      print('Error fetching weather data: $e');
      setState(() {
        _isLoadingWeather = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: Text(
          _greetingService.getGreeting(),
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              // Handle notification button press
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Handle more options button press
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WeatherCard(
                temperature: _weatherData?.currentTemp,
                condition: _weatherData?.dailyForecasts.first.condition,
                humidity: _weatherData?.currentHumidity,
                precipitation: _weatherData?.currentPrecipitation,
                windSpeed: _weatherData?.currentWindSpeed,
                isLoading: _isLoadingWeather,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Crop Health', onViewAllPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CropsScreen()));
              }),
              const SizedBox(height: 8),
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CropHealthCard(
                        cropName: 'Tomato',
                        scanDate: '20 June, 2024',
                        health: 'Early blight',
                        healthStatus: HealthStatus.warning),
                    SizedBox(width: 12),
                    CropHealthCard(
                        cropName: 'Wheat',
                        scanDate: '23, June 2024',
                        health: 'Healthy',
                        healthStatus: HealthStatus.good),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Marketplace', onViewAllPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyStore()));
              }),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: 200,
                      child: MarketplaceCard(
                        imageUrl:
                        'https://images.unsplash.com/photo-1534940519139-f860fb3c6e38?q=80&w=1167&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                        productName: 'Beefsteak tomato',
                        quantity: '10 Boxes',
                        price: '250.00',
                        pawaPayService: PawaPayService(apiToken: PAWAPAY_API_TOKEN),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 200,
                      child: MarketplaceCard(
                        imageUrl:
                        'https://images.unsplash.com/photo-1512070904629-fa988dab2fe1?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fGhhc3MlMjBhdm9jYWRvfGVufDB8fDB8fHww',
                        productName: 'Hass Avocado',
                        quantity: '38 Boxes',
                        price: '250.00',
                        pawaPayService: PawaPayService(apiToken: PAWAPAY_API_TOKEN),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 200,
                      child: MarketplaceCard(
                        imageUrl:
                        'https://images.unsplash.com/photo-1459663296021-50769c04b149?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8dGFuZ2VyaW5lJTIwb3JhbmdlfGVufDB8fDB8fHww',
                        productName: 'Tangerine Oranges',
                        quantity: '96 Boxes',
                        price: '250.00',
                        pawaPayService: PawaPayService(apiToken: PAWAPAY_API_TOKEN),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title,
      {required VoidCallback onViewAllPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onViewAllPressed,
          child: const Text('View all', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }
}
