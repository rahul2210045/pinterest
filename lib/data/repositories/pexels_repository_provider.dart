import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest/core/services/network_api_service_provider.dart';
import 'package:pinterest/data/repositories/pexels_repository.dart';

final pexelsRepositoryProvider = Provider<PexelsRepository>((ref) {
  final apiService = ref.watch(networkApiServiceProvider);
  return PexelsRepository(apiService);
});
