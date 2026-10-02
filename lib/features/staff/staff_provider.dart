import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../core/network/api_client.dart';

final staffProvider =
    StateNotifierProvider<StaffNotifier, AsyncValue<Map<String, dynamic>?>>(
      (ref) => StaffNotifier(),
    );

class StaffNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  StaffNotifier() : super(const AsyncValue.data(null));

  /// Apply staff (POST /staff/apply)
  Future<void> apply(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    final res = await ApiClient.post("/staff/apply", data);
    state = AsyncData(res);
  }
  
  /// Fetch staff profile (GET /staff/{id})
  /// ⚠️ Backend endpoint required later
  Future<void> fetch(String id) async {
    state = const AsyncLoading();
    final res = await ApiClient.get("/staff/$id");
    state = AsyncData(res);
  }
}
