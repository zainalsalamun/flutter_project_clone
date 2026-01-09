import 'package:flutter/material.dart';
import 'package:project_clone/page_menu/talenta/announcement_page.dart';
import 'package:project_clone/page_menu/talenta/menu/attendance_log.dart';
import 'package:project_clone/page_menu/talenta/menu/reimbursement.dart';
import 'package:project_clone/page_menu/talenta/menu/new_menu.dart';

import 'package:project_clone/page_menu/talenta/menu/calendar_page.dart';
import 'package:project_clone/page_menu/talenta/menu/my_payslip.dart';
import 'package:project_clone/page_menu/talenta/menu/time_off.dart';
import 'package:project_clone/page_menu/talenta/menu/live_attendance.dart';
import 'package:project_clone/page_menu/talenta/menu/overtime.dart';
import 'package:project_clone/page_menu/talenta/menu/forms_page.dart';
import 'package:project_clone/page_menu/talenta/menu/goals_page.dart';
import 'package:project_clone/page_menu/talenta/menu/my_files.dart';
import 'package:project_clone/page_menu/talenta/menu/reviews_page.dart';
import 'package:project_clone/page_menu/talenta/menu/assets_page.dart';
import 'package:project_clone/page_menu/talenta/task_page.dart';

class HrHomePage extends StatefulWidget {
  const HrHomePage({super.key});

  @override
  State<HrHomePage> createState() => _HrHomePageState();
}

class _HrHomePageState extends State<HrHomePage> {
  final _menuController = PageController();
  final _promoController = PageController(viewportFraction: 0.92);

  int _menuPage = 0;
  int _promoPage = 0;
  int _bottomIndex = 0;

  late final List<List<_MenuItem>> _menuPages;

  final _promoCards = const [
    _PromoData(
      bg: Color(0xFFB31D1D),
      title:
          'Makin flexible! Kini performance review ⏰\n'
          'dapat dilakukan di Mobile App',
      cta: 'Coba sekarang',
      rightEmoji: '📋',
    ),
    _PromoData(
      bg: Color(0xFF7B6CFF),
      title:
          'Sekarang bisa tarik gaji lebih\nawal dengan fitur Earned\n'
          'Waged Access by Mekari Flex',
      cta: 'Rekomendasikan ke HR',
      rightEmoji: '💸',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _menuPages = [
      [
        _MenuItem(
          'Reimbursement',
          Icons.receipt_long,
          const Color(0xFF2BB7C5),
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const Reimbursement()));
          },
        ),
        _MenuItem(
          'Attendance\nLog',
          Icons.note_alt,
          const Color(0xFFF39C2D),
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const AttendanceLog()));
          },
        ),
        _MenuItem(
          'Calendar',
          Icons.calendar_month,
          const Color(0xFF2F74FF),
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const CalendarPage()));
          },
        ),
        _MenuItem(
          'My Payslip',
          Icons.payments,
          const Color(0xFF18B07A),
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const MyPayslip()));
          },
        ),
        _MenuItem(
          'Time Off',
          Icons.access_time,
          const Color(0xFF2F74FF),
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const TimeOff()));
          },
        ),
        _MenuItem(
          'Live\nAttendance',
          Icons.location_on,
          const Color(0xFFF4B400),
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const LiveAttendance()));
          },
        ),
        _MenuItem(
          'Overtime',
          Icons.timelapse,
          const Color(0xFFF39C2D),
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const Overtime()));
          },
        ),

        _MenuItem(
          'My Task',
          Icons.folder_open,
          const Color(0xFFF4B400),
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const TaskPage()));
          },
        ),
      ],
      [
        _MenuItem(
          'My Payslip',
          Icons.payments,
          const Color(0xFF18B07A),
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const MyPayslip()));
          },
        ),
        _MenuItem(
          'Forms',
          Icons.description,
          const Color(0xFF7A5CFF),
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const FormsPage()));
          },
        ),
        _MenuItem(
          'Goals',
          Icons.refresh,
          const Color(0xFFF39C2D),
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const GoalsPage()));
          },
        ),
        _MenuItem(
          'My files',
          Icons.folder,
          const Color(0xFFF4B400),
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const MyFiles()));
          },
        ),
        _MenuItem(
          'Reviews',
          Icons.leaderboard,
          const Color(0xFF18B07A),
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const ReviewsPage()));
          },
        ),

        _MenuItem(
          'Assets',
          Icons.all_inbox,
          const Color(0xFF2F74FF),
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const AssetsPage()));
          },
        ),
        _MenuItem(
          'New Menu',
          Icons.star,
          const Color(0xFFE91E63),
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const NewMenu()));
          },
        ),
      ],
    ];
  }

  @override
  void dispose() {
    _menuController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF6EDED);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),
                _header(),
                const SizedBox(height: 12),
                _attendanceCard(),
                const SizedBox(height: 14),
                _menuGridCard(),
                const SizedBox(height: 12),
                _promoCarousel(),
                const SizedBox(height: 12),
                _sectionAnnouncement(),
                const SizedBox(height: 12),
                _sectionTask(),
                const SizedBox(height: 12),
                _sectionTimesheet(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Good morning,\nZainal Salamun',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            height: 1.15,
            color: Color(0xFF1A1A1A),
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Don't miss your attendance today!",
          style: TextStyle(
            fontSize: 13.5,
            color: Color(0xFF6A6A6A),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _attendanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFB31212), Color(0xFFF15A5A)],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 54,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const _TinyIconCircle(letter: 'R'),
                const SizedBox(width: 10),
                const Icon(Icons.calendar_today, size: 16, color: Colors.white),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    '17 Dec 2025 (08:00 - 17:00)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.22,
                  child: Icon(
                    Icons.access_time_filled,
                    size: 54,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.login, color: Color(0xFF1F4BD8)),
                        SizedBox(width: 8),
                        Text(
                          'Clock in',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2A2A2A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(width: 1, color: const Color(0xFFE7E7E7)),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.logout, color: Color(0xFF1F4BD8)),
                        SizedBox(width: 8),
                        Text(
                          'Clock out',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2A2A2A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuGridCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 210,
            child: PageView.builder(
              controller: _menuController,
              onPageChanged: (i) => setState(() => _menuPage = i),
              itemCount: _menuPages.length,
              itemBuilder: (_, pageIndex) {
                final items = _menuPages[pageIndex];
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 16,
                    childAspectRatio: _menuAspectRatio(context),
                  ),
                  itemBuilder: (_, i) => _menuTile(items[i]),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          _pagePillIndicator(activeIndex: _menuPage, count: _menuPages.length),
        ],
      ),
    );
  }

  double _menuAspectRatio(BuildContext context) {
    final scale = MediaQuery.of(context).textScaleFactor;
    if (scale > 1.2) return 0.7;
    if (scale > 1.0) return 0.75;
    return 0.8;
  }

  Widget _menuTile(_MenuItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: item.color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A4A4A),
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _promoCarousel() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 120,
          child: PageView.builder(
            controller: _promoController,
            onPageChanged: (i) => setState(() => _promoPage = i),
            itemCount: _promoCards.length,
            itemBuilder: (_, i) {
              final data = _promoCards[i];
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _promoCard(data),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        _dotIndicator(activeIndex: _promoPage, count: _promoCards.length),
      ],
    );
  }

  Widget _promoCard(_PromoData data) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: data.bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC83D),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    data.cta,
                    style: const TextStyle(
                      color: Color(0xFF3A2A00),
                      fontWeight: FontWeight.w800,
                      fontSize: 11.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Text(
                data.rightEmoji,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionAnnouncement() {
    return _whiteSection(
      headerLeft: 'Announcement',
      headerRight: 'View All',
      onTapViewAll: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const AnnouncementPage()));
      },
      child: Column(
        children: const [
          _RowTitleDate(
            title: 'Pengumuman Libur Nataru 2025',
            date: '17 Dec 2025',
          ),
          _DividerSoft(),
          _RowTitleDate(
            title: 'Survey Karyawan dan target 2025',
            date: '17 Dec 2025',
          ),
          _DividerSoft(),
          _RowTitleDate(
            title: 'Pengumuman Outing antar Department 2025',
            date: '17 Dec 2025',
          ),
        ],
      ),
    );
  }

  Widget _sectionTask() {
    return _whiteSection(
      headerLeft: 'Task',
      headerRight: 'View All',
      onTapViewAll: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const TaskPage()));
      },
      child: Column(
        children: const [
          _TaskRow(
            title: 'Information Teknologi',
            id: 'ID: 819',
            meta: 'No due date',
          ),
          _DividerSoft(),
          _TaskRow(
            title: 'Manajemen Risiko',
            id: 'ID: 813',
            meta: 'No due date',
          ),
          _DividerSoft(),
          _TaskRow(
            title: 'Pendaftaran rekrutment karyawan terbaru',
            id: 'ID: 807',
            meta: 'No due date',
          ),
        ],
      ),
    );
  }

  Widget _sectionTimesheet() {
    return _whiteSection(
      headerLeft: 'Timesheet',
      headerRight: 'Go to Time Tracker',
      child: Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        child: Column(
          children: const [
            SizedBox(height: 8),
            Text(
              'No timesheet',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF2A2A2A),
              ),
            ),
            SizedBox(height: 6),
            Text(
              "As you record timesheet, they'll show up here.",
              style: TextStyle(
                color: Color(0xFF7A7A7A),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _whiteSection({
    required String headerLeft,
    required String headerRight,
    required Widget child,
    VoidCallback? onTapViewAll,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                headerLeft,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              const Spacer(),

              // ⬇️ View All jadi fleksibel
              if (onTapViewAll != null)
                GestureDetector(
                  onTap: onTapViewAll,
                  behavior: HitTestBehavior.opaque,
                  child: Text(
                    headerRight,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF4967FF),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _pagePillIndicator({required int activeIndex, required int count}) {
    return SizedBox(
      width: 40,
      height: 5,
      child: Row(
        children: List.generate(count, (i) {
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: EdgeInsets.only(right: i == count - 1 ? 0 : 6),
              decoration: BoxDecoration(
                color:
                    i == activeIndex
                        ? const Color(0xFF2F74FF)
                        : const Color(0xFFE6E6E6),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _dotIndicator({required int activeIndex, required int count}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: active ? 8 : 6,
          height: active ? 8 : 6,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF6A6A6A) : const Color(0xFFD0D0D0),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  Widget _bottomNav() {
    return BottomNavigationBar(
      currentIndex: _bottomIndex,
      onTap: (i) => setState(() => _bottomIndex = i),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF2F74FF),
      unselectedItemColor: const Color(0xFF9AA0A6),
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.groups_2_outlined),
          label: 'Employee',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          label: 'Request',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inbox_outlined),
          label: 'Inbox',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Account',
        ),
      ],
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _MenuItem(this.title, this.icon, this.color, {this.onTap});
}

class _TinyIconCircle extends StatelessWidget {
  final String letter;
  const _TinyIconCircle({required this.letter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.35), width: 1),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _DividerSoft extends StatelessWidget {
  const _DividerSoft();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 1,
      color: const Color(0xFFEDEDED),
    );
  }
}

class _RowTitleDate extends StatelessWidget {
  final String title;
  final String date;
  const _RowTitleDate({required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F1F1F),
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          date,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF8B8B8B),
          ),
        ),
      ],
    );
  }
}

class _TaskRow extends StatelessWidget {
  final String title;
  final String id;
  final String meta;
  const _TaskRow({required this.title, required this.id, required this.meta});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFFBDBDBD), width: 1),
          ),
          child: const Icon(Icons.check, size: 14, color: Color(0xFFBDBDBD)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13.8,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2A2A2A),
                ),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Text(
                    id,
                    style: const TextStyle(
                      fontSize: 12.2,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8B8B8B),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    meta,
                    style: const TextStyle(
                      fontSize: 12.2,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8B8B8B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        CircleAvatar(
          radius: 12,
          backgroundColor: const Color(0xFFE5E5E5),
          child: Icon(
            Icons.person,
            size: 16,
            color: Colors.black.withOpacity(0.35),
          ),
        ),
      ],
    );
  }
}

class _PromoData {
  final Color bg;
  final String title;
  final String cta;
  final String rightEmoji;
  const _PromoData({
    required this.bg,
    required this.title,
    required this.cta,
    required this.rightEmoji,
  });
}
