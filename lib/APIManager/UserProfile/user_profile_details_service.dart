import 'package:dio/dio.dart';

import '../APIUtils/api_constants.dart';
import '../APIUtils/api_service_manager.dart';
import 'user_profile_details_request_model.dart';
import 'user_profile_details_response_model.dart';

class UserProfileDetailsService {
  final ApiServiceManager _apiManager = ApiServiceManager();

  Future<UserProfileDetailsResponseModel> fetchUserProfile(
    UserProfileDetailsRequestModel request,
  ) async {
    try {
      final response = await _apiManager.post(
        ApiConstants.userProfile,
        body: request.toJson(),
      );

      return UserProfileDetailsResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      return UserProfileDetailsResponseModel.failure(
        e.response?.data?['message'] ?? 'Network error',
      );
    } catch (_) {
      return UserProfileDetailsResponseModel.failure(
        'Unexpected error occurred',
      );
    }
  }
}
