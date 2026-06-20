import 'package:dio/dio.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/api_service_manager.dart';

import '../models/doctor_login_request_model.dart';
import '../models/doctor_login_response_model.dart';

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
        e.response?.data?['message'] ?? 'Network error',
      );
    } catch (e) {
      return DoctorLoginResponseModel.failure('Unexpected error');
    }
  }
}
