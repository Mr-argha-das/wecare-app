import 'package:local_auth/local_auth.dart';

class BiometricHelper {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> isBiometricOrPinAvailable() async {
    try {
      final supported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      final biometrics = await _auth.getAvailableBiometrics();

      // Device supports auth AND (biometric enrolled OR PIN exists)
      return supported && (canCheck || biometrics.isNotEmpty);
    } catch (_) {
      return false;
    }
  }
}
