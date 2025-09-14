import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/constants/app_fonts_sizes.dart';
import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/layout/main_layout.dart';
import 'package:employee_portal/screens/messages/chat_screen.dart';
import 'package:employee_portal/utils/custom_navigation.dart';
import 'package:employee_portal/widgets/custom_button.dart';
import 'package:employee_portal/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final date = DateFormat("EEEE, dd MMMM yyyy").format(DateTime.now());

    return MainLayout(
      title: "Home",
      currentIndex: 0,
      isAvatarShow: true,
      isSidebarEnabled: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm.w,
              vertical: AppSpacing.md.h,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28.r,
                      backgroundImage: AssetImage(
                        "assets/images/hero_image.jpg",
                      ),
                    ),
                    AppSpacing.hmd,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Welcome back, Zain!",
                          size: CustomTextSize.lg,
                          fontWeight: FontWeight.bold,
                          color: CustomTextColor.text,
                        ),
                        CustomText(
                          text: date,
                          size: CustomTextSize.sm,
                          color: CustomTextColor.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
                AppSpacing.vmd,

                // Job Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat("Total Jobs", "30", textColor),
                    _buildStat("Completed", "19", textColor),
                    _buildStat("Pending", "3", textColor),
                    _buildStat("Cancelled", "2", textColor),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.vmd,
          CustomText(
            text: "Recent Jobs",
            size: CustomTextSize.lg,
            fontWeight: FontWeight.w600,
            color: CustomTextColor.text,
          ),

          AppSpacing.vmd,
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return _buildJobCard(context, textColor, isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color textColor) {
    return Column(
      children: [
        CustomText(
          text: value,
          size: CustomTextSize.lg,
          fontWeight: FontWeight.bold,
          color: CustomTextColor.text,
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: label,
          size: CustomTextSize.sm,
          color: CustomTextColor.textSecondary,
        ),
      ],
    );
  }

  Widget _buildJobCard(BuildContext context, Color textColor, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Title & Status ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.work_outline_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 18.sp,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    CustomText(
                      text: "Plumber work",
                      color: CustomTextColor.text,
                      fontWeight: FontWeight.w600,
                      size: CustomTextSize.md,
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    "Active",
                    style: TextStyle(
                      fontSize: AppFonts.xs,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),

            AppSpacing.vsm,

            Row(
              children: [
                Icon(Icons.location_on, size: 18.sp, color: Colors.redAccent),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    "Flat 2A, Horizon Tower, DHA Phase 5, Karachi",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: textColor.withValues(alpha: 0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.payments_outlined,
                      size: 18.sp,
                      color: Colors.orange,
                    ),
                    SizedBox(width: 6.w),
                    CustomText(
                      text: "PKR 1500",
                      color: CustomTextColor.textSecondary,
                      size: CustomTextSize.base,
                    ),
                  ],
                ),
                Text(
                  "25 September 2025",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontStyle: FontStyle.italic,
                    color: textColor.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),

            AppSpacing.vlg,

            // --- Action Buttons ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  text: "Message",
                  variant: ButtonVariant.outline,
                  onPressed: () {
                    CustomNavigation.push(context, ChatScreen());
                  },
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                ),
                CustomButton(
                  text: "View Details",
                  onPressed: () {
                    CustomNavigation.push(context, ChatScreen());
                  },
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
