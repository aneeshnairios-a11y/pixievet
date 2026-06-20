// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixievet_app/Utilities/app_colors.dart';

enum AlertType { warning, success, failure }

class AppAlert {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    AlertType type = AlertType.warning,
    String buttonText = "OK",
  }) {
    final alertConfig = _getAlertConfig(type);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Icon Container
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: alertConfig.bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    alertConfig.icon,
                    color: alertConfig.iconColor,
                    size: 32,
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 12),

                // 🔹 Message
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 24),

                // 🔹 Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: alertConfig.buttonColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🔹 Helper method for alert configuration
  static _AlertConfig _getAlertConfig(AlertType type) {
    switch (type) {
      case AlertType.success:
        return _AlertConfig(
          icon: Icons.check_circle_rounded,
          iconColor: AppColors.success,
          bgColor: AppColors.success.withOpacity(0.1),
          buttonColor: AppColors.success,
        );

      case AlertType.failure:
        return _AlertConfig(
          icon: Icons.error_rounded,
          iconColor: AppColors.error,
          bgColor: AppColors.error.withOpacity(0.1),
          buttonColor: AppColors.error,
        );

      case AlertType.warning:
        return _AlertConfig(
          icon: Icons.warning_amber_rounded,
          iconColor: AppColors.primary,
          bgColor: AppColors.primary.withOpacity(0.1),
          buttonColor: AppColors.primary,
        );
    }
  }
}

// 🔹 Internal config model
class _AlertConfig {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final Color buttonColor;

  _AlertConfig({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.buttonColor,
  });
}
