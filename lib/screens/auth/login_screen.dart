import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/layout/auth_layout.dart';
import 'package:employee_portal/screens/auth/otp_screen.dart';
import 'package:employee_portal/services/api_services.dart';
import 'package:employee_portal/utils/custom_navigation.dart';
import 'package:employee_portal/widgets/custom_app_toast.dart';
import 'package:employee_portal/widgets/custom_button.dart';
import 'package:employee_portal/widgets/custom_input_fields.dart';
import 'package:employee_portal/widgets/custom_text.dart';
import 'package:employee_portal/widgets/custom_full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();
  final TextEditingController _phoneController = TextEditingController(
    text: "3281447871",
  );
  bool isLoading = false;

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone number is required";
    }
    String cleaned = value.replaceAll(' ', '');
    if (!RegExp(r'^\d{10}$').hasMatch(cleaned)) {
      return "Enter a valid 10 digit phone number";
    }
    if (!cleaned.startsWith('3')) {
      return "Pakistani number must start with 3";
    }
    return null;
  }

  Future<void> _handleSendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    print("phone number checking+92${_phoneController.text.trim()}");

    try {
      final result = await apiService.postRequest(
        endpoint: "sendprovider-otp",
        body: {"phone_number": "+92${_phoneController.text.trim()}"},
      );

      if (!mounted) return;
      setState(() => isLoading = false);

      final data = result['data'] as Map<String, dynamic>?;

      if (data != null && data['status'] == true) {
        final message = data['message'] ?? "OTP sent successfully!";
        AppToast.show(context, message: message, variant: ToastVariant.success);

        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;
        CustomNavigation.push(
          context,
          OtpVerificationScreen(phoneNumber: data['phone_number']),
        );
      } else {
        final errorMessage =
            data != null
                ? data['message'] ?? "Failed to send OTP"
                : result['message'] ?? "Something went wrong!";
        AppToast.show(
          context,
          message: errorMessage,
          variant: ToastVariant.error,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      AppToast.show(
        context,
        message: "An error occurred: $e",
        variant: ToastVariant.error,
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Stack(
      children: [
        AuthLayout(
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
                CustomPhoneField(
                  controller: _phoneController,
                  validator: _validatePhone,
                ),
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
                    onPressed: _handleSendOtp,
                  ),
                ),
              ],
            ),
          ),
        ),

        if (isLoading) FullScreenLoader(),
      ],
    );
  }
}
