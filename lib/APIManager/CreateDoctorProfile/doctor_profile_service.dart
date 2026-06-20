import 'package:dio/dio.dart';
import 'package:pixievet_app/APIManager/CreateDoctorProfile/doctor_profile_request_model.dart';
import 'package:pixievet_app/APIManager/CreateDoctorProfile/doctor_profile_response_model.dart';
import 'package:pixievet_app/APIManager/APIUtils/api_constants.dart';
import 'package:pixievet_app/APIManager/APIUtils/api_service_manager.dart';

class DoctorProfileService {
  final ApiServiceManager _apiManager = ApiServiceManager();

  Future<DoctorProfileResponseModel> submitProfile(
    DoctorProfileRequestModel request,
  ) async {
    try {
      final formData = FormData.fromMap({
        'user_id': request.userId,
        'token': request.token,
        'device_id': request.deviceId,
        'name': request.name,
        'email': request.email,
        'specialization': request.specialization,
        'experience_years': request.experienceYears.toString(),
        'license_number': request.licenseNumber,
        if (request.profileImage != null)
          'profile_image': await MultipartFile.fromFile(
            request.profileImage!.path,
            filename: request.profileImage!.path.split('/').last,
          ),
      });

      final response = await _apiManager.postMultipart(
        ApiConstants.createDoctorProfile,
        formData,
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
}
