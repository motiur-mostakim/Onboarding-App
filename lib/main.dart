import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onboarding_app/features/onboarding_screen/onboarding_screen.dart';

import 'constants/local_storage_manager.dart';
import 'networks/notification_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await NotificationServices.init();
  await LocalStorageManager.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(360, 800),
      minTextAdapt: true,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}
