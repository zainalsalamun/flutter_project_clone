import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/localization/food_promo_localization.dart';
import '../../core/theme/food_promo_theme.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/navigation/navigation_event.dart';
import '../bloc/navigation/navigation_state.dart';
import '../widgets/animated_bottom_nav.dart';
import 'favorites_tab_screen.dart';
import 'home_screen.dart';
import 'simple_tab_screen.dart';

class FoodPromoMainScreen extends StatelessWidget {
  const FoodPromoMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = FoodPromoCopy.of(context);

    final tabs = [
      const HomeScreen(),
      SimpleTabScreen(
        title: l.explore,
        icon: Icons.explore_rounded,
        subtitle: l.exploreSubtitle,
      ),
      SimpleTabScreen(
        title: l.orders,
        icon: Icons.receipt_long_rounded,
        subtitle: l.ordersSubtitle,
      ),
      const FavoritesTabScreen(),
      SimpleTabScreen(
        title: l.profile,
        icon: Icons.person_rounded,
        subtitle: l.profileSubtitle,
      ),
    ];

    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, navState) {
        final selectedTab = navState.selectedTabIndex;

        return Scaffold(
          backgroundColor: FoodPromoTheme.cream,
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 320),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.04, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: KeyedSubtree(
              key: ValueKey(selectedTab),
              child: tabs[selectedTab],
            ),
          ),
          bottomNavigationBar: AnimatedBottomNav(
            selectedIndex: selectedTab,
            onChanged: (index) {
              context.read<NavigationBloc>().add(ChangeTabEvent(index));
            },
          ),
        );
      },
    );
  }
}
