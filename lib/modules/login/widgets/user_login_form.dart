import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/image_constants.dart';
import '../../../core/extensions/size_extension.dart';
import '../../../core/theme/app_colors.dart';

import '../../../core/utils/device_controller/device_controller.dart';
import '../controllers/login_controller.dart';
import 'login_title.dart';

class UserLoginForm extends GetView<LoginController> {
  const UserLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: controller.userFormKey,
        child: Column(
          children: [
            SizedBox(height: 15.h),

            const LoginTitle(),

            SizedBox(height: 15.h),

            TextFormField(
              controller: controller.mobileController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: const InputDecoration(
                hintText: "Mobile Number",
                counterText: "",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Mobile number is required";
                }

                if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                  return "Enter valid 10-digit number";
                }

                return null;
              },
            ),

            SizedBox(height: 15.h),

            Obx(() {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          if (controller.userFormKey.currentState!.validate()) {
                            final deviceController =
                                Get.find<DeviceController>();

                            controller.userLogin(
                              mobileNumber: controller.mobileController.text
                                  .trim(),
                              deviceId: deviceController.deviceId.value,
                            );
                          }
                        },
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Login"),
                ),
              );
            }),

            SizedBox(height: 18.h),

            Text(
              "- OR -",
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),

            SizedBox(height: 18.h),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppAssetImage.googleIcon, height: 22.h),
                    SizedBox(width: 12.w),
                    Text(
                      "Continue with Google",
                      style: TextStyle(
                        fontSize: 16.sp,
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
    );
  }
}
