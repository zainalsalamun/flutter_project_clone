import 'package:flutter/material.dart';
import 'core/theme/travel_theme.dart';
import 'presentation/pages/travel_home_screen.dart';

class TravelBookingPage extends StatelessWidget {
  const TravelBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: TravelTheme.lightTheme,
      child: const TravelHomeScreen(),
    );
  }
}
