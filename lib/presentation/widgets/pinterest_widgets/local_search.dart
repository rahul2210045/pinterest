import 'package:pinterest/data/local/board_model.dart';
import 'package:pinterest/data/local/saved_pin_model.dart';

List<BoardModel> searchBoards(
  List<BoardModel> boards,
  String query,
) {
  final q = query.toLowerCase();
  return boards
      .where((b) => b.name.toLowerCase().contains(q))
      .toList();
}

List<SavedPinModel> searchPins(
  List<SavedPinModel> pins,
  String query,
) {
  final q = query.toLowerCase();
  return pins.where((p) {
    return p.alt.toLowerCase().contains(q) ||
        p.photographer.toLowerCase().contains(q);
  }).toList();
}
