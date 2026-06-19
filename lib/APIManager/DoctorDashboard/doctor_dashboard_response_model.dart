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
      upcomingAppointments: [],
    );
  }
}

class UpcomingAppointment {
  final String appointmentId;
  final String patientName;
  final String petName;
  final String petType;
  final DateTime appointmentDateTime;

  UpcomingAppointment({
    required this.appointmentId,
    required this.patientName,
    required this.petName,
    required this.petType,
    required this.appointmentDateTime,
  });

  factory UpcomingAppointment.fromJson(Map<String, dynamic> json) {
    return UpcomingAppointment(
      appointmentId: json['_id'] ?? '',
      patientName: json['patient_name'] ?? '',
      petName: json['pet_name'] ?? '',
      petType: json['pet_type'] ?? '',
      appointmentDateTime: DateTime.parse(json['appointment_time']),
    );
  }

  /// UI-friendly formatted date
  String get formattedDateTime {
    return '${appointmentDateTime.day.toString().padLeft(2, '0')} '
        '${_monthName(appointmentDateTime.month)} '
        '${appointmentDateTime.year}, '
        '${_formatTime(appointmentDateTime)}';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}

class DoctorDetails {
  final String id;
  final String name;
  final String specialization;
  final String email;

  DoctorDetails({
    required this.id,
    required this.name,
    required this.specialization,
    required this.email,
  });

  factory DoctorDetails.fromJson(Map<String, dynamic> json) {
    return DoctorDetails(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
