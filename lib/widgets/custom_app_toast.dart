import 'package:employee_portal/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

enum ToastVariant { success, error, custom }

class AppToast {
  static void show(
    BuildContext context, {
    required String message,
    ToastVariant variant = ToastVariant.success,
    IconData? customIcon,
    Color? customColor,
  }) {
    Color backgroundColor;
    IconData? icon;

    switch (variant) {
      case ToastVariant.success:
        backgroundColor = Colors.green.shade600;
        icon = Icons.check_circle;
        break;
      case ToastVariant.error:
        backgroundColor = Colors.red.shade600;
        icon = Icons.error;
        break;
      case ToastVariant.custom:
        backgroundColor = customColor ?? Colors.blue;
        icon = customIcon;
        break;
    }

    Toastification().showCustom(
      context: context,
      autoCloseDuration: const Duration(seconds: 4),
      alignment: Alignment.topRight,
      builder: (BuildContext context, ToastificationItem holder) {
        return SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: AppSpacing.md.w,
                vertical: AppSpacing.md.h,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md.w,
                vertical: AppSpacing.sm.h,
              ),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) Icon(icon, color: Colors.white, size: 22),
                  if (icon != null) const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
