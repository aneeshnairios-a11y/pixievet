class DoctorProfileDetailsResponseModel {
  final bool status;
  final DoctorProfileData? doctor;
  final String message;

  DoctorProfileDetailsResponseModel({
    required this.status,
    this.doctor,
    required this.message,
  });

  factory DoctorProfileDetailsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DoctorProfileDetailsResponseModel(
      status: json['status'] ?? false,
      doctor: json['doctor'] != null
          ? DoctorProfileData.fromJson(json['doctor'])
          : null,
      message: json['message'] ?? '',
    );
  }

  factory DoctorProfileDetailsResponseModel.failure(String message) {
    return DoctorProfileDetailsResponseModel(
      status: false,
      doctor: null,
      message: message,
    );
  }
}

class DoctorProfileData {
  final String id;
  final String mobileNumber;
  final String email;
  final String name;
  final String specialization;
  final int experienceYears;
  final String licenseNumber;

  DoctorProfileData({
    required this.id,
    required this.mobileNumber,
    required this.email,
    required this.name,
    required this.specialization,
    required this.experienceYears,
    required this.licenseNumber,
  });

  factory DoctorProfileData.fromJson(Map<String, dynamic> json) {
    final profile = json['doctor_profile'] ?? {};

    return DoctorProfileData(
      id: json['_id'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      email: json['email'] ?? '',
      name: profile['name'] ?? json['owner_name'] ?? '',
      specialization: profile['specialization'] ?? json['specialization'] ?? '',
      experienceYears:
          profile['experience_years'] ?? json['experience_years'] ?? 0,
      licenseNumber: profile['license_number'] ?? json['license_number'] ?? '',
    );
  }
}
