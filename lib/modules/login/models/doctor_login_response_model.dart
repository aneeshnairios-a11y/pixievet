class DoctorLoginResponseModel {
  final bool status;
  final String message;
  final String? authToken;
  final Doctor? doctor;

  DoctorLoginResponseModel({
    required this.status,
    required this.message,
    this.authToken,
    this.doctor,
  });

  /// Success Response
  factory DoctorLoginResponseModel.fromJson(Map<String, dynamic> json) {
    return DoctorLoginResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      authToken: json['auth_token'],
      doctor: json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null,
    );
  }

  /// Failure Response
  factory DoctorLoginResponseModel.failure(String message) {
    return DoctorLoginResponseModel(
      status: false,
      message: message,
      authToken: null,
      doctor: null,
    );
  }
}

class Doctor {
  final String id;
  final String ownerName;
  final String email;
  final String mobileNumber;
  final String specialization;
  final int experienceYears;
  final String licenseNumber;
  final String? profileImage;
  final bool isActive;
  final DoctorProfile? doctorProfile;

  Doctor({
    required this.id,
    required this.ownerName,
    required this.email,
    required this.mobileNumber,
    required this.specialization,
    required this.experienceYears,
    required this.licenseNumber,
    this.profileImage,
    required this.isActive,
    this.doctorProfile,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['_id'] ?? '',
      ownerName: json['owner_name'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      specialization: json['specialization'] ?? '',
      experienceYears: json['experience_years'] ?? 0,
      licenseNumber: json['license_number'] ?? '',
      profileImage: json['profile_image'],
      isActive: json['is_active'] ?? false,
      doctorProfile: json['doctor_profile'] != null
          ? DoctorProfile.fromJson(json['doctor_profile'])
          : null,
    );
  }
}

class DoctorProfile {
  final String name;
  final String specialization;
  final int experienceYears;
  final String licenseNumber;
  final String updatedAt;

  DoctorProfile({
    required this.name,
    required this.specialization,
    required this.experienceYears,
    required this.licenseNumber,
    required this.updatedAt,
  });

  factory DoctorProfile.fromJson(Map<String, dynamic> json) {
    return DoctorProfile(
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      experienceYears: json['experience_years'] ?? 0,
      licenseNumber: json['license_number'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
