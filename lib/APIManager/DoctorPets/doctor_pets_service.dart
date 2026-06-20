import 'package:dio/dio.dart';
import 'package:pixievet_app/APIManager/APIUtils/api_constants.dart';
import 'package:pixievet_app/APIManager/APIUtils/api_service_manager.dart';
import 'package:pixievet_app/APIManager/SessionManager/session_manager.dart';
import 'package:pixievet_app/Utilities/device_utils.dart';
import 'doctor_pets_response_model.dart';

class DoctorPetsService {
  final ApiServiceManager _apiManager = ApiServiceManager();

  Future<DoctorPetsResponseModel> fetchDoctorPets() async {
    try {
      final session = SessionManager();
      final userId = await session.getUserId();
      final token = await session.getToken();
      final deviceId = await DeviceUtils.getDeviceId();

      final response = await _apiManager.post(
        ApiConstants.doctorPets,
        body: {'user_id': userId, 'token': token, 'device_id': deviceId},
      );

      final petsResponse = DoctorPetsResponseModel.fromJson(response.data);

      if (!petsResponse.status) {
        return DoctorPetsResponseModel.failure('Failed to fetch pets list');
      }

      return petsResponse;
    } on DioException catch (e) {
      return DoctorPetsResponseModel.failure(
        e.response?.data?['message'] ?? 'Network error. Please try again.',
      );
    } catch (e) {
      return DoctorPetsResponseModel.failure('Unexpected error occurred');
    }
  }
}
