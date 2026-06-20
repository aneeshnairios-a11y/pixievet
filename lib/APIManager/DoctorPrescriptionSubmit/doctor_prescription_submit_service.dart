import 'package:dio/dio.dart';
import 'package:pixievet_app/APIManager/APIUtils/api_constants.dart';
import 'package:pixievet_app/APIManager/APIUtils/api_service_manager.dart';
import 'doctor_prescription_submit_request_model.dart';
import 'doctor_prescription_submit_response_model.dart';

class DoctorPrescriptionSubmitService {
  final ApiServiceManager _apiManager = ApiServiceManager();

  Future<DoctorPrescriptionSubmitResponseModel> submitPrescription(
    DoctorPrescriptionSubmitRequestModel request,
  ) async {
    try {
      final formData = FormData.fromMap({
        'user_id': request.userId,
        'token': request.token,
        'device_id': request.deviceId,
        'appointment_id': request.appointmentId,
        'description': request.description,
        'medicines_json': request.medicinesJson,
        'notes': request.notes,

        // 📎 Files (array)
        if (request.files != null && request.files!.isNotEmpty)
          'files': [
            for (final file in request.files!)
              await MultipartFile.fromFile(
                file.path,
                filename: file.path.split('/').last,
              ),
          ],
      });

      final response = await _apiManager.postMultipart(
        ApiConstants.doctorPrescriptionSubmit,
        formData,
      );

      return DoctorPrescriptionSubmitResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      return DoctorPrescriptionSubmitResponseModel.failure(
        e.response?.data?['message'] ?? 'Network error',
      );
    } catch (_) {
      return DoctorPrescriptionSubmitResponseModel.failure(
        'Unexpected error occurred',
      );
    }
  }
}
