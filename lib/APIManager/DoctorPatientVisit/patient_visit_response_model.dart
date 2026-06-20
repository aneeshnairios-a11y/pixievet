class PatientVisitResponseModel {
  final bool status;
  final String message;

  PatientVisitResponseModel({required this.status, required this.message});

  factory PatientVisitResponseModel.fromJson(Map<String, dynamic> json) {
    return PatientVisitResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
    );
  }

  factory PatientVisitResponseModel.failure(String message) {
    return PatientVisitResponseModel(status: false, message: message);
  }
}
