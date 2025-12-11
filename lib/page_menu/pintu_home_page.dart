import 'package:flutter/material.dart';

class PintuHomePage extends StatelessWidget {
  const PintuHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _bottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _topSection(),
              const SizedBox(height: 16),
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
    );
  }

  // -------------------------------------------------------------------------
  // APP BAR
  Widget _topSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Align(alignment: Alignment.centerLeft, child: _tabSwitch()),
        ),
        Row(
          children: [
            Icon(Icons.mail_outline, size: 26),
            const SizedBox(width: 16),
            Icon(Icons.person_outline, size: 28),
          ],
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // TAB SWITCH
  Widget _tabSwitch() {
    return Container(
      height: 36,
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

  // -------------------------------------------------------------------------
  // TOTAL ASET & BALANCE
  Widget _totalAsetSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Total Nilai Aset", style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(height: 6),
        Row(
          children: [
            const Text(
              "Rp 189.519",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            Icon(Icons.visibility_outlined),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "Saldo Aktif Rupiah Rp 140",
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

  // -------------------------------------------------------------------------
  // ANNOUNCEMENT CARD
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

  // -------------------------------------------------------------------------
  // QUICK MENU GRID
  Widget _quickMenu() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1,
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
    );
  }

  // ignore: non_constant_identifier_names
  static Widget _menuItem(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 28),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(fontSize: 13)),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // TOP MOVERS HORIZONTAL
  Widget _topMovers() {
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
            children: [
              _moverCard("MAVIA", "Rp 1.100", "+32,2%"),
              _moverCard("HEI", "Rp 2.666", "-29,34%"),
              _moverCard("FWOG", "Rp 262,4", "+22,5%"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _moverCard(String name, String price, String change) {
    final isUp = change.contains("+");
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
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(price),
          const SizedBox(height: 6),
          Text(
            change,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isUp ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // WATCHLIST
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            coin,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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

  // -------------------------------------------------------------------------
  // GENERIC SECTION TITLE
  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  // -------------------------------------------------------------------------
  // PROMO CAROUSEL
  Widget _promoCarousel() {
    return SizedBox(
      height: 160,
      child: PageView(
        children: [
          _bannerCard(Colors.blue.shade700, "Trading Futures dapat Rp 100 rb"),
          _bannerCard(Colors.deepPurple, "Promo Lainnya"),
        ],
      ),
    );
  }

  Widget _bannerCard(Color color, String text) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // ACADEMY CAROUSEL
  Widget _academyCarousel() {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _academyCard("Cara Kelola Risiko Trading Futures"),
          _academyCard("Apa itu Fusaka Hardfork Ethereum?"),
        ],
      ),
    );
  }

  Widget _academyCard(String title) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  // -------------------------------------------------------------------------
  // BELAJAR CRYPTO
  Widget _learnCryptoCarousel() {
    return SizedBox(
      height: 170,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _learnCard("Apa itu Bitcoin? Cara Kerja, Membeli dan Legalitasnya"),
          _learnCard("Apa itu Crypto Futures?"),
        ],
      ),
    );
  }

  Widget _learnCard(String title) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  // -------------------------------------------------------------------------
  // FAQ
  Widget _faq() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _faqItem("Cara Deposit Rupiah"),
        _faqItem("Jumlah Min/Maks Trading"),
        _faqItem("Cara Tarik Rupiah"),
      ],
    );
  }

  Widget _faqItem(String title) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(title),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // NEWS LIST
  Widget _newsList() {
    final items = [
      "Bagaimana Sembilan Hari Mengubah Kepemilikan Bitcoin",
      "Ledger Finds Popular Smartphone Chip Vulnerability",
      "High-Leverage Crypto ETF Applications Ditahan SEC",
      "BlackRock Remains Risk-on as Mega Forces Transform Markets",
    ];

    return Column(children: items.map((t) => _newsItem(t)).toList());
  }

  Widget _newsItem(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Container(width: 60, height: 60, color: Colors.grey.shade300),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // BOTTOM NAV BAR
  Widget _bottomNav() {
    return BottomNavigationBar(
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
    );
  }
}
