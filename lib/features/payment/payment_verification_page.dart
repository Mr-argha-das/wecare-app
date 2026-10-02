import 'package:flutter/material.dart';
import 'package:healthcare/core/storage/payment_storage.dart';
import 'package:healthcare/core/storage/token_storage.dart';
import 'package:healthcare/features/auth/login_page.dart';
import 'package:healthcare/features/pataint/patain.profile.dart';
import 'package:healthcare/services/razorpay_service.dart';

enum PaymentViewState { verifying, success, failed, pending, error }

class PaymentVerificationPage extends StatefulWidget {
  final String orderId;
  final String flow;
  final String? userId;
  final String initialStatus;
  final PaymentCheckoutResult? checkoutResult;

  const PaymentVerificationPage({
    super.key,
    required this.orderId,
    required this.flow,
    this.userId,
    this.initialStatus = "created",
    this.checkoutResult,
  });

  factory PaymentVerificationPage.fromPending(PendingPayment payment) {
    return PaymentVerificationPage(
      orderId: payment.orderId,
      flow: payment.flow,
      userId: payment.userId,
      initialStatus: payment.localStatus,
    );
  }

  @override
  State<PaymentVerificationPage> createState() =>
      _PaymentVerificationPageState();
}

class _PaymentVerificationPageState extends State<PaymentVerificationPage> {
  final RazorpayService _razorpay = RazorpayService();
  late String _orderId;
  late PaymentViewState _state;
  String _message = "Confirming your payment securely…";
  bool _retrying = false;

  @override
  void initState() {
    super.initState();
    _orderId = widget.orderId;
    _state = widget.initialStatus == "failed"
        ? PaymentViewState.failed
        : PaymentViewState.verifying;
    _razorpay.init(onResult: _handleCheckoutResult);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final result = widget.checkoutResult;
      if (result != null) {
        _handleCheckoutResult(result);
      } else if (_state != PaymentViewState.failed) {
        _refreshStatus(poll: true);
      }
    });
  }

  @override
  void dispose() {
    _razorpay.dispose();
    super.dispose();
  }

  Future<void> _handleCheckoutResult(PaymentCheckoutResult result) async {
    _orderId = result.orderId;
    if (!result.checkoutSucceeded) {
      await PaymentStorage.updateStatus("failed");
      if (!mounted) return;
      setState(() {
        _retrying = false;
        _state = PaymentViewState.failed;
        _message = result.errorMessage ?? "Payment failed or was cancelled.";
      });
      return;
    }

    if (mounted) {
      setState(() {
        _retrying = false;
        _state = PaymentViewState.verifying;
        _message = "Payment received. Verifying the transaction…";
      });
    }

    try {
      final status = await RazorpayService.verifyCheckout(result);
      await _applyStatus(status);
    } catch (_) {
      // The webhook may arrive slightly later, so verify using polling too.
      await _refreshStatus(poll: true);
    }
  }

  Future<void> _refreshStatus({bool poll = false}) async {
    if (!mounted) return;
    setState(() {
      _state = PaymentViewState.verifying;
      _message = "Checking payment status…";
    });

    final attempts = poll ? 10 : 1;
    try {
      for (var attempt = 0; attempt < attempts; attempt++) {
        final status = await RazorpayService.checkOrderStatus(_orderId);
        if (status == "success" || status == "failed") {
          await _applyStatus(status);
          return;
        }
        if (attempt < attempts - 1) {
          await Future<void>.delayed(const Duration(seconds: 2));
          if (!mounted) return;
        }
      }

      await PaymentStorage.updateStatus("created");
      if (!mounted) return;
      setState(() {
        _state = PaymentViewState.pending;
        _message = "Payment confirmation is taking longer than expected.";
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _state = PaymentViewState.error;
        _message = error.toString().replaceAll("Exception:", "").trim();
      });
    }
  }

  Future<void> _applyStatus(String status) async {
    final normalized = status.toLowerCase();
    await PaymentStorage.updateStatus(normalized);
    if (!mounted) return;
    setState(() {
      if (normalized == "success") {
        _state = PaymentViewState.success;
        _message = "Your payment has been verified successfully.";
      } else if (normalized == "failed") {
        _state = PaymentViewState.failed;
        _message = "Payment was not completed. No amount has been confirmed.";
      } else {
        _state = PaymentViewState.pending;
        _message = "Payment is still pending confirmation.";
      }
    });
  }

  Future<void> _retryPayment() async {
    if (_retrying) return;
    setState(() => _retrying = true);
    try {
      if (widget.flow == "patient") {
        _orderId = await _razorpay.createOrder2();
      } else {
        final userId = widget.userId;
        if (userId == null || userId.isEmpty) {
          throw Exception("Nurse profile is missing. Please register again.");
        }
        _orderId = await _razorpay.createOrder(userId: userId);
      }
      if (!mounted) return;
      setState(() {
        _state = PaymentViewState.pending;
        _message = "Complete the payment in the Razorpay window.";
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _retrying = false;
        _state = PaymentViewState.error;
        _message = error.toString().replaceAll("Exception:", "").trim();
      });
    }
  }

  Future<void> _continueAfterSuccess() async {
    await PaymentStorage.clear();
    if (!mounted) return;

    if (widget.flow == "patient") {
      final token = await TokenStorage.getToken();
      if (!mounted) return;
      if (token != null && token.isNotEmpty) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const PataintProfilePage()),
          (_) => false,
        );
        return;
      }
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) return;

    await PaymentStorage.clear();
    await TokenStorage.clearToken();
    await TokenStorage.clearRole();
    await TokenStorage.clearUserId();

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = _state == PaymentViewState.success;
    final isFailed = _state == PaymentViewState.failed;
    final isVerifying = _state == PaymentViewState.verifying;
    final color = isSuccess
        ? Colors.green.shade700
        : isFailed
            ? Colors.red.shade700
            : Colors.blue.shade700;
    final icon = isSuccess
        ? Icons.check_circle_rounded
        : isFailed
            ? Icons.cancel_rounded
            : Icons.verified_user_rounded;
    final title = isSuccess
        ? "Payment Successful"
        : isFailed
            ? "Payment Failed"
            : _state == PaymentViewState.pending
                ? "Payment Pending"
                : "Verifying Payment";

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F7FC),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Payment Verification"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Card(
                  elevation: 8,
                  shadowColor: color.withValues(alpha: 0.18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
                    child: Column(
                      children: [
                        Container(
                          height: 104,
                          width: 104,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.10),
                            shape: BoxShape.circle,
                          ),
                          child: isVerifying
                              ? Padding(
                                  padding: const EdgeInsets.all(30),
                                  child: CircularProgressIndicator(
                                    color: color,
                                    strokeWidth: 4,
                                  ),
                                )
                              : Icon(icon, size: 66, color: color),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 1.45,
                            fontSize: 15,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Order ID",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 5),
                              SelectableText(
                                _orderId,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        if (isSuccess)
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton.icon(
                              onPressed: _continueAfterSuccess,
                              icon: const Icon(Icons.home_rounded),
                              label: const Text("CONTINUE TO HOME"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade700,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          )
                        else ...[
                          if (!isVerifying)
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton.icon(
                                onPressed: _retrying ? null : _retryPayment,
                                icon: _retrying
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.refresh_rounded),
                                label: const Text("PAY AGAIN"),
                              ),
                            ),
                          const SizedBox(height: 10),
                          TextButton.icon(
                            onPressed: isVerifying
                                ? null
                                : () => _refreshStatus(poll: true),
                            icon: const Icon(Icons.sync_rounded),
                            label: const Text("CHECK STATUS AGAIN"),
                          ),
                        ],
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton.icon(
                            onPressed: _logout,
                            icon: const Icon(Icons.logout_rounded),
                            label: const Text("LOGOUT"),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Do not close the app while payment is being verified.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.black45),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
