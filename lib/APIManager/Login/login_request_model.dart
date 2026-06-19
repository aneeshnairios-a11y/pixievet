class LoginRequestModel {
  final String mobileNumber;
  final String deviceid;

  LoginRequestModel({required this.mobileNumber, required this.deviceid});

  Map<String, dynamic> toJson() {
    return {'mobile_number': mobileNumber, 'device_id': deviceid};
  }
}
