import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../bloc/cart/cart_bloc.dart';
import '../main_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is! CartLoaded) return const SizedBox.shrink();

          return Stepper(
            type: StepperType.horizontal,
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep < 2) {
                setState(() => _currentStep += 1);
              } else {
                _processPayment(context);
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep -= 1);
              }
            },
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: details.onStepContinue,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _currentStep == 2 ? 'Place Order' : 'Continue',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                    if (_currentStep > 0) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: details.onStepCancel,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            foregroundColor: Colors.blueAccent,
                            side: const BorderSide(color: Colors.blueAccent, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Back',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
            steps: [
              Step(
                title: const Text('Address'),
                content: const _AddressForm(),
                isActive: _currentStep >= 0,
              ),
              Step(
                title: const Text('Payment'),
                content: const _PaymentMethodSelection(),
                isActive: _currentStep >= 1,
              ),
              Step(
                title: const Text('Summary'),
                content: _OrderSummary(total: state.total),
                isActive: _currentStep >= 2,
              ),
            ],
          );
        },
      ),
    );
  }

  void _processPayment(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // hide loading
      context.read<CartBloc>().add(ClearCart());
      _showSuccessScreen(context);
    });
  }

  void _showSuccessScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 100),
                const SizedBox(height: 24),
                const Text('Payment Successful!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Text('Your order is being processed.', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainPage()));
                  },
                  child: const Text('Back to Home'),
                )
              ],
            ),
          ),
        ),
      ),
      (route) => false,
    );
  }
}

class _AddressForm extends StatelessWidget {
  const _AddressForm();

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      alignLabelWithHint: true,
      filled: true,
      fillColor: Colors.grey.shade100,
      prefixIcon: Icon(icon, color: Colors.blueAccent),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(decoration: _inputDecoration('Full Name', Icons.person)),
        const SizedBox(height: 16),
        TextField(
          decoration: _inputDecoration('Address', Icons.location_on),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: _inputDecoration('Phone Number', Icons.phone),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }
}

class _PaymentMethodSelection extends StatelessWidget {
  const _PaymentMethodSelection();

  Widget _buildPaymentOption(String title, IconData icon, int value) {
    bool isSelected = value == 1; // 1 is default selected in this demo
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: RadioListTile(
        value: value,
        groupValue: 1,
        onChanged: (val) {},
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        secondary: Icon(icon, color: Colors.blueAccent),
        activeColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPaymentOption('Credit Card', Icons.credit_card, 1),
        _buildPaymentOption('Bank Transfer', Icons.account_balance, 2),
        _buildPaymentOption('E-Wallet', Icons.account_balance_wallet, 3),
      ],
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final double total;
  const _OrderSummary({required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Items Total', style: TextStyle(color: Colors.grey)),
        Text(CurrencyFormatter.format(total), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Divider(height: 32),
        const Text('Shipping', style: TextStyle(color: Colors.grey)),
        Text(CurrencyFormatter.format(10.0), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Divider(height: 32),
        const Text('Grand Total', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(CurrencyFormatter.format(total + 10.0), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
      ],
    );
  }
}
