import 'package:AgriTech_Link/services/plant_analysis_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final plantAnalysisServiceProvider = Provider<PlantAnalysisService>((ref) {
  return PlantAnalysisService();
});