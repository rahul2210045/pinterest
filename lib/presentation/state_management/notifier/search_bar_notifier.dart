import 'package:flutter_riverpod/legacy.dart';
import 'package:pinterest/data/repositories/pexels_repository.dart';
import 'package:pinterest/presentation/state_management/provider/search_bar_provider.dart';

class SearchResultNotifier extends StateNotifier<SearchResultState> {
  final PexelsRepository repo;
  final String query;

  int _page = 1;
  bool _hasMore = true;

  SearchResultNotifier(this.repo, this.query)
      : super(const SearchResultState()) {
    loadInitial();
  }

  /// INITIAL LOAD (shimmer only once)
  Future<void> loadInitial() async {
    _page = 1;
    _hasMore = true;

    state = state.copyWith(isInitialLoading: true);

    final data = await repo.searchPhotos(
      query,
      page: _page,
    );

    state = state.copyWith(
      isInitialLoading: false,
      photos: data,
    );

    if (data.isEmpty) {
      _hasMore = false;
    }
  }

  /// PAGINATION (loader only, no shimmer)
  Future<void> loadMore() async {
    if (state.isPaginating || !_hasMore) return;

    state = state.copyWith(isPaginating: true);
    _page++;

    final more = await repo.searchPhotos(
      query,
      page: _page,
    );

    if (more.isEmpty) {
      _hasMore = false;
    }

    state = state.copyWith(
      isPaginating: false,
      photos: [...state.photos, ...more],
    );
  }
}

