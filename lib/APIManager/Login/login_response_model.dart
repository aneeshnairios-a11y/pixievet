class LoginResponseModel {
  final bool status;
  final String message;
  final bool isDoctor;
  final String? otp;

  LoginResponseModel({
    required this.status,
    required this.message,
    required this.isDoctor,
    this.otp,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? 'Something went wrong',
      isDoctor: json['is_doctor'] ?? false,
      otp: json['otp'],
    );
  }

  factory LoginResponseModel.failure(String message) {
    return LoginResponseModel(
      status: false,
      message: message,
      isDoctor: false,
      otp: null,
    );
  }
}
