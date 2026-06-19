class PetDashboardResponseModel {
  final bool status;
  final String userId;
  final String ownerName;
  final String mobileNumber;
  final String email;
  final List<AppointmentModel> appointments;

  PetDashboardResponseModel({
    required this.status,
    required this.userId,
    required this.ownerName,
    required this.mobileNumber,
    required this.email,
    required this.appointments,
  });

  factory PetDashboardResponseModel.fromJson(Map<String, dynamic> json) {
    return PetDashboardResponseModel(
      status: json['status'] ?? false,
      userId: json['user_id'] ?? '',
      ownerName: json['owner_name'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      email: json['email'] ?? '',
      appointments: (json['appointments'] as List<dynamic>? ?? [])
          .map((e) => AppointmentModel.fromJson(e))
          .toList(),
    );
  }
}

class AppointmentModel {
  AppointmentModel();

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel();
  }
}
