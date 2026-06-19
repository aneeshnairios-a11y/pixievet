import 'package:dio/dio.dart';
import 'package:pixievet/APIManager/CreatePetProfile/pet_profile_create_request_model.dart';
import 'package:pixievet/APIManager/CreatePetProfile/pet_profile_create_response_model.dart';
import 'package:pixievet/APIManager/APIUtils/api_constants.dart';
import 'package:pixievet/APIManager/APIUtils/api_service_manager.dart';

class PetProfileCreateService {
  final ApiServiceManager _apiManager = ApiServiceManager();

  Future<PetProfileCreateResponseModel> createProfile(
    PetProfileCreateRequestModel request,
  ) async {
    try {
      final response = await _apiManager.post(
        ApiConstants.createPetProfile,
        body: request.toJson(),
      );

      final profileResponse = PetProfileCreateResponseModel.fromJson(
        response.data,
      );

      if (!profileResponse.status) {
        return PetProfileCreateResponseModel.failure(profileResponse.message);
      }

      return profileResponse;
    } on DioException catch (e) {
      return PetProfileCreateResponseModel.failure(
        e.response?.data?['message'] ?? 'Network error. Please try again.',
      );
    } catch (_) {
      return PetProfileCreateResponseModel.failure('Unexpected error occurred');
    }
  }
}
