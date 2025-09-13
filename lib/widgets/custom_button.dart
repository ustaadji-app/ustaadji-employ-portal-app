import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ButtonVariant { primary, outline }

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.borderRadius = 8.0,
    this.padding,
    this.isLoading = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color primaryBg =
        isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final Color outlineBorder =
        isDark ? AppColors.darkText : AppColors.lightText;
    final Color textColorPrimary = AppColors.lightSurface;

    final EdgeInsetsGeometry buttonPadding =
        widget.padding ??
        EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w);

    ButtonStyle style;

    if (widget.variant == ButtonVariant.primary) {
      style = ElevatedButton.styleFrom(
        backgroundColor: primaryBg,
        padding: buttonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius.r),
        ),
      );
    } else {
      style = OutlinedButton.styleFrom(
        side: BorderSide(color: outlineBorder, width: 1.5.w),
        padding: buttonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius.r),
        ),
      );
    }

    Widget childContent =
        widget.isLoading
            ? SizedBox(
              width: 20.w,
              height: 20.h,
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.variant == ButtonVariant.primary
                      ? textColorPrimary
                      : outlineBorder,
                ),
              ),
            )
            : CustomText(
              text: widget.text,
              size: CustomTextSize.md,
              fontWeight: FontWeight.w600,
              fontFamily: "Poppins",
              color:
                  widget.variant == ButtonVariant.primary
                      ? CustomTextColor.btnText
                      : CustomTextColor.text,
            );

    return widget.variant == ButtonVariant.primary
        ? ElevatedButton(
          style: style,
          onPressed: widget.isLoading ? null : widget.onPressed,
          child: childContent,
        )
        : OutlinedButton(
          style: style,
          onPressed: widget.isLoading ? null : widget.onPressed,
          child: childContent,
        );
  }
}
