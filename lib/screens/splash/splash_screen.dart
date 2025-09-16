import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/constants/app_fonts_sizes.dart';
import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/screens/auth/landing_screen.dart';
import 'package:employee_portal/screens/auth/pending_verification.dart';
import 'package:employee_portal/screens/home/home_screen.dart';
import 'package:employee_portal/provider/user_provider.dart';
import 'package:employee_portal/utils/storage_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final String _text = "Ustaad Ji";
  String _displayedText = "";
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    Future.delayed(const Duration(seconds: 1), _startTyping);
  }

  void _startTyping() {
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (_currentIndex < _text.length) {
        setState(() {
          _displayedText += _text[_currentIndex];
          _currentIndex++;
        });
      } else {
        timer.cancel();
        _navigateNext(); // Typing complete → Navigate next
      }
    });
  }

  Future<void> _navigateNext() async {
    final token = await StorageHelper.getToken();
    final user = await StorageHelper.getUser();

    if (!mounted) return;

    Future.delayed(const Duration(milliseconds: 800), () {
      if (token != null && token.isNotEmpty && user.isNotEmpty) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);

        // ✅ Set structured data in Provider (same as OTP screen)
        userProvider.setUser(user);

        final provider = user['provider'] ?? {};
        if (provider['is_active'] == 1) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
        } else if (provider['is_active'] == 0) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const PendingVerificationScreen(),
            ),
            (route) => false,
          );
        }
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const AuthLandingScreen()),
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? AppColors.darkText : AppColors.lightText;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color:
            isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: Image.asset(
                  'assets/images/app_logo.png',
                  width: 200.w,
                  height: 200.h,
                ),
              ),
              AppSpacing.vxxl,
              Text(
                _displayedText,
                style: TextStyle(
                  fontSize: AppFonts.xxxl,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
