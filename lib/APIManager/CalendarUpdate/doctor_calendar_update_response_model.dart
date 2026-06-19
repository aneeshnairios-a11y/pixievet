class DoctorCalendarUpdateResponseModel {
  final bool status;
  final String message;

  DoctorCalendarUpdateResponseModel({
    required this.status,
    required this.message,
  });

  factory DoctorCalendarUpdateResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DoctorCalendarUpdateResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
    );
  }

  factory DoctorCalendarUpdateResponseModel.failure(String message) {
    return DoctorCalendarUpdateResponseModel(status: false, message: message);
  }
}
