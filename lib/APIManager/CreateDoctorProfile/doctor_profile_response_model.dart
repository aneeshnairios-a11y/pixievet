class DoctorProfileResponseModel {
  final bool status;
  final String message;
  final String authToken;
  final DoctorModel? doctor;

  DoctorProfileResponseModel({
    required this.status,
    required this.message,
    required this.authToken,
    this.doctor,
  });

  factory DoctorProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return DoctorProfileResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      authToken: json['auth_token'] ?? '',
      doctor: json['doctor'] != null
          ? DoctorModel.fromJson(json['doctor'])
          : null,
    );
  }

  factory DoctorProfileResponseModel.failure(String message) {
    return DoctorProfileResponseModel(
      status: false,
      message: message,
      authToken: '',
      doctor: null,
    );
  }
}

class DoctorModel {
  final String id;
  final String mobileNumber;
  final String deviceId;
  final String role;
  final String email;
  final int experienceYears;
  final String licenseNumber;
  final String ownerName;
  final String specialization;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DoctorProfile? doctorProfile;

  DoctorModel({
    required this.id,
    required this.mobileNumber,
    required this.deviceId,
    required this.role,
    required this.email,
    required this.experienceYears,
    required this.licenseNumber,
    required this.ownerName,
    required this.specialization,
    required this.createdAt,
    required this.updatedAt,
    this.doctorProfile,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['_id'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      deviceId: json['device_id'] ?? '',
      role: json['role'] ?? '',
      email: json['email'] ?? '',
      experienceYears: json['experience_years'] ?? 0,
      licenseNumber: json['license_number'] ?? '',
      ownerName: json['owner_name'] ?? '',
      specialization: json['specialization'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
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
  final DateTime updatedAt;

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
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}
