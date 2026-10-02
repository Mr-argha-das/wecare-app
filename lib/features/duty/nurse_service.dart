import 'dart:convert';
import 'package:healthcare/core/network/base.dart';
import 'package:http/http.dart' as http;
import '../../core/storage/token_storage.dart';

class NurseService {
  static const baseUrl = baseUrlApi;

  static Future<List<Map<String, dynamic>>> getPatients() async {
    final token = await TokenStorage.getToken();

    final res = await http.get(
      Uri.parse("$baseUrl/nurse/patients"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to load patients");
    }

    final data = jsonDecode(res.body);
    return List<Map<String, dynamic>>.from(data["patients"]);
  }
}
