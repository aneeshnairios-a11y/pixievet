import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixievet/modules/login/services/user_login_service.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../../core/utils/device_controller/device_controller.dart';
import '../../../modules/login/models/user_login_request_model.dart';
import '../models/doctor_login_request_model.dart';
import '../services/doctor_login_service.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// Forms
  final userFormKey = GlobalKey<FormState>();
  final doctorFormKey = GlobalKey<FormState>();

  /// Controllers
  final mobileController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  /// Password visibility
  var isPasswordHidden = true.obs;

  final isLoading = false.obs;

  /// Tab Controller
  late TabController tabController;

  final DoctorLoginService _loginService = DoctorLoginService();
  final UserLoginService _userLoginService = UserLoginService();

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  /// USER LOGIN
  Future<void> userLogin({
    required String mobileNumber,
    required String deviceId,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!userFormKey.currentState!.validate()) return;

    isLoading.value = true;

    final response = await _userLoginService.login(
      UserLoginRequestModel(mobileNumber: mobileNumber, deviceId: deviceId),
    );

    isLoading.value = false;

    if (response.status) {
      Get.snackbar(
        "Success",
        response.message,
        snackPosition: SnackPosition.BOTTOM,
      );

      /// Navigate to OTP screen if needed
      // Get.toNamed("/otp", arguments: mobileNumber);
    } else {
      Get.snackbar(
        "Login Failed",
        response.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// DOCTOR LOGIN
  Future<void> doctorLogin() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!doctorFormKey.currentState!.validate()) return;

    isLoading.value = true;
    final deviceController = Get.find<DeviceController>();
    final response = await _loginService.login(
      DoctorLoginRequestModel(
        email: usernameController.text.trim(),
        password: passwordController.text.trim(),
        deviceId: deviceController.deviceId.value,
      ),
    );

    isLoading.value = false;

    if (response.status && response.authToken != null) {
      await SecureStorageService.saveToken(response.authToken!);
      await SecureStorageService.saveDoctorId(response.doctor?.id ?? '');

      Get.snackbar(
        "Success",
        "Login successful",
        snackPosition: SnackPosition.BOTTOM,
      );

      /// Navigate to dashboard
      Get.offAllNamed(AppRoutes.doctorDashboard);
    } else {
      Get.snackbar(
        "Login Failed",
        response.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void togglePassword() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  @override
  void onClose() {
    mobileController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    tabController.dispose();
    super.onClose();
  }
}
