part of 'auth_cubit.dart';

class AuthState {
  final BlocStatus status;
  final String? errorMessage;

  const AuthState({
    this.status = BlocStatus.initial,
    this.errorMessage,
  });

  AuthState copyWith({
    BlocStatus? status,
    String? errorMessage,
  }) =>
      AuthState(
        status: status ?? this.status,
        errorMessage: errorMessage,
      );
}
