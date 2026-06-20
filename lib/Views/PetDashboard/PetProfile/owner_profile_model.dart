import 'dart:io';

class OwnerProfileModel {
  final String fullName;
  final String mobile;
  final String email;
  final String gender;
  final File? profileImage;

  OwnerProfileModel({
    required this.fullName,
    required this.mobile,
    required this.email,
    required this.gender,
    this.profileImage,
  });
}
