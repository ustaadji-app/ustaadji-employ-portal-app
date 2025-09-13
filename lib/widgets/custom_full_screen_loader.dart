import 'dart:ui';
import 'package:employee_portal/constants/app_colors.dart';
import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark
            ? AppColors.darkBackground.withValues(alpha: 0.5)
            : AppColors.lightBackground.withValues(alpha: 0.5);

    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.4, sigmaY: 2.4),
          child: Container(color: backgroundColor),
        ),
        // Prevent user interaction
        ModalBarrier(dismissible: false, color: Colors.transparent),
        Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
