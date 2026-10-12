import 'package:flutter/material.dart';

class StripedLinearProgressShowcase extends StatefulWidget {
  const StripedLinearProgressShowcase({super.key});

  @override
  State<StripedLinearProgressShowcase> createState() =>
      _StripedLinearProgressShowcaseState();
}

class _StripedLinearProgressShowcaseState
    extends State<StripedLinearProgressShowcase>
    with SingleTickerProviderStateMixin {
  late AnimationController _stripeController;
  double _progressValue = 0.68; // 0.0 to 1.0
  bool _isStripesAnimated = true;
  int _currentStep = 1; // 0, 1, 2

  @override
  void initState() {
    super.initState();
    _stripeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _stripeController.dispose();
    super.dispose();
  }

  void _toggleStripeAnimation() {
    setState(() {
      _isStripesAnimated = !_isStripesAnimated;
      if (_isStripesAnimated) {
        _stripeController.repeat();
      } else {
        _stripeController.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------------- 1. STRIPED FLOWING PROGRESS BAR ----------------
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.cloud_upload_rounded,
                          size: 18,
                          color: Color(0xFF6366F1),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Mengunggah File Proyek...',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${(_progressValue * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Striped Canvas Bar
              Container(
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedBuilder(
                    animation: _stripeController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: Size.infinite,
                        painter: _StripedProgressPainter(
                          progress: _progressValue,
                          animationOffset:
                              _isStripesAnimated
                                  ? _stripeController.value
                                  : 0.0,
                          primaryColor: const Color(0xFF6366F1),
                          secondaryColor: const Color(0xFF818CF8),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Interactive Slider to change percentage
              Row(
                children: [
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFF6366F1),
                        thumbColor: const Color(0xFF6366F1),
                        inactiveTrackColor: Colors.grey.shade200,
                        trackHeight: 3,
                      ),
                      child: Slider(
                        value: _progressValue,
                        min: 0.0,
                        max: 1.0,
                        onChanged:
                            (val) => setState(() => _progressValue = val),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isStripesAnimated
                          ? Icons.pause_circle_rounded
                          : Icons.play_circle_rounded,
                      color: const Color(0xFF6366F1),
                      size: 22,
                    ),
                    tooltip: 'Jeda / Putar Animasi Strip',
                    onPressed: _toggleStripeAnimation,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ---------------- 2. SEGMENTED STORAGE / BUDGET BAR ----------------
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Penyimpanan Perangkat',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '25.6 / 32 GB',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Multi-segment Horizontal Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 14,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 40,
                        child: Container(color: const Color(0xFF8B5CF6)),
                      ),
                      Expanded(
                        flex: 25,
                        child: Container(color: const Color(0xFF06B6D4)),
                      ),
                      Expanded(
                        flex: 15,
                        child: Container(color: const Color(0xFFF59E0B)),
                      ),
                      Expanded(
                        flex: 20,
                        child: Container(color: Colors.grey.shade200),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Segment Legend
              const Wrap(
                spacing: 12,
                runSpacing: 6,
                children: [
                  _StorageLegendItem(
                    color: Color(0xFF8B5CF6),
                    label: 'Media (12.8 GB)',
                  ),
                  _StorageLegendItem(
                    color: Color(0xFF06B6D4),
                    label: 'Aplikasi (8.0 GB)',
                  ),
                  _StorageLegendItem(
                    color: Color(0xFFF59E0B),
                    label: 'Dokumen (4.8 GB)',
                  ),
                  _StorageLegendItem(
                    color: Color(0xFFCBD5E1),
                    label: 'Tersedia (6.4 GB)',
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ---------------- 3. STEPPED MILESTONE PROGRESS ----------------
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Tahapan Transaksi',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildStepButton(0, '1'),
                      const SizedBox(width: 4),
                      _buildStepButton(1, '2'),
                      const SizedBox(width: 4),
                      _buildStepButton(2, '3'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Stepped Progress Indicator Row
              Row(
                children: [
                  _buildStepNode(0, 'Keranjang', _currentStep >= 0),
                  _buildStepConnector(_currentStep >= 1),
                  _buildStepNode(1, 'Pembayaran', _currentStep >= 1),
                  _buildStepConnector(_currentStep >= 2),
                  _buildStepNode(2, 'Selesai', _currentStep >= 2),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepButton(int step, String label) {
    final isSelected = _currentStep == step;
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: () => setState(() => _currentStep = step),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          'Tahap $label',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildStepNode(int step, String label, bool isCompleted) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isCompleted ? const Color(0xFF6366F1) : Colors.grey.shade200,
            shape: BoxShape.circle,
            boxShadow:
                isCompleted
                    ? [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                        blurRadius: 6,
                      ),
                    ]
                    : null,
          ),
          child: Center(
            child:
                isCompleted
                    ? const Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: Colors.white,
                    )
                    : Text(
                      '${step + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: isCompleted ? FontWeight.bold : FontWeight.w500,
            color: isCompleted ? const Color(0xFF0F172A) : Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector(bool isActive) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 3,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF6366F1) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// DIAGONAL STRIPED PROGRESS PAINTER
// ---------------------------------------------------------------------------
class _StripedProgressPainter extends CustomPainter {
  final double progress;
  final double animationOffset; // 0.0 to 1.0
  final Color primaryColor;
  final Color secondaryColor;

  _StripedProgressPainter({
    required this.progress,
    required this.animationOffset,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final fillWidth = size.width * progress.clamp(0.0, 1.0);
    final fillRect = Rect.fromLTWH(0, 0, fillWidth, size.height);

    canvas.save();
    canvas.clipRect(fillRect);

    // 1. Base Fill
    final basePaint = Paint()..color = primaryColor;
    canvas.drawRect(fillRect, basePaint);

    // 2. Flowing Diagonal Stripes
    final stripePaint = Paint()..color = secondaryColor;
    const stripeWidth = 12.0;
    const stripeGap = 12.0;
    final totalStripe = stripeWidth + stripeGap;

    final offsetShift = animationOffset * totalStripe;

    for (
      double x = -totalStripe + offsetShift;
      x < fillWidth + size.height + totalStripe;
      x += totalStripe
    ) {
      final path =
          Path()
            ..moveTo(x, 0)
            ..lineTo(x + stripeWidth, 0)
            ..lineTo(x + stripeWidth - size.height, size.height)
            ..lineTo(x - size.height, size.height)
            ..close();

      canvas.drawPath(path, stripePaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _StripedProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.animationOffset != animationOffset;
  }
}

class _StorageLegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _StorageLegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
