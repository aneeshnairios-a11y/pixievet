class PatientSlotsResponseModel {
  final bool status;
  final List<PatientSlot> slots;
  final String message;

  PatientSlotsResponseModel({
    required this.status,
    required this.slots,
    required this.message,
  });

  factory PatientSlotsResponseModel.fromJson(Map<String, dynamic> json) {
    return PatientSlotsResponseModel(
      status: json['status'] ?? false,
      slots: json['slots'] != null
          ? (json['slots'] as List).map((e) => PatientSlot.fromJson(e)).toList()
          : [],
      message: json['message'] ?? '',
    );
  }

  factory PatientSlotsResponseModel.failure(String message) {
    return PatientSlotsResponseModel(
      status: false,
      slots: [],
      message: message,
    );
  }
}

class PatientSlot {
  final int slotId;
  final String slotTime; // 24h format e.g. 09:30
  final String slotStatus; // available / unavailable

  PatientSlot({
    required this.slotId,
    required this.slotTime,
    required this.slotStatus,
  });

  factory PatientSlot.fromJson(Map<String, dynamic> json) {
    return PatientSlot(
      slotId: json['slotId'] ?? 0,
      slotTime: json['slotTime'] ?? '',
      slotStatus: json['slotStatus'] ?? '',
    );
  }

  bool get isAvailable => slotStatus == 'available';
}
