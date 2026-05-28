import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({
    required this.message,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

// Server Failure (5xx)
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Server error. Please try again later.',
    super.statusCode,
  });
}

// Network Failure (No internet)
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection.',
    super.statusCode,
  });
}

// Cache Failure (Local database error)
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to save data locally.',
    super.statusCode,
  });
}

// Not Found Failure (404)
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Resource not found.',
    super.statusCode = 404,
  });
}

// Unauthorized Failure (401)
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Authorization required.',
    super.statusCode = 401,
  });
}

// Forbidden Failure (403)
class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    super.message = 'Access denied.',
    super.statusCode = 403,
  });
}

// Bad Request Failure (400)
class BadRequestFailure extends Failure {
  const BadRequestFailure({
    super.message = 'Invalid request.',
    super.statusCode = 400,
  });
}

// Validation Failure
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;

  const ValidationFailure({
    super.message = 'Invalid data provided.',
    super.statusCode = 422,
    this.errors,
  });

  @override
  List<Object?> get props => [message, statusCode, errors];
}

// Payment Failure
class PaymentFailure extends Failure {
  const PaymentFailure({
    super.message = 'Payment failed.',
    super.statusCode,
  });
}

// Unknown Failure
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred.',
    super.statusCode,
  });
}
