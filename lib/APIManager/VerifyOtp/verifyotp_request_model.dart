class VerifyOtpRequestModel {
  final String mobileNumber;
  final String otp;
  final String deviceId;

  VerifyOtpRequestModel({
    required this.mobileNumber,
    required this.otp,
    required this.deviceId,
  });

  Map<String, dynamic> toJson() {
    return {'mobile_number': mobileNumber, 'otp': otp, 'device_id': deviceId};
  }
}
