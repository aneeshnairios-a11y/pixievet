import 'dart:io';

class DoctorProfileRequestModel {
  final String userId;
  final String token;
  final String deviceId;
  final String name;
  final String email;
  final String specialization;
  final int experienceYears;
  final String licenseNumber;
  final File? profileImage;

  DoctorProfileRequestModel({
    required this.userId,
    required this.token,
    required this.deviceId,
    required this.name,
    required this.email,
    required this.specialization,
    required this.experienceYears,
    required this.licenseNumber,
    this.profileImage,
  });
}
