import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GojekHomePage extends StatefulWidget {
  const GojekHomePage({super.key});

  @override
  State<GojekHomePage> createState() => _GojekHomePageState();
}

class _GojekHomePageState extends State<GojekHomePage> {
  final PageController _bannerController = PageController(
    viewportFraction: 0.92,
  );
  int _bannerIndex = 0;

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: const _GojekBottomNav(),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _SearchAndProfile(),
                    const SizedBox(height: 18),
                    _BannerSlider(
                      controller: _bannerController,
                      onPageChanged: (i) => setState(() => _bannerIndex = i),
                      index: _bannerIndex,
                    ),
                    const SizedBox(height: 18),
                    _GoPayMiniCard(),
                    const SizedBox(height: 18),
                    _ServiceGrid(),
                    const SizedBox(height: 18),
                    _SimpleGreenStrip(),
                    const SizedBox(height: 24),
                    const _SectionTitleWithChip(
                      title: "Bayangin rasanya deh (nyam!)",
                      actionText: "Lihat semua",
                    ),
                    const SizedBox(height: 14),
                    _HorizontalFoodRevealList(),
                    const SizedBox(height: 24),
                    const _SectionTitle(title: "Promo yang wajib dicek"),
                    const SizedBox(height: 14),
                    _PromoSlider(),
                    const SizedBox(height: 26),
                    const _SectionTitle(
                      title: "Resto dengan rating jempolan",
                      subtitle: "Ad",
                    ),
                    const SizedBox(height: 10),
                    _HorizontalRestaurantCards(),
                    const SizedBox(height: 24),
                    const _SectionTitle(title: "Masih eksplor? Coba cek ini"),
                    const SizedBox(height: 12),
                    _BigFoodDiscoveryCard(),
                    const SizedBox(height: 24),
                    const _SectionTitle(
                      title: "Maw ide liburan akhir tahun?",
                      prefixLogo: "gojek",
                      action: "Lihat semua",
                    ),
                    const SizedBox(height: 12),
                    _DestinationHorizontalList(),
                    const SizedBox(height: 24),
                    const _SectionTitle(
                      title: "Jangan ketinggalan promo ini!",
                      prefixLogo: "gopay",
                    ),
                    const SizedBox(height: 12),
                    _HorizontalShopPromoList(),
                    const SizedBox(height: 24),
                    const _SectionTitle(
                      title: "BARU! Cobain GoGreen SM 🚗✨",
                      prefixLogo: "gojek",
                    ),
                    const SizedBox(height: 12),
                    const _BigImagePromoCard(
                      imageUrl:
                          "https://images.pexels.com/photos/4488630/pexels-photo-4488630.jpeg?auto=compress&cs=tinysrgb&w=800",
                      title:
                          "Tanpa langkah ekstra, cukup pilih tujuanmu dan langsung jalan! 💚",
                    ),
                    const SizedBox(height: 20),
                    const _SectionTitle(
                      title: "Kirim hampers lebih murah pakai GoSend!",
                      prefixLogo: "gosend",
                    ),
                    const SizedBox(height: 12),
                    const _BigImagePromoCard(
                      imageUrl:
                          "https://images.pexels.com/photos/264787/pexels-photo-264787.jpeg?auto=compress&cs=tinysrgb&w=800",
                      title:
                          "Dapatkan potongan ongkir 15RB pakai kode GOSENDHAMPERS 🎁 Klik di sini!",
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchAndProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: const [
                  Icon(Icons.search, color: Colors.grey, size: 22),
                  SizedBox(width: 8),
                  Text(
                    "Nasi Goreng",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFE9F8EC),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green, width: 1.2),
            ),
            child: const Icon(Icons.person, color: Colors.green),
          ),
        ],
      ),
    );
  }
}

class _BannerSlider extends StatelessWidget {
  final PageController controller;
  final ValueChanged<int> onPageChanged;
  final int index;

  const _BannerSlider({
    required this.controller,
    required this.onPageChanged,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    // final banners = [
    //   "https://images.pexels.com/photos/853199/pexels-photo-853199.jpeg?auto=compress&cs=tinysrgb&w=800",
    //   "https://images.pexels.com/photos/140134/pexels-photo-140134.jpeg?auto=compress&cs=tinysrgb&w=800",
    //   "https://images.pexels.com/photos/3186654/pexels-photo-3186654.jpeg?auto=compress&cs=tinysrgb&w=800",
    // ];
    final banners = [
      "https://cdn-site.gojek.com/uploads/EN_GORIDE_c76b5ba317/EN_GORIDE_c76b5ba317.png",
      "https://cdn-site.gojek.com/uploads/ID_GOCAR_961px_721px_9b02fc3146/ID_GOCAR_961px_721px_9b02fc3146.png",
      "https://cdn-site.gojek.com/uploads/ID_GOSEND_961px_721px_e16f8abe50/ID_GOSEND_961px_721px_e16f8abe50.png",
      "https://cdn-site.gojek.com/uploads/ID_GOFOOD_961px_721px_03ff957331/ID_GOFOOD_961px_721px_03ff957331.png",
    ];

    return Column(
      children: [
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: controller,
            onPageChanged: onPageChanged,
            itemCount: banners.length,
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
                              Colors.black.withOpacity(0.4),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      // const Positioned(
                      //   left: 18,
                      //   bottom: 18,
                      //   child: Text(
                      //     "kejog 2025\nCek kilas balikmu sekarang!",
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.w700,
                      //       fontSize: 18,
                      //       height: 1.2,
                      //     ),
                      //   ),
                      // ),
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
            final active = i == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 10 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: active ? Colors.green : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _GoPayMiniCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE9F8EC),
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                color: Colors.green,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Rp9.227",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  "1.200 coins",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
            const Spacer(),
            const _SmallAction(text: "Bayar", icon: Icons.arrow_upward),
            const SizedBox(width: 20),
            const _SmallAction(text: "Top Up", icon: Icons.add),
            const SizedBox(width: 20),
            const _SmallAction(text: "Lainnya", icon: Icons.more_horiz),
          ],
        ),
      ),
    );
  }
}

class _SmallAction extends StatelessWidget {
  final String text;
  final IconData icon;
  const _SmallAction({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFE9F8EC),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.green, size: 18),
        ),
        const SizedBox(height: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _ServiceGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final services = [
      ("GoRide", "5RB!", Icons.two_wheeler),
      ("GoCar", "6RB!", Icons.directions_car),
      ("GoFood", "-70%", Icons.restaurant),
      ("GoSend", "5RB!", Icons.inbox),
      ("GoMart", "30MINS", Icons.local_mall),
      ("GoPay Pinjam", "25JUTA", Icons.savings),
      ("GoFood Sehat", "-50%", Icons.rice_bowl),
      ("Lainnya", "", Icons.more_horiz),
    ];

    final double itemWidth =
        (MediaQuery.of(context).size.width - 14 * 2 - 18 * 3) / 4;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Wrap(
        spacing: 18,
        runSpacing: 16,
        alignment: WrapAlignment.spaceBetween,
        children:
            services.map((s) {
              return SizedBox(
                width: itemWidth,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F7),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            s.$3,
                            color: Colors.green.shade700,
                            size: 32,
                          ),
                        ),
                        if (s.$2.isNotEmpty)
                          Positioned(
                            top: 2,
                            left: 2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                s.$2,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      s.$1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }
}

class _SimpleGreenStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00C853), Color(0xFFB2FF59)],
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: const [
            Icon(Icons.local_offer, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Pasti dapet diskon tiap hari\nLihat keuntungan PLUS ➜",
                style: TextStyle(
                  color: Colors.white,
                  height: 1.3,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? action;
  final String? prefixLogo;

  const _SectionTitle({
    required this.title,
    this.subtitle,
    this.action,
    this.prefixLogo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          if (prefixLogo != null)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Text(
                prefixLogo!,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE9F8EC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                action!,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionTitleWithChip extends StatelessWidget {
  final String title;
  final String actionText;

  const _SectionTitleWithChip({required this.title, required this.actionText});

  @override
  Widget build(BuildContext context) {
    return _SectionTitle(title: title, action: actionText);
  }
}

class _HorizontalFoodRevealList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = ["Warung Tongseng", "Kudapan Haji Didik", "Soto Enak"];

    return SizedBox(
      height: 180,
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 14, right: 10),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          return Container(
            width: 140,
            decoration: BoxDecoration(
              color: Colors.green.shade800,
              borderRadius: BorderRadius.circular(22),
              image: DecorationImage(
                image: const NetworkImage(
                  "https://images.pexels.com/photos/958545/pexels-photo-958545.jpeg?auto=compress&cs=tinysrgb&w=800",
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.35),
                  BlendMode.darken,
                ),
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const Text(
                  "Tap to\nreveal",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  items[i],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.star, size: 12, color: Colors.orange),
                      SizedBox(width: 2),
                      Text("4.8", style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: items.length,
      ),
    );
  }
}

class _PromoSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Image.network(
          "https://images.pexels.com/photos/4392041/pexels-photo-4392041.jpeg?auto=compress&cs=tinysrgb&w=800",
          fit: BoxFit.cover,
          height: 180,
        ),
      ),
    );
  }
}

class _HorizontalRestaurantCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final restaurants = [
      "Chickin-san, Setiabudi",
      "BB.Q Chicken, Citywalk Sudirman",
    ];

    return SizedBox(
      height: 220,
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 14, right: 10),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          final title = (i < restaurants.length) ? restaurants[i] : "";
          return Container(
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                  child: Image.network(
                    "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=800",
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "3.44 km • 15–25 min",
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "⭐ 4.8 • 100+ rating",
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: restaurants.length,
      ),
    );
  }
}

class _BigFoodDiscoveryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Container(
          color: Colors.orange.shade600,
          height: 180,
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Baru! Yang ngaku foodie wajib coba",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Rumah Makan Padang Pariaman ACC, Kota Bandung.",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      Spacer(),
                      Text(
                        "⭐ 4.9   •   Terdekat",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Image.network(
                  "https://images.pexels.com/photos/5930975/pexels-photo-5930975.jpeg?auto=compress&cs=tinysrgb&w=800",
                  fit: BoxFit.cover,
                  height: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DestinationHorizontalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cities = ["Jakarta", "Bandung", "Jogja"];
    return SizedBox(
      height: 180,
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 14, right: 10),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          final city = (i < cities.length) ? cities[i] : "";
          return Container(
            width: 150,
            decoration: BoxDecoration(
              color: Colors.lightGreen.shade100,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade700,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(22),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        city.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text("Klik di sini ⬅️", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: cities.length,
      ),
    );
  }
}

class _HorizontalShopPromoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shops = ["Alfamart", "Indomaret"];
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 14, right: 10),
        itemBuilder: (_, i) {
          final shop = (i < shops.length) ? shops[i] : "";
          return Container(
            width: 170,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(22),
                      ),
                      child: Image.network(
                        "https://images.pexels.com/photos/2381069/pexels-photo-2381069.jpeg?auto=compress&cs=tinysrgb&w=800",
                        height: 110,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "38% off",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        shop,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Belanja Hemat, Dapet Cashback Lagi!",
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: shops.length,
      ),
    );
  }
}

class _BigImagePromoCard extends StatelessWidget {
  final String imageUrl;
  final String title;

  const _BigImagePromoCard({required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GojekBottomNav extends StatelessWidget {
  const _GojekBottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: const [
          _BottomNavItem(icon: Icons.home, label: "Beranda", active: true),
          _BottomNavItem(icon: Icons.local_offer_outlined, label: "Promo"),
          _BottomNavItem(icon: Icons.receipt_long, label: "Aktivitas"),
          _BottomNavItem(icon: Icons.chat_bubble_outline, label: "Chat"),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.green : Colors.grey.shade600;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              color: color,
              fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
