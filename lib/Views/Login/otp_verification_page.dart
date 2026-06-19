// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixievet/APIManager/SessionManager/session_manager.dart';
import 'package:pixievet/APIManager/VerifyOtp/verifyotp_request_model.dart';
import 'package:pixievet/APIManager/VerifyOtp/verifyotp_service.dart';
import 'package:pixievet/Views/DoctorDashboard/DoctorProfile/create_doctor_profile_page.dart';
import 'package:pixievet/Views/PetDashboard/PetProfile/create_pet_profile_page.dart';
import 'package:pixievet/Utilities/app_alert.dart';
import 'package:pixievet/Utilities/app_colors.dart';
import 'package:pixievet/Utilities/app_images.dart';
import 'package:pixievet/Utilities/app_loader.dart';
import 'package:pixievet/Utilities/device_utils.dart';
import 'package:pixievet/app_init_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String mobileNumber;

  const OtpVerificationPage({super.key, required this.mobileNumber});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    // 🔽 Hide keyboard if open
    FocusScope.of(context).unfocus();

    final otp = _controllers.map((e) => e.text).join();

    // ❌ Check OTP length before showing loader
    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter complete OTP")),
      );
      return;
    }

    // 🔄 Show loader while verifying OTP
    AppLoader().show(context, message: "Verifying OTP...");

    try {
      debugPrint("OTP Entered: $otp");
      debugPrint("Mobile: ${widget.mobileNumber}");

      final deviceId = await DeviceUtils.getDeviceId();
      final verifyOtpService = VerifyOtpService();

      final response = await verifyOtpService.verifyOtp(
        VerifyOtpRequestModel(
          mobileNumber: widget.mobileNumber,
          otp: otp,
          deviceId: deviceId,
        ),
      );

      if (response.status) {
        // 🔑 Save token, userId, and isDoctor for future use
        await SessionManager().saveToken(response.authToken);
        await SessionManager().saveUserId(response.userId);

        if (response.isProfileCreated) {
          // ✅ Profile already created → go to dashboard
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const AppInitPage(fromLoginFlow: true),
            ),
            (_) => false,
          );
        } else {
          // ✅ Profile not created → navigate based on isDoctor
          if (!response.isProfileCreated) {
            if (response.isDoctor) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateDoctorProfilePage(),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreatePetPetProfilePage(),
                ),
              );
            }
          }
        }
      } else {
        // ❌ OTP failed
        AppAlert.show(
          context: context,
          type: AlertType.warning,
          title: "OTP Verification Failed",
          message: "Invalid OTP. Please try again.",
        );
      }
    } catch (e) {
      // ❌ Network / unexpected error
      AppAlert.show(
        context: context,
        type: AlertType.warning,
        title: "Something went wrong",
        message: "Please try again later",
      );
    } finally {
      // ✅ Always hide loader
      AppLoader().hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 🔹 App Logo
                        Image.asset(AppImages.appLogo, height: 100),

                        const SizedBox(height: 32),

                        // 🔹 Title
                        Text(
                          "Enter the OTP",
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // 🔹 Subtitle
                        Text(
                          "We sent OTP code to your mobile number",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "+91 ${widget.mobileNumber}",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // 🔹 OTP Fields
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (index) {
                            return SizedBox(
                              width: 48,
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  counterText: "",
                                  filled: true,
                                  fillColor: AppColors.white,
                                  border: OutlineInputBorder(
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
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty && index < 5) {
                                    _focusNodes[index + 1].requestFocus();
                                  } else if (value.isEmpty && index > 0) {
                                    _focusNodes[index - 1].requestFocus();
                                  }
                                },
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 40),

                        // 🔹 Verify Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _verifyOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Verify OTP",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
