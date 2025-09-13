import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final activeColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final inactiveColor = isDark ? AppColors.darkTextSecondary : Colors.grey;

    final items = [
      {'icon': Icons.home, 'label': 'Home', 'route': '/home'},
      {'icon': Icons.message, 'label': 'Messages', 'route': '/chats'},
      {'icon': Icons.info_outline, 'label': 'Status', 'route': '/status'},
      {
        'icon': Icons.report_problem,
        'label': 'Complaints',
        'route': '/complaints',
      },
      {'icon': Icons.person, 'label': 'Profile', 'route': '/profile'},
    ];

    final navHeight = (MediaQuery.of(context).size.height * 0.08).clamp(
      60.h,
      100.h,
    );

    return Container(
      height: navHeight,
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black54 : Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final color = currentIndex == index ? activeColor : inactiveColor;
          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  items[index]['icon'] as IconData,
                  color: color,
                  size: 24.sp,
                ),
                AppSpacing.vxs,
                Text(
                  items[index]['label'] as String,
                  style: TextStyle(
                    color: color,
                    fontSize: 12.sp,
                    fontFamily: "Poppins",
                    fontWeight:
                        currentIndex == index
                            ? FontWeight.w600
                            : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
