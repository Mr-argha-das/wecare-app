import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/core/network/api_client.dart';
import 'package:healthcare/core/network/base.dart';
import 'package:healthcare/core/storage/token_storage.dart';
import 'package:healthcare/core/storage/payment_storage.dart';
import 'package:healthcare/core/theme/app_theme.dart';
import 'package:healthcare/features/auth/about_us_page.dart';
import 'package:healthcare/features/duty/pataint_term.dart';
import 'package:healthcare/features/pataint/myComplaint.page.dart';
import 'package:healthcare/features/pataint/patient_update_profile_page.dart';
import 'package:healthcare/features/payment/payment_verification_page.dart';
import 'package:healthcare/routes/app_routes.dart';
import 'package:intl/intl.dart';

class PataintProfilePage extends StatefulWidget {
  const PataintProfilePage({super.key});

  @override
  State<PataintProfilePage> createState() => _PataintProfilePageState();
}

class _PataintProfilePageState extends State<PataintProfilePage> {
  Future<dynamic>? future;
  bool _checkingPayment = true;
  String? _paymentError;

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await TokenStorage.clearToken();
    await TokenStorage.clearRole();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
          "This action will permanently remove your account and linked patient records. Continue?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ApiClient.delete("/auth/delete-account", {});
      await TokenStorage.clearToken();
      await TokenStorage.clearRole();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account deactivated successfully")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      final payment = await ApiClient.get("/payments/my-status");
      if (!mounted) return;

      if (payment["paid"] == true) {
        setState(() {
          future = ApiClient.get("/patient/profile/view");
          _checkingPayment = false;
        });
        return;
      }

      final orderId = payment["order_id"]?.toString();
      final paymentStatus = payment["status"]?.toString() ?? "not_started";
      if (orderId != null && orderId.isNotEmpty) {
        await PaymentStorage.save(
          orderId: orderId,
          flow: "patient",
          localStatus: paymentStatus,
        );
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentVerificationPage(
              orderId: orderId,
              flow: "patient",
              initialStatus: paymentStatus,
            ),
          ),
          (_) => false,
        );
        return;
      }

      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (_) => const PataintTermCondiation()),
        (_) => false,
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _checkingPayment = false;
        _paymentError = error.toString().replaceAll("Exception:", "").trim();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingPayment) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_paymentError != null || future == null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off_rounded,
                    size: 56, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  _paymentError ?? "Could not verify payment status.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () {
                    setState(() {
                      _checkingPayment = true;
                      _paymentError = null;
                    });
                    _bootstrap();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text("TRY AGAIN"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppTheme.primarylight,
        appBar: AppBar(
          leading: Container(),
          title: const Text("🧑‍⚕️ Patient Details"),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline), // about icon
              tooltip: "About Us",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutUsPage()),
                );
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "Details"),
              Tab(text: "Vitals"),
              Tab(text: "Medications"),
              Tab(text: "Equip"),
            ],
          ),
        ),
        body: FutureBuilder<dynamic>(
          future: future!,
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snap.data!;
            return TabBarView(
              children: [
                _DetailsTab(data),
                _VitalsTab(data["vitals"]),
                _MedicationsTab(data["medications"]),
                EquipmentPage(patientId: ''),
              ],
            );
          },
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _deleteAccount,
                  icon: const Icon(Icons.delete_forever),
                  label: const Text("Delete Account"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 14),
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

class EquipmentPage extends StatefulWidget {
  final String patientId;

  const EquipmentPage({super.key, required this.patientId});

  @override
  State<EquipmentPage> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  List equipments = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadEquipments();
  }

  ///////////////////////////////////////////////////////
  /// LOAD EQUIPMENTS
  ///////////////////////////////////////////////////////
  Future<void> loadEquipments() async {
    try {
      final res = await ApiClient.get("/equipment/equipment-getall");

      setState(() {
        equipments = res;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  ///////////////////////////////////////////////////////
  /// REQUEST EQUIPMENT
  ///////////////////////////////////////////////////////
  Future<void> requestEquipment(String equipmentId) async {
    try {
      await ApiClient.post("/equipment/request-equipment", {
        "equipment_id": equipmentId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Request sent successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  ///////////////////////////////////////////////////////
  /// UI
  ///////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primarylight,
      appBar: AppBar(title: const Text("Equipments")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : equipments.isEmpty
              ? const Center(child: Text("No equipments found"))
              : RefreshIndicator(
                  onRefresh: loadEquipments,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: equipments.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final e = equipments[index];

                      return _equipmentCard(e);
                    },
                  ),
                ),
    );
  }

  ///////////////////////////////////////////////////////
  /// CARD WIDGET
  ///////////////////////////////////////////////////////
  Widget _equipmentCard(Map e) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade50,
        boxShadow: [
          BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.08)),
        ],
      ),
      child: Column(
        children: [
          //////////////////////////////////////
          /// IMAGE
          //////////////////////////////////////
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                baseUrlApi + e["image"],
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 60),
              ),
            ),
          ),

          //////////////////////////////////////
          /// TITLE
          //////////////////////////////////////
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              e["title"],
              style: const TextStyle(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),

          //////////////////////////////////////
          /// BUTTON
          //////////////////////////////////////
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => requestEquipment(e["id"]),
                child: const Text("Request"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsTab extends StatelessWidget {
  final Map data;
  const _DetailsTab(this.data);

  @override
  Widget build(BuildContext context) {
    final patient = data["patient"];
    final duties = data["duties"];
    final notes = data["notes"];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        /// BASIC INFO
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // 🔥 HEADER (Title + Edit)
              // =========================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "👤 Basic Information",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  // ✅ EDIT BUTTON
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    tooltip: "Edit Profile",
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => PatientUpdateProfilePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // =========================
              // GRID
              // =========================
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 20,
                  mainAxisExtent: 60,
                ),
                itemBuilder: (_, i) {
                  final items = [
                    _info("Name", patient["name"]),
                    _info("Phone", patient["phone"]),
                    _info("Age", patient["age"]),
                    _info("Gender", patient["gender"]),
                    _info("Address", patient["address"]),
                    _info("Service Start", patient["service_start"]),
                  ];
                  return items[i];
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => MyComplaintsPage()),
            );
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                "Raise Complaint",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),

        /// NURSE VISITS
        _Card(
          title: "👩‍⚕️ Nurse Visits",
          child: duties.isEmpty
              ? _empty()
              : Column(
                  children: duties.map<Widget>((d) {
                    return ListTile(
                      title: Text(d["nurse"]["name"]),
                      subtitle: Text(
                        "${d["nurse"]["type"]} | ${d["duty_type"]} | ${d["shift"]}",
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    );
                  }).toList(),
                ),
        ),

        /// NOTES
        _Card(
          title: "📝 Daily Notes",
          child: notes.isEmpty
              ? _empty()
              : Column(
                  children: notes.map<Widget>((n) {
                    return ListTile(
                      title:
                          Text(n["title"] ?? n["nurse_name"] ?? "Daily Note"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(n["note"] ?? ""),
                          const SizedBox(height: 4),
                          Text(
                            "By ${n["nurse_name"] ?? "Nurse"}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}

class _VitalsTab extends StatelessWidget {
  final List vitals;
  const _VitalsTab(this.vitals);

  @override
  Widget build(BuildContext context) {
    if (vitals.isEmpty) return _empty();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vitals.length,
      itemBuilder: (_, i) {
        final v = Map<String, dynamic>.from(vitals[i]);

        print("VITAL DATA => $v"); // 👈 ADD THIS

        final time = v["time"] ?? v["recorded_at"];

        Widget item(String label, dynamic value) {
          if (value == null || value.toString().isEmpty) {
            return const SizedBox();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                /// 🔹 KEY (bold left)
                Expanded(
                  flex: 2,
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),

                /// 🔹 VALUE (right aligned)
                Expanded(
                  flex: 3,
                  child: Text(
                    value.toString(),
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        }

        String formatTime(dynamic time) {
          if (time == null) return "-";

          final dt = DateTime.parse(time.toString()).toLocal();

          return DateFormat("dd MMM yyyy • hh:mm a").format(dt);
        }

        return _Card(
          title: "❤️ ${formatTime(time)}",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              item("BP", v["bp"]),
              item("Pulse", v["pulse"]),
              item("SpO₂", v["spo2"]),
              item("Temp (°F)", v["temperature"]),
              item("O₂ Level", v["o2_level"]),
              item("RBS", v["rbs"]),
              item("BiPAP", v["bipap_ventilator"]),
              item("IV Fluids", v["iv_fluids"]),
              item("Suction", v["suction"]),
              item("Feeding Tube", v["feeding_tube"]),
              item("Vomit/Aspirate", v["vomit_aspirate"]),
              item("Urine", v["urine"]),
              item("Stool", v["stool"]),
              item("Notes", v["other"]),
            ],
          ),
        );
      },
    );
  }
}

class _MedicationsTab extends StatelessWidget {
  final List meds;
  const _MedicationsTab(this.meds);

  @override
  Widget build(BuildContext context) {
    if (meds.isEmpty) return _empty();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: meds.length,
      itemBuilder: (_, i) {
        final m = meds[i];

        final notes = (m["notes"] ?? []) as List;

        return _Card(
          title: "💊 ${m["medicine"]}",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Basic info
              Text(
                "${m["dosage"]} | ${m["timing"].join(", ")}",
                style: const TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 4),

              Text(
                "Duration: ${m["duration"]} days | ₹${m["price"] ?? "-"}",
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),

              /// 🔹 Notes section
              if (notes.isNotEmpty) ...[
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 6),
                const Text(
                  "Instructions",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 6),
                ...notes.map(
                  (n) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text("• $n", style: const TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _Card extends StatelessWidget {
  final String? title; // ✅ optional now
  final Widget child;

  const _Card({this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: .5,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 show title only if provided
            if (title != null) ...[
              Text(
                title!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 12),
            ],

            child,
          ],
        ),
      ),
    );
  }
}

Widget _info(String label, dynamic val) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 2),
        Text(
          val?.toString() ?? "-",
          maxLines: 2, // 👈 important
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );

Widget _empty() => const Center(
      child: Text("No data available", style: TextStyle(color: Colors.grey)),
    );
