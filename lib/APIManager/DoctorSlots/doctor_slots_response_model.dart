class DoctorSlotsResponseModel {
  final bool status;
  final List<DoctorSlot> slots;
  final String message;

  DoctorSlotsResponseModel({
    required this.status,
    required this.slots,
    required this.message,
  });

  factory DoctorSlotsResponseModel.fromJson(Map<String, dynamic> json) {
    return DoctorSlotsResponseModel(
      status: json['status'] ?? false,
      slots: json['slots'] != null
          ? (json['slots'] as List).map((e) => DoctorSlot.fromJson(e)).toList()
          : [],
      message: json['message'] ?? '',
    );
  }

  factory DoctorSlotsResponseModel.failure(String message) {
    return DoctorSlotsResponseModel(status: false, slots: [], message: message);
  }
}

class DoctorSlot {
  final int slotId;
  final String slotTime; // 24h format e.g. 09:30
  final String slotStatus; // available / unavailable

  DoctorSlot({
    required this.slotId,
    required this.slotTime,
    required this.slotStatus,
  });

  factory DoctorSlot.fromJson(Map<String, dynamic> json) {
    return DoctorSlot(
      slotId: json['slotId'] ?? 0,
      slotTime: json['slotTime'] ?? '',
      slotStatus: json['slotStatus'] ?? '',
    );
  }

  bool get isAvailable => slotStatus == 'available';
}
