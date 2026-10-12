import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreditCardInputShowcase extends StatefulWidget {
  const CreditCardInputShowcase({super.key});

  @override
  State<CreditCardInputShowcase> createState() =>
      _CreditCardInputShowcaseState();
}

class _CreditCardInputShowcaseState extends State<CreditCardInputShowcase> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _holderController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  _CardBrand _detectedBrand = _CardBrand.other;
  bool _isCvvHidden = true;

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_onCardNumberChanged);
    _holderController.addListener(() => setState(() {}));
    _expiryController.addListener(() => setState(() {}));
    _cvvController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _holderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _onCardNumberChanged() {
    final clean = _cardNumberController.text.replaceAll(' ', '');
    setState(() {
      if (clean.startsWith('4')) {
        _detectedBrand = _CardBrand.visa;
      } else if (clean.startsWith('51') ||
          clean.startsWith('52') ||
          clean.startsWith('53') ||
          clean.startsWith('54') ||
          clean.startsWith('55')) {
        _detectedBrand = _CardBrand.mastercard;
      } else if (clean.startsWith('35')) {
        _detectedBrand = _CardBrand.jcb;
      } else if (clean.startsWith('6019') || clean.startsWith('6011')) {
        _detectedBrand = _CardBrand.bca;
      } else {
        _detectedBrand = _CardBrand.other;
      }
    });
  }

  void _submitCard() {
    if (_cardNumberController.text.length < 19) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nomor kartu kredit belum lengkap (16 digit).'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.verified_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Kartu ${_detectedBrand.name.toUpperCase()} berhasil diverifikasi!',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardNumberDisplay =
        _cardNumberController.text.isEmpty
            ? '••••  ••••  ••••  ••••'
            : _cardNumberController.text;

    final holderDisplay =
        _holderController.text.isEmpty
            ? 'NAMA PEMILIK KARTU'
            : _holderController.text.toUpperCase();

    final expiryDisplay =
        _expiryController.text.isEmpty ? 'MM/YY' : _expiryController.text;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------------- 1. LIVE VIRTUAL CARD PREVIEW ----------------
        Container(
          height: 190,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _getCardGradient(_detectedBrand),
            ),
            boxShadow: [
              BoxShadow(
                color: _getCardGradient(
                  _detectedBrand,
                ).first.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Row: EMV Golden Chip + Brand Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // EMV Chip
                  Container(
                    width: 38,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFDE047), Color(0xFFD97706)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(0xFFB45309),
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            width: 24,
                            height: 1,
                            color: Colors.brown.withValues(alpha: 0.5),
                          ),
                        ),
                        Center(
                          child: Container(
                            height: 18,
                            width: 1,
                            color: Colors.brown.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Brand Badge / Logo
                  _buildBrandBadge(_detectedBrand),
                ],
              ),

              // Middle: Formatted Card Number
              Text(
                cardNumberDisplay,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  fontFamily: 'monospace',
                  shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                ),
              ),

              // Bottom Row: Holder Name & Valid Thru
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CARD HOLDER',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 8.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          holderDisplay,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'EXPIRES',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 8.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        expiryDisplay,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ---------------- 2. CARD INPUT FORM FIELDS ----------------
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
              // 1. Card Number Input
              _buildInputLabel('Nomor Kartu'),
              const SizedBox(height: 6),
              TextField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  _CardNumberInputFormatter(),
                ],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.5,
                ),
                decoration: InputDecoration(
                  hintText: '4000 1234 5678 9010',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  prefixIcon: const Icon(
                    Icons.credit_card_rounded,
                    color: Color(0xFF6366F1),
                    size: 20,
                  ),
                  suffixIcon:
                      _detectedBrand != _CardBrand.other
                          ? Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              _detectedBrand.name.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF6366F1),
                              ),
                            ),
                          )
                          : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF6366F1),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 2. Card Holder Name Input
              _buildInputLabel('Nama Lengkap Pemilik Kartu'),
              const SizedBox(height: 6),
              TextField(
                controller: _holderController,
                textCapitalization: TextCapitalization.characters,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.5,
                ),
                decoration: InputDecoration(
                  hintText: 'CONTOH: BUDI SANTOSO',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  prefixIcon: const Icon(
                    Icons.person_outline_rounded,
                    color: Color(0xFF6366F1),
                    size: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF6366F1),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 3. Expiry & CVV Row
              Row(
                children: [
                  // Expiry
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel('Masa Berlaku'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _expiryController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                            _CardExpiryInputFormatter(),
                          ],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                          ),
                          decoration: InputDecoration(
                            hintText: 'MM/YY',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 13,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            prefixIcon: const Icon(
                              Icons.calendar_today_rounded,
                              color: Color(0xFF6366F1),
                              size: 18,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade200,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade200,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF6366F1),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // CVV
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel('Kode CVV / CVC'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _cvvController,
                          keyboardType: TextInputType.number,
                          obscureText: _isCvvHidden,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                          ),
                          decoration: InputDecoration(
                            hintText: '123',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 13,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            prefixIcon: const Icon(
                              Icons.security_rounded,
                              color: Color(0xFF6366F1),
                              size: 18,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isCvvHidden
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                size: 16,
                                color: Colors.grey,
                              ),
                              onPressed:
                                  () => setState(
                                    () => _isCvvHidden = !_isCvvHidden,
                                  ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade200,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade200,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF6366F1),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Submit Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.lock_rounded, size: 16),
                  label: const Text(
                    'Simpan & Verifikasi Kartu',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _submitCard,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.bold,
        color: Color(0xFF334155),
      ),
    );
  }

  Widget _buildBrandBadge(_CardBrand brand) {
    String label = 'CREDIT';
    Color color = Colors.white;

    switch (brand) {
      case _CardBrand.visa:
        label = 'VISA';
        color = const Color(0xFF38BDF8);
        break;
      case _CardBrand.mastercard:
        label = 'MASTERCARD';
        color = const Color(0xFFF97316);
        break;
      case _CardBrand.jcb:
        label = 'JCB';
        color = const Color(0xFF10B981);
        break;
      case _CardBrand.bca:
        label = 'BCA CARD';
        color = const Color(0xFF60A5FA);
        break;
      case _CardBrand.other:
        label = 'CREDIT / DEBIT';
        color = Colors.white70;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  List<Color> _getCardGradient(_CardBrand brand) {
    switch (brand) {
      case _CardBrand.visa:
        return const [Color(0xFF1E3A8A), Color(0xFF3B82F6)]; // Deep Blue
      case _CardBrand.mastercard:
        return const [Color(0xFF7C2D12), Color(0xFFEA580C)]; // Warm Orange/Red
      case _CardBrand.jcb:
        return const [Color(0xFF064E3B), Color(0xFF059669)]; // Emerald Green
      case _CardBrand.bca:
        return const [Color(0xFF1E1B4B), Color(0xFF4338CA)]; // BCA Indigo
      case _CardBrand.other:
        return const [Color(0xFF0F172A), Color(0xFF334155)]; // Dark Slate
    }
  }
}

enum _CardBrand { visa, mastercard, jcb, bca, other }

// ---------------------------------------------------------------------------
// FORMATTER: CARD NUMBER (XXXX XXXX XXXX XXXX)
// ---------------------------------------------------------------------------
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(' ', '');
    if (text.length > 16) {
      text = text.substring(0, 16);
    }

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }

    final string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

// ---------------------------------------------------------------------------
// FORMATTER: CARD EXPIRY (MM/YY)
// ---------------------------------------------------------------------------
class _CardExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll('/', '');
    if (text.length > 4) {
      text = text.substring(0, 4);
    }

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 && text.length > 2) {
        buffer.write('/');
      }
    }

    final string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
