import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../data/models/order_model.dart';
import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/order/order_bloc.dart';
import '../tracking/order_tracking_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _paymentMethod = 'Cash on Delivery';

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is! CartLoaded) return const SizedBox.shrink();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Delivery Address'),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.green),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Home', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('123 Main Street, Apartment 4B', style: TextStyle(color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
                _buildSectionTitle('Order Summary'),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ...state.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${item.quantity}x ${item.food.name}'),
                            Text(currencyFormat.format(item.totalPrice)),
                          ],
                        ),
                      )),
                      const Divider(),
                      _buildSummaryRow('Subtotal', state.subtotal, currencyFormat),
                      _buildSummaryRow('Delivery Fee', state.deliveryFee, currencyFormat),
                      _buildSummaryRow('Service Fee', state.serviceFee, currencyFormat),
                      const Divider(),
                      _buildSummaryRow('Total', state.total, currencyFormat, isTotal: true),
                    ],
                  ),
                ),
                _buildSectionTitle('Payment Method'),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      RadioListTile(
                        title: const Text('Cash on Delivery'),
                        value: 'Cash on Delivery',
                        groupValue: _paymentMethod,
                        activeColor: Colors.green,
                        onChanged: (val) => setState(() => _paymentMethod = val.toString()),
                      ),
                      RadioListTile(
                        title: const Text('Credit/Debit Card'),
                        value: 'Card',
                        groupValue: _paymentMethod,
                        activeColor: Colors.green,
                        onChanged: (val) => setState(() => _paymentMethod = val.toString()),
                      ),
                      RadioListTile(
                        title: const Text('E-Wallet'),
                        value: 'E-Wallet',
                        groupValue: _paymentMethod,
                        activeColor: Colors.green,
                        onChanged: (val) => setState(() => _paymentMethod = val.toString()),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
      bottomSheet: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          if (cartState is! CartLoaded) return const SizedBox.shrink();
          
          return BlocConsumer<OrderBloc, OrderState>(
            listener: (context, orderState) {
              if (orderState is OrderPlaced) {
                context.read<CartBloc>().add(ClearCart());
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const OrderTrackingPage()),
                );
              } else if (orderState is OrderError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(orderState.message)));
              }
            },
            builder: (context, orderState) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, -5))],
                ),
                child: SafeArea(
                  child: ElevatedButton(
                    onPressed: orderState is OrderProcessing ? null : () {
                      final order = OrderModel(
                        id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
                        restaurant: cartState.restaurant!,
                        items: cartState.items,
                        subtotal: cartState.subtotal,
                        deliveryFee: cartState.deliveryFee,
                        serviceFee: cartState.serviceFee,
                        paymentMethod: _paymentMethod,
                        deliveryAddress: '123 Main Street, Apartment 4B',
                        createdAt: DateTime.now(),
                      );
                      context.read<OrderBloc>().add(PlaceOrder(order));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: orderState is OrderProcessing
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Place Order', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              Text(currencyFormat.format(cartState.total), style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  Widget _buildSummaryRow(String label, double value, NumberFormat format, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, fontSize: isTotal ? 16 : 14)),
          Text(format.format(value), style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, fontSize: isTotal ? 16 : 14)),
        ],
      ),
    );
  }
}
