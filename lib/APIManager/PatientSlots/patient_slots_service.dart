import 'package:dio/dio.dart';
import 'package:pixievet/APIManager/APIUtils/api_service_manager.dart';
import 'package:pixievet/APIManager/APIUtils/api_constants.dart';
import 'package:pixievet/APIManager/PatientSlots/patient_slots_request_model.dart';
import 'package:pixievet/APIManager/PatientSlots/patient_slots_response_model.dart';

class PatientSlotsService {
  final ApiServiceManager _apiManager = ApiServiceManager();

  Future<PatientSlotsResponseModel> fetchPatientSlots(
    PatientSlotsRequestModel request,
  ) async {
    try {
      final response = await _apiManager.post(
        ApiConstants.patientSlots,
        body: request.toJson(),
      );

      final slotsResponse = PatientSlotsResponseModel.fromJson(response.data);

      if (!slotsResponse.status) {
        return PatientSlotsResponseModel.failure('Failed to fetch slots');
      }

      return slotsResponse;
    } on DioException catch (e) {
      return PatientSlotsResponseModel.failure(
        e.response?.data?['message'] ?? 'Network error. Please try again.',
      );
    } catch (_) {
      return PatientSlotsResponseModel.failure('Unexpected error occurred');
    }
  }
}
