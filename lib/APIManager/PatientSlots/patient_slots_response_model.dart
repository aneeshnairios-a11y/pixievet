class PatientSlotsResponseModel {
  final bool status;
  final DoctorInfo? doctor;
  final List<PatientSlot> slots;
  final int totalAvailableSlots;
  final String message;

  PatientSlotsResponseModel({
    required this.status,
    required this.doctor,
    required this.slots,
    required this.totalAvailableSlots,
    this.message = '',
  });

  /// ✅ ADD THIS
  factory PatientSlotsResponseModel.fromJson(Map<String, dynamic> json) {
    return PatientSlotsResponseModel(
      status: json['status'] ?? false,
      doctor: json['doctor'] != null
          ? DoctorInfo.fromJson(json['doctor'])
          : null,
      slots: json['available_slots'] != null
          ? (json['available_slots'] as List)
                .map((e) => PatientSlot.fromTime(e))
                .toList()
          : [],
      totalAvailableSlots: json['total_available_slots'] ?? 0,
      message: json['message'] ?? '',
    );
  }

  factory PatientSlotsResponseModel.failure(String message) {
    return PatientSlotsResponseModel(
      status: false,
      doctor: null,
      slots: [],
      totalAvailableSlots: 0,
      message: message,
    );
  }
}

class DoctorInfo {
  final String doctorId;
  final String doctorName;
  final String specialization;
  final int experienceYears;
  final String date;

  DoctorInfo({
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
    required this.experienceYears,
    required this.date,
  });

  factory DoctorInfo.fromJson(Map<String, dynamic> json) {
    return DoctorInfo(
      doctorId: json['doctor_id'] ?? '',
      doctorName: json['doctor_name'] ?? '',
      specialization: json['specialization'] ?? '',
      experienceYears: json['experience_years'] ?? 0,
      date: json['date'] ?? '',
    );
  }
}

class PatientSlot {
  final String slotTime; // "09:30"

  PatientSlot({required this.slotTime});

  factory PatientSlot.fromTime(String time) {
    return PatientSlot(slotTime: time);
  }

  bool get isAvailable => true; // all returned slots are available
}
