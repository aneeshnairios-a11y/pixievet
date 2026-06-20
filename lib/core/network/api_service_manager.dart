import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_constants.dart';

class ApiServiceManager {
  late Dio dio;

  ApiServiceManager() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {"Content-Type": "application/json"},
      ),
    );

    /// Add Logger Interceptor
    if (!kReleaseMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          logPrint: (object) {
            debugPrint(object.toString());
          },
        ),
      );
    }
  }

  Future<Response> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
  }) async {
    return await dio.post(path, data: body, queryParameters: query);
  }
}
