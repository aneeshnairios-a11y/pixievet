class UserLoginResponseModel {
  final bool status;
  final String message;
  final bool isDoctor;
  final String? otp;

  UserLoginResponseModel({
    required this.status,
    required this.message,
    required this.isDoctor,
    this.otp,
  });

  factory UserLoginResponseModel.fromJson(Map<String, dynamic> json) {
    return UserLoginResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? 'Something went wrong',
      isDoctor: json['is_doctor'] ?? false,
      otp: json['otp'],
    );
  }

  factory UserLoginResponseModel.failure(String message) {
    return UserLoginResponseModel(
      status: false,
      message: message,
      isDoctor: false,
      otp: null,
    );
  }
}
