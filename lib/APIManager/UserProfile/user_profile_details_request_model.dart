class UserProfileDetailsRequestModel {
  final String userId;
  final String token;
  final String deviceId;

  UserProfileDetailsRequestModel({
    required this.userId,
    required this.token,
    required this.deviceId,
  });

  Map<String, dynamic> toJson() {
    return {'user_id': userId, 'token': token, 'device_id': deviceId};
  }
}
