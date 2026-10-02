import 'dart:convert';
import 'dart:developer';
import 'package:healthcare/main.dart';
import 'package:http/http.dart' as http;
import 'package:healthcare/core/network/base.dart';
import 'package:healthcare/core/storage/token_storage.dart';

import 'dart:io';
import 'package:flutter/material.dart';

class ApiClient {
  static const baseUrl = baseUrlApi;

  /* =====================================================
      🔹 GET
  ===================================================== */
  static Future<dynamic> get(String path) async {
    final token = await TokenStorage.getToken();

    final res = await http.get(
      Uri.parse("$baseUrl$path"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    log(res.body);
    await _handleError(res);

    return jsonDecode(res.body);
  }

  static Future<dynamic> getWithoutTokern(String path) async {
    final res = await http.get(
      Uri.parse("$baseUrl$path"),
      headers: {"Content-Type": "application/json"},
    );

    log(res.body);
    await _handleError(res);

    return jsonDecode(res.body);
  }

  /* =====================================================
      🔹 UPLOAD FILE
  ===================================================== */
  static Future<Map<String, dynamic>> uploadFile(
    String url,
    File file, {
    String folder = "documents",
  }) async {
    final token = await TokenStorage.getToken();

    final request = http.MultipartRequest("POST", Uri.parse("$baseUrl$url"));

    request.headers["Authorization"] = "Bearer $token";
    request.fields["folder"] = folder;

    request.files.add(await http.MultipartFile.fromPath("file", file.path));

    final response = await request.send();
    final res = await http.Response.fromStream(response);

    log(res.body);

    await _handleError(res);

    return jsonDecode(res.body);
  }

  /* =====================================================
      🔹 DELETE
  ===================================================== */
  static Future<dynamic> delete(String path, Map body) async {
    final token = await TokenStorage.getToken();

    final res = await http.delete(
      Uri.parse("$baseUrl$path"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    log(res.body);

    await _handleError(res);

    if (res.body.isEmpty) {
      return {"success": true};
    }

    return jsonDecode(res.body);
  }

  /* =====================================================
      🔹 PUT
  ===================================================== */
  static Future<dynamic> put(String path, Map body) async {
    final token = await TokenStorage.getToken();

    final res = await http.put(
      Uri.parse("$baseUrl$path"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    log(res.body);

    await _handleError(res);

    return jsonDecode(res.body);
  }

  /* =====================================================
      🔹 POST
  ===================================================== */
  static Future<dynamic> post(String path, Map body) async {
    final token = await TokenStorage.getToken();

    final res = await http.post(
      Uri.parse("$baseUrl$path"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    log(res.body);

    await _handleError(res);

    return jsonDecode(res.body);
  }

  /* =====================================================
      🔥 CENTRAL ERROR HANDLER
  ===================================================== */
  static Future<void> _handleError(http.Response res) async {
    /* ======================
       🔴 AUTO LOGOUT ON 401
    ====================== */
    if (res.statusCode == 401) {
      await TokenStorage.clearToken();

      // show message
      final ctx = appNavigatorKey.currentContext;
      if (ctx != null && ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text("Session expired. Please login again"),
            backgroundColor: Colors.red,
          ),
        );
      }

      // go login & clear stack
      appNavigatorKey.currentState?.pushNamedAndRemoveUntil(
        "/login",
        (route) => false,
      );

      throw Exception("Session expired");
    }

    /* ======================
       NORMAL ERRORS
    ====================== */
    if (res.statusCode >= 400) {
      String message = "API Error (${res.statusCode})";
      try {
        final body = jsonDecode(res.body);
        if (body is Map) {
          message = body["detail"]?.toString() ??
              body["message"]?.toString() ??
              message;
        }
      } catch (_) {
        // Keep the status-based fallback when the response is not JSON.
      }
      throw Exception(message);
    }
  }

  /* =====================================================
   🔹 POST FORM-DATA (For Aadhaar Upload)
===================================================== */
  static Future<dynamic> postFormData(String path, File file) async {
    final token = await TokenStorage.getToken();

    final request = http.MultipartRequest("POST", Uri.parse("$baseUrl$path"));

    request.headers.addAll({"Authorization": "Bearer $token"});

    request.files.add(await http.MultipartFile.fromPath("file", file.path));

    final response = await request.send();
    final res = await http.Response.fromStream(response);

    log("AADHAAR API STATUS: ${res.statusCode}");
    log("AADHAAR API BODY: ${res.body}");

    await _handleError(res);

    return jsonDecode(res.body);
  }
}

// class FileUploadService {
//   static Future<String> uploadFile(
//     File file, {
//     String folder = "documents",
//   }) async {
//     final request = http.MultipartRequest(
//       "POST",
//       Uri.parse("$baseUrlApi/upload/file?folder=$folder"),
//     );

//     request.files.add(
//       await http.MultipartFile.fromPath("file", file.path),
//     );

//     final response = await request.send();
//     final body = await response.stream.bytesToString();

//     log(body);

//     if (response.statusCode != 200) {
//       throw Exception("File upload failed");
//     }

//     final data = jsonDecode(body);
//     return data["path"]; // 🔥 backend ka exact path
//   }
// }
class FileUploadService {
  static Future<String> uploadFile(
    File file, {
    String folder = "documents",
  }) async {
    final token = await TokenStorage.getToken();
    log("UPLOAD TOKEN: $token");

    final request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrlApi/upload/file?folder=$folder"),
    );

    request.headers.addAll({"Authorization": "Bearer $token"});

    request.files.add(await http.MultipartFile.fromPath("file", file.path));

    final response = await request.send();
    final body = await response.stream.bytesToString();

    log("UPLOAD STATUS: ${response.statusCode}");
    log("UPLOAD BODY: $body");

    if (response.statusCode != 200) {
      throw Exception("File upload failed (${response.statusCode})");
    }

    final data = jsonDecode(body);
    return data["path"];
  }
}
