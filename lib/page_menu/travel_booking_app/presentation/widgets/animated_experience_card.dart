import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/theme/travel_theme.dart';
import '../../core/utils/travel_currency.dart';
import '../../data/models/travel_item_model.dart';

class AnimatedExperienceCard extends StatefulWidget {
  final ExperienceItem experience;
  final double parallaxOffset;
  final VoidCallback? onTap;
  final void Function(GlobalKey key)? onTapWithKey;
  final String? heroTagPrefix;

  const AnimatedExperienceCard({
    super.key,
    required this.experience,
    this.parallaxOffset = 0.0,
    this.onTap,
    this.onTapWithKey,
    this.heroTagPrefix,
  });

  @override
  State<AnimatedExperienceCard> createState() => _AnimatedExperienceCardState();
}

class _AnimatedExperienceCardState extends State<AnimatedExperienceCard> {
  final GlobalKey _cardKey = GlobalKey();
  bool _isPressed = false;
  bool _isFavorite = false;

  void _handleTap() {
    if (widget.onTapWithKey != null) {
      widget.onTapWithKey!(_cardKey);
    } else {
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final heroTag = widget.heroTagPrefix != null
        ? '${widget.heroTagPrefix}-${widget.experience.heroTag}'
        : widget.experience.heroTag;

    return GestureDetector(
      key: _cardKey,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapCancel: () => setState(() => _isPressed = false),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        Future.delayed(const Duration(milliseconds: 60), _handleTap);
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: Container(
          height: 330,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: TravelTheme.dark.withValues(alpha: 0.12),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // Parallax Background Image
                Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(0, widget.parallaxOffset),
                    child: Transform.scale(
                      scale: 1.15,
                      child: Hero(
                        tag: heroTag,
                        child: CachedNetworkImage(
                          imageUrl: widget.experience.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: TravelTheme.border,
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: TravelTheme.emerald,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Gradient Overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: TravelTheme.heroGradient,
                    ),
                  ),
                ),

                // Top Badges
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: TravelTheme.emerald.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.explore_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.experience.categoryTag,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => setState(() => _isFavorite = !_isFavorite),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: _isFavorite ? TravelTheme.accent : TravelTheme.darkMuted,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Content
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            color: TravelTheme.accentGold,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              widget.experience.duration,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '✓ Termasuk Pemandu',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.experience.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: TravelTheme.accentGold,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.experience.rating}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${widget.experience.reviewCount})',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                formatTravelCurrency(widget.experience.price),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                '/orang',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
