import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter/material.dart';

final languageProvider = StateProvider<Locale>((ref) {
  return const Locale('en');
});
