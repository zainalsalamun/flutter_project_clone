import 'package:flutter/material.dart';
import '../../core/warga_kita_currency.dart';
import '../../core/warga_kita_data.dart';
import '../../core/warga_kita_theme.dart';
import '../../models/warga_kita_models.dart';

class WargaKitaBukuKasScreen extends StatefulWidget {
  const WargaKitaBukuKasScreen({super.key});

  @override
  State<WargaKitaBukuKasScreen> createState() => _WargaKitaBukuKasScreenState();
}

class _WargaKitaBukuKasScreenState extends State<WargaKitaBukuKasScreen> {
  String _selectedFilter = 'Semua';

  List<KasTransaction> _getFiltered(List<KasTransaction> all) {
    if (_selectedFilter == 'Pemasukan') {
      return all.where((t) => t.isIncome).toList();
    } else if (_selectedFilter == 'Pengeluaran') {
      return all.where((t) => !t.isIncome).toList();
    }
    return all;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WargaKitaTheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: WargaKitaTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Buku Kas Transparan RT 04',
          style: WargaKitaTheme.font(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: WargaKitaTheme.textPrimary,
          ),
        ),
      ),
      body: ValueListenableBuilder<KasSummary>(
        valueListenable: WargaKitaData().kasSummaryNotifier,
        builder: (context, kas, _) {
          return ValueListenableBuilder<List<KasTransaction>>(
            valueListenable: WargaKitaData().transactionsNotifier,
            builder: (context, transactions, _) {
              final list = _getFiltered(transactions);

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Hero Balance Box
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF004D36), Color(0xFF047857)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: WargaKitaTheme.kasCardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Saldo Kas Kas Terverifikasi',
                              style: WargaKitaTheme.font(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                kas.lastAuditDate,
                                style: WargaKitaTheme.font(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF9FFDD3),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formatWargaRupiah(kas.totalKas),
                          style: WargaKitaTheme.font(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Divider(color: Colors.white24, height: 1),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pemasukan Bulan Ini',
                                    style: WargaKitaTheme.font(fontSize: 10, color: Colors.white70),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '+${formatWargaRupiahClean(kas.monthlyIncome)}',
                                    style: WargaKitaTheme.font(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF6CF8BB),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pengeluaran Bulan Ini',
                                    style: WargaKitaTheme.font(fontSize: 10, color: Colors.white70),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '-${formatWargaRupiahClean(kas.monthlyExpense)}',
                                    style: WargaKitaTheme.font(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFFFFB3AD),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Filter Row
                  Row(
                    children: ['Semua', 'Pemasukan', 'Pengeluaran'].map((tab) {
                      final isSel = _selectedFilter == tab;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(tab),
                          selected: isSel,
                          selectedColor: WargaKitaTheme.primaryContainer,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSel ? Colors.white : WargaKitaTheme.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSel ? WargaKitaTheme.primaryContainer : WargaKitaTheme.cardBorder,
                            ),
                          ),
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedFilter = tab);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Transactions List
                  ...list.map((tx) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: WargaKitaTheme.cardBorder),
                        boxShadow: WargaKitaTheme.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: tx.isIncome
                                      ? const Color(0xFFECFDF5)
                                      : const Color(0xFFFFEBEB),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  tx.isIncome
                                      ? Icons.arrow_downward_rounded
                                      : Icons.arrow_upward_rounded,
                                  color: tx.isIncome
                                      ? const Color(0xFF047857)
                                      : const Color(0xFFDC2626),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tx.title,
                                      style: WargaKitaTheme.font(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: WargaKitaTheme.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${tx.date} • Ref: ${tx.receiptNumber}',
                                      style: WargaKitaTheme.font(
                                        fontSize: 11,
                                        color: WargaKitaTheme.textTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${tx.isIncome ? '+' : '-'}${formatWargaRupiah(tx.amount)}',
                                style: WargaKitaTheme.font(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: tx.isIncome
                                      ? const Color(0xFF047857)
                                      : const Color(0xFFDC2626),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.verified_user_rounded, color: Color(0xFF047857), size: 14),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    tx.verifiedBy,
                                    style: WargaKitaTheme.font(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: WargaKitaTheme.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
