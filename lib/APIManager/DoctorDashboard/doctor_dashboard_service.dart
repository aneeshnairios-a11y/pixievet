import 'package:dio/dio.dart';
import 'package:pixievet/APIManager/DoctorDashboard/doctor_dashboard_response_model.dart';
import 'package:pixievet/APIManager/APIUtils/api_constants.dart';
import 'package:pixievet/APIManager/APIUtils/api_service_manager.dart';
import 'package:pixievet/APIManager/SessionManager/session_manager.dart';
import 'package:pixievet/Utilities/device_utils.dart';

class DoctorDashboardService {
  final ApiServiceManager _apiManager = ApiServiceManager();

  Future<DoctorDashboardResponseModel> fetchDoctorDashboard() async {
    try {
      final session = SessionManager();
      final userId = await session.getUserId();
      final token = await session.getToken();
      final deviceId = await DeviceUtils.getDeviceId();

      final response = await _apiManager.post(
        ApiConstants.doctorDashboard,
        body: {'user_id': userId, 'token': token, 'device_id': deviceId},
      );

      final dashboardResponse = DoctorDashboardResponseModel.fromJson(
        response.data,
      );

      if (!dashboardResponse.status) {
        return DoctorDashboardResponseModel.failure(
          'Failed to fetch doctor dashboard',
        );
      }

      return dashboardResponse;
    } on DioException catch (e) {
      return DoctorDashboardResponseModel.failure(
        e.response?.data?['message'] ?? 'Network error. Please try again.',
      );
    } catch (_) {
      return DoctorDashboardResponseModel.failure('Unexpected error occurred');
    }
  }
}
