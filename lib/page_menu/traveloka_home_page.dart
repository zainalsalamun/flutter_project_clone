import 'package:flutter/material.dart';

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

  // 🔥 SCROLL CONTROLLER (UNTUK ANIMASI SEARCH)
  late final ScrollController _scrollController;
  double _scrollOffset = 0;

  // ================= MENU DATA =================
  final List<List<Map<String, dynamic>>> menuPages = [
    [
      {"title": "12.12 Sale", "icon": Icons.percent},
      {"title": "Tiket Pesawat", "icon": Icons.flight},
      {"title": "Hotel", "icon": Icons.hotel},
      {"title": "Xperience", "icon": Icons.local_activity},
      {"title": "Bus & Travel", "icon": Icons.directions_bus},
      {"title": "Cruises", "icon": Icons.directions_boat},
      {"title": "Kereta Api", "icon": Icons.train},
      {"title": "Antar Jemput", "icon": Icons.directions_car},
    ],
    [
      {"title": "Whoosh", "icon": Icons.trending_up},
      {"title": "TPayLater", "icon": Icons.credit_card},
      {"title": "Sewa Mobil", "icon": Icons.car_rental},
      {"title": "Semua Produk", "icon": Icons.grid_view},
    ],
  ];

  // ================= MOCK DATA =================
  final hotelData = [
    {
      "title": "Elsotel Purwokerto",
      "image":
          "https://ik.imagekit.io/tvlk/apr-asset/dgXfoyh24ryQLRcGq00cIdKHRmotrWLNlvG-TxlcLxGkiDwaUSggleJNPRgIHCX6/hotel/asset/20055615-64991677955ac2ee6a625110ea463ff9.jpeg?_src=imagekit&tr=dpr-2,f-jpg,fo-auto,h-161,pr-true,q-80,w-300",
      "rating": "9.1 / 10 • 977 ulasan",
      "price": "Rp 436.499",
    },
    {
      "title": "Green Valley Resort",
      "image":
          "https://ik.imagekit.io/tvlk/apr-asset/dgXfoyh24ryQLRcGq00cIdKHRmotrWLNlvG-TxlcLxGkiDwaUSggleJNPRgIHCX6/hotel/asset/10040050-2000x1333-FIT_AND_TRIM-a21b84e741cb75d21b106e0349b8e72a.jpeg?_src=imagekit&tr=dpr-2,f-jpg,fo-auto,h-161,pr-true,q-80,w-300",
      "rating": "7.8 / 10 • 1.3rb ulasan",
      "price": "Rp 633.588",
    },
  ];

  final experienceData = [
    {
      "title": "Ramayana Ballet Jogja",
      "image": "https://images.unsplash.com/photo-1587502537745-84c0e6b0f8a1",
      "rating": "9.3 / 10 • 612 ulasan",
      "price": "Rp 120.000",
    },
    {
      "title": "Obelix Hills",
      "image": "https://images.unsplash.com/photo-1600435335786-d74d2bb6de37",
      "rating": "9.0 / 10 • 23 ulasan",
      "price": "Rp 30.000",
    },
  ];

  // ================= INIT =================
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

  // ================= BUILD =================
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
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  // ================= SLIVER HEADER (ANIMATED) =================
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
                offset: Offset(0, -t * 20), // 🔥 cuma geser Y
                child: _searchBar(),
              ),
              const SizedBox(height: 12),
              _keywordChips(), // 🔥 chip keyword
            ],
          ),
        ),
      ),
    );
  }

  // ================= SEARCH BAR =================
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

  // ================= MENU SECTION =================
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
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: const Color(0xFFE6F7FF),
                          child: Icon(item["icon"], color: primaryBlue),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item["title"],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              menuPages.length,
              (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: menuPageIndex == i ? 8 : 6,
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

  // ================= TOGGLE =================
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: active ? primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(20),
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

  // ================= HORIZONTAL LIST =================
  Widget _horizontalList(List data) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final item = data[i];
          return Container(
            width: 260,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(16),
                  ),
                  child: Image.network(
                    item['image'],
                    width: 90,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(
                          width: 90,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['rating'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['price'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================= PAYLATER =================
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

  // ================= BOTTOM NAV =================
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
