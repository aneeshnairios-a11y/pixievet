class DoctorDashboardRequestModel {
  final String userId;
  final String token;
  final String deviceId;

  DoctorDashboardRequestModel({
    required this.userId,
    required this.token,
    required this.deviceId,
  });

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "token": token,
    "device_id": deviceId,
  };
}
