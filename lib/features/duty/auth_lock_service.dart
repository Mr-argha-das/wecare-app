import 'package:healthcare/features/duty/permission_service.dart';
import 'package:local_auth/local_auth.dart';


class AuthLockService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> authenticate({required String reason}) async {
    final available = await BiometricHelper.isBiometricOrPinAvailable();

    if (!available) return false;

    return await _auth.authenticate(
      localizedReason: reason,
      biometricOnly: false, // PIN allowed
      sensitiveTransaction: true,
      persistAcrossBackgrounding: false,
    );
  }
}