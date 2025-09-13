import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomPopup {
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget body,
    bool dismissible = true,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return showDialog<T>(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) {
        return Dialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(padding: EdgeInsets.all(AppSpacing.md.w), child: body),
        );
      },
    );
  }
}
