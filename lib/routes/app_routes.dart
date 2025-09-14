import 'package:employee_portal/routes/app_routes_names.dart';
import 'package:employee_portal/screens/auth/landing_screen.dart';
import 'package:employee_portal/screens/auth/login_screen.dart';
import 'package:employee_portal/screens/auth/otp_screen.dart';
import 'package:employee_portal/screens/auth/register_screen.dart';
import 'package:employee_portal/screens/home/home_screen.dart';
import 'package:employee_portal/screens/messages/chat_screen.dart';
import 'package:employee_portal/screens/notfications/notifcations_screen.dart';
import 'package:employee_portal/screens/profile/profile_screen.dart';
import 'package:employee_portal/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    AppRoutesNames.splash: (context) => SplashScreen(),
    AppRoutesNames.chats: (context) => ChatScreen(),
    AppRoutesNames.profile: (context) => const ProfileScreen(),
    AppRoutesNames.notification: (context) => NotificationsScreen(),
    AppRoutesNames.register: (context) => RegisterScreen(),
    AppRoutesNames.login: (context) => LoginScreen(),
    AppRoutesNames.landing: (context) => AuthLandingScreen(),
    AppRoutesNames.otp: (context) => OtpVerificationScreen(),
    AppRoutesNames.home: (context) => const HomeScreen(),
    // AppRouteNames.serviceBooked: (context) => ,
    // AppRouteNames.status: (context) => StatusScreen(),
    // AppRouteNames.phoneNumber: (context) => const PhoneNumberScreen(),
    // AppRouteNames.createProfile: (context) => const CreateProfileScreen(),
    // AppRouteNames.complains: (context) => const MyComplainScreen(),
  };
}
