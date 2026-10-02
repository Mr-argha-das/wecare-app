import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/features/auth/nurse_update_password_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:healthcare/core/network/api_client.dart';
import 'package:healthcare/core/theme/app_theme.dart';

class NurseEditProfilePage extends StatefulWidget {
  const NurseEditProfilePage({super.key});

  @override
  State<NurseEditProfilePage> createState() => _NurseEditProfilePageState();
}

class _NurseEditProfilePageState extends State<NurseEditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  // ---------------- CONTROLLERS ----------------
  final phoneCtrl = TextEditingController();

  final otherPhoneCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final fatherCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  // @override
  // void dispose() {
  //   phoneCtrl.dispose();
  //   otherPhoneCtrl.dispose();
  //   nameCtrl.dispose();
  //   fatherCtrl.dispose();
  //   emailCtrl.dispose();
  //   super.dispose();
  // }

  String nurseType = "GNM";
  String? resPassword;
  DateTime? joiningDate;

  // new picked files
  File? profilePhoto;
  File? digitalSignature;
  List<File> qualificationDocs = [];
  List<File> experienceDocs = [];
  List<File> police = [];

  // existing urls (important)
  String? existingProfilePhoto;
  String? existingSignature;
  List<String> existingQualificationDocs = [];
  List<String> existingExperienceDocs = [];
  List<String> existingpolice = [];
  File? aadhaarFront;
  String? extractedAadhaar; // API se jo number aayega
  bool aadhaarLoading = false;
  bool loading = false;

  // =========================================================
  // INIT
  // =========================================================

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  // =========================================================
  // LOAD PROFILE (GET API)
  

  Future<void> loadProfile() async {
    try {
      setState(() => loading = true);

      late final Map<String, dynamic> res;
      try {
        res = await ApiClient.get("/nurse/self-signup/me");
      } catch (_) {
        final data = await ApiClient.get("/nurse/profile/me/json");
        res = {
          ...data["nurse"],
          "phone": data["nurse"]["phone"],
          "other_number": data["nurse"]["other_number"],
          "name": data["nurse"]["name"],
          "father_name": data["nurse"]["father_name"],
          "email": data["nurse"]["email"],
          "profile_photo": data["nurse"]["profile_photo"],
          "digital_signature": data["nurse"]["digital_signature"],
          "qualification_docs": data["nurse"]["qualification_docs"],
          "experience_docs": data["nurse"]["experience_docs"],
          "police": data["nurse"]["police"],
          "joining_date": data["nurse"]["joining_date"],
        };
      }

      phoneCtrl.text = res["phone"] ?? "";
      resPassword = res["password_hash"] ?? "";
      otherPhoneCtrl.text = res["other_number"] ?? "";
      nameCtrl.text = res["name"] ?? "";
      fatherCtrl.text = res["father_name"] ?? "";
      emailCtrl.text = res["email"] ?? "";

      nurseType = res["nurse_type"] ?? "GNM";

      if (res["joining_date"] != null) {
        joiningDate = DateTime.parse(res["joining_date"]);
      }

      existingProfilePhoto = res["profile_photo"];
      existingSignature = res["digital_signature"];
      existingQualificationDocs = List<String>.from(
        res["qualification_docs"] ?? [],
      );
      existingExperienceDocs = List<String>.from(res["experience_docs"] ?? []);
      existingpolice = List<String>.from(res["police"] ?? []);

      setState(() {});
    } catch (e) {
      _snack("Failed to load profile", error: true);
    } finally {
      setState(() => loading = false);
    }
  }

  // =========================================================
  // SUBMIT UPDATE (PUT API)
  // =========================================================

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      // -------- profile photo --------
      String? profilePhotoPath = existingProfilePhoto;
      if (profilePhoto != null) {
        profilePhotoPath = await FileUploadService.uploadFile(profilePhoto!);
      }

      // -------- signature --------
      String? signaturePath = existingSignature;
      if (digitalSignature != null) {
        signaturePath = await FileUploadService.uploadFile(digitalSignature!);
      }

      // -------- qualification --------
      List<String> qualificationPaths = [...existingQualificationDocs];
      for (final f in qualificationDocs) {
        qualificationPaths.add(await FileUploadService.uploadFile(f));
      }

      // -------- experience --------
      List<String> experiencePaths = [...existingExperienceDocs];
      for (final f in experienceDocs) {
        experiencePaths.add(await FileUploadService.uploadFile(f));
      }
      // -------- experience --------
      List<String> policePaths = [...existingpolice];
      for (final f in police) {
        // ← use new picked files
        policePaths.add(await FileUploadService.uploadFile(f));
      }

      final payload = {
        "phone": phoneCtrl.text,
        "other_number": otherPhoneCtrl.text,
        "name": nameCtrl.text,
        "father_name": fatherCtrl.text,
        "email": emailCtrl.text,
        "nurse_type": nurseType,
        "joining_date": joiningDate != null
            ? DateFormat("yyyy-MM-dd").format(joiningDate!)
            : null,
        "profile_photo": profilePhotoPath,
        "digital_signature": signaturePath,
        "qualification_docs": qualificationPaths,
        "experience_docs": experiencePaths,
        "police": policePaths,
      };

      await ApiClient.put("/nurse/self-signup/update", payload);

      _snack("Profile Updated Successfully ✅");
      Navigator.pop(context, true);
    } catch (e) {
      _snack("Update failed: $e", error: true);
    } finally {
      setState(() => loading = false);
    }
  }

  // =========================================================
  // IMAGE PICKERS
  // =========================================================
  String? referenceId;
  bool otpLoading = false;
  bool aadhaarVerified = false;

  

  Future<File?> _pickSingle() async {
    final x = await picker.pickImage(source: ImageSource.gallery);
    return x != null ? File(x.path) : null;
  }

  Future<void> _pickMultiple(List<File> target) async {
    final files = await picker.pickMultiImage();
    target.addAll(files.map((e) => File(e.path)));
    setState(() {});
  }


  // =========================================================
  // UI
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primarylight,
      appBar: AppBar(title: const Text("Edit Profile"), centerTitle: true),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// PROFILE PHOTO
                    GestureDetector(
                      onTap: () async {
                        profilePhoto = await _pickSingle();
                        setState(() {});
                      },
                      child: CircleAvatar(
                        radius: 45,
                        backgroundImage: profilePhoto != null
                            ? FileImage(profilePhoto!)
                            : existingProfilePhoto != null
                            ? NetworkImage(existingProfilePhoto!)
                                  as ImageProvider
                            : null,
                        child:
                            profilePhoto == null && existingProfilePhoto == null
                            ? const Icon(Icons.camera_alt)
                            : null,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // GestureDetector(
                    //   onTap: () async {
                    //     // 🔥 async add karo

                    //     final updated = await Navigator.push(
                    //       context,
                    //       CupertinoPageRoute(
                    //         builder: (_) => NurseUpdatePasswordPage(
                    //           phone: phoneCtrl.text,
                    //           currentPassword: resPassword,
                    //         ),
                    //       ),
                    //     );

                    //     if (updated == true) {
                    //       loadProfile(); // 🔥 refresh API again
                    //     }
                    //   },
                    //   child: Container(
                    //     padding: const EdgeInsets.symmetric(
                    //       vertical: 10,
                    //       horizontal: 14,
                    //     ),
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(10),
                    //       border: Border.all(color: AppTheme.primary),
                    //     ),
                    //     child: const Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Icon(
                    //           Icons.lock_reset,
                    //           size: 18,
                    //           color: AppTheme.primary,
                    //         ),
                    //         SizedBox(width: 8),
                    //         Text(
                    //           "Update Admin Password",
                    //           style: TextStyle(
                    //             color: AppTheme.primary,
                    //             fontWeight: FontWeight.w600,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 20),

                    // _field(phoneCtrl, "Phone"),
                    _field(otherPhoneCtrl, "Alternate Phone"),
                    _field(nameCtrl, "Name"),
                    _field(fatherCtrl, "Father Name"),
                    _field(emailCtrl, "Email"),

                    // _field(policeCtrl, "Aadhaar Number"),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      initialValue: nurseType,
                      items: const [
                        DropdownMenuItem(value: "GNM", child: Text("GNM")),
                        DropdownMenuItem(value: "ANM", child: Text("ANM")),
                        DropdownMenuItem(
                          value: "CARETAKER",
                          child: Text("Caretaker"),
                        ),
                        DropdownMenuItem(
                          value: "PHYSIO",
                          child: Text("Physio"),
                        ),
                        DropdownMenuItem(value: "COMBO", child: Text("Combo")),
                        DropdownMenuItem(value: "OTHER", child: Text("Other")),
                      ],
                      onChanged: (v) => setState(() => nurseType = v!),
                      decoration: _dec("Nurse Type"),
                    ),
                    const SizedBox(height: 12),

                    

                    

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => _pickMultiple(qualificationDocs),
                        child: Text(
                          "Add Qualification Docs (${existingQualificationDocs.length + qualificationDocs.length})",
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => _pickMultiple(experienceDocs),
                        child: Text(
                          "Add Experience Docs (${existingExperienceDocs.length + experienceDocs.length})",
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => _pickMultiple(police),
                        child: Text(
                          "Add Police Verification (${existingpolice.length + police.length})",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: loading ? null : submit,
          child: const Text("Update Profile"),
        ),
      ),
    );
  }

  // =========================================================
  // HELPERS
  // =========================================================

  Widget _field(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        validator: (v) => v!.isEmpty ? "Required" : null,
        decoration: _dec(label),
      ),
    );
  }

  InputDecoration _dec(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppTheme.primarylight,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),

      // normal
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
      ),

      // focused
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.primary, width: 1),
      ),
    );
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }
}
