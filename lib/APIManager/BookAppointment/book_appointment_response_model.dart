class BookAppointmentResponseModel {
  final bool status;
  final String message;
  final String? paymentUrl;
  final String? appointmentId;

  BookAppointmentResponseModel({
    required this.status,
    required this.message,
    this.paymentUrl,
    this.appointmentId,
  });

  factory BookAppointmentResponseModel.fromJson(Map<String, dynamic> json) {
    return BookAppointmentResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      paymentUrl: json['payment_url'],
      appointmentId: json['appointment_id'],
    );
  }

  factory BookAppointmentResponseModel.failure(String message) {
    return BookAppointmentResponseModel(status: false, message: message);
  }
}
