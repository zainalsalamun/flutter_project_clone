import 'dart:math';
import 'package:flutter/material.dart';

class PasswordStrengthMeterShowcase extends StatefulWidget {
  const PasswordStrengthMeterShowcase({super.key});

  @override
  State<PasswordStrengthMeterShowcase> createState() =>
      _PasswordStrengthMeterShowcaseState();
}

class _PasswordStrengthMeterShowcaseState
    extends State<PasswordStrengthMeterShowcase> {
  final TextEditingController _controller = TextEditingController();
  bool _obscureText = true;

  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  int _strengthScore = 0; // 0 to 4

  @override
  void initState() {
    super.initState();
    _controller.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validatePassword() {
    final text = _controller.text;
    setState(() {
      _hasMinLength = text.length >= 8;
      _hasUppercase = text.contains(RegExp(r'[A-Z]'));
      _hasLowercase = text.contains(RegExp(r'[a-z]'));
      _hasNumber = text.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = text.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));

      int score = 0;
      if (_hasMinLength) score++;
      if (_hasUppercase && _hasLowercase) score++;
      if (_hasNumber) score++;
      if (_hasSpecialChar) score++;

      _strengthScore = text.isEmpty ? 0 : score;
    });
  }

  void _generateStrongPassword() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*';
    final random = Random.secure();
    final generated =
        List.generate(
          12,
          (index) => chars[random.nextInt(chars.length)],
        ).join();
    _controller.text = generated;
  }

  String _getStrengthLabel() {
    if (_controller.text.isEmpty) return 'Masukkan password';
    switch (_strengthScore) {
      case 1:
        return 'Sangat Lemah';
      case 2:
        return 'Cukup Lemah';
      case 3:
        return 'Kuat (Sedang)';
      case 4:
        return 'Sangat Kuat & Aman';
      default:
        return 'Sangat Lemah';
    }
  }

  Color _getStrengthColor() {
    if (_controller.text.isEmpty) return Colors.grey.shade300;
    switch (_strengthScore) {
      case 1:
        return const Color(0xFFEF4444); // Red
      case 2:
        return const Color(0xFFF97316); // Orange
      case 3:
        return const Color(0xFFF59E0B); // Amber
      case 4:
        return const Color(0xFF10B981); // Green
      default:
        return const Color(0xFFEF4444);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strengthColor = _getStrengthColor();
    final strengthLabel = _getStrengthLabel();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Main Input Card Container
        Container(
          padding: const EdgeInsets.all(18),
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
              // Header & Generate Action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kata Sandi / Password Baru',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF6366F1),
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                    ),
                    icon: const Icon(Icons.auto_awesome_rounded, size: 14),
                    label: const Text(
                      'Acak Kuat',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _generateStrongPassword,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Password TextField
              TextField(
                controller: _controller,
                obscureText: _obscureText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
                decoration: InputDecoration(
                  hintText: 'Ketik password Anda...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                    letterSpacing: 0,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: Color(0xFF6366F1),
                    size: 20,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_controller.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(
                            Icons.clear_rounded,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onPressed: () => _controller.clear(),
                        ),
                      IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          size: 18,
                          color: Colors.grey.shade600,
                        ),
                        onPressed:
                            () => setState(() => _obscureText = !_obscureText),
                      ),
                    ],
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

              // Strength Score Label & 4-Segment Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kekuatan Sandi:',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  Text(
                    strengthLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: strengthColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // 4-Segment Animated Progress Bar
              Row(
                children: List.generate(4, (index) {
                  final isActive =
                      _controller.text.isNotEmpty && index < _strengthScore;
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.only(right: index < 3 ? 5 : 0),
                      height: 5,
                      decoration: BoxDecoration(
                        color: isActive ? strengthColor : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),

              // Live Criteria Checklist Grid
              const Divider(height: 1),
              const SizedBox(height: 12),
              const Text(
                'Syarat Keamanan Password:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 8),

              _CriteriaItem(
                isValid: _hasMinLength,
                label: 'Minimal 8 karakter',
              ),
              const SizedBox(height: 5),
              _CriteriaItem(
                isValid: _hasUppercase && _hasLowercase,
                label: 'Kombinasi huruf besar (A-Z) & kecil (a-z)',
              ),
              const SizedBox(height: 5),
              _CriteriaItem(
                isValid: _hasNumber,
                label: 'Mengandung minimal 1 angka (0-9)',
              ),
              const SizedBox(height: 5),
              _CriteriaItem(
                isValid: _hasSpecialChar,
                label: 'Mengandung karakter unik (!@#\$%^&*)',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CriteriaItem extends StatelessWidget {
  final bool isValid;
  final String label;

  const _CriteriaItem({required this.isValid, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: isValid ? const Color(0xFF10B981) : Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isValid ? Icons.check_rounded : Icons.close_rounded,
            size: 11,
            color: isValid ? Colors.white : Colors.grey.shade500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isValid ? FontWeight.bold : FontWeight.normal,
              color: isValid ? const Color(0xFF0F172A) : Colors.grey.shade500,
            ),
          ),
        ),
      ],
    );
  }
}
