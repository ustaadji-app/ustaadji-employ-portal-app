import 'package:employee_portal/constants/app_colors.dart';
import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark
            ? AppColors.darkBackground.withValues(alpha: 0.5)
            : AppColors.lightBackground.withValues(alpha: 0.5);

    return Stack(
      children: [
        Container(color: backgroundColor),
        const ModalBarrier(dismissible: false, color: Colors.transparent),

        // Loader center me
        Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
