import 'package:AgriTech_Link/services/weather/weather_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecommendationEngine {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Recommendation>> generateRecommendations(WeatherForecastData forecastData) async {
    final List<Recommendation> recommendations = [];

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return recommendations;

      final farmResponse = await _supabase
          .from('farms')
          .select()
          .eq('user_id', user.id)
          .single();


// Access the farm ID directly
      final farmId = farmResponse['id'];


      final cropsResponse = await _supabase
          .from('crops')
          .select()
          .eq('farm_id', farmId);


      final List<dynamic> crops = cropsResponse as List<dynamic>;


      for (var crop in crops) {
        recommendations.addAll(await _generateCropRecommendations(crop, forecastData));
      }

      recommendations.addAll(_generateGeneralRecommendations(forecastData));

    } catch (e) {
      print('Error generating recommendations: $e');
    }

    return recommendations;
  }

  Future<List<Recommendation>> _generateCropRecommendations(Map<String, dynamic> crop, WeatherForecastData forecastData) async {
    final List<Recommendation> recommendations = [];

    if (forecastData.dailyForecasts[0].tempMin < 2 && ['tomato', 'pepper', 'cucumber'].contains(crop['crop_type'])) {
      recommendations.add(Recommendation(
        type: RecommendationType.frostWarning,
        message: 'Frost risk detected for ${crop['crop_type']}. Consider protecting your crops.',
        severity: RecommendationSeverity.warning,
      ));
    }

    // Add more crop-specific recommendations here

    return recommendations;
  }

  List<Recommendation> _generateGeneralRecommendations(WeatherForecastData forecastData) {
    final List<Recommendation> recommendations = [];

    if (forecastData.dailyForecasts[0].precipitation > 20) {
      recommendations.add(Recommendation(
        type: RecommendationType.heavyRain,
        message: 'Heavy rain expected. Consider postponing fertilizer application.',
        severity: RecommendationSeverity.info,
      ));
    }

    if (forecastData.dailyForecasts[0].windSpeed > 30) {
      recommendations.add(Recommendation(
        type: RecommendationType.highWind,
        message: 'High winds expected. Delay spraying operations and secure equipment.',
        severity: RecommendationSeverity.warning,
      ));
    }

    // Add more general recommendations here

    return recommendations;
  }
}

enum RecommendationType {
  frostWarning,
  heavyRain,
  highWind,
  // Add more types as needed
}

enum RecommendationSeverity {
  info,
  warning,
  critical,
}

class Recommendation {
  final RecommendationType type;
  final String message;
  final RecommendationSeverity severity;

  Recommendation({
    required this.type,
    required this.message,
    required this.severity,
  });
}