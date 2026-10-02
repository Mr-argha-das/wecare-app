import 'dart:convert';
import 'package:healthcare/core/network/base.dart';
import 'package:http/http.dart' as http;
import '../../core/storage/token_storage.dart';

class SOSService {
  static const String baseUrl = baseUrlApi;

  static Future<void> triggerSOS({
    required String patientId,
    required String message,
  }) async {
    final token = await TokenStorage.getToken();

    final uri =
        Uri.parse("$baseUrl/sos/trigger?patient_id=$patientId");

    final res = await http.post(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"message": message}),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to trigger SOS");
    }
  }
}
