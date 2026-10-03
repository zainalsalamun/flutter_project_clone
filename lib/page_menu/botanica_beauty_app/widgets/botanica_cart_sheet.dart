import 'package:flutter/material.dart';
import '../core/botanica_currency.dart';
import '../core/botanica_data.dart';
import '../core/botanica_theme.dart';
import '../models/botanica_models.dart';
import 'botanica_network_image.dart';

class BotanicaCartSheet extends StatefulWidget {
  const BotanicaCartSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const BotanicaCartSheet(),
    );
  }

  @override
  State<BotanicaCartSheet> createState() => _BotanicaCartSheetState();
}

class _BotanicaCartSheetState extends State<BotanicaCartSheet> {
  final TextEditingController _voucherController = TextEditingController();
  bool _isCheckingOut = false;

  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }

  void _applyVoucherCode() {
    final code = _voucherController.text.trim();
    if (code.isEmpty) return;

    final success = BotanicaData().applyVoucher(code);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Voucher $code berhasil digunakan!'),
          backgroundColor: const Color(0xFF047857),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kode voucher tidak valid. Coba: BOTANICAGLOW atau BEAUTY50'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _processCheckout() {
    setState(() {
      _isCheckingOut = true;
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6F3EF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF0F3E33),
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Pesanan Berhasil!',
                style: BotanicaTheme.font(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: BotanicaTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Terima kasih telah berbelanja di BOTANICA Beauty & Care. Resi pengiriman akan dikirimkan ke email Anda.',
                textAlign: TextAlign.center,
                style: BotanicaTheme.font(
                  fontSize: 12,
                  color: BotanicaTheme.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    BotanicaData().cartNotifier.value = [];
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BotanicaTheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    'Selesai',
                    style: BotanicaTheme.font(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shopping Bag',
                style: BotanicaTheme.font(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: BotanicaTheme.textPrimary,
                ),
              ),
              ValueListenableBuilder<List<BotanicaCartItem>>(
                valueListenable: BotanicaData().cartNotifier,
                builder: (context, items, _) {
                  return Text(
                    '${items.length} Items',
                    style: BotanicaTheme.font(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: BotanicaTheme.textTertiary,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Cart Items List
          Expanded(
            child: ValueListenableBuilder<List<BotanicaCartItem>>(
              valueListenable: BotanicaData().cartNotifier,
              builder: (context, items, _) {
                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_bag_outlined,
                          size: 48,
                          color: BotanicaTheme.textMuted,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Shopping bag Anda masih kosong',
                          style: BotanicaTheme.font(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: BotanicaTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (context, idx) => const Divider(height: 20, color: Color(0xFFF3F4F6)),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thumbnail
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: BotanicaTheme.cardBorder),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: BotanicaNetworkImage(
                              imageUrl: item.product.imageUrl,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.brand,
                                style: BotanicaTheme.font(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: BotanicaTheme.textTertiary,
                                ),
                              ),
                              Text(
                                item.product.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: BotanicaTheme.font(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: BotanicaTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Size: ${item.selectedSize}',
                                style: BotanicaTheme.font(
                                  fontSize: 11,
                                  color: BotanicaTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                formatBotanicaRupiah(item.product.price),
                                style: BotanicaTheme.font(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: BotanicaTheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Quantity Counter
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                BotanicaData().updateCartQuantity(index, item.quantity - 1);
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.remove, size: 14, color: BotanicaTheme.textPrimary),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '${item.quantity}',
                                style: BotanicaTheme.font(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                BotanicaData().updateCartQuantity(index, item.quantity + 1);
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.add, size: 14, color: BotanicaTheme.textPrimary),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Voucher Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: BotanicaTheme.cardBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_offer_outlined, color: BotanicaTheme.primary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _voucherController,
                    decoration: InputDecoration(
                      hintText: 'Kode promo (cth: BOTANICAGLOW)',
                      hintStyle: BotanicaTheme.font(fontSize: 12, color: BotanicaTheme.textTertiary),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _applyVoucherCode,
                  child: Text(
                    'Pakai',
                    style: BotanicaTheme.font(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: BotanicaTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Price Summary Box
          ValueListenableBuilder<List<BotanicaCartItem>>(
            valueListenable: BotanicaData().cartNotifier,
            builder: (context, items, _) {
              final subtotal = BotanicaData().cartTotalSubtotal;
              final discount = BotanicaData().voucherDiscountNotifier.value;
              final shipping = subtotal >= 250000 ? 0 : 20000;
              final finalTotal = BotanicaData().cartFinalTotal;

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal', style: BotanicaTheme.font(fontSize: 12, color: BotanicaTheme.textSecondary)),
                      Text(formatBotanicaRupiah(subtotal), style: BotanicaTheme.font(fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ongkos Kirim', style: BotanicaTheme.font(fontSize: 12, color: BotanicaTheme.textSecondary)),
                      Text(
                        shipping == 0 ? 'GRATIS' : formatBotanicaRupiah(shipping),
                        style: BotanicaTheme.font(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: shipping == 0 ? const Color(0xFF047857) : BotanicaTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  if (discount > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Diskon Voucher', style: BotanicaTheme.font(fontSize: 12, color: const Color(0xFFBE123C))),
                        Text('-${formatBotanicaRupiah(discount)}', style: BotanicaTheme.font(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFFBE123C))),
                      ],
                    ),
                  ],
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: Color(0xFFF3F4F6)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Pembayaran',
                        style: BotanicaTheme.font(fontSize: 14, fontWeight: FontWeight.w800, color: BotanicaTheme.textPrimary),
                      ),
                      Text(
                        formatBotanicaRupiah(finalTotal),
                        style: BotanicaTheme.font(fontSize: 16, fontWeight: FontWeight.w800, color: BotanicaTheme.primary),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),

          // Checkout Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isCheckingOut ? null : _processCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: BotanicaTheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: _isCheckingOut
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Checkout Sekarang',
                          style: BotanicaTheme.font(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
