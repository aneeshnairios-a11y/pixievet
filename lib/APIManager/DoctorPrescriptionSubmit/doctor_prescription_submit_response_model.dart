class DoctorPrescriptionSubmitResponseModel {
  final bool status;
  final String message;

  DoctorPrescriptionSubmitResponseModel({
    required this.status,
    required this.message,
  });

  factory DoctorPrescriptionSubmitResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DoctorPrescriptionSubmitResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? 'Something went wrong',
    );
  }

  factory DoctorPrescriptionSubmitResponseModel.failure(String message) {
    return DoctorPrescriptionSubmitResponseModel(
      status: false,
      message: message,
    );
  }
}
