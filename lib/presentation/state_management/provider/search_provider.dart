// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest/data/repositories/pexels_repository.dart';
import 'package:pinterest/data/repositories/pexels_repository_provider.dart';

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((
  ref,
) {
  final repo = ref.read(pexelsRepositoryProvider);
  return SearchNotifier(repo);
});

class SearchState {
  final bool isLoading;
  final List<dynamic> carousel;
  final List<FeaturedCollection> collections;
  final Map<String, List<dynamic>> ideas;

  const SearchState({
    this.isLoading = true,
    this.carousel = const [],
    this.collections = const [],
    this.ideas = const {},
  });

  SearchState copyWith({
    bool? isLoading,
    List<dynamic>? carousel,
    List<FeaturedCollection>? collections,
    Map<String, List<dynamic>>? ideas,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      carousel: carousel ?? this.carousel,
      collections: collections ?? this.collections,
      ideas: ideas ?? this.ideas,
    );
  }
}

class FeaturedCollection {
  final dynamic info;
  final List<dynamic> photos;

  FeaturedCollection({required this.info, required this.photos});
}

class SearchNotifier extends StateNotifier<SearchState> {
  final PexelsRepository repo;

  SearchNotifier(this.repo) : super(const SearchState()) {
    loadAll();
  }

  Future<void> loadAll() async {
    try {
      // 1️⃣ Carousel (7 curated images)
      final curated = await repo.fetchCuratedPhotos(perPage: 7);

      // 2️⃣ Featured collections (FILTERED)
      final featured = await repo.fetchFeaturedCollections(perPage: 10);
      final List<FeaturedCollection> validCollections = [];

      for (final c in featured) {
        final photos = await repo.fetchCollectionPhotos(c['id'], perPage: 6);

        // ✅ KEEP ONLY REAL IMAGES
        final validPhotos = photos.where((p) {
          final src = p['src'];
          return src != null && src['medium'] != null;
        }).toList();

        // ✅ MUST HAVE AT LEAST 3 IMAGES
        if (validPhotos.length >= 3) {
          validCollections.add(
            FeaturedCollection(info: c, photos: validPhotos.take(3).toList()),
          );
        }
      }

      // 3️⃣ Ideas for you (search sections)
      final ideas = <String, List<dynamic>>{};
      for (final q in [
        'Krishna',
        'Makar sankranti',
        'Ariana grande',
        'Dp for whatsapp',
        'House architecture',
        'Vision board',
        'Dance reels',
        'Pfp ideas',

        'Science',
        'Billi eilish',
        'Celebrating republic day',

        'Cute dogs',
      ]) {
        ideas[q] = await repo.searchPhotos(q, perPage: 4);
      }

      state = state.copyWith(
        isLoading: false,
        carousel: curated,
        collections: validCollections,
        ideas: ideas,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}

// class SearchNotifier extends StateNotifier<SearchState> {
//   final PexelsRepository repo;

//   SearchNotifier(this.repo) : super(const SearchState()) {
//     loadAll();
//   }

//   Future<void> loadAll() async {
//     try {
//       // 1️⃣ Carousel
//       final curated = await repo.fetchCuratedPhotos(perPage: 7);

//       // 2️⃣ Featured collections
//       final featured = await repo.fetchFeaturedCollections(perPage: 10);
//       final List<FeaturedCollection> collections = [];

//       for (final c in featured) {
//         final photos =
//             await repo.fetchCollectionPhotos(c['id'], perPage: 3);
//         collections.add(
//           FeaturedCollection(info: c, photos: photos),
//         );
//       }

//       // 3️⃣ Ideas sections
//       final ideas = <String, List<dynamic>>{};
//       for (final q in [
//         'Krishna',
//         'Makar sankranti',
//         'Science',
//         'Cute dogs',
//         'Ariana grande',
//       ]) {
//         ideas[q] = await repo.searchPhotos(q, perPage: 4);
//       }

//       state = state.copyWith(
//         isLoading: false,
//         carousel: curated,
//         collections: collections,
//         ideas: ideas,
//       );
//     } catch (_) {
//       state = state.copyWith(isLoading: false);
//     }
//   }
// }

// final searchProvider =
//     StateNotifierProvider<SearchNotifier, SearchState>((ref) {
//   return SearchNotifier();
// });

// class SearchState {
//   final bool isLoading;
//   final List<dynamic> carousel;
//   final List<dynamic> featuredCollections;
//   final Map<String, List<dynamic>> ideas;

//   SearchState({
//     this.isLoading = true,
//     this.carousel = const [],
//     this.featuredCollections = const [],
//     this.ideas = const {},
//   });

//   SearchState copyWith({
//     bool? isLoading,
//     List<dynamic>? carousel,
//     List<dynamic>? featuredCollections,
//     Map<String, List<dynamic>>? ideas,
//   }) {
//     return SearchState(
//       isLoading: isLoading ?? this.isLoading,
//       carousel: carousel ?? this.carousel,
//       featuredCollections: featuredCollections ?? this.featuredCollections,
//       ideas: ideas ?? this.ideas,
//     );
//   }
// }

// class SearchNotifier extends StateNotifier<SearchState> {
//   SearchNotifier() : super(SearchState()) {
//     loadAll();
//   }

//   Future<void> loadAll() async {
//     // TODO: replace with real APIs
//     await Future.delayed(const Duration(seconds: 2));

//     state = state.copyWith(
//       isLoading: false,
//       carousel: List.generate(7, (i) => {}),
//       featuredCollections: List.generate(10, (i) => {}),
//       ideas: {
//         "Krishna": List.generate(4, (i) => {}),
//         "Makar sankranti": List.generate(4, (i) => {}),
//         "Science": List.generate(4, (i) => {}),
//         "Cute dogs": List.generate(4, (i) => {}),
//       },
//     );
//   }
// }
