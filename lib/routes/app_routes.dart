import 'package:flutter/material.dart';
import 'package:healthcare/features/duty/register.dart';

// CORE
import '../core/bootstrap/splash_page.dart';

// AUTH
import '../features/auth/login_page.dart';
import '../features/auth/otp_page.dart';

// MAIN
import '../features/duty/dashboard_page.dart';

// OTHER
import '../features/patient/patients_page.dart';
import '../features/staff/staff_apply_page.dart';
import '../features/staff/staff_profile_page.dart';
import '../features/duty/visit_page.dart';
import '../features/sos/sos_page.dart';

// 🔥 NURSE SELF SIGNUP

class AppRoutes {
  // 🔐 ROOT
  static const String root = "/";

  // AUTH
  static const String login = "/login";
  static const String otp = "/otp";

  // MAIN
  static const String dashboard = "/dashboard";

  // OTHERS
  static const String patientsList = "/patients-list";
  static const String apply = "/apply";
  static const String profile = "/profile";
  static const String visits = "/visits";
  static const String sos = "/sos";

  // 🔥 NURSE
  static const String nurseSignup = "/nurse-self-signup";

  static Map<String, WidgetBuilder> routes = {
    root: (_) => const SplashPage(),

    // AUTH
    login: (_) => const LoginPage(),
    otp: (_) => const OtpPage(),

    // MAIN
    dashboard: (_) => const DashboardPage(),

    // OTHERS
    patientsList: (_) => const PatientsPage(),
    apply: (_) => const StaffApplyPage(),
    profile: (_) => const StaffProfilePage(),
    visits: (_) => const VisitPage(),
    sos: (_) => const SOSPage(),

    // 🔥 NURSE SELF SIGNUP
    nurseSignup: (_) => const NurseSelfSignupPage(),
  };
}
