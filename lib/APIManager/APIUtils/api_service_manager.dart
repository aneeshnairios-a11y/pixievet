import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dio_client.dart';
import 'api_exception.dart';

class ApiServiceManager {
  final Dio _dio = DioClient().dio;

  Future<Response> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      if (kDebugMode) {
        print("body $body");
      }
      return await _dio.post(endpoint, data: body);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> postMultipart(String endpoint, FormData formData) async {
    try {
      return await _dio.post(
        endpoint,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      return await _dio.get(endpoint, queryParameters: queryParams);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ApiException _handleDioError(DioException e) {
    final message = e.response?.data['message'] ?? 'Something went wrong';
    return ApiException(message, statusCode: e.response?.statusCode);
  }
}
