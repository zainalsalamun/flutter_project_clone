import 'package:flutter/material.dart';

class AnimatedCheckboxRadioShowcase extends StatefulWidget {
  const AnimatedCheckboxRadioShowcase({super.key});

  @override
  State<AnimatedCheckboxRadioShowcase> createState() =>
      _AnimatedCheckboxRadioShowcaseState();
}

class _AnimatedCheckboxRadioShowcaseState
    extends State<AnimatedCheckboxRadioShowcase> {
  // Checkbox states
  bool _cbSquare1 = true;
  bool _cbSquare2 = false;
  bool _cbCircle1 = true;
  bool? _cbIndeterminate; // null for indeterminate

  // Radio state (Payment method)
  String _selectedPayment = 'qris';

  // Toggle switch tile
  bool _isAutoRenew = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------------- SECTION 1: CUSTOM CHECKBOXES ----------------
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
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.check_box_rounded,
                      size: 16,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Custom Animated Checkboxes',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Square Checkboxes Row
              Row(
                children: [
                  Expanded(
                    child: _CustomCheckboxTile(
                      label: 'Square Box A',
                      value: _cbSquare1,
                      isCircular: false,
                      activeColor: const Color(0xFF6366F1),
                      onChanged:
                          (val) => setState(() => _cbSquare1 = val ?? false),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _CustomCheckboxTile(
                      label: 'Square Box B',
                      value: _cbSquare2,
                      isCircular: false,
                      activeColor: const Color(0xFF10B981),
                      onChanged:
                          (val) => setState(() => _cbSquare2 = val ?? false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Circle Checkbox & Indeterminate Row
              Row(
                children: [
                  Expanded(
                    child: _CustomCheckboxTile(
                      label: 'Circular Pill',
                      value: _cbCircle1,
                      isCircular: true,
                      activeColor: const Color(0xFFEC4899),
                      onChanged:
                          (val) => setState(() => _cbCircle1 = val ?? false),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _CustomCheckboxTile(
                      label: 'Indeterminate (-)',
                      value: _cbIndeterminate,
                      isCircular: false,
                      activeColor: const Color(0xFFF59E0B),
                      onChanged: (val) {
                        setState(() {
                          if (_cbIndeterminate == null) {
                            _cbIndeterminate = true;
                          } else if (_cbIndeterminate == true) {
                            _cbIndeterminate = false;
                          } else {
                            _cbIndeterminate = null;
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ---------------- SECTION 2: RADIO SELECTION TILES ----------------
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.radio_button_checked_rounded,
                          size: 16,
                          color: Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Pilihan Metode Bayar (Radio)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _selectedPayment.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              _CustomRadioCard(
                title: 'QRIS Instant Pay',
                subtitle: 'Scan via GoPay, OVO, BCA, Dana',
                icon: Icons.qr_code_scanner_rounded,
                value: 'qris',
                groupValue: _selectedPayment,
                badge: 'Gratis Biaya',
                badgeColor: const Color(0xFF10B981),
                onChanged: (val) => setState(() => _selectedPayment = val),
              ),
              const SizedBox(height: 8),

              _CustomRadioCard(
                title: 'Virtual Account Bank',
                subtitle: 'BCA, Mandiri, BNI, BRI (Auto-Check)',
                icon: Icons.account_balance_rounded,
                value: 'va',
                groupValue: _selectedPayment,
                onChanged: (val) => setState(() => _selectedPayment = val),
              ),
              const SizedBox(height: 8),

              _CustomRadioCard(
                title: 'Kartu Kredit / Debit',
                subtitle: 'Visa, Mastercard, JCB (Cicilan 0%)',
                icon: Icons.credit_card_rounded,
                value: 'cc',
                groupValue: _selectedPayment,
                badge: 'Diskon 10%',
                badgeColor: const Color(0xFFF59E0B),
                onChanged: (val) => setState(() => _selectedPayment = val),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ---------------- SECTION 3: SWITCH TILE ----------------
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            _isAutoRenew
                                ? const Color(0xFF6366F1).withValues(alpha: 0.1)
                                : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.autorenew_rounded,
                        size: 18,
                        color:
                            _isAutoRenew
                                ? const Color(0xFF6366F1)
                                : Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Perpanjangan Otomatis',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            'Perbarui paket langganan tiap bulan',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Switch.adaptive(
                value: _isAutoRenew,
                activeColor: const Color(0xFF6366F1),
                onChanged: (val) => setState(() => _isAutoRenew = val),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// CUSTOM CHECKBOX WIDGET
// ---------------------------------------------------------------------------
class _CustomCheckboxTile extends StatelessWidget {
  final String label;
  final bool? value; // null for indeterminate
  final bool isCircular;
  final Color activeColor;
  final ValueChanged<bool?> onChanged;

  const _CustomCheckboxTile({
    required this.label,
    required this.value,
    required this.isCircular,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isChecked = value == true;
    final isIndeterminate = value == null;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => onChanged(value == null ? true : !isChecked),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color:
              (isChecked || isIndeterminate)
                  ? activeColor.withValues(alpha: 0.06)
                  : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                (isChecked || isIndeterminate)
                    ? activeColor.withValues(alpha: 0.35)
                    : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color:
                    (isChecked || isIndeterminate)
                        ? activeColor
                        : Colors.transparent,
                shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: isCircular ? null : BorderRadius.circular(6),
                border: Border.all(
                  color:
                      (isChecked || isIndeterminate)
                          ? activeColor
                          : Colors.grey.shade400,
                  width: 2,
                ),
                boxShadow:
                    (isChecked || isIndeterminate)
                        ? [
                          BoxShadow(
                            color: activeColor.withValues(alpha: 0.35),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                        : null,
              ),
              child: Center(
                child:
                    isIndeterminate
                        ? Container(
                          width: 10,
                          height: 2.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        )
                        : isChecked
                        ? const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: Colors.white,
                        )
                        : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                      (isChecked || isIndeterminate)
                          ? FontWeight.bold
                          : FontWeight.w500,
                  color:
                      (isChecked || isIndeterminate)
                          ? const Color(0xFF0F172A)
                          : Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CUSTOM RADIO CARD WIDGET
// ---------------------------------------------------------------------------
class _CustomRadioCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String value;
  final String groupValue;
  final String? badge;
  final Color? badgeColor;
  final ValueChanged<String> onChanged;

  const _CustomRadioCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.groupValue,
    this.badge,
    this.badgeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFF6366F1).withValues(alpha: 0.05)
                  : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF6366F1) : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            // Left Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? const Color(0xFF6366F1).withValues(alpha: 0.12)
                        : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color:
                      isSelected
                          ? const Color(0xFF6366F1).withValues(alpha: 0.3)
                          : Colors.grey.shade200,
                ),
              ),
              child: Icon(
                icon,
                size: 20,
                color:
                    isSelected ? const Color(0xFF6366F1) : Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 12),

            // Middle Titles
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color:
                              isSelected
                                  ? const Color(0xFF0F172A)
                                  : Colors.grey.shade800,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: (badgeColor ?? const Color(0xFF10B981))
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badge!,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: badgeColor ?? const Color(0xFF10B981),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),

            // Right Custom Animated Radio Circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected
                          ? const Color(0xFF6366F1)
                          : Colors.grey.shade400,
                  width: isSelected ? 6 : 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
