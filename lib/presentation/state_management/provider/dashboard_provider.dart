import 'package:flutter_riverpod/legacy.dart';
import 'package:pinterest/data/repositories/pexels_repository.dart';
import 'package:pinterest/data/repositories/pexels_repository_provider.dart';


final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final repo = ref.watch(pexelsRepositoryProvider);
  return DashboardNotifier(repo);
});

class DashboardNotifier extends StateNotifier<DashboardState> {
  final PexelsRepository repository;
  int _page = 1;
  bool _hasMore = true;

  DashboardNotifier(this.repository) : super(const DashboardState()) {
    fetchInitial();
  }

  Future<void> fetchInitial() async {
    _page = 1;
    _hasMore = true;
    state = state.copyWith(isLoading: true);

    try {
      final photos = await repository.fetchCuratedPhotos(page: _page);
      state = state.copyWith(
        photos: photos,
        isLoading: false,
        isPaginating: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refresh() async {
  if (state.isRefreshing) return;

  state = state.copyWith(isRefreshing: true);

  try {
    _page = 1;
    final fresh = await repository.fetchCuratedPhotos(page: _page);
    state = state.copyWith(
      photos: fresh,
      isRefreshing: false,
    );
  } catch (_) {
    state = state.copyWith(isRefreshing: false);
  }
}




  Future<void> loadMore() async {
    if (state.isPaginating || !_hasMore) return;

    state = state.copyWith(isPaginating: true);
    _page++;

    try {
      final more = await repository.fetchCuratedPhotos(page: _page);

      if (more.isEmpty) {
        _hasMore = false;
      }

      state = state.copyWith(
        photos: [...state.photos, ...more],
        isPaginating: false,
      );
    } catch (_) {
      state = state.copyWith(isPaginating: false);
    }
  }
}

class DashboardState {
  final List<dynamic> photos;
  final bool isLoading;
  final bool isPaginating;
  final bool isRefreshing;

  const DashboardState({
    this.photos = const [],
    this.isLoading = false,
    this.isPaginating = false,
    this.isRefreshing = false,
  });

  DashboardState copyWith({
    List<dynamic>? photos,
    bool? isLoading,
    bool? isPaginating,
    bool? isRefreshing,
  }) {
    return DashboardState(
      photos: photos ?? this.photos,
      isLoading: isLoading ?? this.isLoading,
      isPaginating: isPaginating ?? this.isPaginating,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

