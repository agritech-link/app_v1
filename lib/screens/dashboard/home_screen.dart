import 'package:AgriTech_Link/const.dart';
import 'package:AgriTech_Link/custom_widgets/crop_health_card.dart';
import 'package:AgriTech_Link/custom_widgets/custom_bottom_navbar.dart';
import 'package:AgriTech_Link/custom_widgets/marketplace_item.dart';
import 'package:AgriTech_Link/custom_widgets/weather_card.dart';
import 'package:AgriTech_Link/screens/dashboard/crops_screen.dart';
import 'package:AgriTech_Link/screens/dashboard/marketplace/market.dart';
import 'package:AgriTech_Link/services/greeting_service.dart';
import 'package:AgriTech_Link/services/weather_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final WeatherService _weatherService =
      WeatherService(apiKey: OPENWEATHER_API_KEY);
  WeatherCardData? _weatherData;
  bool _isLoadingWeather = true;
  final GreetingService _greetingService = GreetingService();

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    setState(() {
      _isLoadingWeather = true;
    });
    try {
      final data = await _weatherService.getWeatherCardData();
      setState(() {
        _weatherData = data;
        _isLoadingWeather = false;
      });
    } catch (e) {
      print('Error fetching weather data: $e');
      setState(() {
        _isLoadingWeather = false;
      });
      // You might want to show an error message to the user here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      appBar: AppBar(
        title: Text(
          _greetingService.getGreeting(),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              // Handle notification button press
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
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
                temperature: _weatherData?.temperature,
                condition: _weatherData?.condition,
                humidity: _weatherData?.humidity,
                precipitation: _weatherData?.precipitation,
                windSpeed: _weatherData?.windSpeed,
                isLoading: _isLoadingWeather,
              ),
              SizedBox(height: 24),
              _buildSectionTitle('Crop Health', onViewAllPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CropsScreen()));
              }),
              SizedBox(height: 8),
              SingleChildScrollView(
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
              SizedBox(height: 24),
              _buildSectionTitle('Marketplace', onViewAllPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Market()));
              }),
              SizedBox(height: 8),
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
                        price: 'K250.00 /Box',
                      ),
                    ),
                    SizedBox(width: 12),
                    SizedBox(
                      width: 200,
                      child: MarketplaceCard(
                        imageUrl:
                            'https://images.unsplash.com/photo-1512070904629-fa988dab2fe1?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fGhhc3MlMjBhdm9jYWRvfGVufDB8fDB8fHww',
                        productName: 'Hass Avocado',
                        quantity: '38 Boxes',
                        price: 'K250.00 /Box',
                      ),
                    ),
                    SizedBox(width: 12),
                    SizedBox(
                      width: 200,
                      child: MarketplaceCard(
                        imageUrl:
                            'https://images.unsplash.com/photo-1459663296021-50769c04b149?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8dGFuZ2VyaW5lJTIwb3JhbmdlfGVufDB8fDB8fHww',
                        productName: 'Tangerine Oranges',
                        quantity: '96 Boxes',
                        price: 'K250.00 /Box',
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
          // Handle navigation to different screens based on index
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onViewAllPressed,
          child: Text('View all', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }
}
