import 'dart:convert';
import 'dart:developer';

import 'package:healthcare/config/api.dart';
import 'package:healthcare/core/network/api_client.dart';
import 'package:healthcare/core/storage/payment_storage.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentCheckoutResult {
  final bool checkoutSucceeded;
  final String orderId;
  final String? paymentId;
  final String? signature;
  final String? errorMessage;

  const PaymentCheckoutResult({
    required this.checkoutSucceeded,
    required this.orderId,
    this.paymentId,
    this.signature,
    this.errorMessage,
  });
}

class RazorpayService {
  late final Razorpay _razorpay;
  String orderId = "";

  void init({required void Function(PaymentCheckoutResult) onResult}) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (
      PaymentSuccessResponse response,
    ) {
      onResult(
        PaymentCheckoutResult(
          checkoutSucceeded: true,
          orderId: response.orderId ?? orderId,
          paymentId: response.paymentId,
          signature: response.signature,
        ),
      );
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (
      PaymentFailureResponse response,
    ) {
      onResult(
        PaymentCheckoutResult(
          checkoutSucceeded: false,
          orderId: orderId,
          errorMessage: response.message ?? "Payment failed or was cancelled",
        ),
      );
    });
  }

  void dispose() {
    _razorpay.clear();
  }

  Future<String> createOrder({required String userId}) async {
    final res = await http.post(
      Uri.parse(createOrderApi),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId}),
    );

    if (res.statusCode != 200) {
      throw Exception(_errorMessage(res));
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return _openCheckout(data, flow: "nurse", userId: userId);
  }

  Future<String> createOrder2() async {
    final data = await ApiClient.post("/payments/create-order-pataint", {});
    return _openCheckout(
      Map<String, dynamic>.from(data as Map),
      flow: "patient",
    );
  }

  Future<String> _openCheckout(
    Map<String, dynamic> data, {
    required String flow,
    String? userId,
  }) async {
    final newOrderId = data["order_id"]?.toString();
    if (newOrderId == null || newOrderId.isEmpty || data["amount"] == null) {
      throw Exception("Invalid payment order response");
    }

    orderId = newOrderId;
    await PaymentStorage.save(
      orderId: orderId,
      flow: flow,
      userId: userId,
    );

    _razorpay.open({
      "key": data["key"],
      "amount": data["amount"],
      "order_id": orderId,
      "name": "WeCare Healthcare",
      "description": "Joining fee payment",
      "theme": {"color": "#1565C0"},
    });

    return orderId;
  }

  static Future<String> checkOrderStatus(String orderId) async {
    final res = await http.get(Uri.parse("$paymentStatusApi/$orderId"));
    if (res.statusCode != 200) {
      throw Exception(_errorMessage(res));
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return data["status"]?.toString().toLowerCase() ?? "created";
  }

  static Future<String> verifyCheckout(PaymentCheckoutResult result) async {
    if (!result.checkoutSucceeded ||
        result.paymentId == null ||
        result.signature == null) {
      return "failed";
    }

    final response = await ApiClient.post("/payments/verify-signature", {
      "order_id": result.orderId,
      "payment_id": result.paymentId,
      "signature": result.signature,
    });
    return response["status"]?.toString().toLowerCase() ?? "failed";
  }

  static String _errorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map) {
        return body["detail"]?.toString() ??
            body["message"]?.toString() ??
            "Payment request failed (${response.statusCode})";
      }
    } catch (error) {
      log("Payment error response parse failed: $error");
    }
    return "Payment request failed (${response.statusCode})";
  }
}
