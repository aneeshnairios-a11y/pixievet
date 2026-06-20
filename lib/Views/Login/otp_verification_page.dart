// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixievet_app/APIManager/SessionManager/session_manager.dart';
import 'package:pixievet_app/APIManager/VerifyOtp/verifyotp_request_model.dart';
import 'package:pixievet_app/APIManager/VerifyOtp/verifyotp_service.dart';
import 'package:pixievet_app/Views/DoctorDashboard/DoctorProfile/create_doctor_profile_page.dart';
import 'package:pixievet_app/Utilities/app_alert.dart';
import 'package:pixievet_app/Utilities/app_colors.dart';
import 'package:pixievet_app/Utilities/app_images.dart';
import 'package:pixievet_app/Utilities/app_loader.dart';
import 'package:pixievet_app/Utilities/device_utils.dart';
import 'package:pixievet_app/app_init_page.dart';

import '../PetDashboard/PetProfile/owner_profile_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String mobileNumber;
  final String otp;

  const OtpVerificationPage({
    super.key,
    required this.mobileNumber,
    required this.otp,
  });

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

  @override
  void initState() {
    super.initState();

    // 🔹 Auto-fill OTP digits
    if (widget.otp.length == 6) {
      for (int i = 0; i < 6; i++) {
        _controllers[i].text = widget.otp[i];
      }

      // Move focus to last field
      Future.delayed(const Duration(milliseconds: 100), () {
        _focusNodes[5].requestFocus();
      });
    }
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
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) =>
              //         CreatePetPetProfilePage(phoneNumber: widget.mobileNumber),
              //   ),
              // );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      OwnerProfilePage(phoneNumber: widget.mobileNumber),
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
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Background Image
          SizedBox(
            width: size.width,
            height: size.height,
            child: Image.asset(AppImages.appBackground, fit: BoxFit.cover),
          ),

          // 🔹 Bottom Sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: size.height * 0.55,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    // 🔹 Title
                    Text(
                      "Verification",
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 🔹 Subtitle
                    Column(
                      children: [
                        Text(
                          "Enter the verification code we sent to your",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "+91 ${_maskMobile(widget.mobileNumber)}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

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
                              color: AppColors.primary, // 👈 text color
                            ),
                            decoration: InputDecoration(
                              counterText: "",
                              filled: true,
                              fillColor: AppColors.primary.withOpacity(
                                0.07,
                              ), // 👈 light primary bg
                              // 🔹 Normal border
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: 1,
                                ),
                              ),

                              // 🔹 Focused border
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
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

                    const SizedBox(height: 36),

                    // 🔹 Verify OTP Button
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

                    const SizedBox(height: 20),

                    // 🔹 Didn't receive code
                    Text(
                      "Didn’t you receive any code?",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // 🔹 Resend OTP
                    TextButton(
                      onPressed: () {
                        // TODO: Call resend OTP API
                      },
                      child: Text(
                        "Resend OTP",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _maskMobile(String mobile) {
    if (mobile.length < 2) return mobile;
    return "XXXXXXXX${mobile.substring(mobile.length - 2)}";
  }
}
