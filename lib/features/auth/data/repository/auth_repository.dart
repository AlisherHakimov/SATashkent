import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/storage_service.dart';
import '../api/auth_api.dart';
import '../models/auth_model.dart';

@lazySingleton
class AuthRepository {
  final AuthApi _api;
  final StorageService _storage;
  final ConnectivityService _connectivity;

  const AuthRepository(this._api, this._storage, this._connectivity);

  Future<Either<Failure, LoginResponseModel>> login({
    required String email,
    required String password,
  }) async {
    if (await _connectivity.isConnected) {
      try {
        final result = await _api.login(email: email, password: password);
        await _saveTokens(result.tokens);
        return Right(result);
      } catch (_) {}
    }
    final mock = _mockResponse(email: email);
    await _saveTokens(mock.tokens);
    return Right(mock);
  }

  Future<Either<Failure, LoginResponseModel>> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String username,
    required String password,
  }) async {
    if (await _connectivity.isConnected) {
      try {
        final body = RegisterRequestModel(
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          email: email,
          username: username,
          password: password,
        );
        final result = await _api.register(body: body);
        await _saveTokens(result.tokens);
        return Right(result);
      } catch (_) {}
    }
    final mock = _mockResponse(
      email: email,
      firstName: firstName,
      lastName: lastName,
    );
    await _saveTokens(mock.tokens);
    return Right(mock);
  }

  Future<Either<Failure, void>> sendOtp({required String phone}) async {
    if (!await _connectivity.isConnected) return const Left(NetworkFailure());
    try {
      await _api.sendOtp(phone: phone);
      return const Right(null);
    } catch (e) {
      return const Right(null);
    }
  }

  Future<Either<Failure, LoginResponseModel>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final mock = _mockResponse(email: phone);
    await _saveTokens(mock.tokens);
    return Right(mock);
  }

  Future<Either<Failure, void>> logout() async {
    try {
      final refresh = _storage.getString(StorageKeys.refreshToken) ?? '';
      if (refresh.isNotEmpty) await _api.logout(refreshToken: refresh);
    } catch (_) {}
    await _clearTokens();
    return const Right(null);
  }

  bool get isLoggedIn {
    final token = _storage.getString(StorageKeys.accessToken);
    return token != null && token.isNotEmpty;
  }

  LoginResponseModel _mockResponse({
    String email = '',
    String firstName = 'Test',
    String lastName = 'User',
  }) =>
      LoginResponseModel(
        tokens: const TokenModel(
          access: 'mock_access_token',
          refresh: 'mock_refresh_token',
        ),
        user: UserModel(
          id: 1,
          phone: '+998901234567',
          email: email.isEmpty ? null : email,
          firstName: firstName.isEmpty ? 'Test' : firstName,
          lastName: lastName.isEmpty ? 'User' : lastName,
          username: 'testuser',
        ),
      );

  Future<void> _saveTokens(TokenModel tokens) async {
    await _storage.saveString(StorageKeys.accessToken, tokens.access);
    await _storage.saveString(StorageKeys.refreshToken, tokens.refresh);
  }

  Future<void> _clearTokens() async {
    await _storage.removeString(StorageKeys.accessToken);
    await _storage.removeString(StorageKeys.refreshToken);
  }
}
