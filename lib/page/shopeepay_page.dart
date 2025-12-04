import 'package:flutter/material.dart';

const shopeeOrange = Color(0xFFF75D34);
const headerOrange = Color(0xFFFF5B26);
const cardBg = Color(0xFFFFF7EC);
const pageBg = Colors.white;

class ShopeePayPage extends StatelessWidget {
  const ShopeePayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: headerOrange,
      body: SafeArea(
        child: Column(
          children: [
            _Header(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: pageBg,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: const _Body(),
              ),
            ),
            const _BottomNav(),
          ],
        ),
      ),
    );
  }
}
//Header
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: headerOrange,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Row(
        children: [
          const Icon(Icons.arrow_back, color: Colors.white),
          const SizedBox(width: 12),
          const Text(
            "ShopeePay",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              "PLUS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),
          //claim
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(Icons.monetization_on,
                    color: Colors.yellowAccent, size: 18),
                SizedBox(width: 4),
                Text(
                  "Klaim 50RB",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.white, size: 18),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.visibility, color: Colors.white),
        ],
      ),
    );
  }
}


class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _BalanceSection(),
          SizedBox(height: 16),
          _QuickActionSection(),
          SizedBox(height: 16),
          _GridMenuSection(),
          SizedBox(height: 20),
          _PromoCard(),
          SizedBox(height: 90),
        ],
      ),
    );
  }
}

class _BalanceSection extends StatelessWidget {
  const _BalanceSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: BalanceCardShopee(
                title: "ShopeePay",
                subtitle: "Rp 123.691",
                icon: Icons.account_balance_wallet_outlined,
                showSecondaryText: true,
                secondaryText:
                "Upgrade sekarang\nuntuk dapat bunga 6%!",
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: BalanceCardShopee(
                title: "SeaBank",
                subtitle: "Bunga cair setiap hari",
                icon: Icons.account_balance,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const BalanceCardShopee(
          title: "SP …",
          subtitle: "Rp 1.500.000",
          icon: Icons.credit_card,
          trailingText: "Perbarui Informasi",
        ),
      ],
    );
  }
}

class BalanceCardShopee extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? trailingText;
  final IconData icon;
  final bool showSecondaryText;
  final String? secondaryText;

  const BalanceCardShopee({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.trailingText,
    this.showSecondaryText = false,
    this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: showSecondaryText ? 96 : null,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          // watermark icon samar di kanan bawah
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              Icons.account_balance_wallet,
              size: 70,
              color: Colors.white.withOpacity(0.25),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 24, color: shopeeOrange),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    if (showSecondaryText && secondaryText != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        secondaryText!,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailingText != null)
                Text(
                  trailingText!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: shopeeOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}


class _QuickActionSection extends StatelessWidget {
  const _QuickActionSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: pageBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          MainMenuItemShopee(
            icon: Icons.add,
            label: "Isi Saldo",
            showBadge: true,
          ),
          MainMenuItemShopee(
            icon: Icons.qr_code_2,
            label: "Kode Bayar",
          ),
          MainMenuItemShopee(
            icon: Icons.send,
            label: "Kirim Uang",
          ),
          MainMenuItemShopee(
            icon: Icons.account_balance,
            label: "Kirim ke Bank",
            showBadge: true,
          ),
        ],
      ),
    );
  }
}

class MainMenuItemShopee extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool showBadge;

  const MainMenuItemShopee({
    super.key,
    required this.icon,
    required this.label,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: shopeeOrange.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: Icon(icon, color: shopeeOrange),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          if (showBadge)
            Positioned(
              top: -8,
              right: -6,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: shopeeOrange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "GRATIS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GridMenuSection extends StatelessWidget {
  const _GridMenuSection();

  @override
  Widget build(BuildContext context) {
    final items = [
      const FeatureMenuItemShopee(
        icon: Icons.account_balance_wallet,
        label: "Aplikasi ShopeePay",
        iconColor: Colors.orange,
      ),
      const FeatureMenuItemShopee(
        icon: Icons.money,
        label: "Tarik Tunai",
        iconColor: Colors.green,
      ),
      const FeatureMenuItemShopee(
        icon: Icons.location_on,
        label: "ShopeePay Sekitarmu",
        iconColor: Colors.red,
      ),
      const FeatureMenuItemShopee(
        icon: Icons.payments,
        label: "SPinjam",
        iconColor: Colors.orange,
      ),
      const FeatureMenuItemShopee(
        icon: Icons.swap_horiz,
        label: "Kirim ke E-Wallet",
        iconColor: Colors.cyan,
      ),
      const FeatureMenuItemShopee(
        icon: Icons.show_chart,
        label: "Reksa Dana",
        iconColor: Colors.green,
      ),
      const FeatureMenuItemShopee(
        icon: Icons.apple,
        label: "Apple Hub",
        iconColor: Colors.black,
      ),
      const FeatureMenuItemShopee(
        icon: Icons.grid_view,
        label: "Lihat Semua",
        iconColor: Colors.orange,
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 18,
      crossAxisSpacing: 6,
      childAspectRatio: 0.78,
      children: items,
    );
  }
}

class FeatureMenuItemShopee extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;

  const FeatureMenuItemShopee({
    super.key,
    required this.icon,
    required this.label,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ],
    );
  }
}


class _PromoCard extends StatelessWidget {
  const _PromoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: pageBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.local_offer, color: shopeeOrange),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Promo Aplikasi ShopeePay",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Gratis Koin s/d 50RB dengan Cek-in Setiap Hari!",
                  style: TextStyle(fontSize: 13, height: 1.3),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: shopeeOrange,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              elevation: 0,
            ),
            onPressed: () {},
            child: const Text(
              "Klaim",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
}


class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      decoration: const BoxDecoration(
        color: pageBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          BottomNavItem(icon: Icons.home, label: "Beranda", active: true),
          BottomNavItem(
              icon: Icons.account_balance_wallet_outlined, label: "Keuangan"),
          QRISNavButton(),
          BottomNavItem(icon: Icons.receipt_long_outlined, label: "Riwayat"),
          BottomNavItem(icon: Icons.person_outline, label: "Saya"),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? shopeeOrange : Colors.grey;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: color),
        ),
      ],
    );
  }
}

class QRISNavButton extends StatelessWidget {
  const QRISNavButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        color: shopeeOrange,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.qr_code_scanner,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}
