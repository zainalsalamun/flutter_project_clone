import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/abc_bloc.dart';
import '../bloc/abc_event.dart';
import '../bloc/abc_state.dart';
import 'qris_page.dart';

class MAbcPageWrapper extends StatelessWidget {
  const MAbcPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AbcBloc()..add(LoadAccountData()),
      child: const MyAbcHomePage(),
    );
  }
}

class MyAbcHomePage extends StatefulWidget {
  const MyAbcHomePage({super.key});

  @override
  State<MyAbcHomePage> createState() => _MyAbcHomePageState();
}

class _MyAbcHomePageState extends State<MyAbcHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF005AA9), // myABC blue color
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  child: _buildCurrentTab(),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QrisPage()),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(top: 30),
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF00A2E9), // Light blue for QRIS
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
              SizedBox(height: 2),
              Text(
                'QRIS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildHistoryTab();
      case 2:
        // Index 2 is visually skipped for the QRIS button, but if tapped on empty space, we can just return home or keep empty.
        return _buildHomeTab();
      case 3:
        return _buildNotificationTab();
      case 4:
        return _buildAccountTab();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: BlocBuilder<AbcBloc, AbcState>(
        builder: (context, state) {
          if (state is AbcLoading || state is AbcInitial) {
            return const SizedBox(
              height: 300,
              child: Center(child: CircularProgressIndicator(color: Color(0xFF005AA9))),
            );
          } else if (state is AbcError) {
            return Center(child: Text(state.message));
          } else if (state is AbcLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'HALO, ${state.account.name.toUpperCase()}',
                    style: const TextStyle(
                      color: Color(0xFF005AA9),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildAccountCard(context, state),
                const SizedBox(height: 30),
                _buildMainMenuGrid(),
                const SizedBox(height: 30),
                _buildSectionTitle('BAYAR & ISI ULANG'),
                const SizedBox(height: 16),
                _buildHorizontalMenu(),
                const SizedBox(height: 30),
                _buildSectionTitle('TRANSAKSI FAVORIT'),
                const SizedBox(height: 16),
                _buildFavoriteMenu(),
                const SizedBox(height: 40),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHistoryTab() {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: 5,
      separatorBuilder: (context, index) => const Divider(height: 30),
      itemBuilder: (context, index) {
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F3FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.compare_arrows, color: Color(0xFF005AA9)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Transfer ke Budi',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '02 Aug 2026 - 15:30',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Text(
              '- IDR 50.000',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotificationTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Promo Khusus',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF005AA9)),
                  ),
                  Text(
                    'Baru saja',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Nikmati cashback hingga 50% untuk pembayaran menggunakan QRIS di merchant pilihan!',
                style: TextStyle(fontSize: 13, height: 1.4),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAccountTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: Color(0xFF005AA9),
          child: Icon(Icons.person, size: 40, color: Colors.white),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'ANDHINI PUTRI',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const Center(
          child: Text(
            'andhini@example.com',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 30),
        _buildAccountMenuItem(Icons.lock, 'Ganti PIN'),
        _buildAccountMenuItem(Icons.fingerprint, 'Biometrik'),
        _buildAccountMenuItem(Icons.description, 'Syarat & Ketentuan'),
        _buildAccountMenuItem(Icons.headset_mic, 'Pusat Bantuan'),
      ],
    );
  }

  Widget _buildAccountMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFE6F3FF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF005AA9), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'myABC',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.exit_to_app, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, AbcLoaded state) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'IDR ', decimalDigits: 0);
    final balanceText = state.isBalanceVisible 
        ? currencyFormatter.format(state.account.balance)
        : 'IDR *********';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Rekening ${state.account.accountNumber.substring(0, 6)}-XXX',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600, size: 16),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                balanceText,
                style: const TextStyle(
                  color: Color(0xFF005AA9),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              context.read<AbcBloc>().add(ToggleBalanceVisibility());
            },
            icon: Icon(
              state.isBalanceVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey.shade300,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainMenuGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 24,
        crossAxisSpacing: 8,
        childAspectRatio: 0.8,
        children: [
          _buildGridItem(Icons.swap_horiz, 'Transfer', const Color(0xFF005AA9)),
          _buildGridItem(Icons.monetization_on, 'Deposito', const Color(0xFF7E8C2F)),
          _buildGridItem(Icons.show_chart, 'Welma', const Color(0xFF009688)),
          _buildGridItem(Icons.calendar_month, 'Transaksi\nTerjadwal', const Color(0xFF9C27B0)),
          _buildGridItem(Icons.receipt_long, 'e-Statement', const Color(0xFF03A9F4)),
          _buildGridItem(Icons.stars, 'Kredit\nKonsumen', const Color(0xFFFF5722)),
          _buildGridItem(Icons.credit_card, 'Flazz', const Color(0xFF005AA9)),
          _buildGridItem(Icons.phone_android, 'Cardless', const Color(0xFF005AA9)),
        ],
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String title, Color color) {
    return Column(
      children: [
        Icon(icon, size: 36, color: color),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF005AA9),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF005AA9),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const Text(
            'Selengkapnya',
            style: TextStyle(
              color: Color(0xFF005AA9),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalMenu() {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildHorizontalItem(Icons.phone_iphone, 'Paket Data'),
          _buildHorizontalItem(Icons.health_and_safety, 'BPJS\nKesehatan'),
          _buildHorizontalItem(Icons.water_drop, 'Air'),
          _buildHorizontalItem(Icons.shield, 'Asuransi'),
          _buildHorizontalItem(Icons.home, 'Pinjaman'),
        ],
      ),
    );
  }

  Widget _buildHorizontalItem(IconData icon, String title) {
    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F3FF),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF005AA9), size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF005AA9),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteMenu() {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFavoriteItem('BP', 'Budi Putra', Colors.orange),
          _buildFavoriteItem('PLN', 'Listrik', Colors.green),
          _buildFavoriteItem('OVO', 'Top up OVO', Colors.purple),
          _buildFavoriteItem('AS', 'Andi Susanto', Colors.blue),
        ],
      ),
    );
  }

  Widget _buildFavoriteItem(String initials, String name, Color color) {
    return Container(
      width: 70,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color.withOpacity(0.2),
            child: Text(
              initials,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF005AA9),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF003366), // Dark blue for bottom bar
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBottomNavItem(Icons.home, 'Beranda', 0),
              _buildBottomNavItem(Icons.receipt_long, 'Riwayat', 1),
              const SizedBox(width: 40), // Empty space for FAB
              _buildBottomNavItem(Icons.notifications, 'Notifikasi', 3),
              _buildBottomNavItem(Icons.person, 'Akun Saya', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    final isActive = _currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.white54,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white54,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
