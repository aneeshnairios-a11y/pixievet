import 'package:dio/dio.dart';
import 'package:pixievet_app/APIManager/APIUtils/api_constants.dart';
import 'package:pixievet_app/APIManager/APIUtils/api_service_manager.dart';
import 'package:pixievet_app/APIManager/BookAppointment/book_appointment_request_model.dart';
import 'package:pixievet_app/APIManager/BookAppointment/book_appointment_response_model.dart';

class BookAppointmentService {
  final ApiServiceManager _apiManager = ApiServiceManager();

  Future<BookAppointmentResponseModel> bookAppointment(
    BookAppointmentRequestModel request,
  ) async {
    try {
      final response = await _apiManager.post(
        ApiConstants.bookAppointment,
        body: request.toJson(),
      );

      return BookAppointmentResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      return BookAppointmentResponseModel.failure(
        e.response?.data?['message'] ??
            'Unable to book appointment. Please try again.',
      );
    } catch (_) {
      return BookAppointmentResponseModel.failure('Unexpected error occurred');
    }
  }
}
