import 'package:dio/dio.dart';
import 'package:pixievet_app/APIManager/VerifyOtp/verifyotp_request_model.dart';
import 'package:pixievet_app/APIManager/VerifyOtp/verifyotp_response_model.dart';
import 'package:pixievet_app/APIManager/APIUtils/api_constants.dart';
import 'package:pixievet_app/APIManager/APIUtils/api_service_manager.dart';

class VerifyOtpService {
  final ApiServiceManager _apiManager = ApiServiceManager();

  Future<VerifyOtpResponseModel> verifyOtp(
    VerifyOtpRequestModel request,
  ) async {
    try {
      final response = await _apiManager.post(
        ApiConstants.dummyOtpVerify,
        body: request.toJson(),
      );

      final verifyOtpResponse = VerifyOtpResponseModel.fromJson(response.data);

      if (!verifyOtpResponse.status) {
        return VerifyOtpResponseModel.failure();
      }

      return verifyOtpResponse;
    } on DioException {
      return VerifyOtpResponseModel.failure();
    } catch (_) {
      return VerifyOtpResponseModel.failure();
    }
  }
}
