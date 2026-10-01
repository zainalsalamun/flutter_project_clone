import 'package:flutter/material.dart';
import '../models/warga_kita_models.dart';

class WargaKitaData {
  static final WargaKitaData _instance = WargaKitaData._internal();
  factory WargaKitaData() => _instance;
  WargaKitaData._internal();

  // Reactive State Notifiers
  final ValueNotifier<bool> isBalanceHidden = ValueNotifier<bool>(false);
  final ValueNotifier<WargaUserProfile> currentUserNotifier = ValueNotifier<WargaUserProfile>(defaultUser);
  final ValueNotifier<KasSummary> kasSummaryNotifier = ValueNotifier<KasSummary>(defaultKasSummary);
  final ValueNotifier<List<KasTransaction>> transactionsNotifier = ValueNotifier<List<KasTransaction>>([]);
  final ValueNotifier<List<IuranPeriod>> iuranNotifier = ValueNotifier<List<IuranPeriod>>([]);
  final ValueNotifier<List<AgendaItem>> agendaNotifier = ValueNotifier<List<AgendaItem>>([]);
  final ValueNotifier<List<AnnouncementItem>> announcementsNotifier = ValueNotifier<List<AnnouncementItem>>([]);
  final ValueNotifier<List<SuratPengantarRequest>> suratRequestsNotifier = ValueNotifier<List<SuratPengantarRequest>>([]);
  final ValueNotifier<List<ComplaintReport>> complaintsNotifier = ValueNotifier<List<ComplaintReport>>([]);
  final ValueNotifier<List<ResidentContact>> residentsNotifier = ValueNotifier<List<ResidentContact>>([]);
  final ValueNotifier<List<Map<String, dynamic>>> sosAlertsNotifier = ValueNotifier<List<Map<String, dynamic>>>([]);

  void init() {
    transactionsNotifier.value = List.from(defaultTransactions);
    iuranNotifier.value = List.from(defaultIuranPeriods);
    agendaNotifier.value = List.from(defaultAgendas);
    announcementsNotifier.value = List.from(defaultAnnouncements);
    suratRequestsNotifier.value = List.from(defaultSuratRequests);
    complaintsNotifier.value = List.from(defaultComplaints);
    residentsNotifier.value = List.from(defaultResidents);
  }

  void toggleBalanceVisibility() {
    isBalanceHidden.value = !isBalanceHidden.value;
  }

  void payIuran(String periodId, String method) {
    final list = List<IuranPeriod>.from(iuranNotifier.value);
    final index = list.indexWhere((p) => p.id == periodId);
    if (index >= 0) {
      list[index].isPaid = true;
      iuranNotifier.value = list;

      // Add to Kas Transactions
      final newTx = KasTransaction(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Iuran Warga ${list[index].month} ${list[index].year} - Blok C2/14',
        category: KasCategory.iuranWarga,
        amount: list[index].totalAmount,
        isIncome: true,
        date: 'Hari ini, ${TimeOfDay.now().format(WidgetsBinding.instance.rootElement!)}',
        receiptNumber: 'KAS-RT04-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        notes: 'Pembayaran via $method oleh Budi Santoso',
        verifiedBy: 'Bendahara RT (Auto QRIS)',
      );
      transactionsNotifier.value = [newTx, ...transactionsNotifier.value];

      // Update Kas Summary
      final currentKas = kasSummaryNotifier.value;
      kasSummaryNotifier.value = KasSummary(
        totalKas: currentKas.totalKas + list[index].totalAmount,
        monthlyIncome: currentKas.monthlyIncome + list[index].totalAmount,
        monthlyExpense: currentKas.monthlyExpense,
        lastAuditDate: 'Hari Ini, Realtime',
        bankName: currentKas.bankName,
        accountNumber: currentKas.accountNumber,
        accountHolder: currentKas.accountHolder,
      );
    }
  }

  void toggleAgendaRsvp(String agendaId) {
    final list = List<AgendaItem>.from(agendaNotifier.value);
    final index = list.indexWhere((a) => a.id == agendaId);
    if (index >= 0) {
      final item = list[index];
      if (item.isConfirmed) {
        item.isConfirmed = false;
        item.attendeeCount -= 1;
      } else {
        item.isConfirmed = true;
        item.attendeeCount += 1;
      }
      agendaNotifier.value = list;
    }
  }

  void swapShift(String agendaId) {
    final list = List<AgendaItem>.from(agendaNotifier.value);
    final index = list.indexWhere((a) => a.id == agendaId);
    if (index >= 0) {
      // Toggle swap shift
      final item = list[index];
      item.isConfirmed = !item.isConfirmed;
      agendaNotifier.value = list;
    }
  }

  void addSuratRequest(SuratPengantarRequest request) {
    suratRequestsNotifier.value = [request, ...suratRequestsNotifier.value];
  }

  void addComplaint(ComplaintReport complaint) {
    complaintsNotifier.value = [complaint, ...complaintsNotifier.value];
  }

  void triggerEmergencyAlert({
    required String emergencyType,
    required String notes,
  }) {
    final newAlert = {
      'id': 'sos_${DateTime.now().millisecondsSinceEpoch}',
      'type': emergencyType,
      'notes': notes,
      'reporter': currentUserNotifier.value.name,
      'location': currentUserNotifier.value.blockNumber,
      'timestamp': 'Hari Ini, ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')} WIB',
      'status': 'Petugas Pos Ronda Merespons (Menuju Lokasi)',
    };
    sosAlertsNotifier.value = [newAlert, ...sosAlertsNotifier.value];
  }

  // --- Default Static Data ---

  static const WargaUserProfile defaultUser = WargaUserProfile(
    name: 'Pak Budi',
    fullName: 'Budi Santoso, S.T.',
    role: 'Warga Tetap',
    blockNumber: 'Blok C2 No. 14',
    rtRw: 'RT 04 / RW 08',
    village: 'Sukamaju',
    nik: '3175081903820002',
    kkNumber: '3175082405100015',
    phone: '0812-8941-2094',
    avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&auto=format&fit=crop&q=80',
    duesStatus: 'Lunas (Mei 2025)',
    isDuesPaidCurrentMonth: true,
    familyMembers: [
      FamilyMember(name: 'Budi Santoso', relation: 'Kepala Keluarga', nik: '3175081903820002', age: '43 Th'),
      FamilyMember(name: 'Siti Rahmawati', relation: 'Istri', nik: '3175085408850004', age: '40 Th'),
      FamilyMember(name: 'Dimas Anggara', relation: 'Anak (1)', nik: '3175081206120001', age: '14 Th'),
      FamilyMember(name: 'Alya Putri', relation: 'Anak (2)', nik: '3175086810160003', age: '9 Th'),
    ],
  );

  static const KasSummary defaultKasSummary = KasSummary(
    totalKas: 18450000,
    monthlyIncome: 3200000,
    monthlyExpense: 850000,
    lastAuditDate: 'Hari Ini, 09:30 WIB',
    bankName: 'Bank Mandiri',
    accountNumber: '123-00-9823412-1',
    accountHolder: 'KAS RT 04 SUKAMAJU',
  );

  static final List<KasTransaction> defaultTransactions = [
    const KasTransaction(
      id: 'tx_1',
      title: 'Iuran Sampah & Keamanan Warga (32 KK)',
      category: KasCategory.iuranWarga,
      amount: 3200000,
      isIncome: true,
      date: '20 Mei 2025',
      receiptNumber: 'KAS-RT04-250520-01',
      notes: 'Penerimaan iuran bulanan warga RT 04',
      verifiedBy: 'Bendahara: Bpk. Gunawan',
    ),
    const KasTransaction(
      id: 'tx_2',
      title: 'Honor Petugas Keamanan Pos Ronda (2 Orang)',
      category: KasCategory.satpamKeamanan,
      amount: 500000,
      isIncome: false,
      date: '18 Mei 2025',
      receiptNumber: 'KAS-RT04-250518-02',
      notes: 'Gaji paruh bulan satpam malam pos utama',
      verifiedBy: 'Ketua RT: Bpk. H. Rahmat',
    ),
    const KasTransaction(
      id: 'tx_3',
      title: 'Beli Lampu Sorot LED Pos Ronda & Blok C',
      category: KasCategory.perbaikanFasilitas,
      amount: 350000,
      isIncome: false,
      date: '15 Mei 2025',
      receiptNumber: 'KAS-RT04-250515-03',
      notes: 'Penggantian 2 unit lampu PJU penerangan jalan yang padam',
      verifiedBy: 'Seksi Pembangunan: Bpk. Agus',
    ),
    const KasTransaction(
      id: 'tx_4',
      title: 'Iuran Kas Sukarela Kegiatan Fogging DBD',
      category: KasCategory.kegiatanSosial,
      amount: 600000,
      isIncome: true,
      date: '12 Mei 2025',
      receiptNumber: 'KAS-RT04-250512-04',
      notes: 'Sumbangan swadaya warga untuk obat abate dan sewa alat fogging',
      verifiedBy: 'Bendahara: Bpk. Gunawan',
    ),
  ];

  static final List<IuranPeriod> defaultIuranPeriods = [
    IuranPeriod(
      id: 'iuran_2025_06',
      month: 'Juni',
      year: 2025,
      amountKasRT: 50000,
      amountSatpam: 60000,
      amountKebersihan: 40000,
      isPaid: false,
    ),
    IuranPeriod(
      id: 'iuran_2025_05',
      month: 'Mei',
      year: 2025,
      amountKasRT: 50000,
      amountSatpam: 60000,
      amountKebersihan: 40000,
      isPaid: true,
      paidAt: '05 Mei 2025',
      paymentMethod: 'QRIS Mandiri',
      receiptRef: 'INV/RT04/202505/014',
    ),
    IuranPeriod(
      id: 'iuran_2025_04',
      month: 'April',
      year: 2025,
      amountKasRT: 50000,
      amountSatpam: 60000,
      amountKebersihan: 40000,
      isPaid: true,
      paidAt: '03 Apr 2025',
      paymentMethod: 'Transfer Bank',
      receiptRef: 'INV/RT04/202504/014',
    ),
  ];

  static final List<AgendaItem> defaultAgendas = [
    AgendaItem(
      id: 'agenda_1',
      categoryBadge: 'Gotong Royong',
      categoryBadgeColor: const Color(0xFF10B981),
      organizer: 'Oleh: Pak RW 08',
      timeAgo: '2 jam lalu',
      title: 'Kerja Bakti Bersih Selokan & Fogging DBD Serentak',
      description: 'Menjelang musim penghujan, warga dihimbau membawa cangkul, karung, dan sapu lidi ke posko ronda utama.',
      dateFormatted: 'Minggu, 25 Mei 2025',
      timeFormatted: '07.00 – 10.30 WIB',
      location: 'Titik Kumpul Pos Ronda Utama',
      attendeeCount: 38,
      attendeeInitials: ['H', 'R', 'A'],
      isConfirmed: false,
      actionLabel: 'Ikut Serta',
    ),
    AgendaItem(
      id: 'agenda_2',
      categoryBadge: 'Keamanan Siskamling',
      categoryBadgeColor: const Color(0xFF0284C7),
      organizer: 'Seksi Keamanan RT',
      timeAgo: 'Kemarin',
      title: 'Jadwal Giliran Ronda Malam Pekan Ini (Regu Garuda)',
      description: 'Giliran jaga malam untuk Blok C1 sampai C4. Patroli keliling tiap 2 jam sekali dan membunyikan tiang lonceng pos gardu.',
      dateFormatted: 'Senin – Minggu',
      timeFormatted: 'Pukul 22.00 – 04.30 WIB',
      location: 'Pos Gardu Keamanan RT 04',
      attendeeCount: 12,
      attendeeInitials: ['B', 'G', 'W'],
      isConfirmed: false,
      actionLabel: 'Tukar Jadwal',
      isSiskamling: true,
      shiftDetails: 'Malam Ini: Regu Bpk. Hendra & Bpk. Budi\nPukul 22.00 – 04.30 WIB',
    ),
  ];

  static final List<AnnouncementItem> defaultAnnouncements = [
    AnnouncementItem(
      id: 'ann_1',
      badge: 'Surat Edaran',
      badgeColor: const Color(0xFF047857),
      title: 'Jadwal Pengambilan Sampah Besar & Daur Ulang',
      snippet: 'Dinas Kebersihan akan mengangkut perabotan bekas dan dahan pohon pada Sabtu pagi.',
      fullContent: 'Diberitahukan kepada seluruh warga RT 04 / RW 08, armada truk kebersihan khusus sampah non-organik dan dahan ranting akan melintas pada hari Sabtu, 24 Mei 2025 pukul 08.00 WIB. Mohon diletakkan di depan pagar rumah masing-masing.',
      publisher: 'Sekretaris RT 04: Bpk. Yudi',
      date: 'Hari Ini, 08:00 WIB',
      isUnread: true,
    ),
    AnnouncementItem(
      id: 'ann_2',
      badge: 'Kesehatan',
      badgeColor: const Color(0xFF0284C7),
      title: 'Pelaksanaan Posyandu Balita & Lansia Mei 2025',
      snippet: 'Pemberian vitamin A, imunisasi dasar, dan cek tensi/gula darah gratis di Balai Warga.',
      fullContent: 'Kader Posyandu Melati 04 mengundang ibu-ibu balita dan lansia untuk hadir pada penimbangan rutin dan pemeriksaan kesehatan gratis hari Selasa, 27 Mei 2025 pukul 09.00 - 12.00 WIB di Balai Warga RT 04.',
      publisher: 'Ketua Posyandu: Ibu Sri Wahyuni',
      date: 'Kemarin, 14:20 WIB',
      isUnread: true,
    ),
    AnnouncementItem(
      id: 'ann_3',
      badge: 'Kamtibmas',
      badgeColor: const Color(0xFFD97706),
      title: 'Sosialisasi Tamu Menginap Wajib Lapor 1x24 Jam',
      snippet: 'Demi keamanan bersama, tamu yang menginap lebih dari 24 jam harap dilaporkan melalui aplikasi WargaKita.',
      fullContent: 'Sesuai tata tertib lingkungan RT 04 Sukamaju, setiap warga yang menerima tamu menginap lebih dari 1x24 jam wajib mengisi formulir lapor tamu di aplikasi atau melapor ke pos satpam terdekat.',
      publisher: 'Seksi Keamanan: Bpk. Hendra',
      date: '18 Mei 2025',
      isUnread: false,
    ),
  ];

  static final List<SuratPengantarRequest> defaultSuratRequests = [
    const SuratPengantarRequest(
      id: 'srt_1',
      requestNumber: 'SP/RT04/2025/089',
      letterType: 'Surat Pengantar Perpanjangan KTP',
      purpose: 'Perpanjangan KTP Elektronik di Kelurahan Sukamaju',
      applicantName: 'Budi Santoso',
      applicantNik: '3175081903820002',
      blockNumber: 'Blok C2 No. 14',
      status: SuratStatus.selesai,
      qrCodeHash: 'WK-VERIF-RT04-SP2025089-BUDISANTOSO-VALID',
      createdDate: '10 Mei 2025',
      signedByRt: 'H. Rahmat (Ketua RT 04)',
    ),
    const SuratPengantarRequest(
      id: 'srt_2',
      requestNumber: 'SP/RT04/2025/094',
      letterType: 'Surat Keterangan Domisili Usaha',
      purpose: 'Pengajuan Rekening Bisnis UMKM Katering',
      applicantName: 'Siti Rahmawati',
      applicantNik: '3175085408850004',
      blockNumber: 'Blok C2 No. 14',
      status: SuratStatus.disetujui,
      qrCodeHash: 'WK-VERIF-RT04-SP2025094-SITIRAHMAWATI-VALID',
      createdDate: '19 Mei 2025',
      signedByRt: 'H. Rahmat (Ketua RT 04)',
    ),
  ];

  static final List<ComplaintReport> defaultComplaints = [
    ComplaintReport(
      id: 'cmp_1',
      ticketNumber: 'LAPOR-2025-042',
      category: 'Lampu Jalan Padam',
      categoryIcon: Icons.lightbulb_outline_rounded,
      title: 'Lampu PJU Tiang No. 04 Depan Blok C2 Padam',
      description: 'Lampu penerangan jalan utama depan rumah Blok C2 No. 10 padam sejak 2 hari lalu, kondisi jalan gelap saat malam.',
      locationAddress: 'Depan Blok C2 No. 10, Jalan Mawar II',
      photoUrl: 'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?w=600&auto=format&fit=crop&q=80',
      status: ComplaintStatus.diproses,
      reportedDate: '20 Mei 2025, 20:15 WIB',
      rtNotes: 'Petugas PLN / Pembangunan RT dijadwalkan mengganti bohlam LED besok pagi.',
    ),
    ComplaintReport(
      id: 'cmp_2',
      ticketNumber: 'LAPOR-2025-039',
      category: 'Saluran Air / Selokan',
      categoryIcon: Icons.water_damage_outlined,
      title: 'Endapan Lumpur & Sampah di Gorong-gorong Blok C1',
      description: 'Saluran air tersumbat dedaunan dan lumpur tebal sehingga air meluap saat hujan deras.',
      locationAddress: 'Simpang Blok C1 / C2',
      photoUrl: null,
      status: ComplaintStatus.selesai,
      reportedDate: '14 Mei 2025, 08:30 WIB',
      rtNotes: 'Sudah dibersihkan bersama saat agenda kerja bakti.',
    ),
  ];

  static const List<ResidentContact> defaultResidents = [
    ResidentContact(
      id: 'res_1',
      name: 'H. Rahmat Hidayat',
      block: 'Blok C1',
      houseNumber: 'No. 01',
      phone: '0811-2233-4455',
      role: 'Ketua RT 04',
      avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&auto=format&fit=crop&q=80',
    ),
    ResidentContact(
      id: 'res_2',
      name: 'Budi Santoso (Anda)',
      block: 'Blok C2',
      houseNumber: 'No. 14',
      phone: '0812-8941-2094',
      role: 'Warga Tetap',
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80',
    ),
    ResidentContact(
      id: 'res_3',
      name: 'Gunawan Pratama',
      block: 'Blok C3',
      houseNumber: 'No. 08',
      phone: '0813-9988-7766',
      role: 'Bendahara RT',
      avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80',
    ),
    ResidentContact(
      id: 'res_4',
      name: 'Hendra Setiawan',
      block: 'Blok C2',
      houseNumber: 'No. 05',
      phone: '0857-1122-3344',
      role: 'Koordinator Keamanan',
      avatarUrl: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=200&auto=format&fit=crop&q=80',
    ),
    ResidentContact(
      id: 'res_5',
      name: 'Dr. Anita Wijaya',
      block: 'Blok C4',
      houseNumber: 'No. 12',
      phone: '0818-4455-6677',
      role: 'Koordinator Kesehatan',
      avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&auto=format&fit=crop&q=80',
    ),
    ResidentContact(
      id: 'res_6',
      name: 'Ahmad Fauzi',
      block: 'Blok C1',
      houseNumber: 'No. 09',
      phone: '0812-3344-5566',
      role: 'Warga Tetap',
      avatarUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&auto=format&fit=crop&q=80',
    ),
  ];
}
