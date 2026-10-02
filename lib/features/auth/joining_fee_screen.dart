// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:healthcare/features/auth/login_page.dart';
// import 'package:healthcare/services/razorpay_service.dart';

// class JoiningFeeScreen extends StatefulWidget {
//   final String userId;
//   const JoiningFeeScreen({super.key, required this.userId});

//   @override
//   State<JoiningFeeScreen> createState() => _JoiningFeeScreenState();
// }

// class _JoiningFeeScreenState extends State<JoiningFeeScreen> {
//   final RazorpayService _service = RazorpayService();
//   String status = "";
//   bool loading = false;

//   @override
//   void initState() {
//     super.initState();
//     _service.init(
//       onWaiting: () {
//         setState(() {
//           status = "Verifying payment...";
//           loading = true;
//         });
//         _pollStatus();
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _service.dispose();
//     super.dispose();
//   }

//   void _pollStatus() async {
//     for (int i = 0; i < 10; i++) {
//       await Future.delayed(const Duration(seconds: 3));
//       final result = await _service.checkStatus();

//       if (result == "success") {
//         if (!mounted) return;

//         setState(() {
//           status = "SUCCESS";
//           loading = false;
//           Navigator.pushAndRemoveUntil(
//             context,
//             CupertinoPageRoute(builder: (context) => LoginPage()),
//             (route) => false,
//           );
//         });

//         // ✅ REDIRECT TO LOGIN
//         Future.delayed(const Duration(seconds: 1), () {
//           Navigator.pushNamedAndRemoveUntil(
//             context,
//             "/login",
//             (route) => false,
//           );
//         });

//         return;
//       }

//       if (result == "failed") {
//         if (!mounted) return;

//         setState(() {
//           status = "FAILED";
//           loading = false;
//         });

//         return;
//       }
//     }

//     setState(() {
//       status = "Pending, please refresh";
//       loading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Joining Fee"), leading: SizedBox()),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 _service.createOrder(userId: widget.userId);
//               },
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: Text("Pay Joining Fee"),
//               ),
//             ),
//             const SizedBox(height: 20),
//             if (loading) const CircularProgressIndicator(),
//             const SizedBox(height: 10),
//             Text(status),
//           ],
//         ),
//       ),
//     );
//   }
// }
