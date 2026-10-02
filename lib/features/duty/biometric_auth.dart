import 'package:local_auth/local_auth.dart';

class BiometricAuth {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> hasFaceBiometric() async {
    try {
      final available = await _auth.getAvailableBiometrics();
      return available.contains(BiometricType.face);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> authenticate({
    String reason = "Authenticate to continue",
  }) async {
    try {
      final bool isSupported = await _auth.isDeviceSupported();
      final bool canCheck = await _auth.canCheckBiometrics;
      final available = await _auth.getAvailableBiometrics();

      if (!isSupported || !canCheck || available.isEmpty) {
        return false;
      }

      final bool authenticated = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        sensitiveTransaction: true,
        persistAcrossBackgrounding: false,
      );

      return authenticated;
    } catch (_) {
      return false;
    }
  }
}
