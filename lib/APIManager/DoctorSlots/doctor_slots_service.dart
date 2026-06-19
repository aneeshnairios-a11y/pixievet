import 'package:dio/dio.dart';
import 'package:pixievet/APIManager/APIUtils/api_service_manager.dart';
import 'package:pixievet/APIManager/APIUtils/api_constants.dart';
import 'package:pixievet/APIManager/DoctorSlots/doctor_slots_request_model.dart';
import 'package:pixievet/APIManager/DoctorSlots/doctor_slots_response_model.dart';

class DoctorSlotsService {
  final ApiServiceManager _apiManager = ApiServiceManager();

  Future<DoctorSlotsResponseModel> fetchDoctorSlots(
    DoctorSlotsRequestModel request,
  ) async {
    try {
      final response = await _apiManager.post(
        ApiConstants.doctorSlots,
        body: request.toJson(),
      );

      final slotsResponse = DoctorSlotsResponseModel.fromJson(response.data);

      if (!slotsResponse.status) {
        return DoctorSlotsResponseModel.failure('Failed to fetch slots');
      }

      return slotsResponse;
    } on DioException catch (e) {
      return DoctorSlotsResponseModel.failure(
        e.response?.data?['message'] ?? 'Network error. Please try again.',
      );
    } catch (_) {
      return DoctorSlotsResponseModel.failure('Unexpected error occurred');
    }
  }
}
