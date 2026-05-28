import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../network/interceptors/refresh_token_interceptor.dart';

@module
abstract class RegisterModule {
  @preResolve
  @singleton
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  Dio dio(
    AuthInterceptor authInterceptor,
    RefreshTokenInterceptor refreshInterceptor,
  ) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      authInterceptor, // token qo'shadi
      refreshInterceptor,
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ),
    ]);

    return dio;
  }

  @Named('authDio')
  @lazySingleton
  Dio authDio() {
    return Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  @lazySingleton
  Connectivity get connectivity => Connectivity();
}
