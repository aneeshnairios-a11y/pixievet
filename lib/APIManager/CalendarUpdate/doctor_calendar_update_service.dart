import 'package:dio/dio.dart';
import 'package:pixievet/APIManager/APIUtils/api_constants.dart';
import 'package:pixievet/APIManager/APIUtils/api_service_manager.dart';
import 'package:pixievet/APIManager/CalendarUpdate/doctor_calendar_update_request_model.dart';
import 'package:pixievet/APIManager/CalendarUpdate/doctor_calendar_update_response_model.dart';

class DoctorCalendarUpdateService {
  final ApiServiceManager _apiManager = ApiServiceManager();

  Future<DoctorCalendarUpdateResponseModel> updateCalendar(
    DoctorCalendarUpdateRequestModel request,
  ) async {
    try {
      final response = await _apiManager.post(
        ApiConstants.doctorCalendarUpdate,
        body: request.toJson(),
      );

      final apiResponse = DoctorCalendarUpdateResponseModel.fromJson(
        response.data,
      );

      if (!apiResponse.status) {
        return DoctorCalendarUpdateResponseModel.failure(apiResponse.message);
      }

      return apiResponse;
    } on DioException catch (e) {
      return DoctorCalendarUpdateResponseModel.failure(
        e.response?.data?['message'] ?? 'Network error. Please try again.',
      );
    } catch (_) {
      return DoctorCalendarUpdateResponseModel.failure(
        'Unexpected error occurred',
      );
    }
  }
}
