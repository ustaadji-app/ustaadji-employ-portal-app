import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/constants/app_fonts_sizes.dart';
import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

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

    // Start typing animation after 1 second
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
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
        (route) => false,
      );
    });
  }

  // Future<void> _navigateNext() async {
  //   final user = await StorageHelper.getUser();

  //   if (!mounted) return;

  //   print(user);

  //   if (user.isNotEmpty) {
  //     // Set user in Provider
  //     final userProvider = Provider.of<UserProvider>(context, listen: false);
  //     userProvider.setUser(
  //       user.map((key, value) => MapEntry(key, value.toString())),
  //     );

  //     Future.delayed(const Duration(seconds: 1));
  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (_) => const HomeScreen()),
  //       (route) => false,
  //     );
  //   } else {
  //     Future.delayed(const Duration(seconds: 1));
  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (_) => const CreateProfileScreen()),
  //       (route) => false,
  //     );
  //   }
  // }

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
