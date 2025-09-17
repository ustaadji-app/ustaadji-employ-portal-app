import 'dart:convert';

import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/layout/auth_layout.dart';
import 'package:employee_portal/screens/home/home_screen.dart';
import 'package:employee_portal/services/api_services.dart';
import 'package:employee_portal/widgets/custom_button.dart';
import 'package:employee_portal/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:employee_portal/widgets/custom_full_screen_loader.dart';
import 'package:employee_portal/widgets/custom_app_toast.dart';
import 'package:employee_portal/provider/user_provider.dart';
import 'package:employee_portal/utils/storage_helper.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final int _otpLength = 4;
  late final List<FocusNode> _focusNodes;
  late final List<TextEditingController> _controllers;
  bool isLoading = false;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
    _controllers = List.generate(_otpLength, (_) => TextEditingController());
  }

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
    if (value.length == 1 && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String _getOtpCode() {
    return _controllers.map((e) => e.text).join();
  }

  Future<void> _handleVerify() async {
    FocusScope.of(context).unfocus();
    final otp = _getOtpCode();

    if (otp.length != _otpLength) {
      AppToast.show(
        context,
        message: "Please enter complete OTP",
        variant: ToastVariant.error,
      );
      return;
    }

    setState(() => isLoading = true);
    final cleanedPhone = widget.phoneNumber.replaceAll('+', '');
    try {
      final result = await apiService.postRequest(
        endpoint: "provider/login-otp",
        body: {"phone_number": cleanedPhone, "otp": otp},
      );

      print(jsonEncode(result));
      if (!mounted) return;
      setState(() => isLoading = false);

      if (result['success']) {
        final data = result['data'] as Map<String, dynamic>?;

        if (data != null && data['provider'] != null) {
          final userProvider = Provider.of<UserProvider>(
            context,
            listen: false,
          );

          final provider = data['provider'] as Map<String, dynamic>;
          final subscriptions = data['subscriptions'] as List<dynamic>? ?? [];
          final token = data['access_token'] as String;

          // ✅ Save token in SecureStorage
          await StorageHelper.saveToken(token);

          // ✅ Combine provider + subscription
          final userData = {
            "provider": provider,
            "subscriptions": subscriptions,
          };

          // ✅ Save user in SharedPreferences
          await StorageHelper.saveUser(userData);

          // ✅ Update Provider state
          userProvider.setUser(userData);

          AppToast.show(
            context,
            message: data['message'] ?? "You are logged in successfully",
            variant: ToastVariant.success,
          );

          await Future.delayed(const Duration(milliseconds: 500));
          if (!mounted) return;
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
        } else {
          AppToast.show(
            context,
            message: "Provider data missing in response",
            variant: ToastVariant.error,
          );
        }
      } else {
        final errorMessage =
            result['data'] != null
                ? result['data']['message'] ?? "OTP not matched"
                : "OTP not matched";
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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final inputBgColor = isDark ? Colors.grey[800] : Colors.grey[200];

    return Stack(
      children: [
        AuthLayout(
          title: "Verify OTP",
          isBackAction: true,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                text: "OTP Verification",
                size: CustomTextSize.xl,
                color: CustomTextColor.text,
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins",
              ),
              AppSpacing.vxs,
              CustomText(
                text:
                    "Enter the $_otpLength-digit code sent to ${widget.phoneNumber}",
                size: CustomTextSize.sm,
                color: CustomTextColor.textSecondary,
                textAlign: TextAlign.center,
              ),
              AppSpacing.vlg,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_otpLength, (index) {
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
              AppSpacing.vxl,
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: "Verify & Continue",
                  onPressed: _handleVerify,
                ),
              ),
            ],
          ),
        ),
        if (isLoading) const FullScreenLoader(),
      ],
    );
  }
}
