import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';

final sosProvider = Provider((ref) => SosService());

class SosService {
  Future<void> send(String staffId, String msg) async {
    await ApiClient.post("/staff/$staffId/sos?message=$msg", {});
  }
}
