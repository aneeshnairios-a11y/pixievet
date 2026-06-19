class PatientSlotsRequestModel {
  final String userId;
  final String token;
  final String deviceId;
  final String doctorId;
  final String date; // format: dd/MM/yyyy

  PatientSlotsRequestModel({
    required this.userId,
    required this.token,
    required this.deviceId,
    required this.doctorId,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'token': token,
      'device_id': deviceId,
      'doctor_id': doctorId,
      'date': date,
    };
  }
}
