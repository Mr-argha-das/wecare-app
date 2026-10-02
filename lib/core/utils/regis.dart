import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthcare/core/lang/language_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:healthcare/core/network/api_client.dart';
import 'package:healthcare/core/theme/app_theme.dart';
import 'package:healthcare/core/lang/app_strings.dart';

class NurseSelfSignupPage extends ConsumerStatefulWidget {
  const NurseSelfSignupPage({super.key});

  @override
  ConsumerState<NurseSelfSignupPage> createState() =>
      _NurseSelfSignupPageState();
}

class _NurseSelfSignupPageState extends ConsumerState<NurseSelfSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  // Controllers
  final phoneCtrl = TextEditingController();
  final otherPhoneCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final fatherCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final aadhaarCtrl = TextEditingController();

  String nurseType = "GNM";
  DateTime? joiningDate;

  File? profilePhoto;
  File? digitalSignature;
  List<File> qualificationDocs = [];
  List<File> experienceDocs = [];

  bool loading = false;

  // ---------------- IMAGE PICKERS ----------------

  Future<ImageSource?> _pickSource(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  Future<File?> _pickSingle(BuildContext context) async {
    final source = await _pickSource(context);
    if (source == null) return null;
    final x = await picker.pickImage(source: source, imageQuality: 70);
    return x != null ? File(x.path) : null;
  }

  Future<void> _pickMultipleDocs(
    BuildContext context,
    List<File> target,
  ) async {
    final source = await _pickSource(context);
    if (source == null) return;

    if (source == ImageSource.gallery) {
      final files = await picker.pickMultiImage(imageQuality: 70);
      target.addAll(files.map((e) => File(e.path)));
    } else {
      final file = await picker.pickImage(source: ImageSource.camera);
      if (file != null) target.add(File(file.path));
    }
    setState(() {});
  }

  // ---------------- SUBMIT ----------------

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) {
      _snack("Please fill all required fields", error: true);
      return;
    }
    if (joiningDate == null) {
      _snack("Please select joining date", error: true);
      return;
    }

    if (profilePhoto == null) {
      _snack("Please upload profile photo", error: true);
      return;
    }
    setState(() => loading = true);

    try {
      String? profilePhotoPath;
      String? signaturePath;
      List<String> qualificationPaths = [];
      List<String> experiencePaths = [];

      if (profilePhoto != null) {
        profilePhotoPath = await FileUploadService.uploadFile(profilePhoto!);
      }
      if (digitalSignature != null) {
        signaturePath = await FileUploadService.uploadFile(digitalSignature!);
      }

      for (final f in qualificationDocs) {
        qualificationPaths.add(await FileUploadService.uploadFile(f));
      }
      for (final f in experienceDocs) {
        experiencePaths.add(await FileUploadService.uploadFile(f));
      }

      final payload = {
        "phone": phoneCtrl.text,
        "other_number": otherPhoneCtrl.text,
        "name": nameCtrl.text,
        "father_name": fatherCtrl.text.isNotEmpty ? fatherCtrl.text : null,
        "email": emailCtrl.text.isNotEmpty ? emailCtrl.text : null,
        "nurse_type": nurseType,
        "aadhaar_number": aadhaarCtrl.text.isNotEmpty ? aadhaarCtrl.text : null,
        "joining_date": DateFormat("yyyy-MM-dd").format(joiningDate!),
        "profile_photo": profilePhotoPath,
        "digital_signature": signaturePath,
        "qualification_docs": qualificationPaths,
        "experience_docs": experiencePaths,
      };

      await ApiClient.post("/nurse/self-signup", payload);

      _snack("Signup successful. Await admin approval ✅");
      Navigator.pop(context, true);
    } catch (e) {
      print("SIGNUP ERROR: $e");
      _snack("Signup failed: $e", error: true);
    } finally {
      setState(() => loading = false);
    }
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primarylight,
      appBar: AppBar(
        title: Text(T.t(ref, "title")),
        centerTitle: true,

        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: (locale) {
              ref.read(languageProvider.notifier).state = locale;
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: Locale('en'), child: Text("English")),
              PopupMenuItem(value: Locale('hi'), child: Text("हिन्दी")),
              PopupMenuItem(value: Locale('gu'), child: Text("ગુજરાતી")),
              PopupMenuItem(value: Locale('bn'), child: Text("বাংলা")),
              PopupMenuItem(value: Locale('mr'), child: Text("मराठी")),
              PopupMenuItem(value: Locale('ta'), child: Text("தமிழ்")),
              PopupMenuItem(value: Locale('te'), child: Text("తెలుగు")),
              PopupMenuItem(value: Locale('kn'), child: Text("ಕನ್ನಡ")),
            ],
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // PROFILE PHOTO
              GestureDetector(
                onTap: () async {
                  profilePhoto = await _pickSingle(context);
                  setState(() {});
                },
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: AppTheme.primary,
                  backgroundImage: profilePhoto != null
                      ? FileImage(profilePhoto!)
                      : null,
                  child: profilePhoto == null
                      ? const Icon(Icons.camera_alt, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 20),

              _SectionCard(
                title: T.t(ref, "personal_info"),
                icon: Icons.person,
                child: Column(
                  children: [
                    _field(phoneCtrl, T.t(ref, "phone"), TextInputType.phone),
                    _field(
                      otherPhoneCtrl,
                      "Alternate Phone",
                      TextInputType.phone,
                    ),
                    _field(nameCtrl, T.t(ref, "name")),
                    _field(fatherCtrl, "Father Name"),
                    _field(emailCtrl, T.t(ref, "email")),
                  ],
                ),
              ),

              _SectionCard(
                title: "Professional Details",
                icon: Icons.medical_services,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
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
                          child: Text("Physiotherapist"),
                        ),
                        DropdownMenuItem(value: "COMBO", child: Text("Combo")),
                        DropdownMenuItem(value: "OTHER", child: Text("Other")),
                      ],
                      onChanged: (v) => setState(() => nurseType = v!),
                      decoration: _inputDecoration("Nurse Type"),
                    ),
                    const SizedBox(height: 13),
                    _field(aadhaarCtrl, "Aadhaar Number", TextInputType.number),
                    const SizedBox(height: 2),
                    _datePicker(),
                  ],
                ),
              ),

              _SectionCard(
                title: "Documents Upload",
                icon: Icons.upload_file,
                child: Column(
                  children: [
                    _UploadTile(
                      title: "Digital Signature",
                      count: digitalSignature == null ? 0 : 1,
                      onTap: () async {
                        digitalSignature = await _pickSingle(context);
                        setState(() {});
                      },
                    ),
                    _UploadTile(
                      title: "Qualifications",
                      count: qualificationDocs.length,
                      onTap: () =>
                          _pickMultipleDocs(context, qualificationDocs),
                    ),
                    _UploadTile(
                      title: "Experience",
                      count: experienceDocs.length,
                      onTap: () => _pickMultipleDocs(context, experienceDocs),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // SUBMIT
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: loading ? null : submit,
            child: loading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    T.t(ref, "Submit Application"),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
    );
  }

  // ---------------- HELPERS ----------------

  Widget _datePicker() {
    return InkWell(
      onTap: () async {
        joiningDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.primarylight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                joiningDate == null
                    ? T.t(ref, "Select Joining Date")
                    : DateFormat("dd MMM yyyy").format(joiningDate!),
              ),
            ),
            const Icon(Icons.calendar_month),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label, [
    TextInputType type = TextInputType.text,
  ]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: type,
        validator: (v) => v!.isEmpty ? "Required" : null,
        decoration: _inputDecoration(label),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppTheme.primarylight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
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

// ---------------- UI COMPONENTS ----------------

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final IconData icon;

  const _SectionCard({
    required this.title,
    required this.child,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: .5,
      color: Colors.grey.shade50,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _UploadTile extends StatelessWidget {
  final String title;
  final int count;
  final VoidCallback onTap;

  const _UploadTile({
    required this.title,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: const Icon(Icons.upload),
      title: Text(title),
      trailing: count > 0
          ? CircleAvatar(
              radius: 12,
              backgroundColor: Colors.green,
              child: Text(
                "$count",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          : const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
