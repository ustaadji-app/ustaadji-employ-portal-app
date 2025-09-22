import 'package:employee_portal/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_spacing.dart';
import '../widgets/custom_text.dart';

class CustomSidebar extends StatefulWidget {
  final Widget child;
  const CustomSidebar({super.key, required this.child});

  @override
  CustomSidebarState createState() => CustomSidebarState();
}

class CustomSidebarState extends State<CustomSidebar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _isSidebarOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
      if (_isSidebarOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sidebarWidth = MediaQuery.of(context).size.width * 0.7;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return Stack(
      children: [
        widget.child,
        if (_isSidebarOpen)
          GestureDetector(
            onTap: toggleSidebar,
            child: Container(color: Colors.black54),
          ),
        SlideTransition(
          position: _slideAnimation,
          child: SafeArea(
            child: Material(
              elevation: 8,
              child: Container(
                width: sidebarWidth,
                color: backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Section
                    Container(
                      width: double.infinity,
                      color:
                          isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md.w,
                        vertical: AppSpacing.lg.h,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28.r,
                            backgroundColor: textColor.withValues(alpha: 0.09),
                            child: Icon(
                              Icons.person,
                              size: 32.sp,
                              color: Colors.white,
                            ),
                          ),
                          AppSpacing.hmd,
                          Expanded(
                            child: CustomText(
                              text: "Ustaad Ji",
                              size: CustomTextSize.xl,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              color: CustomTextColor.alwaysWhite,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.vmd,
                    // Menu Section
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildMenuItem(
                              icon: Icons.dashboard,
                              label: "Dashboard",
                              color: textColor,
                              onTap: toggleSidebar,
                            ),
                            _buildMenuItem(
                              icon: Icons.work,
                              label: "My Projects",
                              color: textColor,
                              onTap: toggleSidebar,
                            ),
                            _buildMenuItem(
                              icon: Icons.chat,
                              label: "Messages",
                              color: textColor,
                              onTap: toggleSidebar,
                            ),
                            _buildMenuItem(
                              icon: Icons.notifications,
                              label: "Notifications",
                              color: textColor,
                              onTap: toggleSidebar,
                            ),
                            _buildMenuItem(
                              icon: Icons.people,
                              label: "Team",
                              color: textColor,
                              onTap: toggleSidebar,
                            ),
                            _buildMenuItem(
                              icon: Icons.analytics,
                              label: "Reports",
                              color: textColor,
                              onTap: toggleSidebar,
                            ),
                            _buildMenuItem(
                              icon: Icons.settings,
                              label: "Settings",
                              color: textColor,
                              onTap: toggleSidebar,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Logout Fixed Bottom
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md.w,
                        vertical: AppSpacing.md.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.redAccent.withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 0.6,
                          ),
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.r),
                        onTap: toggleSidebar,
                        child: Row(
                          children: [
                            // Circle background for icon
                            Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.logout,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            AppSpacing.hmd,
                            Expanded(
                              child: CustomText(
                                text: "Logout",
                                size: CustomTextSize.base,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                color: CustomTextColor.error,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.error,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.sm.h,
            horizontal: AppSpacing.sm.w,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color:
                isDark
                    ? AppColors.darkTextSecondary.withValues(alpha: 0.07)
                    : AppColors.lightTextSecondary.withValues(alpha: 0.07),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22.sp),
              AppSpacing.hsm,
              Expanded(
                child: CustomText(
                  text: label,
                  size: CustomTextSize.base,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  color: CustomTextColor.text,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
