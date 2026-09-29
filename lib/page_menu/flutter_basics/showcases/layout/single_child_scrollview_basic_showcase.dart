import 'package:flutter/material.dart';

class SingleChildScrollViewBasicShowcase extends StatefulWidget {
  const SingleChildScrollViewBasicShowcase({super.key});

  @override
  State<SingleChildScrollViewBasicShowcase> createState() =>
      _SingleChildScrollViewBasicShowcaseState();
}

class _SingleChildScrollViewBasicShowcaseState
    extends State<SingleChildScrollViewBasicShowcase> {
  final ScrollController _scrollController = ScrollController();
  Axis _scrollDirection = Axis.vertical;
  bool _useBouncing = true;
  bool _reverse = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          height: 220,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: _scrollDirection,
              reverse: _reverse,
              physics:
                  _useBouncing
                      ? const BouncingScrollPhysics()
                      : const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(12),
              child:
                  _scrollDirection == Axis.vertical
                      ? Column(
                        children: List.generate(
                          10,
                          (i) => _buildItemCard(i, isHorizontal: false),
                        ),
                      )
                      : Row(
                        children: List.generate(
                          10,
                          (i) => _buildItemCard(i, isHorizontal: true),
                        ),
                      ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'SingleChildScrollView Controls',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            const Expanded(
              child: Text(
                'Scroll Direction:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            ChoiceChip(
              label: const Text('Vertical', style: TextStyle(fontSize: 11)),
              selected: _scrollDirection == Axis.vertical,
              onSelected:
                  (v) => setState(() => _scrollDirection = Axis.vertical),
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('Horizontal', style: TextStyle(fontSize: 11)),
              selected: _scrollDirection == Axis.horizontal,
              onSelected:
                  (v) => setState(() => _scrollDirection = Axis.horizontal),
            ),
          ],
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            const Expanded(
              child: Text(
                'Physics (Bouncing vs Clamping):',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            Switch(
              value: _useBouncing,
              activeThumbColor: const Color(0xFF6366F1),
              onChanged: (v) => setState(() => _useBouncing = v),
            ),
          ],
        ),
        const SizedBox(height: 4),

        Row(
          children: [
            const Expanded(
              child: Text(
                'Reverse Scrolling:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            Switch(
              value: _reverse,
              activeThumbColor: const Color(0xFF6366F1),
              onChanged: (v) => setState(() => _reverse = v),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItemCard(int i, {required bool isHorizontal}) {
    return Container(
      width: isHorizontal ? 120 : double.infinity,
      height: isHorizontal ? 160 : 48,
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        'Item #${i + 1}',
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}
