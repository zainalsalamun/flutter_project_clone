import 'dart:ui';
import 'package:flutter/material.dart';

class OVOColor {
  static const purple = Color(0xFF6A33AA);
  static const purpleSoft = Color(0xFFB9A7EA);
  static const gradient1 = Color(0xFF725CE9);
  static const gradient2 = Color(0xFF4E54C8);
  static const iconBg = Color(0xFFF3EEFF);
}

class BalanceController extends ChangeNotifier {
  double offset = 0;
  void updateOffset(double v) {
    offset = v;
    notifyListeners();
  }
}

class OVOHomePage extends StatefulWidget {
  const OVOHomePage({super.key});

  @override
  State<OVOHomePage> createState() => _OVOHomePageState();
}

class _OVOHomePageState extends State<OVOHomePage> {
  final balanceController = BalanceController();

  @override
  Widget build(BuildContext context) {
    final status = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFE9E3FF),
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n.metrics.axis == Axis.vertical) {
                balanceController.updateOffset(n.metrics.pixels);
              }
              return false;
            },
            child: Padding(
              padding: EdgeInsets.only(top: status + 60), // 🔥 FIXED
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),

                    const _AnimatedBalanceCard(),
                    const _BySuperbankLabel(),

                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(28),
                        ),
                      ),
                      padding: const EdgeInsets.only(top: 16, bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const [
                          _InfoBanner(),
                          SizedBox(height: 10),
                          _CategoryTabs(),
                          SizedBox(height: 10),
                          _GridFavoriteMenu(),
                          SizedBox(height: 10),
                          _ParallaxBanner(),
                          SizedBox(height: 24),
                          _RecommendationSection(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Container(
            height: status + 70,
            width: double.infinity,
            padding: EdgeInsets.only(top: status + 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFD4C8FF), Color(0xFFE9E3FF)],
              ),
            ),
            child: const _Header(),
          ),

          const Positioned(right: 16, bottom: 100, child: _StampButton()),
        ],
      ),
      bottomNavigationBar: const _BottomNav(),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "OVO",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: OVOColor.purple,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: OVOColor.purpleSoft,
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
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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

class _BySuperbankLabel extends StatelessWidget {
  const _BySuperbankLabel();

  @override
  Widget build(BuildContext context) {
    final scroll =
        context
            .findAncestorStateOfType<_OVOHomePageState>()!
            .balanceController
            .offset;
    final collapsed = scroll > 60;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: collapsed ? 0 : 1,
      child: Padding(
        padding: const EdgeInsets.only(left: 28, top: 4),
        child: Row(
          children: const [
            Text("by ", style: TextStyle(color: Colors.black45, fontSize: 11)),
            Text(
              "superbank",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedBalanceCard extends StatelessWidget {
  const _AnimatedBalanceCard();

  @override
  Widget build(BuildContext context) {
    final controller =
        context.findAncestorStateOfType<_OVOHomePageState>()!.balanceController;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final scroll = controller.offset;

        final collapse = scroll.clamp(0, 140).toDouble();
        final isCollapsed = collapse > 60;

        final scale = (1 - (collapse / 650)).clamp(0.75, 1).toDouble();
        final translateY = -(collapse / 3).toDouble();
        final opacity = (1 - (collapse / 240)).clamp(0.4, 1).toDouble();

        final blurSigma = (collapse / 25).clamp(0, 6).toDouble();
        final shadowBlur = (collapse / 14).clamp(0, 8).toDouble();

        return Transform.translate(
          offset: Offset(0, translateY),
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.topCenter,
            child: Opacity(
              opacity: opacity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: Stack(
                  children: [
                    if (blurSigma > 0)
                      BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: blurSigma,
                          sigmaY: blurSigma,
                        ),
                        child: Container(color: Colors.white.withOpacity(0.05)),
                      ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.18),
                            blurRadius: shadowBlur,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: _BalanceCard(isCollapsed: isCollapsed),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final bool isCollapsed;
  const _BalanceCard({this.isCollapsed = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 230),
      margin: const EdgeInsets.symmetric(horizontal: 22),
      padding: EdgeInsets.all(isCollapsed ? 16 : 20),
      height: isCollapsed ? 110 : null,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [OVOColor.gradient1, OVOColor.gradient2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: isCollapsed ? _collapsedView() : _expandedView(),
    );
  }

  Widget _expandedView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "OVO Nabung • 0300114890000",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),

        const SizedBox(height: 10),

        const Text(
          "Total Saldo",
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),

        const SizedBox(height: 4),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Rp 12.525",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                "313 Points",
                style: TextStyle(
                  color: OVOColor.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _BalanceAction(icon: Icons.add, label: "Top Up"),
            _BalanceAction(icon: Icons.call_made, label: "Transfer"),
            _BalanceAction(icon: Icons.money_outlined, label: "Tarik Tunai"),
            _BalanceAction(icon: Icons.menu, label: "History"),
          ],
        ),
      ],
    );
  }

  Widget _collapsedView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Rp 12.525",
              style: TextStyle(
                fontSize: 26,
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Total Saldo",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),

        Text(
          "superbank",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
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
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: OVOColor.purple, size: 22),
        ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF0A4D9C),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: const [
            Icon(Icons.info, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "GRATIS TRANSFER ANTAR BANK DENGAN UPGRADE KE OVO NABUNG",
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _TabItem("Favorit", active: true),
        _TabItem("Finansial"),
        _TabItem("Hiburan"),
        _TabItem("Pilihan Lain"),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool active;

  const _TabItem(this.label, {this.active = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? OVOColor.purple : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: active ? OVOColor.purple : Colors.black54,
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
      _gridItem(Icons.volunteer_activism, "Pinjaman", badge: "BARU"),
      _gridItem(Icons.credit_card, "Uang Elektronik"),
      _gridItem(Icons.list_alt, "Angsuran Kredit"),
      _gridItem(Icons.phone_android, "Pulsa/Paket Data"),
      _gridItem(Icons.bolt, "PLN"),
      _gridItem(Icons.water_drop, "Air PDAM"),
      _gridItem(Icons.tv, "Internet & TV Kabel"),
      _gridItem(Icons.health_and_safety, "BPJS Kesehatan"),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 4,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 0.8,
        children: items,
      ),
    );
  }

  static Widget _gridItem(IconData icon, String label, {String? badge}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: OVOColor.iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: OVOColor.purple, size: 28),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        if (badge != null)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badge,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
      ],
    );
  }
}

class _ParallaxBanner extends StatefulWidget {
  const _ParallaxBanner();

  @override
  State<_ParallaxBanner> createState() => _ParallaxBannerState();
}

class _ParallaxBannerState extends State<_ParallaxBanner> {
  final PageController pageController = PageController(viewportFraction: 0.90);
  int indexNow = 0;

  final List<String> banners = [
    "https://images-loyalty.ovo.id/public/deal/36/44/l/39109.jpg?ver=1",
    "https://images-loyalty.ovo.id/public/deal/90/23/l/30288.jpg?ver=1",
    "https://images-loyalty.ovo.id/public/deal/03/19/l/39001.jpg?ver=1",
    "https://images-loyalty.ovo.id/public/deal/89/64/l/27980.jpg?ver=1",
    "https://images-loyalty.ovo.id/public/deal/42/35/l/27041.jpg?ver=1",
    "https://images-loyalty.ovo.id/public/deal/89/64/l/27980.jpg?ver=1",
    "https://www.k24klik.com/blog/wp-content/uploads/2021/03/blog-banner-OVO-CLBK.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    final scroll =
        context
            .findAncestorStateOfType<_OVOHomePageState>()!
            .balanceController
            .offset;

    final offset = (scroll / 20).clamp(0, 16).toDouble();

    return Transform.translate(
      offset: Offset(0, -offset),
      child: Column(
        children: [
          SizedBox(
            height: 170,
            child: PageView.builder(
              controller: pageController,
              itemCount: banners.length,
              onPageChanged: (i) => setState(() => indexNow = i),
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(banners[i], fit: BoxFit.cover),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.45),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(banners.length, (i) {
              final active = i == indexNow;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 12 : 7,
                height: 7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: active ? OVOColor.purple : Colors.grey.shade400,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _RecommendationSection extends StatelessWidget {
  const _RecommendationSection();

  @override
  Widget build(BuildContext context) {
    final data = [
      {
        "subtitle": "Modal upgrade bisa dapetin McD GRATIS...",
        "image": "https://dummyimage.com/400x240/8e44ad/ffffff&text=McD",
      },
      {
        "subtitle": "Abis Q4 jangan lupa liburan...",
        "image": "https://dummyimage.com/400x240/34495e/ffffff&text=Travel",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 22),
          child: Text(
            "Rekomendasi Pilihan",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            scrollDirection: Axis.horizontal,
            itemCount: data.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, i) {
              final item = data[i];
              return SizedBox(
                width: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(item["image"]!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Promo Online",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      item["subtitle"]!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StampButton extends StatelessWidget {
  const _StampButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.yellow.shade600,
            ),
            child: const Center(
              child: Text("S", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            "Mulai Misi!",
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
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
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _BottomNavItem(Icons.home, "Home", active: true),
          _BottomNavItem(Icons.wallet, "Finance"),
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
  final String label;
  final bool active;

  const _BottomNavItem(this.icon, this.label, {this.active = false});

  @override
  Widget build(BuildContext context) {
    final color = active ? OVOColor.purple : Colors.grey;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 3),
        Text(label, style: TextStyle(color: color, fontSize: 11)),
      ],
    );
  }
}

class _PayButton extends StatelessWidget {
  const _PayButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        color: OVOColor.purple,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 30),
    );
  }
}
