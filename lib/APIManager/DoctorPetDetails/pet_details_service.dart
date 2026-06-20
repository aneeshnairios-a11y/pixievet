import 'package:dio/dio.dart';
import 'package:pixievet_app/APIManager/APIUtils/api_constants.dart';
import 'package:pixievet_app/APIManager/APIUtils/api_service_manager.dart';

import 'pet_details_request_model.dart';
import 'pet_details_response_model.dart';

class PetDetailsService {
  final ApiServiceManager _apiManager = ApiServiceManager();

  Future<PetDetailsResponseModel> fetchPetDetails(
    PetDetailsRequestModel request,
  ) async {
    try {
      final response = await _apiManager.post(
        ApiConstants.doctorPetDetails,
        body: request.toJson(),
      );

      return PetDetailsResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      return PetDetailsResponseModel.failure(
        e.response?.data?['message'] ?? 'Network error',
      );
    } catch (_) {
      return PetDetailsResponseModel.failure('Unexpected error occurred');
    }
  }
}
