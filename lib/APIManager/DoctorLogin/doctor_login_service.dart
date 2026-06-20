import 'package:dio/dio.dart';
import '../APIUtils/api_constants.dart';
import '../APIUtils/api_service_manager.dart';
import 'doctor_login_request_model.dart';
import 'doctor_login_response_model.dart';

class DoctorLoginService {
  final ApiServiceManager _apiManager = ApiServiceManager();

  Future<DoctorLoginResponseModel> login(
    DoctorLoginRequestModel request,
  ) async {
    try {
      final response = await _apiManager.post(
        ApiConstants.doctorLogin,
        body: request.toJson(),
      );

      final loginResponse = DoctorLoginResponseModel.fromJson(response.data);

      if (!loginResponse.status) {
        return DoctorLoginResponseModel.failure(loginResponse.message);
      }

      return loginResponse;
    } on DioException catch (e) {
      return DoctorLoginResponseModel.failure(
        e.response?.data?['message'] ?? 'Network error, please try again',
      );
    } catch (_) {
      return DoctorLoginResponseModel.failure('Unexpected error occurred');
    }
  }
}
