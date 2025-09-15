import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/constants/app_fonts_sizes.dart';
import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/screens/auth/login_screen.dart';
import 'package:employee_portal/screens/auth/register_screen.dart';
import 'package:employee_portal/utils/custom_navigation.dart';
import 'package:employee_portal/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:employee_portal/widgets/custom_button.dart';

class AuthLandingScreen extends StatelessWidget {
  const AuthLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // --- Background Image ---
          Positioned.fill(
            child: Image.asset(
              "assets/images/hero_image.jpg",
              fit: BoxFit.cover,
            ),
          ),

          // --- Overlay Gradient ---
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.black.withValues(alpha: 0.3),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),

          // --- Main Content ---
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // --- Branding ---
                  Padding(
                    padding: EdgeInsets.only(top: 24.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Ustaad Ji",
                        style: TextStyle(
                          fontSize: AppFonts.xxxl,
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightBackground,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.6),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // --- Title + Subtitle ---
                  Column(
                    children: [
                      Text(
                        "Work Smart. Earn Better.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.black.withValues(alpha: 0.4),
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "Over 1,500 service providers trust Ustaadji.\nBe one of them — register now and start earning.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white70,
                          height: 1.6,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),

                  // --- Buttons ---
                  Padding(
                    padding: EdgeInsets.only(bottom: 40.h),
                    child: Column(
                      children: [
                        // --- Primary Button ---
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: "Register",
                            onPressed: () {
                              CustomNavigation.push(context, RegisterScreen());
                            },
                          ),
                        ),

                        AppSpacing.vmd,

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              side: BorderSide(
                                color: AppColors.lightBackground,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              foregroundColor: Colors.white,
                              overlayColor: WidgetStateColor.resolveWith((
                                states,
                              ) {
                                if (states.contains(WidgetState.pressed)) {
                                  return Colors.white24;
                                }
                                return Colors.transparent;
                              }),
                            ),
                            onPressed: () {
                              CustomNavigation.push(context, LoginScreen());
                            },
                            child: CustomText(
                              text: "Login",
                              color: CustomTextColor.alwaysWhite,
                              size: CustomTextSize.md,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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
