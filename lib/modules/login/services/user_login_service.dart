// ignore_for_file: avoid_print

import 'package:dio/dio.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_service_manager.dart';
import '../models/user_login_request_model.dart';
import '../models/user_login_response_model.dart';

class UserLoginService {
  final ApiServiceManager _apiManager = ApiServiceManager();

  Future<UserLoginResponseModel> login(UserLoginRequestModel request) async {
    try {
      print("--------- USER LOGIN API ---------");
      print("URL: ${ApiConstants.userLogin}");
      print("Request Body: ${request.toJson()}");

      final response = await _apiManager.post(
        ApiConstants.userLogin,
        body: request.toJson(),
      );

      print("Response: ${response.data}");
      print("----------------------------------");

      final loginResponse = UserLoginResponseModel.fromJson(response.data);

      if (!loginResponse.status) {
        return UserLoginResponseModel.failure(loginResponse.message);
      }

      return loginResponse;
    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}");

      return UserLoginResponseModel.failure(
        e.response?.data?['message'] ?? 'Network error',
      );
    } catch (e) {
      print("Unexpected Error: $e");

      return UserLoginResponseModel.failure('Unexpected error occurred');
    }
  }
}
