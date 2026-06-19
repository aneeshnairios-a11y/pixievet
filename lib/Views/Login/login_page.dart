// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixievet/APIManager/Login/login_request_model.dart';
import 'package:pixievet/APIManager/Login/login_service.dart';
import 'package:pixievet/APIManager/SessionManager/session_manager.dart';
import 'package:pixievet/Views/Login/otp_verification_page.dart';
import 'package:pixievet/Utilities/app_alert.dart';
import 'package:pixievet/Utilities/app_colors.dart';
import 'package:pixievet/Utilities/app_images.dart';
import 'package:pixievet/Utilities/app_loader.dart';
import 'package:pixievet/Utilities/device_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();

  Future<void> _onSignInPressed() async {
    // 🔽 Hide keyboard if open
    FocusScope.of(context).unfocus();

    // ❌ Empty mobile check (before loader)
    if (_mobileController.text.trim().isEmpty) {
      AppAlert.show(
        context: context,
        type: AlertType.warning,
        title: "Mobile Number Required",
        message: "Please enter your mobile number to continue.",
      );
      return;
    }

    // ❌ Form validation
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 🔄 Show loader only when API starts
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
        await SessionManager().saveIsDoctor(response.isDoctor);

        // ✅ SUCCESS
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpVerificationPage(
              mobileNumber: _mobileController.text.trim(),
            ),
          ),
        );
      } else {
        // ❌ API failure
        AppAlert.show(
          context: context,
          type: AlertType.warning,
          title: "Login Failed",
          message: response.message,
        );
      }
    } catch (e) {
      // ❌ Network / unexpected error
      AppAlert.show(
        context: context,
        type: AlertType.warning,
        title: "Something went wrong",
        message: e.toString(),
      );
    } finally {
      // ✅ ALWAYS hide loader
      AppLoader().hide();
    }
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 🔹 Logo
                            Image.asset(AppImages.appLogo, height: 120),

                            const SizedBox(height: 32),

                            // 🔹 Sign In
                            Text(
                              "Sign In",
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // 🔹 Subtitle
                            Text(
                              "Access to your account",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),

                            const SizedBox(height: 32),

                            // 🔹 Mobile Number Label
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Mobile Number",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            // 🔹 Mobile Number Field with validation
                            TextFormField(
                              controller: _mobileController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: AppColors.textPrimary,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Mobile number is required";
                                }
                                if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                  return "Enter a valid 10-digit mobile number";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: "Enter your mobile number",
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: AppColors.textHint,
                                ),
                                prefixIcon: const Icon(
                                  Icons.phone,
                                  color: AppColors.primary,
                                ),
                                filled: true,
                                fillColor: AppColors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.border,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.border,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                    width: 1.5,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // 🔹 Sign In Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _onSignInPressed,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  "Sign In",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // 🔹 OR
                            Text(
                              "- OR -",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // 🔹 Google Button
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  backgroundColor: AppColors.white,
                                  side: const BorderSide(
                                    color: AppColors.border,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      AppImages.googleIcon,
                                      height: 22,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      "Google",
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
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
