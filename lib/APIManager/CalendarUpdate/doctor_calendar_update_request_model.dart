class DoctorCalendarUpdateRequestModel {
  final String userId;
  final String token;
  final String deviceId;
  final List<DoctorDateOff> datesOff;

  DoctorCalendarUpdateRequestModel({
    required this.userId,
    required this.token,
    required this.deviceId,
    required this.datesOff,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'token': token,
      'device_id': deviceId,
      'dates_off': datesOff.map((e) => e.toJson()).toList(),
    };
  }
}

class DoctorDateOff {
  final String date;
  final List<String> slots;

  DoctorDateOff({required this.date, required this.slots});

  Map<String, dynamic> toJson() {
    return {'date': date, 'slots': slots};
  }
}
