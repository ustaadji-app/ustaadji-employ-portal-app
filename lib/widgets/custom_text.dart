import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/constants/app_fonts_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum CustomTextSize { xxxl, x2l, xl, lg, md, base, sm, xs }

enum CustomTextColor {
  primary,
  secondary,
  text,
  textSecondary,
  btnText,
  error,
  alwaysWhite,
}

class CustomText extends StatelessWidget {
  final String text;
  final CustomTextSize size;
  final CustomTextColor color;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final String? fontFamily;
  final double? fontSize;
  final double? letterSpacing;
  final double? lineHeight;

  const CustomText({
    super.key,
    required this.text,
    this.size = CustomTextSize.base,
    this.color = CustomTextColor.text,
    this.fontWeight = FontWeight.normal,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.fontFamily,
    this.fontSize,
    this.letterSpacing,
    this.lineHeight,
  });

  Map<String, dynamic> _getTextStyleDefaults() {
    switch (size) {
      case CustomTextSize.xxxl:
        return {"size": AppFonts.xxxl, "spacing": 0.5.sp, "height": 1.3};
      case CustomTextSize.x2l: // Big headings
        return {"size": AppFonts.xxl, "spacing": 0.5.sp, "height": 1.3};
      case CustomTextSize.xl: // Section title
        return {"size": AppFonts.xl, "spacing": 0.4.sp, "height": 1.3};
      case CustomTextSize.lg: // Sub-heading
        return {"size": AppFonts.lg, "spacing": 0.3.sp, "height": 1.3};
      case CustomTextSize.md: // Normal body
        return {"size": AppFonts.md, "spacing": 0.2.sp, "height": 1.4};
      case CustomTextSize.base: // Default text
        return {"size": AppFonts.sm, "spacing": 0.1.sp, "height": 1.4};
      case CustomTextSize.sm: // Small text
        return {"size": AppFonts.xs, "spacing": 0.0.sp, "height": 1.4};
      case CustomTextSize.xs: // Extra small
        return {"size": 10.0.sp, "spacing": 0.0.sp, "height": 1.4};
    }
  }

  Color _getColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (color) {
      case CustomTextColor.primary:
        return isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
      case CustomTextColor.secondary:
        return isDark ? AppColors.darkSecondary : AppColors.lightSecondary;
      case CustomTextColor.text:
        return isDark ? AppColors.darkText : AppColors.lightText;
      case CustomTextColor.btnText:
        return Colors.white;
      case CustomTextColor.textSecondary:
        return isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary;
      case CustomTextColor.error:
        return AppColors.error;
      case CustomTextColor.alwaysWhite:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaults = _getTextStyleDefaults();

    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize ?? defaults["size"],
        letterSpacing: letterSpacing ?? defaults["spacing"],
        height: lineHeight ?? defaults["height"],
        color: _getColor(context),
        fontWeight: fontWeight,
        fontFamily: fontFamily ?? 'Roboto',
      ),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
