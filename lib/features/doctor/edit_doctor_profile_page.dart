import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/core/network/api_client.dart';
import 'package:healthcare/core/theme/app_theme.dart';
import 'package:healthcare/features/auth/nurse_update_password_page.dart';

class EditDoctorProfilePage extends StatefulWidget {
  const EditDoctorProfilePage({super.key});

  @override
  State<EditDoctorProfilePage> createState() => _EditDoctorProfilePageState();
}

class _EditDoctorProfilePageState extends State<EditDoctorProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final specializationController = TextEditingController();
  // final registrationController = TextEditingController();
  final nameController = TextEditingController();
  final experienceController = TextEditingController();
  final phoneController = TextEditingController();

  bool isLoading = false;
  String? currentPassword;

  // ======================================================
  // 🔥 LOAD PROFILE (GET /profile/me)
  // ======================================================
  Future<void> loadProfile() async {
    try {
      setState(() => isLoading = true);

      final data = await ApiClient.get("/doctor/profile/me");

      print(data);
      specializationController.text = data["specialization"] ?? "";
      nameController.text = data["name"] ?? "";
      phoneController.text = data["phone"] ?? "";
      currentPassword = data["password_hash"] ?? "";

      // registrationController.text = data["registration_number"] ?? "";

      experienceController.text = (data["experience_years"] ?? "").toString();
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ======================================================
  // 🔥 UPDATE PROFILE (PUT /profile/update)
  // ======================================================
  Future<void> updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => isLoading = true);

      await ApiClient.put("/doctor/profile/update", {
        "name": nameController.text,
        "specialization": specializationController.text,
        "experience_years": int.parse(experienceController.text),
      });

      _showSuccess("Profile updated successfully ✅");
      Navigator.pop(context);
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ======================================================
  // UI HELPERS
  // ======================================================
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void initState() {
    super.initState();
    loadProfile(); // 🔥 load automatically
  }

  @override
  void dispose() {
    specializationController.dispose();
    nameController.dispose();
    experienceController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primarylight,
      appBar: AppBar(title: const Text("Edit Profile")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // GestureDetector(
                    //   onTap: () async {
                    //     final updated = await Navigator.push(
                    //       context,
                    //       CupertinoPageRoute(
                    //         builder: (_) => NurseUpdatePasswordPage(
                    //           phone: phoneController.text,
                    //           currentPassword: currentPassword,
                    //         ),
                    //       ),
                    //     );

                    //     if (updated == true) {
                    //       loadProfile(); // ✅ correct name
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
                    //           "Update Password",
                    //           style: TextStyle(
                    //             color: AppTheme.primary,
                    //             fontWeight: FontWeight.w600,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 20),
                    // ======================
                    // Specialization
                    // ======================
                    TextFormField(
                      controller: specializationController,
                      decoration: InputDecoration(
                        labelText: "Specialization",

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),

                        // normal
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),

                        // focused
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppTheme.primary,
                            width: 1,
                          ),
                        ),
                      ),
                      validator: (v) => v!.isEmpty ? "Required" : null,
                    ),

                    const SizedBox(height: 16),

                    // ======================
                    // Registration Number
                    // ======================
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),

                        // normal
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.2,
                          ),
                        ),

                        // focused
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppTheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (v) => v!.isEmpty ? "Required" : null,
                    ),

                    const SizedBox(height: 16),

                    // ======================
                    // Experience
                    // ======================
                    TextFormField(
                      controller: experienceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Experience (years)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),

                        // normal
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.2,
                          ),
                        ),

                        // focused
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppTheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (v) => v!.isEmpty ? "Required" : null,
                    ),

                    const SizedBox(height: 30),

                    // ======================
                    // Save Button
                    // ======================
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: updateProfile,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
