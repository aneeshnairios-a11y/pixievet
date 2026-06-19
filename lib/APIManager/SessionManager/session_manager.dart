import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionManager {
  // Singleton
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Keys
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _doctorIdKey = 'doctor_id';
  static const _isDoctorKey = 'is_doctor';

  /* =======================
     SAVE METHODS
  ======================= */

  /// 🔐 Save auth token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// 👤 Save user id
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  /// 👤 Save doctor id
  Future<void> saveDoctorId(String doctorId) async {
    await _storage.write(key: _doctorIdKey, value: doctorId);
  }

  Future<void> saveIsDoctor(bool isDoctor) async {
    await _storage.write(key: _isDoctorKey, value: isDoctor ? '1' : '0');
  }

  /// ✅ Save both token & userId together (recommended)
  Future<void> saveSession({
    required String token,
    required String userId,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _userIdKey, value: userId);
  }

  /* =======================
     GET METHODS
  ======================= */

  /// 🔑 Get auth token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// 👤 Get user id
  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  /// 👤 Get user id
  Future<String?> getDoctorId() async {
    return await _storage.read(key: _doctorIdKey);
  }

  /// 🧠 Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    final userId = await getUserId();
    return token != null && token.isNotEmpty && userId != null;
  }

  Future<bool> isDoctor() async {
    final value = await _storage.read(key: _isDoctorKey);
    return value == '1';
  }
  /* =======================
     CLEAR METHODS
  ======================= */

  /// 🚪 Clear only auth data
  Future<void> clearSession() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _isDoctorKey);
    await _storage.delete(key: _doctorIdKey);
  }

  /// ❌ Clear everything (use carefully)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
