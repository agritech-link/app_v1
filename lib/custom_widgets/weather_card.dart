import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WeatherCard extends StatelessWidget {
  final int? temperature;
  final String? condition;
  final int? humidity;
  final double? precipitation;
  final int? windSpeed;
  final bool isLoading;

  const WeatherCard({
    Key? key,
    this.temperature,
    this.condition,
    this.humidity,
    this.precipitation,
    this.windSpeed,
    this.isLoading = false,
  }) : super(key: key);

  IconData _getWeatherIcon(String? condition) {
    if (condition == null) return Icons.wb_sunny;
    switch (condition.toLowerCase()) {
      case 'clear':
      case 'sunny':
        return Icons.wb_sunny;
      case 'partly cloudy':
        return Icons.wb_cloudy_outlined;
      case 'cloudy':
        return Icons.cloud;
      case 'rain':
      case 'light rain':
      case 'drizzle':
        return Icons.grain;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      default:
        return Icons.wb_sunny;
    }
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
        isLoading
            ? Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 50,
            height: 16,
            color: Colors.white,
          ),
        )
            : Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

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
                  _getWeatherIcon(condition),
                  color: Colors.orange,
                  size: 24,
                ),
                SizedBox(width: 8),
                isLoading
                    ? Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 150,
                    height: 20,
                    color: Colors.white,
                  ),
                )
                    : Text(
                  '${temperature ?? 0}°C ${condition ?? ''} / Today',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildWeatherInfo('Humidity', '${humidity ?? 0}%'),
                _buildWeatherInfo('Precipitation', '${precipitation ?? 0.0}mm'),
                _buildWeatherInfo('Wind', '${windSpeed ?? 0}m/s'),
              ],
            )
          ],
        ),
      ),
    );
  }
}




















































