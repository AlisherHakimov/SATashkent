import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../core/services/storage_service.dart';

sealed class AppState {}

class AppInitial extends AppState {}

class AppAuthenticated extends AppState {}

class AppUnauthenticated extends AppState {}

@singleton
class AppCubit extends Cubit<AppState> {
  final StorageService _storage;

  AppCubit(this._storage) : super(AppInitial());

  void checkAuth() {
    final token = _storage.getString(StorageKeys.accessToken);
    if (token != null && token.isNotEmpty) {
      emit(AppAuthenticated());
    } else {
      emit(AppUnauthenticated());
    }
  }

  Future<void> logout() async {
    await _storage.removeString(StorageKeys.accessToken);
    await _storage.removeString(StorageKeys.refreshToken);
    emit(AppUnauthenticated());
  }
}
