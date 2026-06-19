class PetProfileCreateResponseModel {
  final bool status;
  final String message;
  final bool isProfileCreated;

  PetProfileCreateResponseModel({
    required this.status,
    required this.message,
    required this.isProfileCreated,
  });

  factory PetProfileCreateResponseModel.fromJson(Map<String, dynamic> json) {
    return PetProfileCreateResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? 'Something went wrong',
      isProfileCreated: json['isProfileCreated'] ?? false,
    );
  }

  factory PetProfileCreateResponseModel.failure(String message) {
    return PetProfileCreateResponseModel(
      status: false,
      message: message,
      isProfileCreated: false,
    );
  }
}
