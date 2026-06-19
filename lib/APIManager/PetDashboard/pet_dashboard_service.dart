import 'package:pixievet/APIManager/PetDashboard/petdashboard_response_model.dart';
import 'package:pixievet/APIManager/APIUtils/api_constants.dart';
import 'package:pixievet/APIManager/APIUtils/api_service_manager.dart';
import 'package:pixievet/APIManager/SessionManager/session_manager.dart';
import 'package:pixievet/Utilities/device_utils.dart';

class PetDashboardService {
  final ApiServiceManager _apiManager = ApiServiceManager();

  Future<PetDashboardResponseModel> fetchPetDashboard() async {
    final session = SessionManager();

    final userId = await session.getUserId();
    final token = await session.getToken();
    final deviceId = await DeviceUtils.getDeviceId();

    final response = await _apiManager.get(
      ApiConstants.petDashboard,
      queryParams: {
        'user_id': userId,
        'device_id': deviceId,
        'auth_token': token,
      },
    );

    return PetDashboardResponseModel.fromJson(response.data);
  }
}
