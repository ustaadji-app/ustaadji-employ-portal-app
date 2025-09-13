import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/themes/theme_provider.dart';
import 'package:employee_portal/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackAction;
  final bool isAvatarShow;
  final bool isSidebarEnabled;
  final VoidCallback? onMenuPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.isBackAction = false,
    this.isAvatarShow = true,
    this.isSidebarEnabled = false,
    this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // final user = Provider.of<UserProvider>(context).user;
    // final name = user['name'] ?? "";
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final themeIcon = isDarkMode ? Icons.dark_mode : Icons.light_mode;

    final Map<String, dynamic> user = {
      'name': 'Zara Khan',
      'email': 'zara.khan@example.com',
      'avatarUrl': '',
    };
    final String firstLetter =
        user['name'] != null && user['name'].toString().isNotEmpty
            ? user['name'].toString().trim().split(' ')[0][0].toUpperCase()
            : '';

    return AppBar(
      automaticallyImplyLeading: false,
      leading:
          isBackAction
              ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color:
                      isDarkMode
                          ? AppColors.lightSurface
                          : AppColors.darkSurface,
                ),
                onPressed: () => Navigator.pop(context),
              )
              : isSidebarEnabled
              ? IconButton(
                icon: Icon(
                  Icons.menu,
                  color:
                      isDarkMode
                          ? AppColors.lightSurface
                          : AppColors.darkSurface,
                ),
                onPressed: onMenuPressed,
              )
              : null,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isAvatarShow)
            (user['avatarUrl'] != null &&
                    user['avatarUrl'].toString().isNotEmpty
                ? Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user['avatarUrl'].toString()),
                    radius: 16.r,
                  ),
                )
                : Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: CircleAvatar(
                    radius: 16.r,
                    backgroundColor: AppColors.lightPrimary,
                    child: CustomText(
                      text: firstLetter,
                      size: CustomTextSize.lg,
                      fontWeight: FontWeight.bold,
                      color: CustomTextColor.alwaysWhite,
                    ),
                  ),
                )),

          CustomText(
            text: title,
            size: CustomTextSize.lg,
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins",
            color: CustomTextColor.text,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        if (user.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: InkWell(
              borderRadius: BorderRadius.circular(20.r),
              onTap: () {
                themeProvider.toggleTheme(!isDarkMode);
              },
              child: Container(
                width: 34.w,
                height: 34.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        isDarkMode
                            ? AppColors.lightSurface
                            : AppColors.darkSurface,
                    width: 1.w,
                  ),
                ),
                child: Icon(
                  themeIcon,
                  color:
                      isDarkMode
                          ? AppColors.lightSurface
                          : AppColors.darkSurface,
                  size: 18.sp,
                ),
              ),
            ),
          )
        else ...[
          Row(
            children: [
              if (isAvatarShow)
                IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color:
                        isDarkMode
                            ? AppColors.lightSurface
                            : AppColors.darkSurface,
                    size: 20.sp,
                  ),
                  onPressed: () {
                    // CustomNavigation.push(context,  NotificationsScreen());
                  },
                ),

              // Theme Toggle
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20.r),
                  onTap: () {
                    themeProvider.toggleTheme(!isDarkMode);
                  },
                  child: Container(
                    width: 30.w,
                    height: 30.h,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            isDarkMode
                                ? AppColors.lightSurface
                                : AppColors.darkSurface,

                        width: 1.w,
                      ),
                    ),
                    child: Icon(
                      themeIcon,
                      color:
                          isDarkMode
                              ? AppColors.lightSurface
                              : AppColors.darkSurface,
                      size: 18.sp,
                    ),
                  ),
                ),
              ),

              // Avatar
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child:
                    (user['avatarUrl'] != null &&
                            user['avatarUrl'].toString().isNotEmpty)
                        ? CircleAvatar(
                          backgroundImage: NetworkImage(
                            user['avatarUrl'].toString(),
                          ),
                          radius: 16.r,
                        )
                        : CircleAvatar(
                          radius: 16.r,
                          backgroundColor: AppColors.lightPrimary,
                          child: CustomText(
                            text: firstLetter,
                            size: CustomTextSize.lg,
                            fontWeight: FontWeight.bold,
                            color: CustomTextColor.alwaysWhite,
                          ),
                        ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);
}
