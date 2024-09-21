import 'dart:io';
import 'package:AgriTech_Link/const.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlantAnalysisService {
  final String baseUrl = PLANT_DISEASE_API;

  Future<Map<String, dynamic>> analyzePlant(File imageFile) async {
    print('Analyzing plant with API at: $baseUrl/analyze');
    print('Image file path: ${imageFile.path}');

    var uri = Uri.parse('$baseUrl/analyze');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    print('Sending request to: ${uri.toString()}');
    print('Request files: ${request.files.map((file) => file.filename)}');

    var response = await request.send();

    print('Response status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      print('Raw response data: $responseData');

      // Decode the response
      Map<String, dynamic> decodedResponse = json.decode(responseData);

      // Extract the condition and recommendations
      String condition = decodedResponse.keys.first;
      Map<String, dynamic> managementPractices = decodedResponse[condition];

      // Convert the nested structure to Map<String, List<String>>
      Map<String, List<String>> recommendations = {};
      managementPractices.forEach((category, practices) {
        if (practices is List) {
          recommendations[category] = practices.cast<String>();
        }
      });

      // Print out each recommendation for debugging
      recommendations.forEach((category, practices) {
        print('$category:');
        practices.forEach((practice) => print('- $practice'));
      });

      // Return the structured result
      return {
        'condition': condition,
        'recommendations': recommendations,
      };
    } else {
      print('Failed to analyze plant. Status code: ${response.statusCode}');
      throw Exception('Failed to analyze plant');
    }
  }
}
