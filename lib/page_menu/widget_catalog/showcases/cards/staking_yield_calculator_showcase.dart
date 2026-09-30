import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum _CompoundMode {
  daily('Harian (Daily 365x)', 365),
  monthly('Bulanan (Monthly 12x)', 12),
  simple('Bunga Sederhana (Simple)', 1);

  final String label;
  final int freq;
  const _CompoundMode(this.label, this.freq);
}

class _StakingAsset {
  final String symbol;
  final String name;
  final double baseApy;
  final Color color;
  final IconData icon;

  const _StakingAsset({
    required this.symbol,
    required this.name,
    required this.baseApy,
    required this.color,
    required this.icon,
  });
}

class _LockDuration {
  final String label;
  final int days;
  final double boostApy;

  const _LockDuration(this.label, this.days, this.boostApy);
}

class StakingYieldCalculatorShowcase extends StatefulWidget {
  const StakingYieldCalculatorShowcase({super.key});

  @override
  State<StakingYieldCalculatorShowcase> createState() =>
      _StakingYieldCalculatorShowcaseState();
}

class _StakingYieldCalculatorShowcaseState
    extends State<StakingYieldCalculatorShowcase> {
  double _depositAmount = 5000.0;

  final List<_StakingAsset> _assets = const [
    _StakingAsset(
      symbol: 'USDT',
      name: 'Tether USD',
      baseApy: 8.5,
      color: Color(0xFF26A17B),
      icon: Icons.monetization_on_rounded,
    ),
    _StakingAsset(
      symbol: 'ETH',
      name: 'Ethereum',
      baseApy: 4.8,
      color: Color(0xFF627EEA),
      icon: Icons.diamond_rounded,
    ),
    _StakingAsset(
      symbol: 'SOL',
      name: 'Solana',
      baseApy: 7.2,
      color: Color(0xFF14F195),
      icon: Icons.bolt_rounded,
    ),
    _StakingAsset(
      symbol: 'DOT',
      name: 'Polkadot',
      baseApy: 12.0,
      color: Color(0xFFE6007A),
      icon: Icons.blur_circular_rounded,
    ),
  ];

  late _StakingAsset _selectedAsset;

  final List<_LockDuration> _durations = const [
    _LockDuration('Flexible', 0, 0.0),
    _LockDuration('30 Hari', 30, 1.5),
    _LockDuration('90 Hari', 90, 3.8),
    _LockDuration('365 Hari', 365, 7.5),
  ];

  late _LockDuration _selectedDuration;
  _CompoundMode _compoundMode = _CompoundMode.daily;

  @override
  void initState() {
    super.initState();
    _selectedAsset = _assets.first;
    _selectedDuration = _durations[2]; // 90 days default
  }

  double get _effectiveApy =>
      _selectedAsset.baseApy + _selectedDuration.boostApy;

  // Calculate Compounded Final Balance
  double get _finalBalance {
    final r = _effectiveApy / 100.0;
    final years =
        (_selectedDuration.days == 0 ? 365 : _selectedDuration.days) / 365.0;

    if (_compoundMode == _CompoundMode.simple) {
      return _depositAmount * (1.0 + (r * years));
    } else {
      final n = _compoundMode.freq.toDouble();
      return _depositAmount * math.pow(1.0 + (r / n), n * years);
    }
  }

  double get _totalProfit => _finalBalance - _depositAmount;
  double get _dailyProfit =>
      _totalProfit /
      (_selectedDuration.days == 0 ? 365 : _selectedDuration.days);
  double get _monthlyProfit => _dailyProfit * 30.0;

  String _formatCurrency(double val) {
    return '\$${val.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  void _showStakeConfirmationModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (ctx) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _selectedAsset.color.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _selectedAsset.icon,
                        color: _selectedAsset.color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Konfirmasi Staking ${_selectedAsset.symbol}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Durasi: ${_selectedDuration.label} • APY: ${_effectiveApy.toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildModalRow(
                        'Nominal Deposit',
                        _formatCurrency(_depositAmount),
                      ),
                      const SizedBox(height: 8),
                      _buildModalRow(
                        'Estimasi Reward',
                        '+${_formatCurrency(_totalProfit)}',
                        isHighlight: true,
                      ),
                      const SizedBox(height: 8),
                      _buildModalRow(
                        'Total Saldo Akhir',
                        _formatCurrency(_finalBalance),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    Navigator.pop(ctx);
                    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Berhasil mengunci ${_formatCurrency(_depositAmount)} ${_selectedAsset.symbol} ke Staking Pool!',
                        ),
                        backgroundColor: const Color(0xFF10B981),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedAsset.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Kunci & Mulai Hasilkan Yield',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildModalRow(String title, String val, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
        Text(
          val,
          style: TextStyle(
            color: isHighlight ? const Color(0xFF10B981) : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. HEADER INFO CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    isDark
                        ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                        : [Colors.white, const Color(0xFFF8FAFC)],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black12,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _selectedAsset.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.account_balance_rounded,
                    color: _selectedAsset.color,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DeFi Staking & APY Calculator',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Kalkulator bunga majemuk staking aset kripto & tier vault.',
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF10B981)),
                  ),
                  child: Text(
                    '${_effectiveApy.toStringAsFixed(1)}% APY',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. ASSET SELECTOR CHIPS
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  _assets.map((asset) {
                    final isSelected = _selectedAsset.symbol == asset.symbol;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        avatar: Icon(
                          asset.icon,
                          color: isSelected ? Colors.white : asset.color,
                          size: 16,
                        ),
                        label: Text('${asset.symbol} (${asset.baseApy}% Base)'),
                        selected: isSelected,
                        selectedColor: asset.color,
                        onSelected: (val) {
                          if (val) {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedAsset = asset);
                          }
                        },
                      ),
                    );
                  }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // 3. DEPOSIT INPUT CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B1120) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black12,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Jumlah Deposit Staking',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      _formatCurrency(_depositAmount),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: _selectedAsset.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: _selectedAsset.color,
                    thumbColor: _selectedAsset.color,
                    overlayColor: _selectedAsset.color.withValues(alpha: 0.2),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: _depositAmount,
                    min: 100,
                    max: 50000,
                    divisions: 499,
                    onChanged: (val) => setState(() => _depositAmount = val),
                  ),
                ),
                // Quick Presets
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                      [500.0, 2500.0, 10000.0, 50000.0].map((amt) {
                        final isSel = _depositAmount.toInt() == amt.toInt();
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _depositAmount = amt);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSel
                                      ? _selectedAsset.color.withValues(
                                        alpha: 0.2,
                                      )
                                      : (isDark
                                          ? Colors.white10
                                          : Colors.black.withValues(
                                            alpha: 0.05,
                                          )),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                    isSel
                                        ? _selectedAsset.color
                                        : Colors.transparent,
                              ),
                            ),
                            child: Text(
                              amt >= 1000
                                  ? '\$${(amt / 1000).toInt()}k'
                                  : '\$${amt.toInt()}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight:
                                    isSel ? FontWeight.bold : FontWeight.normal,
                                color:
                                    isSel
                                        ? _selectedAsset.color
                                        : (isDark
                                            ? Colors.white70
                                            : Colors.black87),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),

                const SizedBox(height: 18),
                const Divider(height: 1),
                const SizedBox(height: 14),

                // Lock Period Selector
                const Text(
                  'Periode Penguncian (Lock Tier):',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children:
                      _durations.map((dur) {
                        final isSel = _selectedDuration.days == dur.days;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() => _selectedDuration = dur);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color:
                                    isSel
                                        ? _selectedAsset.color.withValues(
                                          alpha: 0.2,
                                        )
                                        : (isDark
                                            ? const Color(0xFF1E293B)
                                            : const Color(0xFFF1F5F9)),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color:
                                      isSel
                                          ? _selectedAsset.color
                                          : Colors.transparent,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    dur.label,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    dur.boostApy > 0
                                        ? '+${dur.boostApy}%'
                                        : 'Std',
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      color:
                                          dur.boostApy > 0
                                              ? const Color(0xFF10B981)
                                              : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),

                const SizedBox(height: 14),

                // Compounding Mode Switcher
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Frekuensi Bunga Majemuk:',
                      style: TextStyle(fontSize: 11.5, color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? Colors.white12 : Colors.black12,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<_CompoundMode>(
                          value: _compoundMode,
                          isDense: true,
                          isExpanded: true,
                          dropdownColor:
                              isDark ? const Color(0xFF1E293B) : Colors.white,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                          items:
                              _CompoundMode.values.map((m) {
                                return DropdownMenuItem(
                                  value: m,
                                  child: Text(m.label),
                                );
                              }).toList(),
                          onChanged: (val) {
                            if (val != null)
                              setState(() => _compoundMode = val);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // 4. PROJECTED RETURNS SUMMARY CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    isDark
                        ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                        : [const Color(0xFFF8FAFC), Colors.white],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF10B981).withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildReturnMetric(
                        'Reward Harian',
                        _formatCurrency(_dailyProfit),
                        const Color(0xFF38BDF8),
                      ),
                    ),
                    Expanded(
                      child: _buildReturnMetric(
                        'Reward Bulanan',
                        _formatCurrency(_monthlyProfit),
                        const Color(0xFF6366F1),
                      ),
                    ),
                    Expanded(
                      child: _buildReturnMetric(
                        'Total Profit Laba',
                        '+${_formatCurrency(_totalProfit)}',
                        const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Total Portofolio Akhir:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      _formatCurrency(_finalBalance),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _showStakeConfirmationModal,
                    icon: const Icon(Icons.lock_clock_rounded),
                    label: Text('Mulai Staking ${_selectedAsset.symbol}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedAsset.color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReturnMetric(String title, String val, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 10.5, color: Colors.grey),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          val,
          style: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
