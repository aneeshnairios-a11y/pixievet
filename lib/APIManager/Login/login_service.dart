import 'package:dio/dio.dart';
import 'package:pixievet/APIManager/Login/login_request_model.dart';
import 'package:pixievet/APIManager/Login/login_response_model.dart';
import 'package:pixievet/APIManager/APIUtils/api_constants.dart';
import 'package:pixievet/APIManager/APIUtils/api_service_manager.dart';

class LoginService {
  final ApiServiceManager _apiManager = ApiServiceManager();

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await _apiManager.post(
        ApiConstants.dummyLogin,
        body: request.toJson(),
      );

      final loginResponse = LoginResponseModel.fromJson(response.data);

      // ✅ Handle API-level failure here
      if (!loginResponse.status) {
        return LoginResponseModel.failure(loginResponse.message);
      }

      return loginResponse;
    } on DioException catch (e) {
      return LoginResponseModel.failure(
        e.response?.data?['message'] ?? 'Network error, please try again',
      );
    } catch (_) {
      return LoginResponseModel.failure('Unexpected error occurred');
    }
  }
}
