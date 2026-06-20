class PetDetailsRequestModel {
  final String userId;
  final String token;
  final String deviceId;
  final String petId;

  PetDetailsRequestModel({
    required this.userId,
    required this.token,
    required this.deviceId,
    required this.petId,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'token': token,
      'device_id': deviceId,
      'pet_id': petId,
    };
  }
}
