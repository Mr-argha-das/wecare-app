import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthcare/core/network/api_client.dart';
import 'package:healthcare/core/storage/token_storage.dart';
import 'package:healthcare/core/theme/app_theme.dart';
import 'package:healthcare/core/utils/app_message.dart';
import 'package:healthcare/features/duty/lang/mainLangChang.dart'; // ← your Lang class
import 'package:healthcare/features/payment/payment_verification_page.dart';
import 'package:healthcare/services/razorpay_service.dart';
import 'package:image_picker/image_picker.dart';

class NurseConsentPage extends StatefulWidget {
  final Map<String, dynamic> statusData;

  const NurseConsentPage({super.key, required this.statusData});

  @override
  State<NurseConsentPage> createState() => _NurseConsentPageState();
}

class _NurseConsentPageState extends State<NurseConsentPage> {
  File? signatureFile;
  bool loading = false;
  final RazorpayService _service = RazorpayService();

  final ImagePicker _picker = ImagePicker();

  bool get canSignConsent =>
      widget.statusData["police_verified"] == "CLEAR" &&
      widget.statusData["aadhaar_verified"] == true;

  // ================= SIGNATURE PICK =================
  Future<void> pickSignature(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 80);

    if (picked != null) {
      setState(() {
        signatureFile = File(picked.path);
      });
    }
  }

  void changeLanguage(AppLanguage lang) {
    setState(() {
      Lang.current = lang;
    });
  }

  Future<bool> _showPaymentConfirmationDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Payment Confirmation"),
          content: const Text(
            "By continuing, you are paying the subscription fee to activate your profile for job placement and to receive healthcare job opportunities through our platform. This payment helps keep your account active and visible to employers.",
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

  // ================= SUBMIT =================
  Future<void> submitConsent() async {
    if (agreed == false) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Accept the term & conditions")));
      return;
    }
    if (signatureFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(Lang.t("please_upload"))));
      return;
    }

    final confirmed = await _showPaymentConfirmationDialog();
    if (!confirmed) return;

    setState(() => loading = true);

    try {
      final nurseId = widget.statusData["nurse_id"];

      final uploadRes = await ApiClient.uploadFile(
        "/upload/file",
        signatureFile!,
        folder: "signatures",
      );

      final signaturePath = uploadRes["path"];

      await ApiClient.put("/nurse/signature/$nurseId", {
        "signature_path": signaturePath,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Lang.t("success")),
          backgroundColor: Colors.green,
        ),
      );

      AppMessage.snack = Lang.t("signup_done");

      await _service.createOrder(userId: nurseId);
      log("Order created → waiting for Razorpay result");
    } catch (e) {
      log("Submit error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed: $e")));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  bool agreed = false;

  // ================= BOTTOM SHEET =================
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
                Lang.t("upload_title"),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(Lang.t("camera")),
                onTap: () {
                  Navigator.pop(context);
                  pickSignature(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(Lang.t("gallery")),
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
    aadhaarVerified = widget.statusData["aadhaar_verified"] == true;
    _service.init(
      onResult: (result) {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentVerificationPage(
              orderId: result.orderId,
              flow: "nurse",
              userId: widget.statusData["nurse_id"]?.toString(),
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

  File? aadhaarFront;
  String? extractedAadhaar; // API se jo number aayega
  bool aadhaarLoading = false;

  final picker = ImagePicker();
  String? referenceId;
  bool otpLoading = false;
  bool aadhaarVerified = false;
  Future<File?> _pickSingle() async {
    final x = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    return x != null ? File(x.path) : null;
  }

  Future<void> verifyAadhaarOtp(String otp, BuildContext dialogContext) async {
    try {
      setState(() => otpLoading = true);

      var userId = widget.statusData["user_id"]?.toString();
      if (userId == null || userId.isEmpty || userId == "null") {
        userId = await TokenStorage.getUserId();
      }
      if (userId == null || userId.isEmpty) {
        final currentUser = await ApiClient.get("/auth/me");
        userId = currentUser["id"]?.toString();
        if (userId != null && userId.isNotEmpty) {
          await TokenStorage.saveUserId(userId);
        }
      }
      if (userId == null || userId.isEmpty) {
        throw Exception("Unable to identify your account. Please login again.");
      }

      final res = await ApiClient.post("/adhar/verify-otp", {
        "user_id": userId,
        "reference_id": referenceId,
        "otp": otp,
        "aadhaar_number": extractedAadhaar,
      });

      // 🔥 IN_PROGRESS → DO NOT CLOSE DIALOG
      if (res["success"] == false && res["error_code"] == "IN_PROGRESS") {
        _snack("Verification is in progress. Please wait 30 seconds.");

        return; // dialog open hi rahega
      }

      // ✅ SUCCESS
      if (res["status"] == "SUCCESS" || res["success"] == true) {
        if (!mounted || !dialogContext.mounted) return;
        Navigator.pop(dialogContext); // close only on success

        setState(() {
          aadhaarVerified = true;
        });

        _snack("Aadhaar Verified Successfully ✅");
        return;
      }

      // ❌ FAILED
      _snack(
        res["message"]?.toString() ?? "OTP verification failed",
        error: true,
      );
    } catch (e) {
      _snack("Verification failed: $e", error: true);
    } finally {
      if (mounted) {
        setState(() => otpLoading = false);
      }
    }
  }

  Future<void> sendAadhaarOtp() async {
    try {
      setState(() => otpLoading = true);

      final res = await ApiClient.post("/adhar/generate-otp", {
        "aadhaar_number": extractedAadhaar,
      });

      // 🔥 HANDLE IN_PROGRESS
      if (res["success"] == false && res["error_code"] == "IN_PROGRESS") {
        _snack("Verification already in progress. Please wait 30 seconds.");
        return;
      }

      referenceId = res["reference_id"]?.toString() ??
          res["data"]?["reference_id"]?.toString();

      if (referenceId != null) {
        // The OTP dialog is a separate route. Reset the parent loading state
        // before opening it so its Verify button is enabled on first build.
        if (mounted) {
          setState(() => otpLoading = false);
        }
        _snack("OTP sent successfully");
        _showOtpDialog();
      } else {
        _snack("Failed to send OTP, try again later", error: true);
      }
    } catch (e) {
      _snack("OTP failed: $e", error: true);
    } finally {
      if (mounted) {
        setState(() => otpLoading = false);
      }
    }
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  void _showOtpDialog() {
    final otpCtrl = TextEditingController();
    var isVerifying = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Verify Aadhaar OTP"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("OTP sent to registered mobile"),
                  const SizedBox(height: 12),
                  TextField(
                    controller: otpCtrl,
                    enabled: !isVerifying,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      labelText: "Enter 6-digit OTP",
                      border: OutlineInputBorder(),
                      counterText: "",
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed:
                      isVerifying ? null : () => Navigator.pop(dialogContext),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: isVerifying
                      ? null
                      : () async {
                          final otp = otpCtrl.text.trim();
                          if (!RegExp(r"^\d{6}$").hasMatch(otp)) {
                            _snack("Please enter a valid 6-digit OTP",
                                error: true);
                            return;
                          }

                          setDialogState(() => isVerifying = true);
                          await verifyAadhaarOtp(otp, dialogContext);

                          if (dialogContext.mounted) {
                            setDialogState(() => isVerifying = false);
                          }
                        },
                  child: isVerifying
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Verify"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> uploadAadhaarFront(File file) async {
    try {
      setState(() => aadhaarLoading = true);

      final res = await ApiClient.postFormData("/adhar/extract-aadhaar", file);

      if (res["aadhaar_number"] != null) {
        extractedAadhaar = res["aadhaar_number"];
        _snack("Aadhaar detected: ${res["aadhaar_number"]}");
      } else {
        _snack("Aadhaar number not found, upload clear image ", error: true);
      }
    } catch (e) {
      _snack("Aadhaar upload failed: $e", error: true);
    } finally {
      setState(() => aadhaarLoading = false);
    }
  }

  final TextEditingController aadhaarController = TextEditingController();

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    log(widget.statusData.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(Lang.t("title")),
        automaticallyImplyLeading: true,
        actions: [
          PopupMenuButton<AppLanguage>(
            icon: const Icon(Icons.language),
            onSelected: changeLanguage,
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: AppLanguage.english,
                child: Text("English"),
              ),
              const PopupMenuItem(
                value: AppLanguage.hindi,
                child: Text("हिंदी"),
              ),
              const PopupMenuItem(
                value: AppLanguage.gujarati,
                child: Text("ગુજરાતી"),
              ),
              const PopupMenuItem(
                value: AppLanguage.marathi,
                child: Text("मराठी"),
              ),
              const PopupMenuItem(
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
            // ────────────── LEGAL DECLARATION ──────────────
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
                    Text(Lang.t("point1"), style: const TextStyle(height: 1.4)),
                    const SizedBox(height: 10),
                    Text(Lang.t("point2"), style: const TextStyle(height: 1.4)),
                    const SizedBox(height: 10),
                    Text(Lang.t("point3"), style: const TextStyle(height: 1.4)),
                    const SizedBox(height: 10),
                    Text(Lang.t("point4"), style: const TextStyle(height: 1.4)),
                    const SizedBox(height: 10),
                    Text(Lang.t("point5"), style: const TextStyle(height: 1.4)),
                    const SizedBox(height: 10),
                    Text(Lang.t("point6"), style: const TextStyle(height: 1.4)),
                    const SizedBox(height: 10),
                    Text(Lang.t("point7"), style: const TextStyle(height: 1.4)),
                    const SizedBox(height: 10),
                    Text(Lang.t("point8"), style: const TextStyle(height: 1.4)),
                    const SizedBox(height: 10),
                    Text(Lang.t("point9"), style: const TextStyle(height: 1.4)),
                    const SizedBox(height: 10),
                    Text(
                      Lang.t("point10"),
                      style: const TextStyle(height: 1.4),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      Lang.t("point11"),
                      style: const TextStyle(height: 1.4),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ────────────── CARE TAKER / COMBO SCOPE ──────────────
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
                      Lang.t("caretaker_title"),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      Lang.t("point12"),
                      style: const TextStyle(height: 1.4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Lang.t("point13"),
                      style: const TextStyle(height: 1.4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Lang.t("point14"),
                      style: const TextStyle(height: 1.4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Lang.t("point15"),
                      style: const TextStyle(height: 1.4),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ────────────── CONFIDENTIALITY & DISCIPLINE ──────────────
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
                      Lang.t("confidential_title"),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      Lang.t("confidential"),
                      style: const TextStyle(height: 1.4),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ────────────── JOB APPLICATION FEE ──────────────
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
                      Lang.t("fee_title"),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      Lang.t("fee_content"),
                      style: const TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
            // ────────────── AADHAAR SECTION ──────────────
            // ────────────── AADHAAR SECTION ──────────────
            Card(
              color: Colors.grey.shade50,
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Enter Aadhaar Number",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Aadhaar Input Field
                    TextField(
                      controller: aadhaarController,
                      keyboardType: TextInputType.number,
                      maxLength: 12,
                      decoration: const InputDecoration(
                        labelText: "Aadhaar Number",
                        border: OutlineInputBorder(),
                        counterText: "",
                      ),
                      onChanged: (value) {
                        setState(() {}); // refresh UI
                      },
                    ),

                    const SizedBox(height: 10),

                    // Show button only when 12 digits entered
                    if (!aadhaarVerified &&
                        aadhaarController.text.length == 12 &&
                        RegExp(
                          r'^[0-9]{12}$',
                        ).hasMatch(aadhaarController.text)) ...[
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: otpLoading
                              ? null
                              : () {
                                  extractedAadhaar = aadhaarController.text;
                                  sendAadhaarOtp();
                                },
                          child: otpLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text("Send OTP to Verify Aadhaar"),
                        ),
                      ),
                    ],

                    if (aadhaarVerified)
                      const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text(
                          "✅ Aadhaar Verified",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ────────────── SIGNATURE SECTION ──────────────
            Card(
              color: Colors.grey.shade50,
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      Lang.t("upload_signature"),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: showSignatureSourceSheet,
                      child: Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: signatureFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  signatureFile!,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : Center(
                                child: Text(
                                  Lang.t("tap_upload"),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: agreed,
                          onChanged: (v) {
                            setState(() => agreed = v ?? false);
                          },
                        ),
                        Expanded(
                          child: Text(
                            "By accepting, you agree to our terms & conditions.",
                            style: TextStyle(fontSize: 12),
                            overflow: TextOverflow.visible,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: loading ? null : submitConsent,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
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
                            : Text(
                                "Submit & Pay", // or "Pay & Submit" if you prefer
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
