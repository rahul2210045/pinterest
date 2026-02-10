import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pinterest/data/local/board_model.dart';
import 'package:pinterest/data/local/saved_pin_model.dart';

final boardsBoxListenableProvider = Provider<ValueListenable<Box<BoardModel>>>((
  ref,
) {
  return Hive.box<BoardModel>('boardsBox').listenable();
});

final allSavedPinsProvider = Provider<List<SavedPinModel>>((ref) {
  final listenable = ref.watch(boardsBoxListenableProvider);
  final box = listenable.value;

  final allPins = <SavedPinModel>[];

  for (final board in box.values) {
    allPins.addAll(board.pins);
  }

  allPins.sort((a, b) => b.savedAt.compareTo(a.savedAt));

  return allPins;
});
