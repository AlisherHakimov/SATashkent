import 'package:dio/dio.dart';
import '../error/failures.dart';

class ApiErrorHandler {
  static Failure handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(
          message: 'Connection timed out. Check your internet connection.',
        );

      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response);

      case DioExceptionType.cancel:
        return const UnknownFailure(
          message: 'Request was cancelled.',
        );

      case DioExceptionType.unknown:
        if (error.error.toString().contains('SocketException')) {
          return const NetworkFailure(
            message: 'No internet connection.',
          );
        }
        return UnknownFailure(
          message: error.message ?? 'An unexpected error occurred.',
        );

      default:
        return const UnknownFailure();
    }
  }

  static Failure _handleStatusCode(Response? response) {
    final statusCode = response?.statusCode ?? 0;
    final data = response?.data;

    String message = 'Something went wrong.';

    // Try to extract error message from response
    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? data['detail'] ?? message;
    }

    switch (statusCode) {
      case 400:
        return BadRequestFailure(
          message: message,
          statusCode: statusCode,
        );

      case 401:
        return UnauthorizedFailure(
          message: message,
          statusCode: statusCode,
        );

      case 403:
        return ForbiddenFailure(
          message: message,
          statusCode: statusCode,
        );

      case 404:
        return NotFoundFailure(
          message: message,
          statusCode: statusCode,
        );

      case 422:
        Map<String, List<String>>? validationErrors;
        if (data is Map<String, dynamic> && data.containsKey('errors')) {
          validationErrors = (data['errors'] as Map<String, dynamic>).map((key, value) => MapEntry(
                key,
                (value as List).map((e) => e.toString()).toList(),
              ));
        }
        return ValidationFailure(
          message: message,
          statusCode: statusCode,
          errors: validationErrors,
        );

      case 500:
      case 502:
      case 503:
        return ServerFailure(
          message: message,
          statusCode: statusCode,
        );

      default:
        return UnknownFailure(
          message: message,
          statusCode: statusCode,
        );
    }
  }

  static Failure handleException(Object error) {
    if (error is DioException) {
      return handleDioError(error);
    }
    return UnknownFailure(
      message: error.toString(),
    );
  }
}
