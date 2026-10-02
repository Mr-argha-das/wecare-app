import 'package:permission_handler/permission_handler.dart';

class AppPermissions {

  static Future<void> requestAll() async {

    List<Permission> permissions = [
      Permission.camera,
      Permission.locationWhenInUse,
      Permission.locationAlways,
      Permission.photos,        // READ_MEDIA_IMAGES
      Permission.notification,  // Android 13+
    ];

    Map<Permission, PermissionStatus> result =
        await permissions.request();

    result.forEach((permission, status) {

      if (status.isGranted) {
        print("✅ $permission granted");
      }
      else if (status.isDenied) {
        print("❌ $permission denied");
      }
      else if (status.isPermanentlyDenied) {
        print("🚫 $permission permanently denied");
        openAppSettings();
      }

    });
  }
}
