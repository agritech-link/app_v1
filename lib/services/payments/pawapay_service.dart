import 'dart:convert';
import 'package:AgriTech_Link/const.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class PawaPayService {
  final String apiToken;
  final String baseUrl;

  PawaPayService({
    required this.apiToken,
    this.baseUrl = PAWAPAY_BASE_URL,
  });

  Future<Map<String, dynamic>> initiatePayment({
    required String amount,
    required String currency,
    required String country,
    required String correspondent,
    required String recipientPhoneNumber,
    required String statementDescription,
}) async {
    final uuid = Uuid();
    final payoutId = uuid.v4();
    final customerTimestamp = DateTime.now().toUtc().toIso8601String();

    final response = await http.post(
      Uri.parse('$baseUrl/payouts'),
      headers: {
        'Authorization': 'Bearer $apiToken',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'payoutId': payoutId,
        'amount': amount,
        'currency': currency,
        'country': country,
        'correspondent': correspondent,
        'recipient': {
          'type': 'MSISDN',
          'address': {
            'value': recipientPhoneNumber,
          }
        },
        'customerTimestamp': customerTimestamp,
        'statementDescription': statementDescription
      })
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to initiate payout ${response.body}');
    }
  }
}
