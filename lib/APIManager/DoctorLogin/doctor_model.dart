class DoctorModel {
  final String id;
  final String ownerName;
  final String email;
  final String mobileNumber;
  final String specialization;
  final int experienceYears;
  final String licenseNumber;
  final String? profileImage;
  final bool isActive;

  DoctorModel({
    required this.id,
    required this.ownerName,
    required this.email,
    required this.mobileNumber,
    required this.specialization,
    required this.experienceYears,
    required this.licenseNumber,
    required this.profileImage,
    required this.isActive,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['_id'] ?? '',
      ownerName: json['owner_name'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      specialization: json['specialization'] ?? '',
      experienceYears: json['experience_years'] ?? 0,
      licenseNumber: json['license_number'] ?? '',
      profileImage: json['profile_image'],
      isActive: json['is_active'] ?? false,
    );
  }
}
