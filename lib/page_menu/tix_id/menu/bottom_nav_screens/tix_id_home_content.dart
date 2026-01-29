import 'package:flutter/material.dart';
import '../widgets/tix_id_promo_widgets.dart';
import '../widgets/tix_id_movie_widgets.dart';
import '../widgets/tix_id_feature_widgets.dart';
import '../widgets/tix_id_footer_widget.dart';

class TixIdHomeContent extends StatefulWidget {
  const TixIdHomeContent({super.key});

  @override
  State<TixIdHomeContent> createState() => _TixIdHomeContentState();
}

class _TixIdHomeContentState extends State<TixIdHomeContent> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TixIdGopayBanner(),
          const TixIdVipBanner(),
          const SizedBox(height: 24),
          const TixIdNowShowingSection(),
          const SizedBox(height: 24),
          const TixIdMercyBanner(),
          const SizedBox(height: 24),
          const TixIdEventsSection(),
          const SizedBox(height: 24),
          const TixIdReferralBar(),
          const SizedBox(height: 24),
          const TixIdFoodSection(),
          const SizedBox(height: 24),
          const TixIdRentSection(),
          const SizedBox(height: 16),
          const TixIdVideoSection(),
          const SizedBox(height: 32),
          const TixIdSpotlightSection(),
          const SizedBox(height: 32),
          const TixIdNewsSection(),
          const SizedBox(height: 32),
          const TixIdComingSoonSection(),
          const SizedBox(height: 48),
          TixIdFooter(onBackToTop: _scrollToTop),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
