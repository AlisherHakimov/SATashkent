import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../constants/storage_keys.dart';
import '../../services/storage_service.dart';

/// Refreshes the token on 401 errors and retries the original request.
@lazySingleton
class RefreshTokenInterceptor extends QueuedInterceptor {
  final Dio _dio;
  final StorageService _storage;

  RefreshTokenInterceptor(
    @Named('authDio') this._dio,
    this._storage,
  );

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final refreshToken = _storage.getString(StorageKeys.refreshToken);

    // Refresh token yo'q — logout
    if (refreshToken == null || refreshToken.isEmpty) {
      await _clearTokens();
      return handler.next(err);
    }

    try {
      final response = await _dio.post(
        '/auth/token/refresh/',
        data: {'refresh': refreshToken},
      );

      final newAccessToken = response.data['access'] as String?;
      final newRefreshToken = response.data['refresh'] as String?;

      if (newAccessToken == null) {
        await _clearTokens();
        return handler.next(err);
      }

      await _storage.saveString(StorageKeys.accessToken, newAccessToken);
      if (newRefreshToken != null) {
        await _storage.saveString(StorageKeys.refreshToken, newRefreshToken);
      }

      final retryOptions = err.requestOptions;
      retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';

      final retryResponse = await _dio.fetch(retryOptions);
      return handler.resolve(retryResponse);
    } on DioException catch (e) {
      await _clearTokens();
      return handler.next(e);
    }
  }

  Future<void> _clearTokens() async {
    await _storage.removeString(StorageKeys.accessToken);
    await _storage.removeString(StorageKeys.refreshToken);
  }
}
