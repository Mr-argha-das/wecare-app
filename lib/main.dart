import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthcare/firebase_options.dart';
import 'routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/responsive_app_frame.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

final FlutterLocalNotificationsPlugin localNotifications =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  runApp(const ProviderScope(child: HospitalApp()));
}

class HospitalApp extends StatefulWidget {
  const HospitalApp({super.key});

  @override
  State<HospitalApp> createState() => _HospitalAppState();
}

class _HospitalAppState extends State<HospitalApp> {
  @override
  void initState() {
    super.initState();
    initFCM();
  }

  Future<void> initFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    /// permission
    await messaging.requestPermission();

    /// token
    String? token = await messaging.getToken();
    log("FCM TOKEN => $token");

    /// foreground message
    FirebaseMessaging.onMessage.listen((message) {
      showLocal(message);
    });

    initLocal();
  }

  void initLocal() {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    localNotifications.initialize(
      settings: InitializationSettings(android: android),
    );
  }

  void showLocal(RemoteMessage message) {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    localNotifications.show(
      id: 0,
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: NotificationDetails(android: androidDetails),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: appNavigatorKey,
      title: 'Hospital Management',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme.copyWith(brightness: Brightness.dark),
      themeMode: ThemeMode.light,
      builder: (context, child) => ResponsiveAppFrame(child: child),
      initialRoute: AppRoutes.root,
      routes: AppRoutes.routes,
    );
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:healthcare/core/theme/app_theme.dart';
// import 'package:healthcare/routes/app_routes.dart';
// import 'core/lang/language_provider.dart';

// class HospitalApp extends ConsumerWidget {
//   const HospitalApp({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final locale = ref.watch(languageProvider);

//     return MaterialApp(
//       title: 'Hospital Management',
//       debugShowCheckedModeBanner: false,

//       theme: AppTheme.lightTheme,
//       themeMode: ThemeMode.light,

//       locale: locale,

//       supportedLocales: const [
//         Locale('en'),
//         Locale('hi'),
//         Locale('gu'),
//         Locale('bn'),
//         Locale('mr'),
//         Locale('ta'),
//         Locale('te'),
//         Locale('kn'),
//       ],

//       localizationsDelegates: const [
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],

//       initialRoute: AppRoutes.root,
//       routes: AppRoutes.routes,
//     );
//   }
// }
