import 'package:employee_portal/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/widgets/custom_text.dart';
import 'package:employee_portal/layout/auth_layout.dart';

class PendingVerificationScreen extends StatelessWidget {
  const PendingVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final secondary =
        isDark ? AppColors.darkSecondary : AppColors.lightSecondary;

    return AuthLayout(
      title: "Pending Verification",
      isBackAction: false,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ✅ Circular Illustration/Icon
                    Container(
                      height: 140.h,
                      width: 140.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primary.withValues(alpha: 0.1),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.hourglass_top,
                          color: primary,
                          size: 70.sp,
                        ),
                      ),
                    ),
                    AppSpacing.vxl,

                    // 🎉 Thank you text
                    CustomText(
                      text:
                          "Thank you! Your registration has been completed successfully.",
                      size: CustomTextSize.xl,
                      fontWeight: FontWeight.w700,
                      color: CustomTextColor.text,
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.vmd,

                    // Info Text
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: CustomText(
                        text:
                            "Our admin team is reviewing your information. Please wait — you will be contacted within 24 hours. Your account will be activated only after verification.",
                        size: CustomTextSize.md,
                        fontWeight: FontWeight.w500,
                        color: CustomTextColor.textSecondary,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    AppSpacing.vlg,

                    // Lock / Secure verification Card
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40.w),
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        color: secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock, color: secondary, size: 24.sp),
                          AppSpacing.hsm,
                          CustomText(
                            text: "Secure Verification",
                            size: CustomTextSize.md,
                            fontWeight: FontWeight.w600,
                            color: CustomTextColor.secondary,
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.vxl,

                    // Buttons stacked vertically
                    CustomButton(text: "Contact Support", onPressed: () {}),

                    AppSpacing.vxxl,
                  ],
                ),
              ),
            ),
          ),

          // Footer
          Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: CustomText(
              text: "© 2025 Ustaad Ji. All rights reserved.",
              size: CustomTextSize.sm,
              fontWeight: FontWeight.w400,
              color: CustomTextColor.textSecondary,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
