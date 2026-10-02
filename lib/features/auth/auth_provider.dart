import 'package:flutter_riverpod/legacy.dart';

class AuthState {
  final String? token;
  final String? staffId;
  final bool loading;

  AuthState({this.token, this.staffId, this.loading = false});

  AuthState copyWith({String? token, String? staffId, bool? loading}) {
    return AuthState(
      token: token ?? this.token,
      staffId: staffId ?? this.staffId,
      loading: loading ?? this.loading,
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier()
    : super(
        // 🔥 AUTO LOGIN BYPASS (TEMP)
        AuthState(staffId: "TEMP_STAFF_ID_001", token: "TEMP_TOKEN"),
      );

  // OTP functions future ke liye safe
  Future<void> sendOtp(String phone) async {}
  Future<void> verifyOtp(String phone, String otp) async {}

  void logout() {
    state = AuthState();
  }
}
