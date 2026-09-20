import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/order_model.dart';
import '../../bloc/order/order_bloc.dart';
import '../home/home_page.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _ratingShown = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.35).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showRatingModal(BuildContext context, OrderModel order) {
    if (_ratingShown) return;
    _ratingShown = true;

    int selectedStars = 5;
    final feedbackTags = ['Fast delivery', 'Food was hot', 'Friendly driver', 'Well packaged'];
    final selectedTags = <String>{'Fast delivery', 'Food was hot'};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalCtx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(color: Color(0xFFECFDF5), shape: BoxShape.circle),
                    child: const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 48),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Order Delivered!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'How was your delivery from ${order.restaurant.name}?',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starIndex = index + 1;
                      return GestureDetector(
                        onTap: () {
                          setModalState(() => selectedStars = starIndex);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(
                            Icons.star_rounded,
                            size: 38,
                            color: starIndex <= selectedStars ? const Color(0xFFF59E0B) : Colors.grey.shade300,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: feedbackTags.map((tag) {
                      final isSelected = selectedTags.contains(tag);
                      return FilterChip(
                        label: Text(tag, style: TextStyle(fontSize: 12, color: isSelected ? const Color(0xFF059669) : Colors.grey.shade700)),
                        selected: isSelected,
                        selectedColor: const Color(0xFFECFDF5),
                        backgroundColor: const Color(0xFFF3F4F6),
                        checkmarkColor: const Color(0xFF059669),
                        onSelected: (selected) {
                          setModalState(() {
                            if (selected) {
                              selectedTags.add(tag);
                            } else {
                              selectedTags.remove(tag);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(modalCtx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Thank you for your review!'),
                            backgroundColor: Color(0xFF059669),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF059669),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Submit Review', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Live Order Tracking', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false,
            );
          },
        ),
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderPlaced && state.order.status == OrderStatus.delivered) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) _showRatingModal(context, state.order);
            });
          }
        },
        builder: (context, state) {
          if (state is! OrderPlaced) {
            return const Center(child: Text('No active order found'));
          }

          final order = state.order;
          final statuses = OrderStatus.values;
          final currentIndex = statuses.indexOf(order.status);

          return SingleChildScrollView(
            child: Column(
              children: [
                // Animated Map View with Pulse Marker
                _buildMapHeader(order),

                // Driver & Restaurant Card
                _buildDriverCard(order),

                const SizedBox(height: 12),

                // Live Timeline Stepper
                _buildTimelineCard(statuses, currentIndex),

                const SizedBox(height: 16),

                // Manual Step Simulator Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<OrderBloc>().add(AdvanceOrderStatus());
                      },
                      icon: const Icon(Icons.fast_forward_rounded, color: Color(0xFF059669)),
                      label: Text(
                        currentIndex < statuses.length - 1
                            ? 'Simulate Next Status'
                            : 'Order Completed (Show Rating)',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFF059669), width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMapHeader(OrderModel order) {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=2074&auto=format&fit=crop'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(color: Colors.black.withValues(alpha: 0.2)),
          // Pulsing Marker
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669).withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF059669),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
              ],
            ),
            child: const Icon(Icons.delivery_dining_rounded, color: Colors.white, size: 28),
          ),
          Positioned(
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getStatusText(order.status),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverCard(OrderModel order) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: const NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200&auto=format&fit=crop'),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Budi Santoso', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                    const SizedBox(width: 2),
                    const Text('4.9', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text('• Honda Vario (B 1234 NAL)', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF059669)),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.phone_outlined, color: Color(0xFF059669)),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(List<OrderStatus> statuses, int currentIndex) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Delivery Progress', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ...List.generate(statuses.length, (index) {
            final isCurrent = index == currentIndex;
            final isDone = index < currentIndex;
            return _buildTimelineStep(
              _getStatusText(statuses[index]),
              _getStatusDescription(statuses[index]),
              isDone: isDone,
              isCurrent: isCurrent,
              isLast: index == statuses.length - 1,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(
    String title,
    String subtitle, {
    required bool isDone,
    required bool isCurrent,
    required bool isLast,
  }) {
    final isActive = isDone || isCurrent;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone
                    ? const Color(0xFF059669)
                    : (isCurrent ? Colors.white : Colors.grey.shade200),
                border: Border.all(
                  color: isActive ? const Color(0xFF059669) : Colors.grey.shade300,
                  width: isCurrent ? 5 : 2,
                ),
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 2,
                height: 38,
                color: isDone ? const Color(0xFF059669) : Colors.grey.shade200,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isCurrent
                      ? const Color(0xFF059669)
                      : (isActive ? Colors.black87 : Colors.grey.shade500),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ],
    );
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.received:
        return 'Order Received';
      case OrderStatus.accepted:
        return 'Restaurant Accepted';
      case OrderStatus.preparing:
        return 'Preparing Your Food';
      case OrderStatus.driverAssigned:
        return 'Driver Assigned';
      case OrderStatus.pickingUp:
        return 'Driver is Picking Up';
      case OrderStatus.onDelivery:
        return 'On Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  String _getStatusDescription(OrderStatus status) {
    switch (status) {
      case OrderStatus.received:
        return 'We have received your order.';
      case OrderStatus.accepted:
        return 'The restaurant is preparing the kitchen.';
      case OrderStatus.preparing:
        return 'Chef is cooking your fresh meal.';
      case OrderStatus.driverAssigned:
        return 'Driver is heading to the restaurant.';
      case OrderStatus.pickingUp:
        return 'Driver is checking & packing your meal.';
      case OrderStatus.onDelivery:
        return 'Driver is riding towards your destination.';
      case OrderStatus.delivered:
        return 'Your food has arrived. Enjoy your meal!';
    }
  }
}
