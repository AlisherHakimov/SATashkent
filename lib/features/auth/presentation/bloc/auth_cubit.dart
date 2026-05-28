import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/bloc_status.dart';
import '../../data/repository/auth_repository.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(const AuthState());

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final result = await _repository.login(email: email, password: password);
    result.fold(
      (failure) => emit(state.copyWith(
        status: BlocStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: BlocStatus.success)),
    );
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String username,
    required String password,
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final result = await _repository.register(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      username: username,
      password: password,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: BlocStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: BlocStatus.success)),
    );
  }

  void reset() => emit(const AuthState());
}
