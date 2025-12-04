import 'package:flutter/material.dart';

class LivinHomePage extends StatelessWidget {
  const LivinHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF42A5F5),
      body: SafeArea(
        child: Column(
          children: [
            const _HeaderSection(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(color: Color(0xFFF5F7FA)),
                child: const _MainContent(),
              ),
            ),
            const _BottomNavBar(),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: const Color(0xFF42A5F5),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 28, color: Colors.blue),
          ),
          const SizedBox(width: 12),

          // Name + Points
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "ZAINAL SALAMUN",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "1.799 livin’poin",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),

          const Spacer(),

          Row(
            children: const [
              Icon(Icons.mail_outlined, color: Colors.white, size: 28),
              SizedBox(width: 16),
              Icon(Icons.settings, color: Colors.white, size: 28),
              SizedBox(width: 16),
              Icon(Icons.refresh, color: Colors.white, size: 28),
            ],
          ),
        ],
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: const [
        SizedBox(height: 8),
        _RekeningSection(),
        SizedBox(height: 20),
        _TransaksiFavorit(),
        SizedBox(height: 20),
        _SpesialUntukAnda(),
        SizedBox(height: 20),
        _LivinLebihMudahSection(),
        SizedBox(height: 20),
        _InvestasiSection(),
        SizedBox(height: 20),
        _ProdukPilihanSection(),
        SizedBox(height: 20),
        _PromoTerbaruSection(),
      ],
    );
  }
}

//rekening section

class _RekeningSection extends StatefulWidget {
  const _RekeningSection();

  @override
  State<_RekeningSection> createState() => _RekeningSectionState();
}

class _RekeningSectionState extends State<_RekeningSection> {
  bool showBalance = false;

  final String realBalance = "Rp 92.345.678";
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Saldo + Atur
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Rekening",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                Row(
                  children: [
                    const Text(
                      "Saldo  ",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        setState(() => showBalance = !showBalance);
                      },
                      child: Icon(
                        showBalance ? Icons.visibility : Icons.visibility_off,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(width: 16),

                    const Text(
                      "Atur",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.settings, size: 20, color: Colors.blue),
                  ],
                ),
              ],
            ),
          ),

          // Category Tabs
          const _RekeningTabs(),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tabungan Mandiri",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          showBalance ? realBalance : "Rp *****",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 70,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Produk Tabungan Lain",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                SizedBox(width: 5),
                Icon(Icons.add_circle_outline, color: Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RekeningTabs extends StatelessWidget {
  const _RekeningTabs();

  @override
  Widget build(BuildContext context) {
    final items = [
      ("Tabungan", Icons.savings),
      ("Deposito", Icons.account_balance),
      ("Kartu Kredit", Icons.credit_card),
      ("Pinjaman", Icons.percent),
      ("Investasi", Icons.stacked_line_chart),
    ];

    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 12),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final active = i == 0;
          return Container(
            margin: const EdgeInsets.only(right: 14),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:
                        active ? Colors.yellow.shade100 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    items[i].$2,
                    color: Colors.blue.shade700,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  items[i].$1,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

//Transaksi Favorit

class _TransaksiFavorit extends StatelessWidget {
  const _TransaksiFavorit();

  @override
  Widget build(BuildContext context) {
    final items = [
      ("Transfer Rupiah", Icons.send),
      ("Bayar/VA", Icons.receipt),
      ("Top-up", Icons.add_card),
      ("e-money", Icons.crop_square),
      ("Setor Tarik", Icons.account_balance),
      ("Transfer Valas", Icons.currency_exchange),
      ("Tagih Uang", Icons.chat_bubble_outline),
      ("Investasi", Icons.show_chart),
      ("QR Terima Transfer", Icons.qr_code),
      ("Lihat Semua", Icons.more_horiz),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.only(top: 18, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          // Title
          //
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                Text(
                  "Transaksi Favorit",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  "Atur",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.settings, color: Colors.blue, size: 20),
              ],
            ),
          ),

          const SizedBox(height: 16),

          //
          // Grid Menu
          //
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.count(
              crossAxisCount: 5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.72,
              children:
                  items.map((e) => _FavItem(icon: e.$2, label: e.$1)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _FavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FavItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F2FF),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue, size: 28),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class _SpesialUntukAnda extends StatelessWidget {
  const _SpesialUntukAnda();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Spesial Untuk Anda",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 14),

              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0A72C6),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Ajak keluargamu ikutan\nGerakan Mandirian Militan",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 10),
                          _BlueButton(),
                        ],
                      ),
                    ),

                    Container(
                      width: 120,
                      height: 85,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Atur Quick Pick",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Bikin transaksi rutin Anda makin cepat dan praktis.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.flash_on,
                  color: Colors.orange,
                  size: 32,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Text(
                    "e-Wallet",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  Spacer(),
                  Text(
                    "Hubungkan  ",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.link, color: Colors.blue, size: 20),
                  SizedBox(width: 14),
                  Text(
                    "Hapus  ",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.delete_outline, color: Colors.blue, size: 20),
                ],
              ),

              const SizedBox(height: 20),

              //DANA, Gopay, OVO, ShopeePay)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _WalletItem(
                    name: "DANA",
                    amount: "Rp 404.624",
                    color: Color(0xFFE8F1FF),
                  ),
                  _WalletItem(
                    name: "gopay",
                    amount: "Rp 9.227",
                    color: Color(0xFFE4FAFF),
                  ),
                  _WalletItem(
                    name: "OVO",
                    amount: "Rp 12.525",
                    color: Color(0xFFF3EAFF),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Row(
                children: const [
                  _WalletItem(
                    name: "ShopeePay",
                    amount: "Rp 6.691",
                    color: Color(0xFFFFF1ED),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BlueButton extends StatelessWidget {
  const _BlueButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            "Daftar Sekarang",
            style: TextStyle(
              color: Color(0xFF0A72C6),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          SizedBox(width: 6),
          Icon(Icons.arrow_forward_ios, size: 13, color: Color(0xFF0A72C6)),
        ],
      ),
    );
  }
}

class _WalletItem extends StatelessWidget {
  final String name;
  final String amount;
  final Color color;

  const _WalletItem({
    required this.name,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}

//Bottom
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: const [
          Expanded(
            child: _BottomNavItem(
              icon: Icons.home,
              label: "Beranda",
              active: true,
            ),
          ),

          Expanded(
            child: _BottomNavItem(
              icon: Icons.credit_card,
              label: "Produk Anda",
            ),
          ),

          Expanded(child: Center(child: _QRButton())),

          Expanded(
            child: _BottomNavItem(icon: Icons.shopping_bag, label: "Sukha"),
          ),

          Expanded(child: _BottomNavItem(icon: Icons.stars, label: "Loyalty")),
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
    final color = active ? Colors.blue : Colors.grey.shade500;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _QRButton extends StatefulWidget {
  const _QRButton();

  @override
  State<_QRButton> createState() => _QRButtonState();
}

class _QRButtonState extends State<_QRButton> {
  double scale = 1.0;
  bool pressed = false;

  void _animate() {
    setState(() {
      pressed = true;
      scale = 1.12;
    });

    Future.delayed(const Duration(milliseconds: 140), () {
      if (mounted) {
        setState(() {
          scale = 1.0;
          pressed = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animate(),
      onTapUp: (_) {},
      onTapCancel: () {
        if (mounted) {
          setState(() => scale = 1.0);
        }
      },
      child: Transform.translate(
        offset: const Offset(0, -5),
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.shade400,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(pressed ? 0.5 : 0.3),
                  blurRadius: pressed ? 22 : 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.qr_code_scanner,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}

class _LivinLebihMudahSection extends StatelessWidget {
  const _LivinLebihMudahSection();

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.stop_circle_outlined, "Top-up e-money\ninstan tanpa login"),
      (Icons.shopping_bag_outlined, "Liburan ke mana aja\nbeli tiket di Sukha"),
      (Icons.receipt_long, "Check out Shopee\nbayarnya gampang"),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Livin' Lebih Mudah",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 18),

          SizedBox(
            height: 150,
            child: ListView.separated(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder:
                  (_, i) => Container(
                    width: 164,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.blue.shade50,
                          child: Icon(
                            items[i].$1,
                            color: Colors.orange,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          items[i].$2,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvestasiSection extends StatelessWidget {
  const _InvestasiSection();

  @override
  Widget build(BuildContext context) {
    final sahamList = [
      ("CDIA", "Chandra Daya Investasi Tbk.", 1990, "60 (-2.93%)", false),
      ("BUMI", "Bumi Resources Tbk", 240, "2 (-0.83%)", false),
      ("BKSL", "Sentul City Tbk.", 177, "17 (+10.63%)", true),
      ("INET", "Sinergi Inti Andal…", 775, "125 (+19.23%)", true),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Investasi Saham Langsung di Sini",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 4),

          const Text(
            "Terakhir diperbarui 03 Des 2025 16:14:59 WIB",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),

          const SizedBox(height: 20),

          Row(
            children: const [
              Icon(Icons.star, color: Colors.blue, size: 22),
              SizedBox(width: 6),
              Text(
                "Top Value",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Column(
            children:
                sahamList.map((s) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.blue.shade50,
                          child: Text(
                            s.$1.substring(0, 1),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.blue,
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.$1,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                s.$2,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              s.$3.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              s.$4,
                              style: TextStyle(
                                fontSize: 13,
                                color: s.$5 ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ProdukPilihanSection extends StatelessWidget {
  const _ProdukPilihanSection();

  @override
  Widget build(BuildContext context) {
    final items = [
      ("KPR", "Rumah idaman dengan bunga kompetitif.", Icons.home),
      (
        "Kredit Kendaraan",
        "Cicilan ringan untuk kendaraan impian.",
        Icons.speed,
      ),
      ("Tabungan Baru", "Atur pengeluaran dengan tabungan baru.", Icons.wallet),
      (
        "Tabungan Rencana",
        "Konsisten menabung sesuai tujuan Anda.",
        Icons.calendar_today,
      ),
      ("Deposito", "Simpanan untuk bekal masa depan.", Icons.savings),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Produk Pilihan",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),

          GridView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 150,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemBuilder: (_, i) {
              return Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    // Text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          items[i].$1,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          items[i].$2,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.3,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),

                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.blue.shade50, Colors.blue.shade100],
                          ),
                        ),
                        child: Icon(
                          items[i].$3,
                          color: Colors.blue.shade700,
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PromoTerbaruSection extends StatefulWidget {
  const _PromoTerbaruSection();

  @override
  State<_PromoTerbaruSection> createState() => _PromoTerbaruSectionState();
}

class _PromoTerbaruSectionState extends State<_PromoTerbaruSection> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final promoList = [
      "Promo QR Terima Transfer\nGunakan QR terus, menangkan Rp10 Juta!",
      "Promo Cashback\nNikmati cashback hingga 50%",
      "Promo Belanja\nDiskon eksklusif di merchant pilihan",
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: Colors.white,
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
          Row(
            children: const [
              Text(
                "Promo Terbaru",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              Spacer(),
              Text(
                "Semua Promo",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios, color: Colors.blue, size: 14),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 150,
            child: PageView.builder(
              itemCount: promoList.length,
              onPageChanged: (i) => setState(() => index = i),
              itemBuilder: (_, i) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.blue.shade50,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          promoList[i],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.blue.shade100,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              promoList.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: index == i ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == i ? Colors.blue : Colors.blue.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
