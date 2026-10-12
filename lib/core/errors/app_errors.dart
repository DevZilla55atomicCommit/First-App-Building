// Result type for handling success/failure states
sealed class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;
  factory Result.failure(AppError error) = Failure<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get dataOrNull => this is Success<T> ? (this as Success<T>).data : null;
  AppError? get errorOrNull => this is Failure<T> ? (this as Failure<T>).error : null;
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppError error;
  const Failure(this.error);
}

// Base error class
abstract class AppError implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppError(this.message, {this.code, this.originalError});

  @override
  String toString() => 'AppError: $message${code != null ? ' (code: $code)' : ''}';
}

// Network errors
class NetworkError extends AppError {
  const NetworkError(super.message, {super.code, super.originalError});
}

class TimeoutError extends NetworkError {
  const TimeoutError({super.message = 'Request timed out', super.originalError});
}

class NoConnectionError extends NetworkError {
  const NoConnectionError({super.message = 'No internet connection', super.originalError});
}

// Server errors
class ServerError extends AppError {
  final int statusCode;
  const ServerError(super.message, {required this.statusCode, super.originalError});
}

class UnauthorizedError extends ServerError {
  const UnauthorizedError({super.message = 'Unauthorized', super.originalError})
    : super(statusCode: 401);
}

class NotFoundError extends ServerError {
  const NotFoundError({super.message = 'Not found', super.originalError})
    : super(statusCode: 404);
}

// Validation errors
class ValidationError extends AppError {
  final Map<String, String> fieldErrors;
  const ValidationError(super.message, {required this.fieldErrors, super.code});
}

// Cache/Storage errors
class CacheError extends AppError {
  const CacheError(super.message, {super.code, super.originalError});
}

// Unknown error
class UnknownError extends AppError {
  const UnknownError(super.message, {super.code, super.originalError});
}