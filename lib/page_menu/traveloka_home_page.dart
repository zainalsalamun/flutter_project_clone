import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TravelokaHomePage extends StatefulWidget {
  const TravelokaHomePage({super.key});

  @override
  State<TravelokaHomePage> createState() => _TravelokaHomePageState();
}

class _TravelokaHomePageState extends State<TravelokaHomePage> {
  static const Color primaryBlue = Color(0xFF00A7E1);

  int menuPageIndex = 0;
  bool isHotelSelected = true;

  final PageController _menuController = PageController();

  late final ScrollController _scrollController;
  double _scrollOffset = 0;

  final List<List<Map<String, dynamic>>> menuPages = [
    [
      {
        "title": "12.12 Sale",
        "icon": Icons.percent,
        "bgColor": const Color(0xFF1976D2),
        "iconColor": Colors.white,
        "isPromo": true,
        "useCircle": true,
      },
      {
        "title": "Tiket Pesawat",
        "icon": Icons.flight,
        "bgColor": const Color(0xFF03A9F4),
        "iconColor": Colors.white,
        "isPromo": true,
        "useCircle": true,
      },
      {
        "title": "Hotel",
        "icon": Icons.hotel,
        "bgColor": const Color(0xFF0D47A1),
        "iconColor": Colors.white,
        "isPromo": true,
        "useCircle": true,
      },
      {
        "title": "Xperience",
        "icon": Icons.local_activity,
        "bgColor": const Color(0xFFEF5350),
        "iconColor": Colors.white,
        "isPromo": true,
        "useCircle": true,
      },
      {
        "title": "Tiket Bus & Travel",
        "icon": Icons.directions_bus,
        "bgColor": const Color(0xFF43A047),
        "iconColor": Colors.white,
        "isPromo": true,
        "useCircle": true,
      },
      {
        "title": "Cruises",
        "icon": Icons.directions_boat,
        "bgColor": const Color(0xFFEF5350),
        "iconColor": Colors.white,
        "isPromo": true,
        "useCircle": true,
      },
      {
        "title": "Tiket Kereta Api",
        "icon": Icons.train,
        "bgColor": const Color(0xFFF9A825),
        "iconColor": Colors.white,
        "isPromo": true,
        "useCircle": true,
      },
      {
        "title": "Antar Jemput",
        "icon": Icons.directions_car,
        "bgColor": const Color(0xFF4DB6AC),
        "iconColor": Colors.white,
        "isPromo": true,
        "useCircle": true,
      },
    ],

    [
      {
        "title": "Paket Wisata",
        "icon": Icons.card_travel,
        "bgColor": const Color(0xFF7E57C2),
        "iconColor": Colors.white,
        "isPromo": true,
        "useCircle": true,
      },
      {
        "title": "Mobil",
        "icon": Icons.directions_car_filled,
        "bgColor": const Color(0xFF00897B),
        "iconColor": Colors.white,
        "isPromo": true,
        "useCircle": true,
      },
      {
        "title": "Asuransi",
        "icon": Icons.security,
        "bgColor": Colors.transparent,
        "iconColor": const Color(0xFF1565C0),
        "isPromo": false,
        "useCircle": false,
      },
      {
        "title": "Pesawat + Hotel",
        "icon": Icons.apartment,
        "bgColor": Colors.transparent,
        "iconColor": const Color(0xFFD81B60),
        "isPromo": false,
        "useCircle": false,
      },

      {
        "title": "JR Pass",
        "icon": Icons.train,
        "bgColor": Colors.transparent,
        "iconColor": const Color(0xFFF57C00),
        "isPromo": false,
        "useCircle": false,
      },
      {
        "title": "Panduan Wisata",
        "icon": Icons.map,
        "bgColor": Colors.transparent,
        "iconColor": const Color(0xFF26A69A),
        "isPromo": false,
        "useCircle": false,
      },
      {
        "title": "Hotel Last-minute",
        "icon": Icons.access_time,
        "bgColor": Colors.transparent,
        "iconColor": const Color(0xFF1565C0),
        "isPromo": false,
        "useCircle": false,
      },
      {
        "title": "Voucher Hadiah",
        "icon": Icons.card_giftcard,
        "bgColor": Colors.transparent,
        "iconColor": const Color(0xFFD32F2F),
        "isPromo": false,
        "useCircle": false,
      },
    ],

    [
      {
        "title": "Traveloka Mandiri Card",
        "icon": Icons.credit_card,
        "bgColor": Colors.transparent,
        "iconColor": const Color(0xFF0D47A1),
        "isPromo": false,
        "useCircle": false,
      },
      {
        "title": "Semua Produk",
        "icon": Icons.grid_view,
        "bgColor": const Color(0xFFF5F5F5),
        "iconColor": const Color(0xFF424242),
        "isPromo": false,
        "useCircle": true,
      },
    ],
  ];

  final hotelData = [
    {
      "title": "Elsotel Purwokerto",
      "image": "https://picsum.photos/400/200?random=1",
      "rating": "9.1 / 10 • 977 ulasan",
      "price": "Rp 436.499",
    },
    {
      "title": "Green Valley Resort",
      "image":
          "https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg",
      "rating": "7.8 / 10 • 1.3rb ulasan",
      "price": "Rp 633.588",
    },
  ];

  final experienceData = [
    {
      "title": "Ramayana Ballet Jogja",
      "image":
          "https://images.pexels.com/photos/1190298/pexels-photo-1190298.jpeg",
      "rating": "9.3 / 10 • 612 ulasan",
      "price": "Rp 120.000",
    },
    {
      "title": "Obelix Hills",
      "image":
          "https://images.pexels.com/photos/417074/pexels-photo-417074.jpeg",
      "rating": "9.0 / 10 • 23 ulasan",
      "price": "Rp 30.000",
    },
  ];

  final promoGridData = [
    {
      "title": "12.12 Super Sale",
      "image": "https://images.unsplash.com/photo-1607082349566-187342175e2f",
      "type": "banner",
    },
    {
      "title": "Kupon Instant Cashback",
      "image": "https://images.unsplash.com/photo-1607082348824-0f2f4b6b1c4d",
      "type": "banner",
    },
    {
      "title": "Green Valley Resort\nBaturraden",
      "subtitle": "7.8 / 10 • 1.3rb ulasan",
      "price": "Rp 633.588",
      "image": "https://images.unsplash.com/photo-1501117716987-c8e1ecb2109f",
      "type": "hotel",
    },
    {
      "title": "Hotel Besar Purwokerto",
      "subtitle": "8.5 / 10 • 778 ulasan",
      "price": "Rp 353.595",
      "image": "https://images.unsplash.com/photo-1566073771259-6a8506099945",
      "type": "hotel",
    },
  ];

  final exploreGridData = [
    {
      "type": "xperience",
      "title": "Re-inkarnasi Cinta Roro Jonggrang",
      "location": "Gondomanan",
      "rating": "9.0/10 • 8 ulasan",
      "price": "Rp 80.000",
      "badge": "Hemat 20%",
      "image": "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
    },
    {
      "type": "hotel",
      "title": "Premier Guest House",
      "location": "Kalasan",
      "rating": "8.7/10 • 112 ulasan",
      "price": "Rp 372.584",
      "badge": "Hemat 25%",
      "image": "https://images.unsplash.com/photo-1566073771259-6a8506099945",
    },
    {
      "type": "flight",
      "title": "Jakarta – Kuala Lumpur",
      "price": "Rp 2.515.800",
      "image": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e",
    },
    {
      "type": "flight",
      "title": "Jakarta – Surabaya",
      "price": "Rp 1.999.494",
      "image": "https://images.unsplash.com/photo-1512453979798-5ea266f8880c",
    },
    {
      "type": "banner",
      "title": "Inspirasi Liburan Fall / Winter",
      "price": "Rp 1.999.494",
      "image": "https://images.unsplash.com/photo-1566073771259-6a8506099945",
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController =
        ScrollController()..addListener(() {
          setState(() {
            _scrollOffset = _scrollController.offset;
          });
        });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      bottomNavigationBar: _bottomNav(),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _sliverHeader(context),
          SliverToBoxAdapter(child: _menuSection()),
          SliverToBoxAdapter(child: _activityToggle()),
          SliverToBoxAdapter(
            child:
                isHotelSelected
                    ? _horizontalList(hotelData)
                    : _horizontalList(experienceData),
          ),
          SliverToBoxAdapter(child: _payLaterBanner()),
          SliverToBoxAdapter(child: _promoGridSection()),
          // SliverToBoxAdapter(child: _exploreGridSection()),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: _exploreMasonrySection(),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _exploreMasonrySection() {
    return SliverMasonryGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childCount: exploreGridData.length,
      itemBuilder: (context, index) {
        return _exploreCard(exploreGridData[index]);
      },
    );
  }

  SliverAppBar _sliverHeader(BuildContext context) {
    const double maxScroll = 80;
    final double t = (_scrollOffset / maxScroll).clamp(0.0, 1.0);

    return SliverAppBar(
      backgroundColor: primaryBlue,
      expandedHeight: 160,
      pinned: true,
      elevation: t > 0.2 ? 2 : 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            MediaQuery.of(context).padding.top + 16,
            16,
            16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: Offset(0, -t * 20),
                child: _searchBar(),
              ),
              const SizedBox(height: 12),
              _keywordChips(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Tiket Pesawat cuma Rp120rb",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          const Icon(Icons.percent, color: Colors.orange),
          const SizedBox(width: 12),
          const Icon(Icons.chat_bubble_outline, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _keywordChips() {
    final chips = ["COR Hotel Purwokerto", "opi", "kidzania"];

    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder:
            (_, i) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Text(
                    chips[i],
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.search, size: 14, color: Colors.white),
                ],
              ),
            ),
      ),
    );
  }

  Widget _menuSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _menuController,
              onPageChanged: (i) => setState(() => menuPageIndex = i),
              itemCount: menuPages.length,
              itemBuilder: (_, pageIndex) {
                return GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: menuPages[pageIndex].length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: .9,
                  ),
                  itemBuilder: (_, i) {
                    final item = menuPages[pageIndex][i];

                    return Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            item['useCircle'] == true
                                ? CircleAvatar(
                                  radius: 26,
                                  backgroundColor: item['bgColor'],
                                  child: Icon(
                                    item['icon'],
                                    color: item['iconColor'],
                                    size: 26,
                                  ),
                                )
                                : Icon(
                                  item['icon'],
                                  color: item['iconColor'],
                                  size: 32,
                                ),

                            if (item['isPromo'] == true)
                              Positioned(
                                top: -4,
                                right: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.percent,
                                    size: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        Text(
                          item["title"],
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              menuPages.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: menuPageIndex == i ? 10 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color:
                      menuPageIndex == i ? primaryBlue : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _activityToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _toggleChip("Hotel", isHotelSelected, () {
            setState(() => isHotelSelected = true);
          }),
          const SizedBox(width: 8),
          _toggleChip("Xperience", !isHotelSelected, () {
            setState(() => isHotelSelected = false);
          }),
        ],
      ),
    );
  }

  Widget _toggleChip(String text, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: active ? primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow:
              active
                  ? [
                    BoxShadow(
                      color: primaryBlue.withOpacity(.25),
                      blurRadius: 10,
                    ),
                  ]
                  : [],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _horizontalList(List data) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final item = data[i];

          return Container(
            width: 260,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // 🔥 IMAGE PINPU STYLE
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    item['image'],
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        width: 72,
                        height: 72,
                        color: const Color(0xFFF1F3F5),
                        child: const Icon(
                          Icons.hotel,
                          color: Color(0xFFADB5BD),
                          size: 32,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item['title'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['rating'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['price'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _payLaterBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F7FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: const [
          Icon(Icons.shopping_cart, color: primaryBlue),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Checkout di e-commerce, bayarnya di TPayLater",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            "Cari tahu",
            style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _promoGridSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            "Penawaran 12.12 di Indonesia",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: promoGridData.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: .72,
            ),
            itemBuilder: (context, index) {
              final item = promoGridData[index];
              return _promoGridCard(item);
            },
          ),
        ],
      ),
    );
  }

  Widget _promoGridCard(Map<String, dynamic> item) {
    final isBanner = item['type'] == 'banner';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              item['image'],
              height: isBanner ? 160 : 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  height: 140,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image, size: 40),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),

                if (!isBanner) ...[
                  const SizedBox(height: 6),
                  Text(
                    item['subtitle'],
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['price'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _exploreCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Image.network(
                  item['image'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (c, w, p) {
                    if (p == null) return w;
                    return Container(height: 140, color: Colors.grey.shade200);
                  },
                  errorBuilder: (_, __, ___) {
                    return Container(
                      height: 140,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image,
                        size: 32,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),

                if (item['location'] != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _chip(item['location'], Colors.black87),
                  ),

                if (item['badge'] != null)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: _chip(item['badge'], Colors.orange),
                  ),
              ],
            ),
          ),

          // CONTENT
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item['title'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                if (item['rating'] != null)
                  Text(
                    item['rating'],
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                  ),

                const SizedBox(height: 8),

                Text(
                  item['price'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _bottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryBlue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Awal"),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
        BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Pesanan"),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Simpan"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Akun"),
      ],
    );
  }
}
