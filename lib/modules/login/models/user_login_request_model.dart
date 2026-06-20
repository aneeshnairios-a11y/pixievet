class UserLoginRequestModel {
  final String mobileNumber;
  final String deviceId;

  UserLoginRequestModel({required this.mobileNumber, required this.deviceId});

  Map<String, dynamic> toJson() {
    return {"mobile_number": mobileNumber, "device_id": deviceId};
  }
}
