// Network client configuration using Dio
import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../errors/app_errors.dart';

class ApiClient {
  final Dio _dio;
  final AppConfig _config;

  ApiClient(this._config) : _dio = Dio() {
    _dio.options.baseUrl = _config.baseUrl;
    _dio.options.connectTimeout = Duration(seconds: AppConstants.apiTimeoutSeconds);
    _dio.options.receiveTimeout = Duration(seconds: AppConstants.apiTimeoutSeconds);
    _dio.options.headers = {'Content-Type': 'application/json'};

    if (_config.enableLogging) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ));
    }

    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout) {
          return handler.next(TimeoutError(originalError: error));
        }
        if (error.type == DioExceptionType.connectionError) {
          return handler.next(NoConnectionError(originalError: error));
        }
        if (error.response?.statusCode == 401) {
          return handler.next(UnauthorizedError(originalError: error));
        }
        if (error.response?.statusCode == 404) {
          return handler.next(NotFoundError(originalError: error));
        }
        if (error.response?.statusCode != null && error.response!.statusCode! >= 500) {
          return handler.next(ServerError(
            'Server error',
            statusCode: error.response!.statusCode!,
            originalError: error,
          ));
        }
        handler.next(UnknownError(error.message, originalError: error));
      },
    ));
  }

  Dio get dio => _dio;

  Future<Result<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters, T Function(dynamic)? parser}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      final data = parser != null ? parser(response.data) : response.data as T;
      return Result.success(data);
    } on AppError catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<T>> post<T>(String path,
      {dynamic data, Map<String, dynamic>? queryParameters, T Function(dynamic)? parser}) async {
    try {
      final response = await _dio.post(path, data: data, queryParameters: queryParameters);
      final parsed = parser != null ? parser(response.data) : response.data as T;
      return Result.success(parsed);
    } on AppError catch (e) {
      return Result.failure(e);
    }
  }
}