import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../error/failures.dart';
import '../network/api_error_handler.dart';

/// Wraps any Future request into Either<Failure, T>.
/// Usage:
/// ```dart
/// final result = await response(request: _api.getData());
/// result.fold(
///   (failure) => emit(state.copyWith(status: BlocStatus.error, errorMessage: failure.message)),
///   (data)    => emit(state.copyWith(status: BlocStatus.success, data: data)),
/// );
/// ```
Future<Either<Failure, T>> response<T>({required Future<T> request}) async {
  try {
    final result = await request;
    return Right(result);
  } on DioException catch (e) {
    return Left(ApiErrorHandler.handleDioError(e));
  } catch (e) {
    return Left(UnknownFailure(message: e.toString()));
  }
}
