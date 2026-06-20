class DoctorLoginRequestModel {
  final String email;
  final String password;
  final String deviceId;

  DoctorLoginRequestModel({
    required this.email,
    required this.password,
    required this.deviceId,
  });

  Map<String, dynamic> toJson() {
    return {"email": email, "password": password, "device_id": deviceId};
  }
}
