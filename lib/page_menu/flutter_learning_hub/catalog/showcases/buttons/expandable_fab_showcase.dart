import 'dart:math' as math;
import 'package:flutter/material.dart';

class ExpandableFabShowcase extends StatefulWidget {
  const ExpandableFabShowcase({super.key});

  @override
  State<ExpandableFabShowcase> createState() => _ExpandableFabShowcaseState();
}

class _ExpandableFabShowcaseState extends State<ExpandableFabShowcase> {
  String _lastAction = 'None';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Selected Action: $_lastAction\nTap the floating button below to expand the speed dial.',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ExpandableFab(
              distance: 100,
              children: [
                ActionButton(
                  icon: const Icon(
                    Icons.photo_camera_rounded,
                    color: Colors.white,
                  ),
                  color: Colors.purple,
                  tooltip: 'Camera',
                  onPressed:
                      () => setState(() => _lastAction = 'Camera Clicked'),
                ),
                ActionButton(
                  icon: const Icon(Icons.image_rounded, color: Colors.white),
                  color: Colors.orange,
                  tooltip: 'Gallery',
                  onPressed:
                      () => setState(() => _lastAction = 'Gallery Clicked'),
                ),
                ActionButton(
                  icon: const Icon(
                    Icons.insert_drive_file_rounded,
                    color: Colors.white,
                  ),
                  color: Colors.teal,
                  tooltip: 'Document',
                  onPressed:
                      () => setState(() => _lastAction = 'Document Clicked'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExpandableFab extends StatefulWidget {
  final double distance;
  final List<Widget> children;

  const ExpandableFab({
    super.key,
    required this.distance,
    required this.children,
  });

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: InkWell(
            onTap: _toggle,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.close, color: Color(0xFF6366F1)),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (
      var i = 0, angleInDegrees = 0.0;
      i < count;
      i++, angleInDegrees += step
    ) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            backgroundColor: const Color(0xFF6366F1),
            onPressed: _toggle,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _ExpandingActionButton extends StatelessWidget {
  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0) + (math.pi),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 - offset.dx,
          bottom: 4.0 - offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(opacity: progress, child: child),
    );
  }
}

class ActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final Color color;
  final String? tooltip;

  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
    required this.color,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: color,
      elevation: 4,
      child: IconButton(onPressed: onPressed, icon: icon),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}
