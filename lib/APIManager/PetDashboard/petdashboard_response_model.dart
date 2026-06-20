import 'package:pixievet_app/APIManager/SessionManager/session_manager.dart';

class PetDashboardResponseModel {
  final bool status;
  final String userId;
  final String ownerName;
  final String mobileNumber;
  final String email;
  final List<AppointmentModel> appointments;
  final List<DoctorModel> doctors;

  PetDashboardResponseModel({
    required this.status,
    required this.userId,
    required this.ownerName,
    required this.mobileNumber,
    required this.email,
    required this.appointments,
    required this.doctors,
  });

  factory PetDashboardResponseModel.fromJson(Map<String, dynamic> json) {
    final doctorsList = (json['doctors'] as List<dynamic>? ?? [])
        .map((e) => DoctorModel.fromJson(e))
        .toList();

    if (doctorsList.isNotEmpty) {
      SessionManager().saveDoctorId(doctorsList.first.id);
    }

    return PetDashboardResponseModel(
      status: json['status'] ?? false,
      userId: json['user_id'] ?? '',
      ownerName: json['owner_name'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      email: json['email'] ?? '',
      appointments: (json['appointments'] as List<dynamic>? ?? [])
          .map((e) => AppointmentModel.fromJson(e))
          .toList(),
      doctors: doctorsList,
    );
  }
}

class DoctorModel {
  final String id;
  final String name;
  final String specialization;
  final String email;
  final int? experienceYears;
  final String? licenseNumber;
  final DoctorProfileModel doctorProfile;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.email,
    this.experienceYears,
    this.licenseNumber,
    required this.doctorProfile,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      email: json['email'] ?? '',
      experienceYears: json['experience_years'],
      licenseNumber: json['license_number'],
      doctorProfile: DoctorProfileModel.fromJson(json['doctor_profile'] ?? {}),
    );
  }
}

class DoctorProfileModel {
  final String name;
  final String specialization;
  final int? experienceYears;
  final String? licenseNumber;
  final DateTime? updatedAt;

  DoctorProfileModel({
    required this.name,
    required this.specialization,
    this.experienceYears,
    this.licenseNumber,
    this.updatedAt,
  });

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) {
    return DoctorProfileModel(
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      experienceYears: json['experience_years'],
      licenseNumber: json['license_number'],
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}

class AppointmentModel {
  final int appointmentId;
  final String doctorId;
  final String date;
  final String status;
  final String time;
  final String? link;
  final String? videoCall;
  final DoctorModel doctorDetails;

  AppointmentModel({
    required this.appointmentId,
    required this.doctorId,
    required this.date,
    required this.status,
    required this.time,
    this.link,
    this.videoCall,
    required this.doctorDetails,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      appointmentId: json['appointment_id'],
      doctorId: json['doctor_id'] ?? '',
      date: json['date'],
      status: json['status'] ?? '',
      time: json['time'] ?? '',
      link: json['link'],
      videoCall: json['video_call'],
      doctorDetails: DoctorModel.fromJson(json['doctor_details'] ?? {}),
    );
  }
}
