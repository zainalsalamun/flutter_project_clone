import 'package:flutter/material.dart';
import 'core/botanica_data.dart';
import 'core/botanica_theme.dart';
import 'screens/botanica_main_navigation.dart';

class BotanicaBeautyPage extends StatefulWidget {
  const BotanicaBeautyPage({super.key});

  @override
  State<BotanicaBeautyPage> createState() => _BotanicaBeautyPageState();
}

class _BotanicaBeautyPageState extends State<BotanicaBeautyPage> {
  @override
  void initState() {
    super.initState();
    BotanicaData().init();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: BotanicaTheme.lightTheme,
      child: const BotanicaMainNavigation(),
    );
  }
}
