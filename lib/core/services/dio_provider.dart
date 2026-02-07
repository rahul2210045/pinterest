import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest/core/services/network_api_service.dart';
import 'package:pinterest/reusable_element.dart/common_function.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options.validateStatus = (status) {
    return status! >= 200 && status < 500;
  };
  dio.options.baseUrl = dotenv.get("baseurl") ?? "";
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // final token = IdSharedPreferences.getJWTHead();
        final apiKey = dotenv.get("appkey") ?? "";

        // prnt("Auth Token: $token");
        prnt("x-api-key: $apiKey");

        // if (token != null && token.isNotEmpty) {
        //   options.headers['Authorization'] = "Bearer $token";
        // }
        options.headers['x-api-key'] = apiKey;

        return handler.next(options);
      },
      onError: (DioException e, handler) {
        prnt("Dio Error: ${e.response?.statusCode} ${e.message}");
        return handler.next(e);
      },
    ),
  );

  dio.interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    error: true,
    compact: true,
  ));

  return dio;
});

final networkApiServiceProvider = Provider<NetworkApiService>((ref) {
  return NetworkApiService(ref.watch(dioProvider));
});
