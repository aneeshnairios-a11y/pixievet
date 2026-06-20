import 'package:flutter/material.dart';

import '../../../core/extensions/size_extension.dart';
import '../../../core/theme/app_colors.dart';

class LoginTitle extends StatelessWidget {
  const LoginTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Sign In",
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          "Access to your account",
          style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
