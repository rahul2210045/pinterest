import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:pinterest/data/local/board_model.dart';
import 'package:pinterest/data/local/saved_pin_model.dart';

final recentViewedProvider = Provider<List<SavedPinModel>>((ref) {
  final box = Hive.box<BoardModel>('boardsBox');

  final pins = box.values
      .expand((b) => b.pins)
      .toList();

  pins.sort((a, b) => b.savedAt.compareTo(a.savedAt));

  return pins;
});
Future<void> markPinAsViewed(SavedPinModel pin) async {
  pin.savedAt = DateTime.now();
  await pin.save(); 
}


