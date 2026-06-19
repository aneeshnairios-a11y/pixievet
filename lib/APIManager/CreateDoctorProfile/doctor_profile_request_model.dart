class DoctorProfileRequestModel {
  final String userId;
  final String token;
  final String deviceId;
  final String name;
  final String email;
  final String specialization;
  final int experienceYears;
  final String licenseNumber;

  DoctorProfileRequestModel({
    required this.userId,
    required this.token,
    required this.deviceId,
    required this.name,
    required this.email,
    required this.specialization,
    required this.experienceYears,
    required this.licenseNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'token': token,
      'device_id': deviceId,
      'name': name,
      'email': email,
      'specialization': specialization,
      'experience_years': experienceYears,
      'license_number': licenseNumber,
    };
  }
}
