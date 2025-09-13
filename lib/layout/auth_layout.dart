import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthLayout extends StatelessWidget {
  final Widget body;
  final String title;
  final bool isBackAction;

  const AuthLayout({
    super.key,
    required this.body,
    required this.title,
    this.isBackAction = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title, isBackAction: isBackAction),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md.w,
            vertical: AppSpacing.md.h,
          ),
          child: body,
        ),
      ),
    );
  }
}
