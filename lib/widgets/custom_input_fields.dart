import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.label,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.validator, // ✅
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return TextFormField(
      controller: controller,
      style: TextStyle(color: textColor),
      keyboardType: keyboardType,
      cursorColor: primary,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon) : null,
        prefixIconColor: WidgetStateColor.resolveWith(
          (states) =>
              states.contains(MaterialState.focused) ? primary : textSecondary,
        ),
        labelText: label,
        labelStyle: TextStyle(color: textSecondary, fontSize: 14.sp),
        filled: true,
        fillColor: surface,
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        floatingLabelStyle: TextStyle(
          color: primary,
          fontWeight: FontWeight.w600,
        ),
        errorStyle: TextStyle(
          color: AppColors.error,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Custom Phone Field with 🇵🇰 +92 prefix and validator
class CustomPhoneField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator; // ✅

  const CustomPhoneField({super.key, this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return TextFormField(
      controller: controller,
      style: TextStyle(color: textColor),
      keyboardType: TextInputType.phone,
      cursorColor: primary,
      validator: validator, // ✅
      decoration: InputDecoration(
        prefixIcon: SizedBox(
          width: 80.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("🇵🇰", style: TextStyle(fontSize: 18.sp)),
              SizedBox(width: 6.w),
              Text(
                "+92",
                style: TextStyle(
                  color: textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
        labelText: "Phone Number",
        labelStyle: TextStyle(color: textSecondary, fontSize: 14.sp),
        filled: true,
        fillColor: surface,
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        floatingLabelStyle: TextStyle(
          color: primary,
          fontWeight: FontWeight.w600,
        ),
        errorStyle: TextStyle(
          color: AppColors.error,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
