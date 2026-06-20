import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _tokenKey = "auth_token";
  static const String _doctorIdKey = "doctor_id";
  static const String _isDoctorKey = "is_doctor";

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> saveDoctorId(String doctorId) async {
    await _storage.write(key: _doctorIdKey, value: doctorId);
  }

  static Future<String?> getDoctorId() async {
    return await _storage.read(key: _doctorIdKey);
  }

  static Future<void> saveIsDoctor(bool value) async {
    await _storage.write(key: _isDoctorKey, value: value.toString());
  }

  static Future<bool> getIsDoctor() async {
    final value = await _storage.read(key: _isDoctorKey);
    return value == "true";
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
