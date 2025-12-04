import 'package:flutter/material.dart';

class OVOHomePage extends StatelessWidget {
  const OVOHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDD7F6),
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: const [
                    SizedBox(height: 10),
                    _BalanceCard(),
                    SizedBox(height: 12),
                    _InfoBanner(),
                    SizedBox(height: 8),
                    _CategoryTabs(),
                    SizedBox(height: 8),
                    _GridFavoriteMenu(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const _BottomNav(),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "OVO",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6A33AA),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFAA95DA),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: const [
                Icon(Icons.discount, color: Colors.white, size: 18),
                SizedBox(width: 6),
                Text(
                  "Promo",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF776BE8), Color(0xFF4E54C8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "OVO Nabung • 030011400618",
            style: TextStyle(fontSize: 13, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            "Total Saldo",
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 2),
          const Text(
            "Rp 34.426",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _BalanceAction(icon: Icons.add_circle_outline, label: "Top Up"),
              _BalanceAction(icon: Icons.north_east, label: "Transfer"),
              _BalanceAction(icon: Icons.payments, label: "Tarik Tunai"),
              _BalanceAction(icon: Icons.menu, label: "History"),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BalanceAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF104E96),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: const [
          Icon(Icons.info, color: Colors.white, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "BARU! Ajukan pinjaman, beli tiket & belanja langsung dari homepage OVO",
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _TabItem("Favorit", active: true),
          _TabItem("Finansial"),
          _TabItem("Hiburan"),
          _TabItem("Pilihan Lain"),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String text;
  final bool active;

  const _TabItem(this.text, {this.active = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? const Color(0xFF6A33AA) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
              color: active ? const Color(0xFF6A33AA) : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}

class _GridFavoriteMenu extends StatelessWidget {
  const _GridFavoriteMenu();

  @override
  Widget build(BuildContext context) {
    final items = [
      _GridIconItem(Icons.volunteer_activism, "Pinjaman", badge: "BARU"),
      _GridIconItem(Icons.credit_card, "Uang Elektronik"),
      _GridIconItem(Icons.list_alt, "Angsuran Kredit"),
      _GridIconItem(Icons.phone_android, "Pulsa/Paket Data"),
      _GridIconItem(Icons.bolt, "PLN"),
      _GridIconItem(Icons.water_drop, "Air PDAM"),
      _GridIconItem(Icons.tv, "Internet & TV Kabel"),
      _GridIconItem(Icons.health_and_safety, "BPJS Kesehatan"),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 0.82,
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        children: items,
      ),
    );
  }
}

class _GridIconItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badge;

  const _GridIconItem(this.icon, this.label, {this.badge});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF1ECFF),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: const Color(0xFF6A33AA)),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
            ),
          ],
        ),
        if (badge != null)
          Positioned(
            top: -2,
            right: -3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badge!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _BottomNavItem(Icons.home, "Home", active: true),
          _BottomNavItem(Icons.account_balance_wallet, "Finance"),
          _PayButton(),
          _BottomNavItem(Icons.notifications, "Inbox"),
          _BottomNavItem(Icons.person, "Profile"),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool active;

  const _BottomNavItem(this.icon, this.text, {this.active = false});

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF6A33AA) : Colors.grey;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 4),
        Text(text, style: TextStyle(fontSize: 11, color: color)),
      ],
    );
  }
}

class _PayButton extends StatelessWidget {
  const _PayButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 66,
      height: 66,
      decoration: BoxDecoration(
        color: const Color(0xFF6A33AA),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 32),
    );
  }
}
