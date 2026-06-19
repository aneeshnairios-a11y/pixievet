import 'package:flutter/material.dart';
import 'package:pixievet/APIManager/DoctorDashboard/doctor_dashboard_service.dart';
import 'package:pixievet/APIManager/PetDashboard/pet_dashboard_service.dart';
import 'package:pixievet/APIManager/SessionManager/session_manager.dart';
import 'package:pixievet/APIManager/TokenVerify/token_verify_request_model.dart';
import 'package:pixievet/APIManager/TokenVerify/token_verify_service.dart';
import 'package:pixievet/Views/DoctorDashboard/doctor_dashboard.dart';
import 'package:pixievet/Views/PetDashboard/dashboard_page.dart';
import 'package:pixievet/Views/Login/login_page.dart';
import 'package:pixievet/Utilities/device_utils.dart';

// 👉 import doctor dashboard + service when ready
// import 'package:pixievet/DoctorDashboard/doctor_dashboard_page.dart';
// import 'package:pixievet/APIManager/DoctorDashboard/doctor_dashboard_service.dart';

class AppInitPage extends StatefulWidget {
  final bool fromLoginFlow;

  const AppInitPage({super.key, this.fromLoginFlow = false});

  @override
  State<AppInitPage> createState() => _AppInitPageState();
}

class _AppInitPageState extends State<AppInitPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final session = SessionManager();

    final token = await session.getToken();
    final userId = await session.getUserId();

    // ❌ No session → Login
    if (token == null || userId == null) {
      _goToLogin();
      return;
    }

    try {
      final deviceId = await DeviceUtils.getDeviceId();

      // 🔐 Step 1: Verify Token
      final verifyResponse = await TokenVerifyService().verifyToken(
        TokenVerifyRequestModel(
          userId: userId,
          token: token,
          deviceId: deviceId,
        ),
      );

      if (!verifyResponse.status) {
        await session.clearSession();
        _goToLogin();
        return;
      }

      // 👤 Step 2: Check role
      final bool isDoctor = await session.isDoctor();

      if (!mounted) return;

      // 🩺 Doctor Flow
      if (isDoctor) {
        final doctorDashboard = await DoctorDashboardService()
            .fetchDoctorDashboard();

        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DoctorDashboardPage(dashboardData: doctorDashboard),
          ),
        );
      }
      // 🐶 Pet Owner Flow
      else {
        final petDashboard = await PetDashboardService().fetchPetDashboard();

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => PetDashboardPage(dashboardData: petDashboard),
          ),
          (_) => false,
        );
      }
    } catch (e) {
      await session.clearSession();
      _goToLogin();
    }
  }

  void _goToLogin() {
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔄 Splash / Loader screen
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
