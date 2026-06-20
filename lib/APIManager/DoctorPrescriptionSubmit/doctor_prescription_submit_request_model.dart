import 'dart:io';

class DoctorPrescriptionSubmitRequestModel {
  final String userId;
  final String token;
  final String deviceId;
  final String appointmentId;
  final String description;
  final String medicinesJson;
  final String notes;
  final List<File>? files;

  DoctorPrescriptionSubmitRequestModel({
    required this.userId,
    required this.token,
    required this.deviceId,
    required this.appointmentId,
    required this.description,
    required this.medicinesJson,
    required this.notes,
    this.files,
  });
}
