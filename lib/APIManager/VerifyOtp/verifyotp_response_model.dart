class VerifyOtpResponseModel {
  final bool status;
  final String authToken;
  final String userId;
  final bool isProfileCreated;
  final UserModel? user;

  VerifyOtpResponseModel({
    required this.status,
    required this.authToken,
    required this.userId,
    required this.isProfileCreated,
    this.user,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      status: json['status'] ?? false,
      authToken: json['auth_token'] ?? '',
      userId: json['user_id'] ?? '',
      isProfileCreated: json['isProfileCreated'] ?? false,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  /// Convenience getter to check if user is a doctor
  bool get isDoctor => user?.role.toLowerCase() == 'doctor';

  factory VerifyOtpResponseModel.failure() {
    return VerifyOtpResponseModel(
      status: false,
      authToken: '',
      userId: '',
      isProfileCreated: false,
      user: null,
    );
  }
}

class UserModel {
  final String userId;
  final String mobileNumber;
  final String role;
  final String deviceId;

  UserModel({
    required this.userId,
    required this.mobileNumber,
    required this.role,
    required this.deviceId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      role: json['role'] ?? '',
      deviceId: json['device_id'] ?? '',
    );
  }
}
