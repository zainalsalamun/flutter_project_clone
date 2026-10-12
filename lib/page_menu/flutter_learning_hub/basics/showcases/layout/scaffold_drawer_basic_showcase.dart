import 'package:flutter/material.dart';

class ScaffoldDrawerBasicShowcase extends StatefulWidget {
  const ScaffoldDrawerBasicShowcase({super.key});

  @override
  State<ScaffoldDrawerBasicShowcase> createState() =>
      _ScaffoldDrawerBasicShowcaseState();
}

class _ScaffoldDrawerBasicShowcaseState
    extends State<ScaffoldDrawerBasicShowcase> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedMenu = 'Dashboard Utama';
  bool _hasFloatingActionButton = true;
  final Color _appBarColor = const Color(0xFF6366F1);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Mini Simulated Mobile Phone Frame with Scaffold & Drawer
        Container(
          height: 280,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: _appBarColor,
              foregroundColor: Colors.white,
              elevation: 1,
              title: const Text(
                'Scaffold Frame',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                icon: const Icon(Icons.menu_rounded, size: 20),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: _appBarColor),
                    accountName: const Text(
                      'Zainal Salamun',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    accountEmail: const Text('zainal@flutter.dev'),
                    currentAccountPicture: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        'ZS',
                        style: TextStyle(
                          color: Color(0xFF6366F1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.dashboard_rounded),
                    title: const Text('Dashboard'),
                    selected: _selectedMenu == 'Dashboard',
                    onTap: () {
                      setState(() => _selectedMenu = 'Dashboard');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person_rounded),
                    title: const Text('Profil Pengguna'),
                    selected: _selectedMenu == 'Profil Pengguna',
                    onTap: () {
                      setState(() => _selectedMenu = 'Profil Pengguna');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings_rounded),
                    title: const Text('Pengaturan'),
                    selected: _selectedMenu == 'Pengaturan',
                    onTap: () {
                      setState(() => _selectedMenu = 'Pengaturan');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.home_work_outlined,
                      size: 36,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Halaman Aktif: $_selectedMenu',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Tekan icon menu (kiri atas) atau geser dari tepi kiri untuk membuka Drawer menu.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton:
                _hasFloatingActionButton
                    ? FloatingActionButton.small(
                      backgroundColor: _appBarColor,
                      foregroundColor: Colors.white,
                      onPressed: () {},
                      child: const Icon(Icons.add),
                    )
                    : null,
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'Scaffold Controls',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              icon: const Icon(Icons.menu_open_rounded, size: 16),
              label: const Text('Buka Drawer', style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                visualDensity: VisualDensity.compact,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Show FAB:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                Switch(
                  value: _hasFloatingActionButton,
                  activeThumbColor: const Color(0xFF6366F1),
                  onChanged:
                      (v) => setState(() => _hasFloatingActionButton = v),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
