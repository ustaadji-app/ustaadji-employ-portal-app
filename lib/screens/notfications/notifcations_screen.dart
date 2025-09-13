import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/layout/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/custom_text.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, String>> notifications = [
    {
      "title": "Electrical Service",
      "message":
          "Organize your research with Notes, plan your project with Outline, and structure your ideas with ease. Essay incorporates unique tools that allow you to connect your notes and research to your outline, making it easy to generate ideas and get a rough draft completed.",
      "time": "2 min ago",
      "icon": "electrical_services",
    },
    {
      "title": "AC Repair",
      "message": "Your AC repair service has been scheduled.",
      "time": "30 min ago",
      "icon": "ac_unit",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return MainLayout(
      title: 'Notifications',
      currentIndex: 2,
      isBackAction: true,
      showBottomNav: false,
      body: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md.h),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(AppSpacing.md.r),
              border: Border.all(
                color:
                    isDark
                        ? AppColors.darkTextSecondary.withValues(alpha: 0.3)
                        : Colors.grey.shade300,
              ),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 6.r,
                    offset: const Offset(0, 3),
                  ),
              ],
            ),
            padding: EdgeInsets.all(AppSpacing.md.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor:
                      isDark
                          ? AppColors.darkPrimary.withValues(alpha: 0.15)
                          : AppColors.lightPrimary.withValues(alpha: 0.15),
                  radius: 24.r,
                  child: Icon(
                    Icons.notifications,
                    color:
                        isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: AppSpacing.md.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              text: notif["title"] ?? "",
                              size: CustomTextSize.md,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              color: CustomTextColor.text,
                            ),
                          ),
                          CustomText(
                            text: notif["time"] ?? "",
                            size: CustomTextSize.sm,
                            color: CustomTextColor.textSecondary,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Nunito",
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.xs.h),
                      CustomText(
                        text: notif["message"] ?? "",
                        size: CustomTextSize.base,
                        fontWeight: FontWeight.normal,
                        fontFamily: "Roboto",
                        color: CustomTextColor.textSecondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
