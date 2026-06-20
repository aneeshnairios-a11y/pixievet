class BookAppointmentRequestModel {
  final String userId;
  final String token;
  final String deviceId;
  final String date; // dd/MM/yyyy
  final String time; // HH:mm
  final String doctorId;
  final String petId;

  BookAppointmentRequestModel({
    required this.userId,
    required this.token,
    required this.deviceId,
    required this.date,
    required this.time,
    required this.doctorId,
    required this.petId,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'token': token,
      'device_id': deviceId,
      'date': date,
      'time': time,
      'doctor_id': doctorId,
      'pet_id': petId,
    };
  }
}
