// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixievet_app/APIManager/Login/login_request_model.dart';
import 'package:pixievet_app/APIManager/Login/login_service.dart';
import 'package:pixievet_app/APIManager/SessionManager/session_manager.dart';
import 'package:pixievet_app/Views/Login/otp_verification_page.dart';
import 'package:pixievet_app/Utilities/app_alert.dart';
import 'package:pixievet_app/Utilities/app_colors.dart';
import 'package:pixievet_app/Utilities/app_images.dart';
import 'package:pixievet_app/Utilities/app_loader.dart';
import 'package:pixievet_app/Utilities/device_utils.dart';

import '../../APIManager/DoctorLogin/doctor_login_request_model.dart';
import '../../APIManager/DoctorLogin/doctor_login_service.dart';
import '../../app_init_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _userFormKey = GlobalKey<FormState>();
  final _doctorFormKey = GlobalKey<FormState>();

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordHidden = true;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  /// ================= USER LOGIN =================
  Future<void> _handleUserLogin() async {
    FocusScope.of(context).unfocus();

    if (!_userFormKey.currentState!.validate()) return;

    AppLoader().show(context, message: "Please wait...");

    try {
      final loginService = LoginService();
      final deviceId = await DeviceUtils.getDeviceId();

      final response = await loginService.login(
        LoginRequestModel(
          mobileNumber: _mobileController.text.trim(),
          deviceid: deviceId,
        ),
      );

      if (response.status) {
        await SessionManager().saveIsDoctor(false);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpVerificationPage(
              mobileNumber: _mobileController.text,
              otp: response.otp ?? '',
            ),
          ),
        );
      } else {
        AppAlert.show(
          context: context,
          type: AlertType.warning,
          title: "Login Failed",
          message: response.message,
        );
      }
    } catch (e) {
      AppAlert.show(
        context: context,
        type: AlertType.warning,
        title: "Something went wrong",
        message: e.toString(),
      );
    } finally {
      AppLoader().hide();
    }
  }

  /// ================= DOCTOR LOGIN =================
  Future<void> _handleDoctorLogin() async {
    FocusScope.of(context).unfocus();

    if (!_doctorFormKey.currentState!.validate()) return;

    AppLoader().show(context, message: "Please wait...");

    try {
      final loginService = DoctorLoginService();

      final response = await loginService.login(
        DoctorLoginRequestModel(
          email: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );

      if (response.status && response.authToken != null) {
        /// ✅ Save Session
        await SessionManager().saveToken(response.authToken!);
        await SessionManager().saveIsDoctor(true);
        await SessionManager().saveDoctorId(response.doctor?.id ?? '');
        print(response.authToken!);
        print(response.doctor?.id);

        /// Navigate to Doctor Dashboard
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const AppInitPage(fromLoginFlow: true, isDoctor: true),
          ),
          (_) => false,
        );
      } else {
        AppAlert.show(
          context: context,
          type: AlertType.warning,
          title: "Login Failed",
          message: response.message,
        );
      }
    } catch (e) {
      AppAlert.show(
        context: context,
        type: AlertType.warning,
        title: "Something went wrong",
        message: e.toString(),
      );
    } finally {
      AppLoader().hide();
    }
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            /// Background
            SizedBox(
              width: size.width,
              height: size.height,
              child: Image.asset(AppImages.appBackground, fit: BoxFit.fill),
            ),

            /// Bottom Card
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * 0.60,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  children: [
                    /// 🔹 Tabs
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F5F9),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey.shade600,
                        labelStyle: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        tabs: const [
                          Tab(text: "Doctor"),
                          Tab(text: "User"),
                        ],
                      ),
                    ),

                    /// 🔹 Tab Views
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          /// ================= DOCTOR LOGIN =================
                          SingleChildScrollView(
                            child: Form(
                              key: _doctorFormKey,
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  _titleSection(),
                                  const SizedBox(height: 20),
                                  _doctorFields(),
                                  const SizedBox(height: 35),
                                  _doctorButton(),
                                ],
                              ),
                            ),
                          ),

                          /// ================= USER LOGIN =================
                          SingleChildScrollView(
                            child: Form(
                              key: _userFormKey,
                              child: Column(
                                children: [
                                  const SizedBox(height: 15),
                                  _titleSection(),
                                  const SizedBox(height: 15),
                                  _userFields(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Common Title
  Widget _titleSection() {
    return Column(
      children: [
        Text(
          "Sign In",
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "Access to your account",
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Doctor Fields
  Widget _doctorFields() {
    return Column(
      children: [
        TextFormField(
          controller: _usernameController,
          validator: (value) => value!.isEmpty ? "Username is required" : null,
          decoration: _inputDecoration("Username"),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: _passwordController,
          obscureText: _isPasswordHidden,
          validator: (value) =>
              value == null || value.isEmpty ? "Password is required" : null,
          decoration: _inputDecoration("Password").copyWith(
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordHidden = !_isPasswordHidden;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _doctorButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleDoctorLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text("Login as Doctor"),
      ),
    );
  }

  /// User Fields
  Widget _userFields() {
    return Column(
      children: [
        TextFormField(
          controller: _mobileController,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Mobile number is required";
            }
            if (!RegExp(r'^\d{10}$').hasMatch(value)) {
              return "Enter valid 10-digit number";
            }
            return null;
          },
          decoration: _inputDecoration(
            "Mobile Number",
          ).copyWith(counterText: ""),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handleUserLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text("Sign In"),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          "- OR -",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppImages.googleIcon, height: 22),
                const SizedBox(width: 12),
                Text(
                  "Continue with Google",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
