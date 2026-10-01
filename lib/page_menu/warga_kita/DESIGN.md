# WargaKita Civic System - Design System & UI Specification

## 1. System Overview
**WargaKita Civic System** is a mobile-first civic technology platform designed specifically for Indonesian neighborhood units (*Rukun Tetangga / Rukun Warga - RT/RW*). It merges grassroots community warmth (*gotong royong*) with administrative transparency, digital accountability, and real-time community safety.

---

## 2. Design Tokens & Visual Language

### 2.1 Color Palette
The color architecture reflects administrative reliability, botanical freshness, and high-visibility status indicators:

```yaml
colors:
  surface: '#faf8ff'
  surface-dim: '#d2d9f4'
  surface-bright: '#faf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f3ff'
  surface-container: '#eaedff'
  surface-container-high: '#e2e7ff'
  surface-container-highest: '#dae2fd'
  on-surface: '#131b2e'
  on-surface-variant: '#3e4943'
  inverse-surface: '#283044'
  inverse-on-surface: '#eef0ff'
  outline: '#6e7a73'
  outline-variant: '#bdc9c1'
  surface-tint: '#006c4e'
  primary: '#005d42'                  # Deep Botanical Forest Green
  on-primary: '#ffffff'
  primary-container: '#047857'        # Vivid Forest Green
  on-primary-container: '#9ffdd3'
  inverse-primary: '#7bd8b1'
  secondary: '#006c49'
  on-secondary: '#ffffff'
  secondary-container: '#6cf8bb'
  on-secondary-container: '#00714d'
  tertiary: '#a60418'                 # Urgent Crimson
  on-tertiary: '#ffffff'
  tertiary-container: '#c9282d'
  on-tertiary-container: '#ffe4e1'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#97f5cc'
  primary-fixed-dim: '#7bd8b1'
  on-primary-fixed: '#002115'
  on-primary-fixed-variant: '#00513a'
  secondary-fixed: '#6ffbbe'
  secondary-fixed-dim: '#4edea3'
  on-secondary-fixed: '#002113'
  on-secondary-fixed-variant: '#005236'
  tertiary-fixed: '#ffdad7'
  tertiary-fixed-dim: '#ffb3ad'
  on-tertiary-fixed: '#410004'
  on-tertiary-fixed-variant: '#930013'
  background: '#faf8ff'
  on-background: '#131b2e'
  surface-variant: '#dae2fd'
```

### 2.2 Typography Scale
Powered by **Plus Jakarta Sans** for maximum legibility and modern civic identity:

| Role | Font Size | Weight | Line Height | Usage |
| :--- | :--- | :--- | :--- | :--- |
| **Headline XL** | 36px (Mobile: 28px) | ExtraBold (800) | 44px (36px) | Greeting headers, large metrics |
| **Headline LG** | 30px (Mobile: 24px) | Bold (700) | 38px (32px) | Screen titles, cash balances |
| **Headline MD** | 20px | Bold (700) | 28px | Section headers (*Layanan Warga*, *Kabar RT*) |
| **Headline SM** | 18px | SemiBold (600) | 26px | Card titles, event headlines |
| **Body LG** | 16px | Regular (400) | 24px | Primary descriptions, modal copy |
| **Body MD** | 14px | Regular (400) / Medium (500) | 20px | Standard body, form fields, lists |
| **Body SM** | 12px | Regular (400) / Medium (500) | 18px | Subtitles, event metadata, captions |
| **Label LG** | 14px | SemiBold (600) | 20px | Button labels, tabs |
| **Label MD** | 12px | SemiBold (600) | 16px | Status badges (*Lunas*, *Siaga*, *Gotong Royong*) |
| **Label SM** | 10px | Bold (700) | 14px | Micro badges (*2 Baru*, *Audit Realtime*, *TTD QR*) |

### 2.3 Spacing, Radii & Elevation
- **Card Radius:** `16px` (`rounded-lg`) for content cards; `24px` (`rounded-xl`) for hero widgets (Kas, SOS).
- **Pill Radius:** `9999px` (`rounded-full`) for tags, badges, and action pills.
- **Elevation Level 1 (Cards):** Soft dual-layer ambient shadow `0 2px 8px -2px rgba(15, 23, 42, 0.04), 0 1px 3px 0 rgba(15, 23, 42, 0.02)` with a `1px` border of `rgba(226, 232, 240, 0.8)`.
- **Elevation Level 2 (Sheets & Modals):** `0 12px 24px -4px rgba(15, 23, 42, 0.08)`.
- **Elevation Level 3 (Emergency SOS):** Vibrant Crimson ambient glow `0 20px 32px -8px rgba(239, 68, 68, 0.25)`.

---

## 3. Core Modules & Screen Breakdown

```
WargaKita Civic System
├── 1. Main Navigation (Bottom Bar)
│   ├── [Tab 1] Beranda (Home Dashboard)
│   │   ├── Top Civic App Bar (Logo, RT/RW Badge, Notif Bell, Avatar)
│   │   ├── Resident Greeting & Status Pill (Pak Budi • Blok C2 No. 14 • Lunas)
│   │   ├── Total Kas Lingkungan RT 04 (Realtime Balance, Income/Expense, Ledger Link)
│   │   ├── Tombol Darurat (SOS) Card (Pulsing Beacon, Siaga Darurat, Pos Ronda Status)
│   │   ├── Layanan Warga 2x2 Grid (Bayar Iuran, Pengumuman, Surat Pengantar, Lapor Masalah)
│   │   └── Kabar & Agenda RT (Kerja Bakti, Jadwal Ronda, RSVP Actions)
│   ├── [Tab 2] Warga (Directory of Residents by Blok C1-C4 with KK status)
│   ├── [Tab 3] Pesan (Official Announcements, Circulars & Discussion Board)
│   └── [Tab 4] Profil (Resident Profile, Family KK, Payment History & Contacts)
│
├── 2. Sub-Screens & Interactive Modals
│   ├── Bayar Iuran Screen (Kas RT + Satpam + Kebersihan, QRIS, Digital Receipt)
│   ├── Buku Kas Transparan RT 04 (Monthly Charts, Realtime In/Out Ledger, Audit)
│   ├── Surat Pengantar Online (Form, TTD Digital Pak RT, QR Code Verification)
│   ├── Lapor Masalah (Photo Upload, Category Selector, Ticket Progress Tracker)
│   ├── Agenda & Ronda Full Calendar (RSVP, Tukar Jadwal Ronda)
│   └── SOS Panic Dialog (3s Countdown, Pos Satpam Dispatch Simulation)
```

---

## 4. Key Functional Features

1. **Total Kas Lingkungan RT 04 Transparan**:
   - Tampilan saldo realtime `Rp 18.450.000` dengan tombol toggle sembunyikan/tampilkan saldo (*eye icon*).
   - Badge "Audit Realtime".
   - Ringkasan pemasukan bulanan (`+Rp 3.200.000`) dan pengeluaran bulanan (`-Rp 850.000`).
   - Tautan langsung menuju Buku Kas Transparan dengan grafik alokasi dana dan riwayat kuitansi digital.

2. **Tombol Darurat (SOS) Siaga 24 Jam**:
   - Terintegrasi langsung dengan Pos Satpam & Koordinator Ronda.
   - Fitur modal konfirmasi darurat 3 detik untuk mencegah penekanan tidak sengaja.
   - Pilihan kategori darurat: Keamanan/Maling, Kebakaran, Medis/Ambulans, Hewan Berbahaya.

3. **Layanan Warga Terintegrasi RT 04**:
   - **Bayar Iuran**: Rincian tagihan per bulan (Kas RT Rp 50.000, Satpam Rp 60.000, Sampah Rp 40.000 = Total Rp 150.000/bln). Dilengkapi QRIS simulator dan status "Lunas".
   - **Pengumuman**: Surat edaran resmi pengurus RT/RW dengan indikator belum dibaca.
   - **Surat Pengantar Digital**: Permohonan pembuatan surat KTP/KK/Domisili dengan QR Code tanda tangan digital terverifikasi.
   - **Lapor Masalah**: Pengaduan fasilitas umum rusak (Lampu jalan mati, saluran air tersumbat) lengkap dengan foto dan pelacakan status tindak lanjut.

4. **Kabar & Agenda RT (Gotong Royong & Siskamling)**:
   - Kartu agenda kegiatan warga dengan tanggal, jam, titik kumpul, dan jumlah konfirmasi kehadiran warga.
   - Tombol interaktif "Ikut Serta" untuk RSVP dan "Tukar Jadwal" untuk piket ronda siskamling.

---

## 5. Implementation Notes
- **Language / Locale:** Bahasa Indonesia dengan format mata uang Rupiah (`id_ID`, `Rp ...`).
- **State Management:** Reactive ValueNotifier singleton (`WargaKitaData`) untuk pembaruan instan saldo, status iuran, agenda RSVP, dan tiket laporan.
- **Accessibility:** Touch target minimum 48px, kontras rasio tinggi memenuhi standar WCAG AAA.
