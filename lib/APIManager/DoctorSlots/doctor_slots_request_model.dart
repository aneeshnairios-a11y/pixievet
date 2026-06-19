class DoctorSlotsRequestModel {
  final String userId;
  final String token;
  final String deviceId;
  final String date; // format: dd/MM/yyyy

  DoctorSlotsRequestModel({
    required this.userId,
    required this.token,
    required this.deviceId,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'token': token,
      'device_id': deviceId,
      'date': date,
    };
  }
}
