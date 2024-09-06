import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final int temperature;
  final String condition;
  final int humidity;
  final double precipitation;
  final int windSpeed;

  const WeatherCard({
    Key? key,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.precipitation,
    required this.windSpeed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.wb_sunny,
                  color: Colors.orange,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  '$temperature°C $condition / Today',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildWeatherInfo('Humidity', '$humidity%'),
                _buildWeatherInfo('Precipitation', '${precipitation}mm'),
                _buildWeatherInfo('Wind', '${windSpeed}m/s'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        )
      ],
    );
  }
}
