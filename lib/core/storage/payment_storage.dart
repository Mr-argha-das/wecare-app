import 'package:shared_preferences/shared_preferences.dart';

class PendingPayment {
  final String orderId;
  final String flow;
  final String? userId;
  final String localStatus;

  const PendingPayment({
    required this.orderId,
    required this.flow,
    this.userId,
    this.localStatus = "created",
  });
}

class PaymentStorage {
  static const _orderIdKey = "pending_payment_order_id";
  static const _flowKey = "pending_payment_flow";
  static const _userIdKey = "pending_payment_user_id";
  static const _statusKey = "pending_payment_local_status";

  static Future<void> save({
    required String orderId,
    required String flow,
    String? userId,
    String localStatus = "created",
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_orderIdKey, orderId);
    await prefs.setString(_flowKey, flow);
    await prefs.setString(_statusKey, localStatus);
    if (userId == null || userId.isEmpty) {
      await prefs.remove(_userIdKey);
    } else {
      await prefs.setString(_userIdKey, userId);
    }
  }

  static Future<void> updateStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_statusKey, status);
  }

  static Future<PendingPayment?> getPending() async {
    final prefs = await SharedPreferences.getInstance();
    final orderId = prefs.getString(_orderIdKey);
    final flow = prefs.getString(_flowKey);
    if (orderId == null || orderId.isEmpty || flow == null || flow.isEmpty) {
      return null;
    }
    return PendingPayment(
      orderId: orderId,
      flow: flow,
      userId: prefs.getString(_userIdKey),
      localStatus: prefs.getString(_statusKey) ?? "created",
    );
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_orderIdKey);
    await prefs.remove(_flowKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_statusKey);
  }
}
