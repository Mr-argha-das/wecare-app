import 'dart:convert';
import 'package:healthcare/core/network/base.dart';
import 'package:http/http.dart' as http;
import '../../core/storage/token_storage.dart';

class DashboardService {
  static const String baseUrl = baseUrlApi;

  static Future<Map<String, dynamic>> fetchDashboard() async {
    final token = await TokenStorage.getToken();

    if (token == null) {
      throw Exception("User not logged in");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/nurse/dashboard"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      String message = response.body;
      try {
        final body = jsonDecode(response.body);
        if (body is Map) {
          message = body["detail"]?.toString() ??
              body["message"]?.toString() ??
              response.body;
        }
      } catch (_) {}
      throw Exception(
        "Failed to load dashboard (${response.statusCode}): $message",
      );
    }

    return jsonDecode(response.body);
  }
}
