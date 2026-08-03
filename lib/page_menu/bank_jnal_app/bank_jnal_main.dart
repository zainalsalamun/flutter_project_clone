import 'package:flutter/material.dart';
import 'app/routes/app_router.dart';
import 'app/themes/app_theme.dart';

class BankJnalApp extends StatelessWidget {
  const BankJnalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bank J-NAL',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
