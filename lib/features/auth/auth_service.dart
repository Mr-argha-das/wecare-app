import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:healthcare/core/network/base.dart';
import 'package:healthcare/features/doctor/doctor_home.dart';
import 'package:healthcare/features/pataint/patain.profile.dart';
import 'package:healthcare/features/staff/staff_profile_complaints_page.dart';
import 'package:healthcare/routes/app_routes.dart';
import 'package:http/http.dart' as http;
import '../../core/storage/token_storage.dart';

class AuthService {
  static const baseUrl = baseUrlApi;
  static const testPhones = {
    "9000000001",
    "9000000002",
    "9000000003",
  };

  static bool isTestPhone(String phone) => testPhones.contains(phone.trim());

  static Future<void> loginTestAccount(String phone, context) async {
    if (!isTestPhone(phone)) {
      throw Exception("This is not a test account");
    }
    final res = await http.post(
      Uri.parse("$baseUrl/auth/login-password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone": phone.trim(), "password": phone.trim()}),
    );
    if (res.statusCode != 200) {
      throw Exception("Test login failed");
    }
    await _completeLogin(jsonDecode(res.body), context);
  }

  /// 🔹 SEND OTP
  static Future<void> sendOtp(String phone) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/send-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone": phone}),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to send OTP");
    }
  }

  static Future<void> verifyOtp(
    String phone,
    String otp,
    context,
    String token,
  ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/verify-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone": phone, "otp": otp, "token": token}),
    );

    /// ❌ ERROR RESPONSE
    if (res.statusCode != 200) {
      String message = "Something went wrong";

      try {
        final body = jsonDecode(res.body);
        if (body is Map && body.containsKey("detail")) {
          message = body["detail"];
        }
      } catch (_) {}

      throw Exception(message);
    }

    /// ✅ SUCCESS
    final data = jsonDecode(res.body);
    log(data.toString());
    await _completeLogin(data, context);
  }

  static Future<void> _completeLogin(dynamic data, context) async {
    if (!data.containsKey("access_token")) {
      throw Exception("Invalid server response");
    }

    await TokenStorage.saveToken(data["access_token"]);
    await TokenStorage.saveRole(data["role"]);
    final userId = data["user_id"]?.toString();
    if (userId != null && userId.isNotEmpty) {
      await TokenStorage.saveUserId(userId);
    }

    if (data["role"] == null) {
      throw Exception("User role not found");
    }
    if (data["role"] == "DOCTOR") {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => const DoctorProfilePage()),
      );
    } else if (data["role"] == "NURSE") {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    } else if (data["role"] == "PATIENT") {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => const PataintProfilePage()),
      );
    } else if (data["role"] == "STAFF") {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => StaffProfileComplaintsPage()),
      );
    }
  }
}
