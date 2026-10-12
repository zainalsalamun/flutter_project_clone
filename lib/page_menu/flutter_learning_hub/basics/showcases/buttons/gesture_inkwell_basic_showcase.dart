import 'package:flutter/material.dart';

class GestureInkwellBasicShowcase extends StatefulWidget {
  const GestureInkwellBasicShowcase({super.key});

  @override
  State<GestureInkwellBasicShowcase> createState() =>
      _GestureInkwellBasicShowcaseState();
}

class _GestureInkwellBasicShowcaseState
    extends State<GestureInkwellBasicShowcase> {
  String _gestureLog = 'Coba tap, double tap, atau long press kartu di atas';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              // InkWell with Material ripple
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap:
                      () => setState(
                        () => _gestureLog = 'InkWell: onTap (Single Tap)',
                      ),
                  onDoubleTap:
                      () =>
                          setState(() => _gestureLog = 'InkWell: onDoubleTap!'),
                  onLongPress:
                      () => setState(
                        () => _gestureLog = 'InkWell: onLongPress (Hold)',
                      ),
                  borderRadius: BorderRadius.circular(14),
                  splashColor: const Color(0xFF6366F1).withValues(alpha: 0.2),
                  highlightColor: const Color(
                    0xFF6366F1,
                  ).withValues(alpha: 0.1),
                  child: Ink(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.water_drop_rounded,
                          color: Color(0xFF6366F1),
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'InkWell (Dengan Ripple Wave)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Tap / Double Tap / Long Press saya',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // GestureDetector without ripple
              GestureDetector(
                onTap:
                    () =>
                        setState(() => _gestureLog = 'GestureDetector: onTap'),
                onDoubleTap:
                    () => setState(
                      () => _gestureLog = 'GestureDetector: onDoubleTap!',
                    ),
                onLongPress:
                    () => setState(
                      () => _gestureLog = 'GestureDetector: onLongPress',
                    ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.touch_app_rounded,
                        color: Color(0xFF10B981),
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'GestureDetector (Raw Gestures)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Mendeteksi gesture tanpa efek riak air',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Gesture Log Output
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  _gestureLog,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4338CA),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
