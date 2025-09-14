import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/layout/auth_layout.dart';
import 'package:employee_portal/screens/auth/otp_screen.dart';
import 'package:employee_portal/utils/custom_navigation.dart';
import 'package:employee_portal/widgets/custom_button.dart';
import 'package:employee_portal/widgets/custom_input_fields.dart';
import 'package:employee_portal/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return AuthLayout(
      title: "Login",
      isBackAction: true,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Heading ---
            CustomText(
              text: "Welcome Back 👋",
              size: CustomTextSize.xl,
              color: CustomTextColor.text,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
            ),
            AppSpacing.vxs,
            CustomText(
              text: "Login to continue and explore your employee portal.",
              size: CustomTextSize.sm,
              color: CustomTextColor.textSecondary,
              fontWeight: FontWeight.normal,
            ),
            AppSpacing.vlg,
            // --- Phone Field ---
            CustomPhoneField(),
            AppSpacing.vxs,
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16.sp,
                  color: textColor.withValues(alpha: 0.5),
                ),
                AppSpacing.hxs,
                CustomText(
                  text: "We’ll send you a verification code",
                  color: CustomTextColor.textSecondary,
                  size: CustomTextSize.sm,
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),

            AppSpacing.vlg,

            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: "Send OTP",
                onPressed: () {
                  CustomNavigation.push(context, OtpVerificationScreen());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
