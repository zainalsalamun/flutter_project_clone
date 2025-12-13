import 'package:flutter/material.dart';

class PintuHomePage extends StatelessWidget {
  const PintuHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _bottomNav(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  _topSection(),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _totalAsetSection(),
                    const SizedBox(height: 20),
                    _announcementCard(),
                    const SizedBox(height: 20),
                    _quickMenu(),
                    const SizedBox(height: 24),
                    _topMovers(),
                    const SizedBox(height: 32),
                    _watchlistHeader(),
                    const SizedBox(height: 12),
                    _watchlistList(),
                    const SizedBox(height: 24),
                    _sectionTitle("Info dan Promo Spesial"),
                    const SizedBox(height: 12),
                    _promoCarousel(),
                    const SizedBox(height: 32),
                    _sectionTitle("Academy Minggu Ini"),
                    const SizedBox(height: 16),
                    _academyCarousel(),
                    const SizedBox(height: 32),
                    _sectionTitle("Belajar Investasi Crypto"),
                    const SizedBox(height: 16),
                    _learnCryptoCarousel(),
                    const SizedBox(height: 32),
                    _sectionTitle("Pertanyaan Umum"),
                    const SizedBox(height: 16),
                    _faq(),
                    const SizedBox(height: 32),
                    _sectionTitle("Berita Terkini"),
                    const SizedBox(height: 16),
                    _newsList(),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //App Bar
  Widget _topSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Align(alignment: Alignment.centerLeft, child: _tabSwitch()),
        ),

        Row(
          children: [
            // EMAIL WITH BADGE
            Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.mail_outline, size: 26),

                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      "4",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 16),
            const Icon(Icons.person_outline, size: 28),
          ],
        ),
      ],
    );
  }

  //switch tab
  Widget _tabSwitch() {
    return Container(
      height: 36,
      width: 200,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(children: [_tabItem(true, "Pintu"), _tabItem(false, "Pro")]),
    );
  }

  Widget _tabItem(bool active, String text) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        height: 36,
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow:
              active
                  ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ]
                  : [],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: active ? Colors.black : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  //assets dan balance
  Widget _totalAsetSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Total Nilai Aset", style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(height: 6),
        Row(
          children: [
            const Text(
              "Rp 2.189.519.880",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            Icon(Icons.visibility_outlined),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "Saldo Aktif Rupiah Rp 1.140.000.000",
          style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _primaryButton("Deposit"),
            const SizedBox(width: 12),
            _secondaryButton("Tarik"),
            const SizedBox(width: 12),
            _secondaryButton("Transfer"),
          ],
        ),
      ],
    );
  }

  Widget _primaryButton(String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.blue.shade700,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _secondaryButton(String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  // card
  Widget _announcementCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Expanded(
            child: Text(
              "Info Delisting Kontrak Futures QUICKUSDT-PERP dan SXPUSDT-PERP",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }

  // menu grid
  Widget _quickMenu() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 0.85,
        children: [
          _menuItem(Icons.savings, "Earn"),
          _menuItem(Icons.account_balance_wallet, "PTU Staking"),
          _menuItem(Icons.calendar_today, "Nabung Rutin"),
          _menuItem(Icons.notifications, "Price Alert"),
          _menuItem(Icons.card_giftcard, "Referral"),
          _menuItem(Icons.card_membership, "Reward"),
          _menuItem(Icons.lightbulb, "Academy"),
          _menuItem(Icons.more_horiz, "Lainnya"),
        ],
      ),
    );
  }

  static Widget _menuItem(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 26),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 13),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _topMovers() {
    final movers = [
      ["MAVIA", "Rp 1.100", "+32,2%"],
      ["HEI", "Rp 2.666", "-29,34%"],
      ["FWOG", "Rp 262,4", "+22,5%"],
      ["Bitcoin", "Rp 1.554.648.779", "+1,36%"],
      ["Ethereum", "Rp 53.453.202", "+6,61%"],
      ["BNB", "Rp 15.362.919", "+4,54%"],
      ["Solana", "Rp 2.407.016", "+4,27%"],
      ["Cosmos", "Rp 39.501", "-0,23%"],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Top Movers (24H)",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: movers.map((m) => _moverCard(m[0], m[1], m[2])).toList(),
          ),
        ),
      ],
    );
  }

  Widget _moverCard(String name, String price, String change) {
    final isUp = change.contains("+");

    IconData icon;
    Color bgColor;
    Color iconColor;

    switch (name) {
      case "MAVIA":
        icon = Icons.token;
        bgColor = Colors.yellow.shade100;
        iconColor = Colors.orange.shade700;
        break;

      case "HEI":
        icon = Icons.hexagon;
        bgColor = Colors.purple.shade100;
        iconColor = Colors.purple.shade700;
        break;

      case "FWOG":
        icon = Icons.pets;
        bgColor = Colors.green.shade100;
        iconColor = Colors.green.shade700;
        break;

      case "Bitcoin":
        icon = Icons.currency_bitcoin;
        bgColor = Colors.orange.shade100;
        iconColor = Colors.orange.shade700;
        break;

      case "Ethereum":
        icon = Icons.hexagon_outlined;
        bgColor = Colors.grey.shade300;
        iconColor = Colors.grey.shade800;
        break;

      case "BNB":
        icon = Icons.diamond;
        bgColor = Colors.yellow.shade100;
        iconColor = Colors.amber.shade700;
        break;

      case "Solana":
        icon = Icons.blur_on;
        bgColor = Colors.green.shade100;
        iconColor = Colors.green.shade700;
        break;

      case "Cosmos":
        icon = Icons.bubble_chart;
        bgColor = Colors.blue.shade100;
        iconColor = Colors.blue.shade600;
        break;

      default:
        icon = Icons.circle;
        bgColor = Colors.grey.shade200;
        iconColor = Colors.grey.shade600;
    }

    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: bgColor,
                child: Icon(icon, size: 14, color: iconColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // fix text size overflow
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              price,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            change,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isUp ? Colors.green : Colors.red,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _watchlistHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          "Watchlist Kamu",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          "Ubah Watchlist",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _watchlistList() {
    final coins = [
      ["Bitcoin", "Rp 1.554.648.779", "+1,36%"],
      ["Ethereum", "Rp 53.453.202", "+6,61%"],
      ["BNB", "Rp 15.362.919", "+4,54%"],
      ["Solana", "Rp 2.407.016", "+4,27%"],
      ["Cosmos", "Rp 39.501", "-0,23%"],
    ];

    return Column(
      children: coins.map((c) => _watchItem(c[0], c[1], c[2])).toList(),
    );
  }

  Widget _watchItem(String coin, String price, String change) {
    final isUp = change.contains("+");

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          _coinIcon(coin),
          const SizedBox(width: 12),

          Expanded(
            child: Text(
              coin,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price),
              Text(
                change,
                style: TextStyle(
                  color: isUp ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _coinIcon(String coin) {
    IconData icon;
    Color bg;
    Color color;

    switch (coin) {
      case "Bitcoin":
        icon = Icons.currency_bitcoin;
        bg = Colors.orange.shade100;
        color = Colors.orange.shade700;
        break;

      case "Ethereum":
        icon = Icons.hexagon;
        bg = Colors.grey.shade300;
        color = Colors.grey.shade800;
        break;

      case "BNB":
        icon = Icons.diamond;
        bg = Colors.yellow.shade100;
        color = Colors.amber.shade700;
        break;

      case "Solana":
        icon = Icons.blur_on;
        bg = Colors.green.shade100;
        color = Colors.green.shade700;
        break;

      case "Cosmos":
        icon = Icons.bubble_chart;
        bg = Colors.blue.shade100;
        color = Colors.blue.shade700;
        break;

      default:
        icon = Icons.circle;
        bg = Colors.grey.shade200;
        color = Colors.grey.shade600;
    }

    return CircleAvatar(
      radius: 14,
      backgroundColor: bg,
      child: Icon(icon, size: 16, color: color),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  //promo carousel
  Widget _promoCarousel() {
    return SizedBox(
      height: 160,
      child: PageView(
        children: [
          _bannerCard(
            imageUrl: "https://pintu.co.id/static/images/pro/hero.png",
            title: "Trading Futures dapat Rp 100 rb",
          ),
          _bannerCard(
            imageUrl:
                "https://pintu.co.id/static/images/pro/future/hero-new.webp",
            title: "Promo Lainnya",
          ),
        ],
      ),
    );
  }

  Widget _bannerCard({required String imageUrl, required String title}) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.45),
              Colors.black.withOpacity(0.15),
              Colors.transparent,
            ],
          ),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _academyCarousel() {
    final items = [
      [
        "Cara Kelola Risiko Trading Futures Dengan Leverage 25x",
        "https://pintu-academy.pintukripto.com/wp-content/uploads/2025/07/Cara-Kelola-Risiko-Trading-Futures-Dengan-Leverage-25x-768x576.png",
      ],
      [
        "Manajemen Risiko di Crypto",
        "https://pintu-academy.pintukripto.com/wp-content/uploads/2023/07/Manajemen-Risiko-di-crypto-768x576.png",
      ],
      [
        "Risk Management Future Trading",
        "https://pintu-academy.pintukripto.com/wp-content/uploads/2025/06/Risk-Management-Future-Trading-768x576.png",
      ],
      [
        "How to Count Risk (Pintu Academy)",
        "https://pintu-academy.pintukripto.com/wp-content/uploads/2025/11/Pintu-AcademyArticle-10-14Nov-02-HowtoCountRisk-768x578.png",
      ],
      [
        "How to Succeed in Bull Market",
        "https://pintu-academy.pintukripto.com/wp-content/uploads/2024/12/How-to-succeed-in-bull-market-768x576.png",
      ],
      [
        "Barbell Strategy",
        "https://pintu-academy.pintukripto.com/wp-content/uploads/2023/10/Barbell-Strategy-1-768x576.png",
      ],
      [
        "Strategi Hedging Futures",
        "https://pintu-academy.pintukripto.com/wp-content/uploads/2025/06/Strategi-Hedgin-Futures-768x576.png",
      ],
    ];

    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: items.map((item) => _academyCard(item[0], item[1])).toList(),
      ),
    );
  }

  Widget _academyCard(String title, String imageUrl) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.45),
              Colors.black.withOpacity(0.10),
              Colors.transparent,
            ],
          ),
        ),
        padding: const EdgeInsets.all(14),
        alignment: Alignment.bottomLeft,
        child: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _learnCryptoCarousel() {
    final items = [
      [
        "Apa itu Bitcoin?",
        "https://pintu-academy.pintukripto.com/wp-content/uploads/2021/12/What-is-Bitcoin-768x576.png",
      ],
      [
        "Bitcoin ETF",
        "https://pintu-academy.pintukripto.com/wp-content/uploads/2023/06/Bitcoin-ETF-2-768x576.png",
      ],
      [
        "Bitcoin vs Bitcoin Cash",
        "https://pintu-academy.pintukripto.com/wp-content/uploads/2023/07/Bitcoin-BCH-768x576.png",
      ],
      [
        "Apa itu Taproot?",
        "https://pintu-academy.pintukripto.com/wp-content/uploads/2021/12/Apa-itu-Taproot-768x576.png",
      ],
      [
        "Bitcoin Halving",
        "https://pintu-academy.pintukripto.com/wp-content/uploads/2021/03/Bitcoin_Halving-768x576.png",
      ],
      [
        "Coin Mixer & Coin Join",
        "https://pintu-academy.pintukripto.com/wp-content/uploads/2022/06/Coin-Mixer-dan-Coin-Join-768x576.png",
      ],
      [
        "Sejarah Bitcoin",
        "https://pintu-academy.pintukripto.com/wp-content/uploads/2023/03/Sejarah-Bitcoin-768x576.png",
      ],
      [
        "Bitcoin Maximalism",
        "https://pintu-academy.pintukripto.com/wp-content/uploads/2023/09/Bitcoin-Maximalism-dan-Crypto-Tribalism-768x576.png",
      ],
      [
        "Adopsi Bitcoin Sebagai Cadangan",
        "https://pintu-academy.pintukripto.com/wp-content/uploads/2025/08/Adopsi-Bitcoin-Sebagai-Cadangan-768x576.png",
      ],
    ];

    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: items.map((item) => _learnCard(item[0], item[1])).toList(),
      ),
    );
  }

  Widget _learnCard(String title, String imageUrl) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.45),
              Colors.black.withOpacity(0.10),
              Colors.transparent,
            ],
          ),
        ),
        alignment: Alignment.bottomLeft,
        child: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _faq() {
    final faqItems = [
      [
        "Cara Deposit via OVO",
        "https://blog.pintu.co.id/wp-content/uploads/2021/07/Deposit-Via-Ovo-Blog-Banner2-1-300x226.png",
      ],
      [
        "Deposit via BCA",
        "https://blog.pintu.co.id/wp-content/uploads/2024/03/Tutorial-deposit-di-pintu-dengan-bca-300x226.jpg",
      ],
      [
        "Deposit via Virtual Account",
        "https://blog.pintu.co.id/wp-content/uploads/2025/02/Pintu-Deposit-VA-Blog-300x226.jpg",
      ],
      [
        "Deposit IDR (Pintu Pro)",
        "https://blog.pintu.co.id/wp-content/uploads/2025/06/Pintu-Pro-FiatIDRDeposit-Blog-1020x768-1-300x226.jpg",
      ],
    ];

    return SizedBox(
      height: 150,
      child: Row(
        children: faqItems.map((item) => _faqItem(item[0], item[1])).toList(),
      ),
    );
  }

  Widget _faqItem(String title, String imageUrl) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
              child: Image.network(
                imageUrl,
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _newsList() {
    final items = [
      [
        "Pippin Crypto Melonjak Hari Ini",
        "https://blog.pintu.co.id/wp-content/uploads/2025/12/pippin-crypto-300x169.jpg",
      ],
      [
        "Solana Kembali Menguat",
        "https://blog.pintu.co.id/wp-content/uploads/2025/07/solana-300x174.png",
      ],
      [
        "Mengapa Crypto Turun Hari Ini?",
        "https://blog.pintu.co.id/wp-content/uploads/2025/11/mengapa-crypto-turun-hari-ini-300x171.jpg",
      ],
      [
        "10 Crypto Potensial untuk Tahun 2026",
        "https://blog.pintu.co.id/wp-content/uploads/2025/10/10-crypto-2026-300x171.jpg",
      ],
      [
        "XRP Disetujui di Hong Kong",
        "https://blog.pintu.co.id/wp-content/uploads/2025/12/xrp-hong-kong-300x169.jpg",
      ],
      [
        "Chainlink: Kenaikan On-chain Activity",
        "https://blog.pintu.co.id/wp-content/uploads/2024/09/chainlink-300x227.jpg",
      ],
      [
        "JioCoin Menjadi Sorotan Baru",
        "https://blog.pintu.co.id/wp-content/uploads/2025/12/jiocoin-300x169.jpg",
      ],
      [
        "Harga Dogecoin Naik Tajam",
        "https://blog.pintu.co.id/wp-content/uploads/2025/07/harga-dogecoin-naik-300x172.jpg",
      ],
      [
        "Market Crypto Bergerak Campuran",
        "https://blog.pintu.co.id/wp-content/uploads/2025/06/image-69-300x169.jpg",
      ],
      [
        "Kenapa Crypto Turun Hari Ini?",
        "https://blog.pintu.co.id/wp-content/uploads/2024/07/kenapa-crypto-turun-hari-ini-300x171.jpg",
      ],
    ];

    return Column(
      children: items.map((item) => _newsItem(item[0], item[1])).toList(),
    );
  }

  Widget _newsItem(String title, String imageUrl) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          // Title
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  //bottom
  Widget _bottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 0.8),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey.shade500,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Jelajah"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Market"),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: "Futures",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: "Wallet",
          ),
        ],
      ),
    );
  }
}
