import 'package:pinterest/core/services/network_api_service.dart';

class PexelsRepository {
  final NetworkApiService _apiService;

  PexelsRepository(this._apiService);


  Future<List<dynamic>> fetchCuratedPhotos({
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await _apiService.get(
      '/curated',
      query: {
        'page': page,
        'per_page': perPage,
      },
    );

    return response['photos'] as List<dynamic>;
  }

 
  Future<List<dynamic>> searchPhotos(
    String query, {
    int page = 1,
    int perPage = 20,
  }) async {
    return searchPhotosByQuery(
      query: query,
      page: page,
      perPage: perPage,
    );
  }

  Future<List<dynamic>> searchPhotosByQuery({
    required String query,
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await _apiService.get(
      '/search',
      query: {
        'query': query,
        'page': page,
        'per_page': perPage,
      },
    );

    return response['photos'] as List<dynamic>;
  }

 
  Future<List<dynamic>> fetchFeaturedCollections({
    int perPage = 10,
  }) async {
    final response = await _apiService.get(
      '/collections/featured',
      query: {
        'per_page': perPage,
      },
    );

    return response['collections'] as List<dynamic>;
  }


  Future<List<dynamic>> fetchCollectionPhotos(
    String collectionId, {
    int perPage = 3,
    String sort = 'desc',
  }) async {
    final response = await _apiService.get(
      '/collections/$collectionId',
      query: {
        'per_page': perPage,
        'sort': sort,
      },
    );

    return response['media'] as List<dynamic>;
  }
}

