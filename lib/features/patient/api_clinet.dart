import 'dart:convert';
import 'package:healthcare/core/network/base.dart';
import 'package:http/http.dart' as http;
import '../../core/storage/token_storage.dart';

class ApiClient {
  static const baseUrl = baseUrlApi;

  static Future<http.Response> get(String path) async {
    final token = await TokenStorage.getToken();
    return http.get(
      Uri.parse("$baseUrl$path"),
      headers: {"Authorization": "Bearer $token"},
    );
  }

  static Future<http.Response> post(String path, Map body) async {
    final token = await TokenStorage.getToken();
    return http.post(
      Uri.parse("$baseUrl$path"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );
  }
}
