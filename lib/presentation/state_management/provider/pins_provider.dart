import 'package:flutter_riverpod/legacy.dart';
import 'package:pinterest/data/repositories/pins_repostiory.dart';
import 'package:pinterest/presentation/models/pin_view_model.dart';
import 'package:pinterest/presentation/state_management/provider/hive_boxes_provider.dart';


enum PinsFilter { all, favorites, created }
enum PinsLayout { standard, wide, compact }

class PinsState {
  final List<PinViewModel> pins;
  final PinsFilter filter;
  final PinsLayout layout;

  const PinsState({
    required this.pins,
    this.filter = PinsFilter.all,
    this.layout = PinsLayout.standard,
  });

  PinsState copyWith({
    List<PinViewModel>? pins,
    PinsFilter? filter,
    PinsLayout? layout,
  }) {
    return PinsState(
      pins: pins ?? this.pins,
      filter: filter ?? this.filter,
      layout: layout ?? this.layout,
    );
  }
}

class PinsNotifier extends StateNotifier<PinsState> {
  final BoardsRepository repo;

  PinsNotifier(this.repo)
      : super(PinsState(pins: repo.getAllPins()));

  void setFilter(PinsFilter filter) {
    switch (filter) {
      case PinsFilter.favorites:
        state = state.copyWith(
          filter: filter,
          pins: repo.getFavoritePins(),
        );
        break;

      case PinsFilter.created:
        state = state.copyWith(
          filter: filter,
          pins: repo.getRecentPins(),
        );
        break;

      case PinsFilter.all:
        state = state.copyWith(
          filter: filter,
          pins: repo.getAllPins(),
        );
        break;
    }
  }

  void setLayout(PinsLayout layout) {
    state = state.copyWith(layout: layout);
  }
}

final pinsProvider =
    StateNotifierProvider<PinsNotifier, PinsState>(
  (ref) {
    final boardsBox = ref.read(boardsBoxProvider);
    return PinsNotifier(BoardsRepository(boardsBox));
  },
);
