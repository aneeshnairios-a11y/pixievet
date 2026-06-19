class TokenVerifyResponseModel {
  final bool status;
  final String message;

  TokenVerifyResponseModel({required this.status, required this.message});

  factory TokenVerifyResponseModel.fromJson(Map<String, dynamic> json) {
    return TokenVerifyResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
