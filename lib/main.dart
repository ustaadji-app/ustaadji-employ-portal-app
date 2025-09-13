import 'package:employee_portal/routes/app_routes.dart';
import 'package:employee_portal/routes/app_routes_names.dart';
import 'package:employee_portal/themes/app_theme.dart';
import 'package:employee_portal/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // final notificationService = NotificationService();
  // await notificationService.requestPermission();
  // await notificationService.getToken();
  // await notificationService.initLocalNotifications();
  // notificationService.foregroundMessage();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ScreenUtilInit(
      designSize: kIsWeb ? const Size(1536, 729) : const Size(360, 825),
      minTextAdapt: true,
      splitScreenMode: true,
      builder:
          (context, child) =>
          // ToastificationWrapper(
          //   config: ToastificationConfig(
          //     maxTitleLines: 2,
          //     maxDescriptionLines: 6,
          //     marginBuilder: (context, alignment) =>
          //         const EdgeInsets.fromLTRB(0, 16, 0, 110),
          //   ),
          //   child: child,
          // ),
          MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: AppRoutesNames.splash,
            routes: AppRoutes.routes,
          ),
    );
  }
}
