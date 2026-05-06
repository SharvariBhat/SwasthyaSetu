import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../config/constants/app_constants.dart';

class ApiService {
  late Dio _dio;
  String? _token;

  ApiService() {
    _initializeDio();
  }

  void _initializeDio() {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? AppConstants.baseUrl;

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: AppConstants.connectionTimeout,
        receiveTimeout: AppConstants.apiTimeout,
        contentType: 'application/json',
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          // Handle errors globally if needed
          return handler.next(error);
        },
      ),
    );
  }

  /// Set authentication token
  void setToken(String token) {
    _token = token;
  }

  /// Clear authentication token
  void clearToken() {
    _token = null;
  }

  /// POST request
  Future<Response> post(
    String endpoint, {
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      rethrow;
    }
  }

  /// GET request
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      rethrow;
    }
  }

  /// PUT request
  Future<Response> put(
    String endpoint, {
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      rethrow;
    }
  }

  /// DELETE request
  Future<Response> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      rethrow;
    }
  }

  /// Upload file
  Future<Response> uploadFile(
    String endpoint, {
    required String filePath,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
        ...?additionalData,
      });

      final response = await _dio.post(
        endpoint,
        data: formData,
      );
      return response;
    } on DioException catch (e) {
      rethrow;
    }
  }
}
