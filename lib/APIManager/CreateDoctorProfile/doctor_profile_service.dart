import 'package:dio/dio.dart';
import 'package:pixievet/APIManager/CreateDoctorProfile/doctor_profile_request_model.dart';
import 'package:pixievet/APIManager/CreateDoctorProfile/doctor_profile_response_model.dart';
import 'package:pixievet/APIManager/APIUtils/api_constants.dart';
import 'package:pixievet/APIManager/APIUtils/api_service_manager.dart';

class DoctorProfileService {
  final ApiServiceManager _apiManager = ApiServiceManager();

  Future<DoctorProfileResponseModel> submitProfile(
    DoctorProfileRequestModel request,
  ) async {
    try {
      final response = await _apiManager.post(
        ApiConstants
            .createDoctorProfile, // Make sure this points to 'https://pixievet.vercel.app/doctor/register'
        body: request.toJson(),
      );

      final profileResponse = DoctorProfileResponseModel.fromJson(
        response.data,
      );

      if (!profileResponse.status) {
        return DoctorProfileResponseModel.failure(profileResponse.message);
      }

      return profileResponse;
    } on DioException catch (e) {
      return DoctorProfileResponseModel.failure(
        e.response?.data?['message'] ?? 'Network error. Please try again.',
      );
    } catch (_) {
      return DoctorProfileResponseModel.failure('Unexpected error occurred');
    }
  }

  Future<dynamic> fetchDoctorProfile(DoctorProfileRequestModel request) async {}
}
