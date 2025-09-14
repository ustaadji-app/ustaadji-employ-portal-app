import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/widgets/custom_app_bar.dart';
import 'package:employee_portal/widgets/custom_bottom_navigation_bar.dart';
import 'package:employee_portal/widgets/custom_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainLayout extends StatefulWidget {
  final Widget body;
  final String title;
  final int currentIndex;
  final bool showBottomNav;
  final bool isBackAction;
  final bool isAvatarShow;
  final bool isSidebarEnabled;

  const MainLayout({
    super.key,
    required this.body,
    required this.title,
    required this.currentIndex,
    this.showBottomNav = true,
    this.isBackAction = false,
    this.isAvatarShow = true,
    this.isSidebarEnabled = false,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final GlobalKey<CustomSidebarState> _sidebarKey = GlobalKey();

  void _handleNavTap(int index) {
    String routeName;
    switch (index) {
      case 0:
        routeName = '/home';
        break;
      case 1:
        routeName = '/chats';
        break;
      case 2:
        routeName = '/status';
        break;
      case 3:
        routeName = '/complaints';
        break;
      case 4:
        routeName = '/profile';
        break;
      default:
        routeName = '/home';
    }
    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushNamed(context, routeName);
    }
  }

  void _toggleSidebar() {
    _sidebarKey.currentState?.toggleSidebar();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final scaffold = Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CustomAppBar(
        title: widget.title,
        isBackAction: widget.isBackAction,
        isSidebarEnabled: widget.isSidebarEnabled,
        isAvatarShow: widget.isAvatarShow,
        onMenuPressed: _toggleSidebar,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm.w,
            vertical: AppSpacing.sm.h,
          ),
          child: widget.body,
        ),
      ),
      bottomNavigationBar:
          widget.showBottomNav
              ? SafeArea(
                child: CustomBottomNavigationBar(
                  currentIndex: widget.currentIndex,
                  onTap: _handleNavTap,
                ),
              )
              : null,
    );

    return widget.isSidebarEnabled
        ? CustomSidebar(key: _sidebarKey, child: scaffold)
        : scaffold;
  }
}
