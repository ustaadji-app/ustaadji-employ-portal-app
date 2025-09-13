import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor =
        isDarkMode ? AppColors.darkSurface : AppColors.lightSurface;
    final textColor = isDarkMode ? AppColors.darkText : AppColors.lightText;
    final primaryColor =
        isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary;

    // Responsive width: 70% of screen width
    final sidebarWidth = MediaQuery.of(context).size.width * 0.7;

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
                    Container(
                      width: double.infinity,
                      color: primaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md.w,
                        vertical: AppSpacing.lg.h,
                      ),
                      child: CustomText(
                        text: "Ustaad Ji",
                        size: CustomTextSize.x2l,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                        color: CustomTextColor.alwaysWhite,
                      ),
                    ),
                    AppSpacing.vlg,
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.md.w,
                              ),
                              child: CustomText(
                                text: "Account",
                                size: CustomTextSize.lg,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                color: CustomTextColor.text,
                              ),
                            ),
                            AppSpacing.vmd,
                            _buildMenuItem(
                              icon: Icons.shopping_bag,
                              label: "Orders",
                              color: textColor,
                              onTap: toggleSidebar,
                            ),
                            _buildMenuItem(
                              icon: Icons.location_on,
                              label: "Address",
                              color: textColor,
                              onTap: toggleSidebar,
                            ),
                            _buildMenuItem(
                              icon: Icons.card_giftcard,
                              label: "Rewards",
                              color: textColor,
                              onTap: toggleSidebar,
                            ),
                            _buildMenuItem(
                              icon: Icons.account_balance_wallet,
                              label: "Wallet",
                              color: textColor,
                              onTap: toggleSidebar,
                            ),
                            AppSpacing.vlg,
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.md.w,
                              ),
                              child: CustomText(
                                text: "Information",
                                size: CustomTextSize.lg,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                color: CustomTextColor.text,
                              ),
                            ),
                            AppSpacing.vmd,
                            _buildMenuItem(
                              icon: Icons.info,
                              label: "About Us",
                              color: textColor,
                              onTap: toggleSidebar,
                            ),
                            _buildMenuItem(
                              icon: Icons.description,
                              label: "Terms and Conditions",
                              color: textColor,
                              onTap: toggleSidebar,
                            ),
                            _buildMenuItem(
                              icon: Icons.lock,
                              label: "Privacy Policy",
                              color: textColor,
                              onTap: toggleSidebar,
                            ),
                            _buildMenuItem(
                              icon: Icons.settings,
                              label: "Settings",
                              color: textColor,
                              onTap: toggleSidebar,
                            ),
                            _buildMenuItem(
                              icon: Icons.verified_user,
                              label: "Permissions",
                              color: textColor,
                              onTap: toggleSidebar,
                            ),
                            AppSpacing.vlg,
                            _buildMenuItem(
                              icon: Icons.logout,
                              label: "Logout",
                              color: Colors.redAccent,
                              onTap: toggleSidebar,
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
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.md.h,
          horizontal: AppSpacing.md.w,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24.sp),
            AppSpacing.hsm,
            Expanded(
              child: CustomText(
                text: label,
                size: CustomTextSize.md,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                color: CustomTextColor.text,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
