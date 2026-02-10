import 'package:hive/hive.dart';
import 'package:pinterest/data/local/board_model.dart';
import 'package:pinterest/presentation/models/pin_view_model.dart';


class BoardsRepository {
  final Box<BoardModel> box;

  BoardsRepository(this.box);

  List<PinViewModel> getAllPins() {
    final List<PinViewModel> pins = [];

    for (final board in box.values) {
      for (final pin in board.pins) {
        pins.add(
          PinViewModel(
            id: pin.id,
            imageUrl: pin.large,
            title: pin.alt,
            photographer: pin.photographer,
            liked: pin.liked,
            savedAt: pin.savedAt,
            width: pin.width,
            height: pin.height,
          ),
        );
      }
    }

    return pins;
  }

  List<PinViewModel> getFavoritePins() {
    return getAllPins().where((p) => p.liked).toList();
  }

  List<PinViewModel> getRecentPins() {
    final pins = getAllPins();
    pins.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return pins;
  }
}
