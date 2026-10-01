import 'package:flutter/material.dart';
import 'core/warga_kita_theme.dart';
import 'screens/warga_kita_main_navigation.dart';

class WargaKitaPage extends StatelessWidget {
  const WargaKitaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: WargaKitaTheme.surface,
        colorScheme: ColorScheme.fromSeed(
          seedColor: WargaKitaTheme.primary,
          surface: WargaKitaTheme.surface,
          primary: WargaKitaTheme.primary,
          secondary: WargaKitaTheme.mintContainer,
          tertiary: WargaKitaTheme.crimsonSos,
        ),
      ),
      child: const WargaKitaMainNavigation(),
    );
  }
}
