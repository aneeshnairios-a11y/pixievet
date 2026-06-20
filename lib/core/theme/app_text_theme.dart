import 'package:flutter/material.dart';
import '../extensions/size_extension.dart';
import 'app_colors.dart';

class AppTextTheme {
  static TextTheme textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 28.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),

    headlineMedium: TextStyle(
      fontSize: 22.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),

    bodyLarge: TextStyle(fontSize: 16.sp, color: AppColors.textPrimary),

    bodyMedium: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),

    bodySmall: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
  );
}
