import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../core/services/storage_service.dart';

class ThemeState {
  final ThemeMode themeMode;
  const ThemeState(this.themeMode);
}

@singleton
class ThemeCubit extends Cubit<ThemeState> {
  final StorageService _storage;

  ThemeCubit(this._storage) : super(const ThemeState(ThemeMode.light)) {
    _loadTheme();
  }

  void _loadTheme() {
    final saved = _storage.getString(StorageKeys.themeMode);
    final mode = switch (saved) {
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.light,
    };
    emit(ThemeState(mode));
  }

  Future<void> setTheme(ThemeMode mode) async {
    final key = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
      _ => 'light',
    };
    await _storage.saveString(StorageKeys.themeMode, key);
    emit(ThemeState(mode));
  }

  void toggleTheme() {
    final isDark = state.themeMode == ThemeMode.dark;
    setTheme(isDark ? ThemeMode.light : ThemeMode.dark);
  }
}
