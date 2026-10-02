import 'dart:convert';
import 'dart:developer';
import 'package:healthcare/core/network/base.dart';
import 'package:http/http.dart' as http;
import '../../core/storage/token_storage.dart';

class DutyService {
  static const baseUrl = baseUrlApi;

  static Future<void> checkIn() async {
    final token = await TokenStorage.getToken();

    final res = await http.post(
      Uri.parse("$baseUrl/nurse/duty/check-in"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)["detail"]);
    }
  }

  static Future<void> checkOut() async {
    final token = await TokenStorage.getToken();

    final res = await http.post(
      Uri.parse("$baseUrl/nurse/duty/check-out"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)["detail"]);
    }
  }

  static Future<Map<String, bool>> getDutyStatus() async {
    final token = await TokenStorage.getToken();

    final res = await http.get(
      Uri.parse("$baseUrl/nurse/duty/status"),
      headers: {"Authorization": "Bearer $token"},
    );

    log("Duty Status Response: ${res.body}");
    log(res.body);
    if (res.statusCode != 200) {
      throw Exception("Failed to get duty status");
    }

    return Map<String, bool>.from(jsonDecode(res.body));
  }
}
