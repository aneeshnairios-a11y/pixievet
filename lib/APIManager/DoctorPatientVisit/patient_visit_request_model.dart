class PatientVisitRequestModel {
  final String userId;
  final String token;
  final String deviceId;
  final String appointmentId;
  final bool isVisitCompleted;

  PatientVisitRequestModel({
    required this.userId,
    required this.token,
    required this.deviceId,
    required this.appointmentId,
    required this.isVisitCompleted,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'token': token,
      'device_id': deviceId,
      'appointment_id': appointmentId,
      'is_visit_completed': isVisitCompleted,
    };
  }
}
