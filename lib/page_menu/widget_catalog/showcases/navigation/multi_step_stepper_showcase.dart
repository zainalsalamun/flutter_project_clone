import 'package:flutter/material.dart';

class MultiStepStepperShowcase extends StatefulWidget {
  const MultiStepStepperShowcase({super.key});

  @override
  State<MultiStepStepperShowcase> createState() =>
      _MultiStepStepperShowcaseState();
}

class _MultiStepStepperShowcaseState extends State<MultiStepStepperShowcase> {
  int _currentStep = 1;
  final List<String> _stepTitles = [
    'Address',
    'Shipping',
    'Payment',
    'Confirm',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Stepper Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_stepTitles.length, (index) {
                  final isDone = index < _currentStep;
                  final isCurrent = index == _currentStep;

                  return Expanded(
                    child: Row(
                      children: [
                        // Step Node Circle
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color:
                                isDone
                                    ? const Color(0xFF10B981)
                                    : isCurrent
                                    ? const Color(0xFF6366F1)
                                    : Colors.grey.shade200,
                            shape: BoxShape.circle,
                            boxShadow:
                                isCurrent
                                    ? [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF6366F1,
                                        ).withValues(alpha: 0.4),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                    : null,
                          ),
                          child: Center(
                            child:
                                isDone
                                    ? const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    )
                                    : Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color:
                                            isCurrent
                                                ? Colors.white
                                                : Colors.grey.shade600,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                          ),
                        ),

                        // Connecting Line (except last item)
                        if (index < _stepTitles.length - 1)
                          Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 3,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color:
                                    isDone
                                        ? const Color(0xFF10B981)
                                        : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),

              // Step Label
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_stepTitles.length, (index) {
                  final isCurrent = index == _currentStep;
                  return Text(
                    _stepTitles[index],
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                      color:
                          isCurrent
                              ? const Color(0xFF6366F1)
                              : Colors.grey.shade500,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Step Content Box
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Container(
            key: ValueKey('step_$_currentStep'),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.verified_user_rounded,
                        color: Color(0xFF6366F1),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Step ${_currentStep + 1}: ${_stepTitles[_currentStep]}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _currentStep == 0
                      ? 'Please verify your billing and destination delivery address.'
                      : _currentStep == 1
                      ? 'Select express or standard courier shipping options.'
                      : _currentStep == 2
                      ? 'Choose credit card, bank transfer, or e-wallet.'
                      : 'Review full order summary before final placement.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),

        // Navigation Action Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed:
                  _currentStep > 0
                      ? () => setState(() => _currentStep--)
                      : null,
              child: const Text('Previous'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed:
                  _currentStep < _stepTitles.length - 1
                      ? () => setState(() => _currentStep++)
                      : () => setState(() => _currentStep = 0),
              child: Text(
                _currentStep < _stepTitles.length - 1 ? 'Next Step' : 'Restart',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
