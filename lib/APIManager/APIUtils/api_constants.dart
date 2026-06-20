class ApiConstants {
  static const String baseUrl = 'https://pixievet.vercel.app';
  static const String login = '/auth/login';
  static const String verifyOtp = '/auth/verify-otp';
  static const String petDashboard = '/auth/dashboard';
  static const String dummyLogin = '/auth/dummyotp';
  static const String dummyOtpVerify = '/auth/dummyotp-verify';
  static const String createPetProfile = '/auth/register/v2';
  static const String createDoctorProfile = '/doctor/register';
  static const String doctorDashboard = '/doctor/dashboard';
  static const String doctorCalendarUpdate = '/doctor/calendar/update';
  static const String doctorSlots = '/doctor/slots';
  static const String doctorProfile = '/doctor/profile';
  static const String patientSlots = '/user/doctor/slots';
  static const String bookAppointment = '/appointment/book';
  static const String patientVisit = '/doctor/patient-visit';
  static const String doctorPets = '/doctor/pets';
  static const String doctorPrescriptionSubmit = '/doctor/prescription/submit';
  static const String userProfile = '/user/profile';
  static const String doctorPetDetails = '/doctor/pets/details';
  static const String doctorLogin = "/auth/doctor/login";
}
