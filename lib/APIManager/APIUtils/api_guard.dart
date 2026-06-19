// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pixievet/APIManager/SessionManager/session_manager.dart';
import 'package:pixievet/APIManager/TokenVerify/token_verify_request_model.dart';
import 'package:pixievet/APIManager/TokenVerify/token_verify_service.dart';
import 'package:pixievet/Views/Login/login_page.dart';
import 'package:pixievet/Utilities/device_utils.dart';

class ApiGuard {
  static Future<bool> verifySession(BuildContext context) async {
    final session = SessionManager();

    final userId = await session.getUserId();
    final token = await session.getToken();

    if (userId == null || token == null) {
      _forceLogout(context);
      return false;
    }

    final deviceId = await DeviceUtils.getDeviceId();

    final service = TokenVerifyService();
    final response = await service.verifyToken(
      TokenVerifyRequestModel(userId: userId, token: token, deviceId: deviceId),
    );

    if (response.status) {
      return true;
    } else {
      _forceLogout(context);
      return false;
    }
  }

  static void _forceLogout(BuildContext context) async {
    await SessionManager().clearSession();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }
}
