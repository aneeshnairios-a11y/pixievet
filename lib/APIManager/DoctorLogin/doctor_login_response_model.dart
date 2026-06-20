import 'doctor_model.dart';

class DoctorLoginResponseModel {
  final bool status;
  final String message;
  final String? authToken;
  final DoctorModel? doctor;

  DoctorLoginResponseModel({
    required this.status,
    required this.message,
    this.authToken,
    this.doctor,
  });

  factory DoctorLoginResponseModel.fromJson(Map<String, dynamic> json) {
    return DoctorLoginResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? 'Something went wrong',
      authToken: json['auth_token'],
      doctor: json['doctor'] != null
          ? DoctorModel.fromJson(json['doctor'])
          : null,
    );
  }

  factory DoctorLoginResponseModel.failure(String message) {
    return DoctorLoginResponseModel(
      status: false,
      message: message,
      authToken: null,
      doctor: null,
    );
  }
}
