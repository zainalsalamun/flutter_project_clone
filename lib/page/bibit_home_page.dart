import 'package:flutter/material.dart';

class BibitHomePage extends StatelessWidget {
  const BibitHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      bottomNavigationBar: _bottomNavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _bibitBar(),
              _portfolioCard(),
              _menuRow(),
              _produkInvestasi(),
              _moneyMarketCard(),
              _topReksaDana(),
              _rekomendasiRobo(),
              _liveTransaction(),
              _promoSection(),
              _artikelSection(),
              _eventSection(),
              _academyEducationSection(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bibitBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_rounded,
                color: Color(0xFF00A86B),
                size: 26,
              ),
              const SizedBox(width: 6),
              const Text(
                "bibit",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D1D1D),
                ),
              ),
            ],
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_none, size: 28),
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    "32",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // PORTFOLIO CARD
  // ----------------------------------------------------------
  Widget _portfolioCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 3),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Nilai Portofolio",
            style: TextStyle(fontSize: 14, color: Color(0xFF7A7A7A)),
          ),
          const SizedBox(height: 4),

          // nominal
          Row(
            children: const [
              Text(
                "Rp668,437",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D1D1D),
                ),
              ),
              SizedBox(width: 6),
              Icon(Icons.lock_outline, size: 18, color: Colors.grey),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Keuntungan\nRp34,384",
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Color(0xFF00A86B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "Imbal Hasil\n+5.42%",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Color(0xFF00A86B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // MENU ICON ROW
  // ----------------------------------------------------------
  Widget _menuRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _menuItem(Icons.pie_chart_outline, "Portofolio"),
          _menuItem(Icons.calendar_today, "SIP"),
          _menuItem(Icons.card_giftcard, "Referral"),
          _menuItem(Icons.grid_view, "Lainnya"),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title) {
    return Column(
      children: [
        Icon(icon, size: 26, color: Color(0xFF00A86B)),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  // ----------------------------------------------------------
  // PRODUK INVESTASI
  // ----------------------------------------------------------
  Widget _produkInvestasi() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Produk Investasi",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconItem(Icons.spa, "Reksa Dana"),
              _iconItem(Icons.flag_outlined, "SBN Retail"),
              _iconItem(Icons.shield_outlined, "FR Syariah"),
              _iconItem(Icons.candlestick_chart, "Saham"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconItem(IconData icon, String title) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Color(0xFFE8E8E8)),
          ),
          child: Icon(icon, color: Color(0xFF00A86B)),
        ),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  // ----------------------------------------------------------
  // MAJORIS PASAR UANG CARD
  // ----------------------------------------------------------
  Widget _moneyMarketCard() {
    return Container(
      margin: const EdgeInsets.only(top: 18, left: 16, right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Return Dihitung Harian",
            style: TextStyle(fontSize: 13, color: Color(0xFF00A86B)),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Majoris Pasar Uang Syariah Indonesia",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "RD Pasar Uang   •   1Y Return 5.31%",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xFF00A86B)),
            ),
            child: const Center(
              child: Text(
                "Beli Sekarang",
                style: TextStyle(
                  color: Color(0xFF00A86B),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // TOP REKSA DANA SECTION
  // ----------------------------------------------------------
  Widget _topReksaDana() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Top Reksa Dana",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Text(
                "Lihat Semua",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF00A86B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          const Text(
            "Rutin Investasi di Top Reksa Dana",
            style: TextStyle(fontSize: 13, color: Color(0xFF6F6F6F)),
          ),

          const SizedBox(height: 20),

          // TAB BAR MANUAL
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6F2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _tabItem("Pasar Uang", true),
                _tabItem("Obligasi", false),
                _tabItem("Saham", false),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // LIST RANKING
          _rankItem(
            rank: 1,
            color: Color(0xFFFFD700),
            title: "Majoris Pasar Uang Syariah Indonesia",
            return1Y: "5.31%",
          ),
          const SizedBox(height: 14),

          _rankItem(
            rank: 2,
            color: Color(0xFFC0C0C0),
            title: "Trimegah Kas Syariah",
            return1Y: "5.26%",
          ),
          const SizedBox(height: 14),

          _rankItem(
            rank: 3,
            color: Color(0xFFCD7F32),
            title: "Bahana Likuid Syariah Kelas G",
            return1Y: "5.24%",
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _tabItem(String text, bool active) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              color: active ? Color(0xFF00A86B) : Color(0xFF6F6F6F),
            ),
          ),
        ),
      ),
    );
  }

  Widget _rankItem({
    required int rank,
    required Color color,
    required String title,
    required String return1Y,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 6),

          // Medal icon or rank circle
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.2),
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: color,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Fund title
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1D1D1D),
              ),
            ),
          ),

          // Return
          Text(
            return1Y,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF00A86B),
            ),
          ),

          const SizedBox(width: 10),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // REKOMENDASI ROBO KAMU
  // ----------------------------------------------------------
  Widget _rekomendasiRobo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Robo",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 6),

          const Text(
            "Rekomendasi Robo Kamu",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 4),

          const Text(
            "Langsung top up portofolio kamu sesuai dengan profil risiko kamu.",
            style: TextStyle(fontSize: 13, color: Color(0xFF6F6F6F)),
          ),

          const SizedBox(height: 14),

          // Banner Hijau
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF00A86B).withOpacity(0.15),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Color(0xFF00A86B),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Yuk Kenalan Sama Robo\nBagi kamu yang belum mengerti Robo",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                const Icon(Icons.close, size: 20, color: Colors.grey),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Card Dana Pensiun
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Dana Pensiun + kanan "Ubah"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Dana Pensiun",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Ubah",
                      style: TextStyle(
                        color: Color(0xFF00A86B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                const Text(
                  "Profil Risiko: 7",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),

                const SizedBox(height: 16),

                // Breakdown list
                _roboItem(
                  color: const Color(0xFF00A86B),
                  title: "Pasar Uang",
                  fund: "Majoris Pasar Uang Syariah Indonesia",
                  percent: "10%",
                ),

                const SizedBox(height: 12),

                _roboItem(
                  color: const Color(0xFFFF9800),
                  title: "Obligasi",
                  fund: "Trimegah Dana Tetap Syariah Kelas A",
                  percent: "43%",
                ),

                const SizedBox(height: 12),

                _roboItem(
                  color: const Color(0xFF4CAF50),
                  title: "Saham",
                  fund: "BNP Paribas Pesona Syariah",
                  percent: "47%",
                ),

                const SizedBox(height: 18),

                // Button Investasi
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A86B),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "Investasi Sekarang",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _roboItem({
    required Color color,
    required String title,
    required String fund,
    required String percent,
  }) {
    return Row(
      children: [
        // Colored line indicator (Bibit style)
        Container(
          width: 4,
          height: 45,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),

        const SizedBox(width: 12),

        // Fund info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                fund,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),

        // Percent
        Text(
          percent,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D1D1D),
          ),
        ),

        const SizedBox(width: 4),

        const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      ],
    );
  }

  // ----------------------------------------------------------
  // LIVE TRANSACTION SECTION
  // ----------------------------------------------------------
  Widget _liveTransaction() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Transaksi Terbaru",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Text(
                "Lihat Semua",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF00A86B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          const Text(
            "Lihat transaksi pengguna Bibit secara real-time",
            style: TextStyle(fontSize: 13, color: Color(0xFF6F6F6F)),
          ),

          const SizedBox(height: 16),

          // 3 items example (bisa di-loop nanti)
          _liveItem(
            avatarColor: Color(0xFF00A86B),
            name: "Bibit User",
            action: "Beli",
            fund: "Majoris Pasar Uang Syariah Indonesia",
            timeAgo: "2 menit lalu",
          ),

          const SizedBox(height: 12),

          _liveItem(
            avatarColor: Color(0xFF4CAF50),
            name: "Bibit User",
            action: "Jual",
            fund: "Trimegah Dana Tetap Syariah",
            timeAgo: "5 menit lalu",
          ),

          const SizedBox(height: 12),

          _liveItem(
            avatarColor: Color(0xFFFF9800),
            name: "Bibit User",
            action: "Beli",
            fund: "BNP Paribas Pesona Syariah",
            timeAgo: "8 menit lalu",
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _liveItem({
    required Color avatarColor,
    required String name,
    required String action,
    required String fund,
    required String timeAgo,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Avatar bulat warna
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: avatarColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, color: avatarColor, size: 26),
          ),

          const SizedBox(width: 14),

          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "$action $fund",
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Waktu
          Text(
            timeAgo,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // PROMO SECTION
  // ----------------------------------------------------------
  Widget _promoSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Promo Menarik Untukmu",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 4),

          const Text(
            "Dapatkan promo menarik dari Bibit",
            style: TextStyle(fontSize: 13, color: Color(0xFF6F6F6F)),
          ),

          const SizedBox(height: 14),

          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _promoCard(
                  image: "https://picsum.photos/400/200?1",
                  title: "Cashback hingga Rp50.000 untuk kamu!",
                  category: "Promo",
                ),
                const SizedBox(width: 12),
                _promoCard(
                  image: "https://picsum.photos/400/200?2",
                  title: "Ikuti Event Webinar Bibit dan Menang Hadiah",
                  category: "Event",
                ),
                const SizedBox(width: 12),
                _promoCard(
                  image: "https://picsum.photos/400/200?3",
                  title: "Dapatkan Cashback untuk SIP bulanan",
                  category: "Cashback",
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _promoCard({
    required String image,
    required String title,
    required String category,
  }) {
    return Container(
      width: 280,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.55),
              Colors.black.withOpacity(0.1),
            ],
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                category.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF00A86B),
                ),
              ),
            ),

            const Spacer(),

            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // ARTIKEL SECTION
  // ----------------------------------------------------------
  Widget _artikelSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Artikel Terbaru",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 4),

          const Text(
            "Baca artikel pilihan dari Bibit Academy",
            style: TextStyle(fontSize: 13, color: Color(0xFF6F6F6F)),
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 260,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _artikelCard(
                  image: "https://picsum.photos/400/300?10",
                  tag: "Investasi",
                  title: "Cara Memulai Investasi Reksa Dana untuk Pemula",
                  duration: "3 menit baca",
                ),
                const SizedBox(width: 14),

                _artikelCard(
                  image: "https://picsum.photos/400/300?11",
                  tag: "Pensiun",
                  title: "Tips Menyiapkan Dana Pensiun Lebih Awal",
                  duration: "4 menit baca",
                ),
                const SizedBox(width: 14),

                _artikelCard(
                  image: "https://picsum.photos/400/300?12",
                  tag: "Saham",
                  title: "Mengenal Indeks Saham Syariah Indonesia",
                  duration: "5 menit baca",
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _artikelCard({
    required String image,
    required String tag,
    required String title,
    required String duration,
  }) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            ),
            child: Image.network(
              image,
              height: 130,
              width: 250,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF00A86B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  duration,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6F6F6F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // EVENT SECTION
  // ----------------------------------------------------------
  Widget _eventSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Event Menarik Untukmu",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 4),

          const Text(
            "Ikuti event pilihan Bibit",
            style: TextStyle(fontSize: 13, color: Color(0xFF6F6F6F)),
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 260, // FIX OVERFLOW — card tinggi total ~250 px
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _eventCard(
                  image: "https://picsum.photos/500/300?21",
                  title: "Belajar Investasi Syariah untuk Pemula",
                  subtitle: "Live Webinar Bersama Ahli",
                  status: "Gratis • Online",
                ),
                const SizedBox(width: 14),

                _eventCard(
                  image: "https://picsum.photos/500/300?22",
                  title: "Cara Menyiapkan Dana Pendidikan Anak",
                  subtitle: "Kelas Online Interaktif",
                  status: "Gratis • Online",
                ),
                const SizedBox(width: 14),

                _eventCard(
                  image: "https://picsum.photos/500/300?23",
                  title: "Strategi Investasi Obligasi Syariah",
                  subtitle: "Webinar Terbatas",
                  status: "Gratis • Online",
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _eventCard({
    required String image,
    required String title,
    required String subtitle,
    required String status,
  }) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              image,
              height: 130,
              width: 280,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6F6F6F),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  status,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00A86B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // ACADEMY EDUCATION BANNER SECTION (like Bibit)
  // ----------------------------------------------------------
  Widget _academyEducationSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo + Title
          Row(
            children: const [
              Icon(Icons.school, color: Color(0xFF00A86B), size: 26),
              SizedBox(width: 6),
              Text(
                "Academy",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D1D1D),
                ),
              ),
              Spacer(),
              Text(
                "Lihat Semua",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF00A86B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 20),
            ],
          ),

          const SizedBox(height: 14),

          const Text(
            "Pusat Edukasi Investasi",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 14),

          // Carousel container
          SizedBox(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _academyBannerCard(
                  bgColor: const Color(0xFFFFEFEF),
                  image: "https://picsum.photos/id/50/400/300",
                  title: "Surat Berharga Negara (SBN)",
                  teacher: "Ricky Susanto Joeng, CFP®",
                  videos: "8 Video",
                ),
                const SizedBox(width: 14),
                _academyBannerCard(
                  bgColor: const Color(0xFFEFF7FF),
                  image: "https://picsum.photos/id/60/400/300",
                  title: "Obligasi Syariah",
                  teacher: "Galih Pratama, CFP®",
                  videos: "9 Video",
                ),
                const SizedBox(width: 14),
                _academyBannerCard(
                  bgColor: const Color(0xFFEFFEF4),
                  image: "https://picsum.photos/id/70/400/300",
                  title: "Dasar-Dasar Investasi",
                  teacher: "Andi Wijaya",
                  videos: "12 Video",
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Page Indicator (static for now)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_dot(true), _dot(false), _dot(false)],
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget _dot(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: active ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF00A86B) : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _academyBannerCard({
    required Color bgColor,
    required String image,
    required String title,
    required String teacher,
    required String videos,
  }) {
    return Container(
      width: 310,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          // Right-side image (teacher)
          Positioned(
            right: -10,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(image, height: 170, fit: BoxFit.cover),
            ),
          ),

          // Left-side text
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  teacher,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6F6F6F),
                  ),
                ),

                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    videos,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // BOTTOM NAVIGATION
  // ----------------------------------------------------------
  Widget _bottomNavBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _navItem(Icons.home_outlined, "Home"),
          _navItem(Icons.pie_chart_outline, "Portfolio"),
          _navItem(Icons.search, "Explore"),
          _navItem(Icons.swap_horiz_rounded, "Transaksi"),
          _navItem(Icons.person_outline, "Akun"),
        ],
      ),
    );
  }
}

// NAV ITEM
class _navItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _navItem(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Color(0xFF00A86B)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
