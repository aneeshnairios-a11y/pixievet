class DoctorDashboardResponseModel {
  final bool status;
  final DoctorDetails? doctorDetails;
  final List<UpcomingAppointment> upcomingAppointments;

  DoctorDashboardResponseModel({
    required this.status,
    this.doctorDetails,
    required this.upcomingAppointments,
  });

  factory DoctorDashboardResponseModel.fromJson(Map<String, dynamic> json) {
    return DoctorDashboardResponseModel(
      status: json['status'] ?? false,
      doctorDetails: json['doctor_details'] != null
          ? DoctorDetails.fromJson(json['doctor_details'])
          : null,
      upcomingAppointments: (json['upcoming_appointments'] as List? ?? [])
          .map((e) => UpcomingAppointment.fromJson(e))
          .toList(),
    );
  }

  factory DoctorDashboardResponseModel.failure(String message) {
    return DoctorDashboardResponseModel(
      status: false,
      doctorDetails: null,
      upcomingAppointments: const [],
    );
  }
}

class DoctorDetails {
  final String id;
  final String name;
  final String specialization;
  final String email;
  final String mobileNumber;
  final int experienceYears;
  final String licenseNumber;

  DoctorDetails({
    required this.id,
    required this.name,
    required this.specialization,
    required this.email,
    required this.mobileNumber,
    required this.experienceYears,
    required this.licenseNumber,
  });

  factory DoctorDetails.fromJson(Map<String, dynamic> json) {
    return DoctorDetails(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      experienceYears: json['experience_years'] ?? 0,
      licenseNumber: json['license_number'] ?? '',
    );
  }
}

class UpcomingAppointment {
  final String appointmentId;
  final String userId;
  final String doctorId;
  final String date; // dd/MM/yyyy
  final String time; // HH:mm
  final String paymentStatus;
  final UserDetails userDetails; // NEW

  UpcomingAppointment({
    required this.appointmentId,
    required this.userId,
    required this.doctorId,
    required this.date,
    required this.time,
    required this.paymentStatus,
    required this.userDetails,
  });

  factory UpcomingAppointment.fromJson(Map<String, dynamic> json) {
    return UpcomingAppointment(
      appointmentId: json['_id'] ?? '',
      userId: json['user_id'] ?? '',
      doctorId: json['doctor_id'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      userDetails: json['user_details'] != null
          ? UserDetails.fromJson(json['user_details'])
          : UserDetails(id: '', ownerName: '', email: '', mobileNumber: ''),
    );
  }

  DateTime get appointmentDate {
    final parts = date.split('/');
    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }
}

class UserDetails {
  final String id;
  final String ownerName;
  final String email;
  final String mobileNumber;

  UserDetails({
    required this.id,
    required this.ownerName,
    required this.email,
    required this.mobileNumber,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'] ?? '',
      ownerName: json['owner_name'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
    );
  }
}
