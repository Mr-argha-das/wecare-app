import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthcare/core/theme/app_theme.dart';
import 'package:healthcare/features/duty/lang/mainLangChang.dart';
import 'package:healthcare/features/payment/payment_verification_page.dart';
import 'package:healthcare/services/razorpay_service.dart';
import 'package:image_picker/image_picker.dart';

class PataintTermCondiation extends StatefulWidget {
  const PataintTermCondiation({super.key});

  @override
  State<PataintTermCondiation> createState() => _PataintTermCondiationState();
}

class _PataintTermCondiationState extends State<PataintTermCondiation> {
  File? signatureFile;
  bool loading = false;
  final RazorpayService _service = RazorpayService();

  final ImagePicker _picker = ImagePicker();

  bool agreed = false;

  /// LANGUAGE CHANGE
  void changeLanguage(AppLanguage lang) {
    setState(() {
      Lang2.current = lang;
    });
  }

  /// SIGNATURE PICK
  Future<void> pickSignature(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 80);
    if (picked != null && mounted) {
      setState(() {
        signatureFile = File(picked.path);
      });
    }
  }

  Future<bool> _showPaymentConfirmationDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Payment Confirmation"),
          content: const Text(
            "By continuing, you are paying the registration fee to enable your approved relative to access the patient’s medical reports and related information through our secure platform. This payment helps activate the requested access for the registered relative.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text("Cancel"),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text("Continue to Pay"),
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }

  /// SUBMIT (PAY ₹199)
  Future<void> submitConsent() async {
    if (agreed == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Accept the term & conditions")),
      );
      return;
    }

    final confirmed = await _showPaymentConfirmationDialog();
    if (!confirmed) return;

    setState(() => loading = true);

    try {
      await _service.createOrder2();
      log("Patient fee order created → waiting for callback");
    } catch (e) {
      log("Payment init error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to start payment: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  /// SIGNATURE SOURCE SHEET
  void showSignatureSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Lang2.t("upload_title"),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(Lang2.t("camera")),
                onTap: () {
                  Navigator.pop(context);
                  pickSignature(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(Lang2.t("gallery")),
                onTap: () {
                  Navigator.pop(context);
                  pickSignature(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _service.init(
      onResult: (result) {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentVerificationPage(
              orderId: result.orderId,
              flow: "patient",
              initialStatus: result.checkoutSucceeded ? "created" : "failed",
              checkoutResult: result,
            ),
          ),
          (_) => false,
        );
      },
    );
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Lang2.t("patient_title")),
        automaticallyImplyLeading: true,
        actions: [
          PopupMenuButton<AppLanguage>(
            icon: const Icon(Icons.language),
            onSelected: changeLanguage,
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: AppLanguage.english,
                child: Text("English"),
              ),
              PopupMenuItem(
                value: AppLanguage.hindi,
                child: Text("हिंदी"),
              ),
              PopupMenuItem(
                value: AppLanguage.gujarati,
                child: Text("ગુજરાતી"),
              ),
              PopupMenuItem(
                value: AppLanguage.marathi,
                child: Text("मराठी"),
              ),
              PopupMenuItem(
                value: AppLanguage.kannada,
                child: Text("ಕನ್ನಡ"),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: AppTheme.primarylight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// MAIN DECLARATION CARD
            Card(
              color: Colors.grey.shade50,
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Lang2.t("patient_title"),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(Lang2.t("patient_point1")),
                    const SizedBox(height: 10),
                    Text(Lang2.t("patient_point2")),
                    const SizedBox(height: 10),
                    Text(Lang2.t("patient_point3")),
                    const SizedBox(height: 10),
                    Text(Lang2.t("patient_point4")),
                    const SizedBox(height: 16),
                    Text(
                      Lang2.t("services_title"),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(Lang2.t("patient_point5")),
                    const SizedBox(height: 10),
                    Text(Lang2.t("patient_point6")),
                    const SizedBox(height: 10),
                    Text(Lang2.t("patient_point7")),
                    const SizedBox(height: 10),
                    Text(Lang2.t("patient_point8")),
                    const SizedBox(height: 16),
                    Text(
                      Lang2.t("patient_caretaker_title"),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(Lang2.t("patient_point9")),
                    const SizedBox(height: 10),
                    Text(Lang2.t("patient_point10")),
                    const SizedBox(height: 10),
                    Text(Lang2.t("patient_point11")),
                    const SizedBox(height: 16),
                    Text(
                      Lang2.t("legal_title"),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(Lang2.t("patient_point12")),
                    const SizedBox(height: 10),
                    Text(Lang2.t("patient_point13")),
                    const SizedBox(height: 16),
                    Text(
                      Lang2.t("nonsolicitation_title"),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(Lang2.t("patient_point14")),
                    const SizedBox(height: 10),
                    Text(Lang2.t("patient_point15")),
                    const SizedBox(height: 10),
                    Text(Lang2.t("patient_point16")),
                    const SizedBox(height: 16),
                    Text(
                      Lang2.t("confidentiality_title"),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(Lang2.t("patient_point17")),
                    const SizedBox(height: 16),
                    Text(
                      Lang2.t("payment_title"),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(Lang2.t("patient_point18")),
                    const SizedBox(height: 10),
                    Text(Lang2.t("patient_point19")),
                    const SizedBox(height: 16),
                    Text(
                      Lang2.t("declaration"),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(Lang2.t("patient_point20")),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Checkbox(
                  value: agreed,
                  onChanged: (v) {
                    setState(() {
                      agreed = v ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    "By accepting, you agree to our terms & conditions.",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),

            ElevatedButton(
              onPressed: loading ? null : submitConsent,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                minimumSize: const Size.fromHeight(54),
              ),
              child: loading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      "Pay ₹199 & Accept",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
