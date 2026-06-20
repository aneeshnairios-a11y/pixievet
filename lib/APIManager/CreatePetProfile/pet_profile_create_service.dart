import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pixievet_app/APIManager/CreatePetProfile/pet_profile_create_request_model.dart';
import 'package:pixievet_app/APIManager/CreatePetProfile/pet_profile_create_response_model.dart';
import 'package:pixievet_app/APIManager/APIUtils/api_constants.dart';
import 'package:pixievet_app/APIManager/APIUtils/api_service_manager.dart';

class PetProfileCreateService {
  final ApiServiceManager _apiManager = ApiServiceManager();

  Future<PetProfileCreateResponseModel> createProfile(
    PetProfileCreateRequestModel request,
  ) async {
    try {
      final response = await _apiManager.post(
        ApiConstants.createPetProfile,
        body: request.toJson(), // ✅ correct
      );
      if (kDebugMode) {
        print("body ${response.data}");
      }
      return PetProfileCreateResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      return PetProfileCreateResponseModel.failure(
        e.response?.data?['message'] ?? 'Network error',
      );
    } catch (_) {
      return PetProfileCreateResponseModel.failure('Unexpected error occurred');
    }
  }
}
