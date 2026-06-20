import 'package:dio/dio.dart';
import 'package:pixievet_app/APIManager/APIUtils/api_constants.dart';
import 'package:pixievet_app/APIManager/APIUtils/api_service_manager.dart';
import 'package:pixievet_app/APIManager/DoctorProfileDetails/doctor_profile_details_request_model.dart';
import 'package:pixievet_app/APIManager/DoctorProfileDetails/doctor_profile_details_response_model.dart';

class DoctorProfileDetailsService {
  final ApiServiceManager _apiManager = ApiServiceManager();

  Future<DoctorProfileDetailsResponseModel> fetchDoctorProfile(
    DoctorProfileDetailsRequestModel request,
  ) async {
    try {
      final response = await _apiManager.post(
        ApiConstants.doctorProfile,
        body: request.toJson(),
      );

      return DoctorProfileDetailsResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      return DoctorProfileDetailsResponseModel.failure(
        e.response?.data?['message'] ?? 'Network error',
      );
    } catch (_) {
      return DoctorProfileDetailsResponseModel.failure(
        'Unexpected error occurred',
      );
    }
  }
}
