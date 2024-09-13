import 'dart:io';
import 'package:AgriTech_Link/const.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlantAnalysisService {
  final String baseUrl = PLANT_DISEASE_API;

  Future<Map<String, dynamic>> analyzePlant(File imageFile) async {
    var uri = Uri.parse('$baseUrl/analyze');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      return json.decode(responseData);
    } else {
      throw Exception('Failed to analyze plant');
    }
  }
}