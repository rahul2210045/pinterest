import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';
import 'package:pinterest/data/local/board_model.dart';
import 'package:pinterest/data/local/saved_pin_model.dart';
import 'package:uuid/uuid.dart';

final boardProvider =
    StateNotifierProvider<BoardNotifier, List<BoardModel>>((ref) {
  return BoardNotifier();
});

class BoardNotifier extends StateNotifier<List<BoardModel>> {
  final Box<BoardModel> _box = Hive.box<BoardModel>('boardsBox');

  BoardNotifier() : super([]) {
    loadBoards();
  }

  void loadBoards() {
    state = _box.values.toList();
  }

  void createBoard({
    required String name,
    required dynamic photo,
  }) {
    final pin = _mapPhotoToSavedPin(photo);

    final board = BoardModel(
      id: const Uuid().v4(),
      name: name,
      pins: [pin],
      createdAt: DateTime.now(),
    );

    _box.put(board.id, board);
    loadBoards();
  }

  void savePinToBoard(BoardModel board, dynamic photo) {
    final pin = _mapPhotoToSavedPin(photo);

    final alreadySaved = board.pins.any((p) => p.id == pin.id);
    if (alreadySaved) return;

    board.pins.insert(0, pin);
    board.save();

    loadBoards();
  }

  SavedPinModel _mapPhotoToSavedPin(dynamic photo) {
    return SavedPinModel(
      id: photo['id'],
      width: photo['width'],
      height: photo['height'],
      url: photo['url'],
      photographer: photo['photographer'],
      photographerUrl: photo['photographer_url'],
      photographerId: photo['photographer_id'],
      avgColor: photo['avg_color'],

      original: photo['src']['original'],
      large: photo['src']['large'],
      medium: photo['src']['medium'],
      small: photo['src']['small'],
      portrait: photo['src']['portrait'],
      landscape: photo['src']['landscape'],
      tiny: photo['src']['tiny'],

      alt: photo['alt'] ?? '',
      liked: photo['liked'] ?? false,

      savedAt: DateTime.now(),
    );
  }
}
