import 'package:dio/dio.dart';
import 'package:ticketa/core/errors/exceptions.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  // GET Request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST Request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT Request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error Handling
  AppException _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkException();
    }

    final statusCode = e.response?.statusCode;
    String? message;
    final data = e.response?.data;

    if (data is Map) {
      message = data['message']?.toString();
      if ((message == null || message.isEmpty) && data['errors'] is List) {
        final errors = (data['errors'] as List)
            .where((item) => item != null)
            .map((item) => item.toString())
            .where((item) => item.isNotEmpty)
            .toList();
        if (errors.isNotEmpty) message = errors.join('\n');
      }
      if ((message == null || message.isEmpty) && data['Errors'] is List) {
        final errors = (data['Errors'] as List)
            .where((item) => item != null)
            .map((item) => item.toString())
            .where((item) => item.isNotEmpty)
            .toList();
        if (errors.isNotEmpty) message = errors.join('\n');
      }
    }
    message ??= e.message;
    final finalMessage = message ?? 'Something went wrong';

    if (statusCode == 401 || statusCode == 403) {
      return AuthException(finalMessage, statusCode: statusCode);
    }
    return ServerException(finalMessage, statusCode: statusCode);
  }
}

