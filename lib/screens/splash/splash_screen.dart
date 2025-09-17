import 'dart:async';
import 'package:employee_portal/screens/internet/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:employee_portal/constants/app_colors.dart';
import 'package:employee_portal/constants/app_fonts_sizes.dart';
import 'package:employee_portal/constants/app_spacing.dart';
import 'package:employee_portal/screens/auth/landing_screen.dart';
import 'package:employee_portal/screens/auth/pending_verification.dart';
import 'package:employee_portal/screens/auth/login_screen.dart';
import 'package:employee_portal/screens/home/home_screen.dart';
import 'package:employee_portal/provider/user_provider.dart';
import 'package:employee_portal/utils/storage_helper.dart';
import 'package:employee_portal/services/api_services.dart';

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

  final ApiService apiService = ApiService();

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
        _checkNetworkAndProceed();
      }
    });
  }

  Future<void> _checkNetworkAndProceed() async {
    final hasInternet = await InternetConnectionChecker().hasConnection;

    if (!hasInternet) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NoInternetScreen()),
      );
    } else {
      _checkUserFlow();
    }
  }

  Future<void> _checkUserFlow() async {
    final token = await StorageHelper.getToken();
    final user = await StorageHelper.getUser();

    print("📌 Stored User: $user");
    print("📌 Stored Token: $token");

    if (!mounted) return;

    // 🔹 Scenario 1: User ka data hi nahi hai (new user ya logout)
    if (user.isEmpty) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthLandingScreen()),
        (route) => false,
      );
      return;
    }

    final provider = user['provider'] as Map<String, dynamic>?;
    final phoneNumber = provider?['phone_number'];

    // Agar phone number hi missing ho toh AuthLanding bhej do
    if (phoneNumber == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthLandingScreen()),
        (route) => false,
      );
      return;
    }

    // 🔹 Scenario 2: Data hai but token nahi (registered but not logged in)
    if (token == null || token.isEmpty) {
      try {
        final result = await apiService.getRequest(
          endpoint: "provider/details?phone=$phoneNumber",
        );

        print("📌 Scenario 2 API Response: $result");

        if (!mounted) return;

        if (result['success'] == true) {
          final data = result['data'] as Map<String, dynamic>?;

          if (data != null && data['provider'] != null) {
            final providerData = data['provider'] as Map<String, dynamic>;
            final subscriptions = data['subscriptions'] as List<dynamic>? ?? [];

            final userData = {
              "provider": providerData,
              "subscriptions": subscriptions,
            };

            await StorageHelper.saveUser(userData);
            Provider.of<UserProvider>(context, listen: false).setUser(userData);

            // Active check
            if (providerData['is_active'] == 0) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const PendingVerificationScreen(),
                ),
                (route) => false,
              );
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            }
          } else {
            _goToAuthLanding();
          }
        } else {
          _goToAuthLanding();
        }
      } catch (e) {
        print("❌ Error in Scenario 2: $e");
        _goToAuthLanding();
      }
      return;
    }

    // 🔹 Scenario 3: Data + token dono hain (already login)
    try {
      final result = await apiService.getRequest(
        endpoint: "provider/details?phone=$phoneNumber",
        token: token,
      );

      print("📌 Scenario 3 API Response: $result");

      if (!mounted) return;

      if (result['success'] == true) {
        final data = result['data'] as Map<String, dynamic>?;

        if (data != null && data['provider'] != null) {
          final providerData = data['provider'] as Map<String, dynamic>;
          final subscriptions = data['subscriptions'] as List<dynamic>? ?? [];

          final accessToken = data['access_token'] as String? ?? token;
          await StorageHelper.saveToken(accessToken);

          final userData = {
            "provider": providerData,
            "subscriptions": subscriptions,
          };

          await StorageHelper.saveUser(userData);
          Provider.of<UserProvider>(context, listen: false).setUser(userData);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
        } else {
          _goToAuthLanding();
        }
      } else {
        _goToAuthLanding();
      }
    } catch (e) {
      print("❌ Error in Scenario 3: $e");
      _goToAuthLanding();
    }
  }

  void _goToAuthLanding() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthLandingScreen()),
      (route) => false,
    );
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
