import 'package:flutter/material.dart';
import '../../core/warga_kita_data.dart';
import '../../core/warga_kita_theme.dart';
import '../../models/warga_kita_models.dart';

class WargaKitaPesanTab extends StatefulWidget {
  const WargaKitaPesanTab({super.key});

  @override
  State<WargaKitaPesanTab> createState() => _WargaKitaPesanTabState();
}

class _WargaKitaPesanTabState extends State<WargaKitaPesanTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAnnouncementDetail(AnnouncementItem ann) {
    setState(() {
      ann.isUnread = false;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: ann.badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  ann.badge,
                  style: WargaKitaTheme.font(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: ann.badgeColor,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                ann.title,
                style: WargaKitaTheme.font(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: WargaKitaTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${ann.publisher} • ${ann.date}',
                style: WargaKitaTheme.font(
                  fontSize: 11,
                  color: WargaKitaTheme.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: WargaKitaTheme.cardBorder),
              const SizedBox(height: 12),
              Text(
                ann.fullContent,
                style: WargaKitaTheme.font(
                  fontSize: 14,
                  color: WargaKitaTheme.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WargaKitaTheme.primaryContainer,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Tutup Pengumuman', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WargaKitaTheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Pesan & Pengumuman',
          style: WargaKitaTheme.font(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: WargaKitaTheme.textPrimary,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: WargaKitaTheme.primaryContainer,
          unselectedLabelColor: WargaKitaTheme.textSecondary,
          indicatorColor: WargaKitaTheme.primaryContainer,
          indicatorWeight: 3,
          labelStyle: WargaKitaTheme.font(fontSize: 13, fontWeight: FontWeight.w700),
          tabs: const [
            Tab(text: 'Pengumuman RT'),
            Tab(text: 'Forum Warga'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Pengumuman Resmi RT
          ValueListenableBuilder<List<AnnouncementItem>>(
            valueListenable: WargaKitaData().announcementsNotifier,
            builder: (context, announcements, _) {
              return ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: announcements.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final ann = announcements[index];
                  return InkWell(
                    onTap: () => _showAnnouncementDetail(ann),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: ann.isUnread ? const Color(0xFF9FFDD3) : WargaKitaTheme.cardBorder,
                          width: ann.isUnread ? 1.5 : 1,
                        ),
                        boxShadow: WargaKitaTheme.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: ann.badgeColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  ann.badge,
                                  style: WargaKitaTheme.font(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: ann.badgeColor,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  if (ann.isUnread)
                                    Container(
                                      width: 8,
                                      height: 8,
                                      margin: const EdgeInsets.only(right: 6),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEF4444),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  Text(
                                    ann.date,
                                    style: WargaKitaTheme.font(
                                      fontSize: 11,
                                      color: WargaKitaTheme.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            ann.title,
                            style: WargaKitaTheme.font(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: WargaKitaTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ann.snippet,
                            style: WargaKitaTheme.font(
                              fontSize: 12,
                              color: WargaKitaTheme.textSecondary,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ann.publisher,
                                style: WargaKitaTheme.font(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: WargaKitaTheme.textTertiary,
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: WargaKitaTheme.primaryContainer,
                                size: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // Tab 2: Forum Warga Diskusi
          ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4FF),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFDAE2FD)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.forum_rounded, color: WargaKitaTheme.primaryContainer, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Forum obrolan santai & informasi gotong royong warga RT 04 Sukamaju.',
                        style: WargaKitaTheme.font(fontSize: 12, color: WargaKitaTheme.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildForumCard(
                author: 'Bpk. Gunawan (Blok C3/08)',
                time: '1 jam lalu',
                message: 'Bapak ibu sekalian, ada yang tahu nomor teknisi perbaikan pompa air terdekat? Pompa di pos satpam agak tersumbat.',
                repliesCount: 4,
              ),
              _buildForumCard(
                author: 'Ibu Anita (Blok C4/12)',
                time: '3 jam lalu',
                message: 'Jangan lupa besok pagi ada posyandu balita dan lansia di Balai Warga ya ibu-ibu.',
                repliesCount: 8,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildForumCard({
    required String author,
    required String time,
    required String message,
    required int repliesCount,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: WargaKitaTheme.cardBorder),
        boxShadow: WargaKitaTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                author,
                style: WargaKitaTheme.font(fontSize: 13, fontWeight: FontWeight.w700, color: WargaKitaTheme.textPrimary),
              ),
              Text(
                time,
                style: WargaKitaTheme.font(fontSize: 11, color: WargaKitaTheme.textTertiary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: WargaKitaTheme.font(fontSize: 13, color: WargaKitaTheme.textSecondary, height: 1.45),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.chat_bubble_outline_rounded, size: 15, color: WargaKitaTheme.primaryContainer),
              const SizedBox(width: 4),
              Text(
                '$repliesCount Tanggapan',
                style: WargaKitaTheme.font(fontSize: 11, fontWeight: FontWeight.w600, color: WargaKitaTheme.primaryContainer),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
