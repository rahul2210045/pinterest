import 'package:dio/dio.dart';
import 'exception.dart';

class NetworkApiService {
  final Dio dio;

  NetworkApiService(this.dio);

  Future<dynamic> get(String endpoint, {Map<String, dynamic>? query}) async {
    try {
      final response = await dio.get(
        endpoint,
        queryParameters: query,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  dynamic _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.data;

      case 400:
        throw BadRequestException(response.statusMessage ?? 'Bad request');

      case 401:
        throw UnauthorizedException('Invalid API key');

      case 404:
        throw NotFoundException('Resource not found');

      case 429:
        throw FetchDataException('API rate limit exceeded');

      case 500:
      default:
        throw ServerException('Something went wrong');
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return FetchDataException('Connection timeout');
    }

    if (e.type == DioExceptionType.unknown) {
      return FetchDataException('No internet connection');
    }

    return FetchDataException(e.message ?? 'Unexpected error');
  }
}

