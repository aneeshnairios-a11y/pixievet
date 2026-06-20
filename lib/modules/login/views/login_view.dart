// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/image_constants.dart';
import '../../../core/extensions/size_extension.dart';
import '../../../core/theme/app_colors.dart';

import '../controllers/login_controller.dart';
import '../widgets/doctor_login_form.dart';
import '../widgets/user_login_form.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          /// Background Image
          SizedBox(
            width: size.width,
            height: size.height,
            child: Image.asset(AppAssetImage.appBackground, fit: BoxFit.cover),
          ),

          /// Bottom Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.60,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
              ),
              child: Column(
                children: [
                  /// Tabs
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F5F9),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: TabBar(
                      controller: controller.tabController,
                      indicator: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8.r,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey.shade600,
                      labelStyle: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      tabs: const [
                        Tab(text: "Doctor"),
                        Tab(text: "User"),
                      ],
                    ),
                  ),

                  /// Tab Views
                  Expanded(
                    child: TabBarView(
                      controller: controller.tabController,
                      children: const [DoctorLoginForm(), UserLoginForm()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
