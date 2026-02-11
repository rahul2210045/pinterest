import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pinterest/data/local/saved_pin_model.dart';

final _pinsBoxProvider = Provider<Box<SavedPinModel>>(
  (ref) => Hive.box<SavedPinModel>('pinsBox'),
);

final recentViewedPinsProvider = Provider<List<SavedPinModel>>((ref) {
  final box = ref.watch(_pinsBoxProvider);
  final pins = box.values.toList();

  pins.sort((a, b) => b.savedAt.compareTo(a.savedAt));
  return pins;
});

final recentSavedPinsProvider = Provider<List<SavedPinModel>>((ref) {
  final box = ref.watch(_pinsBoxProvider);
  final pins = box.values.toList();

  pins.sort((a, b) => b.savedAt.compareTo(a.savedAt));
  return pins;
});
