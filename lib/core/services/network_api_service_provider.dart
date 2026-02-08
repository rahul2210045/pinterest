import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest/core/services/dio_provider.dart';
import 'package:pinterest/core/services/network_api_service.dart';

final networkApiServiceProvider = Provider<NetworkApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return NetworkApiService(dio);
});
