import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/layout/auth_layout.dart';
import 'package:employee_portal/widgets/custom_button.dart';
import 'package:employee_portal/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final inputBgColor = isDark ? Colors.grey[800] : Colors.grey[200];

    return AuthLayout(
      title: "Verify OTP",
      isBackAction: true,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- Title ---
            CustomText(
              text: "OTP Verification",
              size: CustomTextSize.xl,
              color: CustomTextColor.text,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
            ),
            AppSpacing.vxs,
            CustomText(
              text: "Enter the 4-digit code sent to your phone.",
              size: CustomTextSize.sm,
              color: CustomTextColor.textSecondary,
            ),
            AppSpacing.vlg,

            // --- OTP Input Fields ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 60.w,
                  child: TextFormField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: inputBgColor,
                      contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) => _onOtpChanged(val, index),
                  ),
                );
              }),
            ),

            AppSpacing.vlg,

            // --- Resend Prompt ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: "Didn't receive the code?",
                  size: CustomTextSize.sm,
                  color: CustomTextColor.textSecondary,
                ),
                AppSpacing.hxs,
                GestureDetector(
                  onTap: () {
                    // TODO: Handle resend logic
                  },
                  child: CustomText(
                    text: "Resend",
                    size: CustomTextSize.sm,
                    color: CustomTextColor.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            AppSpacing.vxl,
            // --- Submit Button ---
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: "Verify & Continue",
                onPressed: () {
                  // TODO: Verify logic
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
