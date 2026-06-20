import 'package:dio/dio.dart';
import 'package:pixievet_app/APIManager/APIUtils/api_service_manager.dart';
import 'package:pixievet_app/APIManager/APIUtils/api_constants.dart';
import 'package:pixievet_app/APIManager/PatientSlots/patient_slots_request_model.dart';
import 'package:pixievet_app/APIManager/PatientSlots/patient_slots_response_model.dart';

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

      return PatientSlotsResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      return PatientSlotsResponseModel.failure(
        e.response?.data?['message'] ?? 'Network error. Please try again.',
      );
    } catch (_) {
      return PatientSlotsResponseModel.failure('Unexpected error occurred');
    }
  }
}
