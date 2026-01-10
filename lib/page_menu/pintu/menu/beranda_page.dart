import 'package:flutter/material.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  bool _isPro = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isPro ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: _isPro ? Colors.black : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  const SizedBox(height: 12),
                  _topSection(),
                  if (_isPro) ...[
                    const SizedBox(height: 20),
                    _buildProHeader(),
                    const SizedBox(height: 24),
                  ] else
                    const SizedBox(height: 16),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      _isPro
                          ? const BorderRadius.vertical(
                            top: Radius.circular(24),
                          )
                          : null,
                ),
                child: ClipRRect(
                  borderRadius:
                      _isPro
                          ? const BorderRadius.vertical(
                            top: Radius.circular(24),
                          )
                          : BorderRadius.zero,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _isPro ? _buildProBody() : _buildPintuBody(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPintuBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
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
    );
  }

  Widget _buildProBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        // Delisting Info
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF4E0),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Info Delisting Token",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // New Year Bonus Banner
        Container(
          width: double.infinity,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF0D1B54), Color(0xFF1E3A8A)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    "https://pintu.co.id/static/images/pro/hero.png", // Example image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "New Year Bonus",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "s.d. Rp 2 jt",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Spesial Trader Futures",
                      style: TextStyle(color: Colors.blueAccent, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Categories Tabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _proCategoryTab("Watchlist"),
              _proCategoryTab("Pro Spot", isActive: true),
              _proCategoryTab("Tokenized Stocks"),
              _proCategoryTab("Futures"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _filterChip("Semua", isActive: true),
              const SizedBox(width: 8),
              _filterChip("🔥 Trending"),
              const SizedBox(width: 8),
              _filterChip("Gainers"),
              const SizedBox(width: 8),
              _filterChip("Losers"),
              const SizedBox(width: 8),
              _filterChip("Baru"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Table Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Text(
                  "NAMA",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Icon(Icons.unfold_more, size: 14, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  "/ VOL",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Icon(Icons.unfold_more, size: 14, color: Colors.grey),
              ],
            ),
            Row(
              children: [
                const Text(
                  "HARGA (IDR)",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const Icon(Icons.unfold_more, size: 14, color: Colors.grey),
                const SizedBox(width: 16),
                const Text(
                  "24H CHANGE",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const Icon(Icons.unfold_more, size: 14, color: Colors.grey),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Market List
        _proMarketItem("USDT", "37,25B", "16.891", "+0,23%", Colors.green),
        _proMarketItem("SOL", "10,08B", "2.342.000", "+3,13%", Colors.green),
        _proMarketItem("BTC", "8,43B", "1.525.445.000", "+0,38%", Colors.green),
        _proMarketItem("ETH", "3,28B", "52.281.000", "-0,54%", Colors.red),
        _proMarketItem("XRP", "2,04B", "35.485", "+0,11%", Colors.green),
        _proMarketItem("PEPE", "694,18M", "0,10301", "-2,37%", Colors.red),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildProHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Total Asset Pro
        Row(
          children: [
            Text(
              "Total Nilai Aset",
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 16, color: Colors.grey.shade400),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Text(
              "Rp 184.321",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.visibility_outlined,
              size: 20,
              color: Colors.grey.shade400,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Action Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A55FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  "Deposit",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.grey.shade800),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  "Tarik",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.grey.shade800),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  "Transfer",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _proCategoryTab(String title, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 24),
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border:
            isActive
                ? const Border(
                  bottom: BorderSide(color: Color(0xFF0A55FF), width: 2),
                )
                : null,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.black : Colors.grey,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _filterChip(String label, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE3F2FD) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? const Color(0xFF0A55FF) : Colors.grey.shade300,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isActive ? const Color(0xFF0A55FF) : Colors.black87,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _proMarketItem(
    String symbol,
    String vol,
    String price,
    String change,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Coin Info
          Row(
            children: [
              _coinIcon(
                symbol == "USDT" ? "Bitcoin" : symbol,
              ), // reusing Icon helper, simplified
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: symbol,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      children: const [
                        TextSpan(
                          text: "/IDR",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Vol $vol",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),

          // Price Info
          Row(
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 70,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: Text(
                  change,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
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
                Icon(
                  Icons.mail_outline,
                  size: 26,
                  color: _isPro ? Colors.white : Colors.black,
                ),

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
            Icon(
              Icons.person_outline,
              size: 28,
              color: _isPro ? Colors.white : Colors.black,
            ),
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
        color: _isPro ? const Color(0xFF1E1E1E) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
        border: _isPro ? Border.all(color: Colors.grey.shade800) : null,
      ),
      child: Row(
        children: [
          _tabItem(
            current: !_isPro,
            text: "Pintu",
            onTap: () => setState(() => _isPro = false),
          ),
          _tabItem(
            current: _isPro,
            text: "Pro",
            onTap: () => setState(() => _isPro = true),
          ),
        ],
      ),
    );
  }

  Widget _tabItem({
    required bool current,
    required String text,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          height: 36,
          decoration: BoxDecoration(
            color:
                current
                    ? (_isPro ? const Color(0xFF2C2C2C) : Colors.white)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            boxShadow:
                current
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
              color:
                  current
                      ? (_isPro ? Colors.white : Colors.black)
                      : Colors.grey.shade600,
            ),
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
}
