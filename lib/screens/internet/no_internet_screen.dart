import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/widgets/custom_button.dart';
import 'package:employee_portal/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off,
                  color:
                      isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                  size: 80.sp,
                ),
                AppSpacing.vmd,
                CustomText(
                  text: 'No Internet Connection',
                  color: CustomTextColor.text,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                  size: CustomTextSize.lg,
                  textAlign: TextAlign.center,
                ),
                AppSpacing.vsm,
                CustomText(
                  text: 'Please check your internet settings and try again.',
                  color: CustomTextColor.textSecondary,
                  textAlign: TextAlign.center,
                  size: CustomTextSize.base,
                ),
                AppSpacing.vlg,
                CustomButton(text: "Try Again", onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
