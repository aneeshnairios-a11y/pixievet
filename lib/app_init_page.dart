import 'package:flutter/material.dart';
import 'package:pixievet_app/APIManager/DoctorDashboard/doctor_dashboard_service.dart';
import 'package:pixievet_app/APIManager/PetDashboard/pet_dashboard_service.dart';
import 'package:pixievet_app/APIManager/SessionManager/session_manager.dart';
import 'package:pixievet_app/APIManager/TokenVerify/token_verify_request_model.dart';
import 'package:pixievet_app/APIManager/TokenVerify/token_verify_service.dart';
import 'package:pixievet_app/Views/DoctorDashboard/doctor_dashboard.dart';
import 'package:pixievet_app/Views/PetDashboard/dashboard_page.dart';
import 'package:pixievet_app/Views/Login/login_page.dart';
import 'package:pixievet_app/Utilities/device_utils.dart';

import 'Views/DoctorDashboard/main_doctor_page.dart';
import 'Views/PetDashboard/main_pet_page.dart';

// 👉 import doctor dashboard + service when ready
// import 'package:pixievet/DoctorDashboard/doctor_dashboard_page.dart';
// import 'package:pixievet/APIManager/DoctorDashboard/doctor_dashboard_service.dart';

class AppInitPage extends StatefulWidget {
  final bool fromLoginFlow;
  final bool? isDoctor; // 👈 add this

  const AppInitPage({super.key, this.fromLoginFlow = false, this.isDoctor});

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
    final doctorId = await session.getDoctorId();

    // ✅ Resolve doctor flag safely
    final bool isDoctor = widget.isDoctor ?? await session.isDoctor();

    // ❌ No session check
    if (token == null || (isDoctor ? doctorId == null : userId == null)) {
      _goToLogin();
      return;
    }

    // ✅ Pick correct ID safely (non-null now)
    final String activeUserId = isDoctor ? doctorId! : userId!;

    try {
      final deviceId = await DeviceUtils.getDeviceId();

      // 🔐 Token Verify
      final verifyResponse = await TokenVerifyService().verifyToken(
        TokenVerifyRequestModel(
          userId: activeUserId,
          token: token,
          deviceId: deviceId,
        ),
      );

      if (!verifyResponse.status) {
        await session.clearSession();
        _goToLogin();
        return;
      }

      if (!mounted) return;

      // 🩺 Doctor Flow
      if (isDoctor) {
        final doctorDashboard = await DoctorDashboardService()
            .fetchDoctorDashboard();

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => MainDoctorPage(dashboardData: doctorDashboard),
          ),
          (_) => false,
        );
      }
      // 🐶 Pet Flow
      else {
        final petDashboard = await PetDashboardService().fetchPetDashboard();

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => MainPetPage(dashboardData: petDashboard),
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
