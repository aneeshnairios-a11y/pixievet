import 'package:dio/dio.dart';
import 'package:pixievet_app/APIManager/APIUtils/api_constants.dart';
import 'package:pixievet_app/APIManager/APIUtils/api_service_manager.dart';
import 'package:pixievet_app/APIManager/DoctorPatientVisit/patient_visit_request_model.dart';
import 'package:pixievet_app/APIManager/DoctorPatientVisit/patient_visit_response_model.dart';
import 'package:pixievet_app/APIManager/SessionManager/session_manager.dart';
import 'package:pixievet_app/Utilities/device_utils.dart';

class PatientVisitService {
  final ApiServiceManager _apiManager = ApiServiceManager();

  Future<PatientVisitResponseModel> markVisit({
    required String appointmentId,
    required bool isVisitCompleted,
  }) async {
    try {
      final session = SessionManager();
      final userId = await session.getUserId();
      final token = await session.getToken();
      final deviceId = await DeviceUtils.getDeviceId();

      final requestModel = PatientVisitRequestModel(
        userId: userId ?? '',
        token: token ?? '',
        deviceId: deviceId,
        appointmentId: appointmentId,
        isVisitCompleted: isVisitCompleted,
      );

      final response = await _apiManager.post(
        ApiConstants.patientVisit, // Define this in your api_constants.dart
        body: requestModel.toJson(),
      );

      final visitResponse = PatientVisitResponseModel.fromJson(response.data);

      if (!visitResponse.status) {
        return PatientVisitResponseModel.failure(
          visitResponse.message.isNotEmpty
              ? visitResponse.message
              : 'Failed to mark visit',
        );
      }

      return visitResponse;
    } on DioException catch (e) {
      return PatientVisitResponseModel.failure(
        e.response?.data?['message'] ?? 'Network error. Please try again.',
      );
    } catch (e) {
      return PatientVisitResponseModel.failure('Unexpected error occurred');
    }
  }
}
