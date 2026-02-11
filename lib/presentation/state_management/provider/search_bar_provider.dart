import 'package:flutter_riverpod/legacy.dart';
import 'package:pinterest/data/repositories/pexels_repository_provider.dart';
import 'package:pinterest/presentation/state_management/notifier/search_bar_notifier.dart';

final searchResultProvider =
    StateNotifierProvider.family<SearchResultNotifier, SearchResultState, String>(
  (ref, query) {
    return SearchResultNotifier(ref.read(pexelsRepositoryProvider), query);
  },
);
class SearchResultState {
  final bool isInitialLoading;
  final bool isPaginating;
  final List<dynamic> photos;

  const SearchResultState({
    this.isInitialLoading = true,
    this.isPaginating = false,
    this.photos = const [],
  });

  SearchResultState copyWith({
    bool? isInitialLoading,
    bool? isPaginating,
    List<dynamic>? photos,
  }) {
    return SearchResultState(
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isPaginating: isPaginating ?? this.isPaginating,
      photos: photos ?? this.photos,
    );
  }
}

