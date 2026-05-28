import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../constants/storage_keys.dart';
import '../../services/storage_service.dart';

/// Har bir request ga Authorization header qo'shadi
@lazySingleton
class AuthInterceptor extends Interceptor {
  final StorageService _storage;

  AuthInterceptor(this._storage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final token = _storage.getString(StorageKeys.accessToken);

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
