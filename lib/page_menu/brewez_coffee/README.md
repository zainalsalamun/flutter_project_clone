# ☕ Brewez Coffee — Fluid Interactive Coffee Lounge (Flutter)

Dokumentasi resmi arsitektur, rekapitulasi fitur, dan bedah teknis implementasi animasi pada modul **Brewez Coffee**. Modul ini berfokus pada pengalaman pengguna yang imersif (*fluid micro-interactions*), visualisasi cangkir dinamis (*Hot vs Iced*), kalkulasi harga multi-add-ons realistis (IDR), alur checkout lengkap (QRIS, E-Wallet, VA, Tunai), proses seduh barista interaktif, hingga struk/tiket pengambilan digital.

---

## 📑 Daftar Isi
1. [Rekapitulasi Fitur yang Telah Dikerjakan](#1-rekapitulasi-fitur-yang-telah-dikerjakan)
2. [Arsitektur & Struktur Folder](#2-arsitektur--struktur-folder)
3. [Alur Pemesanan End-to-End (User Flow)](#3-alur-pemesanan-end-to-end-user-flow)
4. [Bedah Teknis & Implementasi Animasi](#4-bedah-teknis--implementasi-animasi)
   - [Fluid Liquid & Dual Wave Physics](#41-fluid-liquid--dual-wave-physics)
   - [Bentuk Cup: Hot Ceramic Mug vs Iced Glass Tumbler](#42-bentuk-cup-hot-ceramic-mug-vs-iced-glass-tumbler)
   - [Parabolic Fly-to-Cart Particle Trajectory](#43-parabolic-fly-to-cart-particle-trajectory)
   - [Laser Scanner QRIS & Pulse Verification](#44-laser-scanner-qris--pulse-verification)
   - [4-Stage Live Barista Brewing Process](#45-4-stage-live-barista-brewing-process)
   - [Micro-Interactions & Spring Physics](#46-micro-interactions--spring-physics)
5. [Standarisasi Native Flutter Icons & Localization](#5-standarisasi-native-flutter-icons--localization)

---

## 1. Rekapitulasi Fitur yang Telah Dikerjakan

| No | Fitur / Komponen | Deskripsi & Hasil Implementasi | File Utama |
|---|---|---|---|
| **1** | **Bilingual Support (ID/EN)** | Sistem multi-bahasa terpusat menggunakan `ValueNotifier<BrewezLanguage>`. Switcher hanya diletakkan **satu kali di header Home**, otomatis menyinkronkan seluruh halaman tanpa duplikasi tombol. | `core/localization/brewez_localization.dart` |
| **2** | **Mata Uang Rupiah (IDR)** | Format harga standar Indonesia `Rp xx.xxx` di seluruh kartu menu, add-on, subtotal, modal pembayaran, dan struk kasir. | `core/utils/brewez_currency.dart` |
| **3** | **Bentuk Cup: Hangat vs Dingin** | Visualizer otomatis berganti bentuk: **Hangat (Hot)** = Mug keramik dengan pegangan lengkung samping & uap aroma panas; **Dingin (Iced)** = Gelas kaca bening tinggi dengan tetesan embun (*dew drops*) & es batu melayang. | `presentation/widgets/animated_cup_visualizer.dart` |
| **4** | **Add-ons Vertikal (Free vs Paid)** | Pengelompokan 4 seksi vertikal terstruktur: Susu (*Single-Select*), Sirup, Booster, dan Topping dengan transparansi badge `[GRATIS]` dan harga realistis. | `presentation/widgets/interactive_addons_selector.dart` |
| **5** | **Pinned Cup Visualizer** | Cangkir kopi animasi disematkan (*pinned*) di bagian atas Detail Page & Quick Customize Sheet sehingga **tetap terlihat saat pengguna men-scroll kontrol di bawah**. | `brewez_coffee_detail_page.dart` |
| **6** | **Hero Promo Banner di Atas** | Carousel promo otomatis ditempatkan di posisi paling atas feed Home untuk impresi visual pertama yang memikat. | `presentation/widgets/promo_banner_carousel.dart` |
| **7** | **Simulasi Pembayaran (Payment)** | Modal pembayaran multi-metode: QRIS Dinamis (Laser scanner & timer), E-Wallet (GoPay, ShopeePay), BCA Virtual Account (Salin VA), Tunai di Kasir, serta input voucher diskon (`BREWEZ50`, `DISKONKOPI`). | `presentation/widgets/payment_modal_sheet.dart` |
| **8** | **Live Barista Brewing (4 Tahap)** | Simulasi tahapan seduh real-time: Grinding biji -> Ekstraksi 9-bar & racik sirup -> Steam susu / es -> Quality check & siap saji. | `presentation/widgets/brewing_modal.dart` |
| **9** | **Digital Receipt & Pickup Ticket** | Tiket pengambilan antrian (`#BRW-8892`, Antrian `A-24`), stempel status `LUNAS / PAID`, rincian kustomisasi item lengkap, breakdown biaya, dan barcode scanner. | `presentation/widgets/receipt_modal_sheet.dart` |
| **10** | **Clean Flutter Native Icons** | Menghapus seluruh karakter emoji dan menggantinya dengan vektor `Icons.*` bawaan Flutter untuk ketajaman dan konsistensi di seluruh OS. | `presentation/widgets/coffee_mood_selector.dart` |
| **11** | **Live Search & Filter Modal** | Pencarian realtime kata kunci nama/kategori kopi, badge filter aktif, slider rentang harga, sort by harga/rating/nama, dan empty state. | `presentation/widgets/coffee_filter_modal_sheet.dart` |
| **12** | **Halaman Semua Menu (All Menu Page)** | Halaman katalog lengkap dengan tombol "Lihat semua / See all", switch tampilan Grid (2 kolom) vs List, tab kategori, quick customize, dan sinkronisasi cart. | `brewez_all_menu_page.dart` |

---

## 2. Arsitektur & Struktur Folder

```
lib/page_menu/brewez_coffee/
├── README.md                               # Dokumentasi Teknis Proyek
├── brewez_coffee_page.dart                 # Halaman Utama (Header, Promo Carousel, Mood, Grid, Fly-to-Cart)
├── brewez_all_menu_page.dart               # [Baru] Halaman Semua Menu Kopi (Grid/List View, Search & Filter)
├── brewez_coffee_detail_page.dart          # Halaman Detail (Pinned Visualizer, Add-on Sections, Brew Flow)
├── core/
│   ├── localization/
│   │   └── brewez_localization.dart         # Kamus Dwi-bahasa (ID/EN) & Reactive Notifier
│   ├── theme/
│   │   └── brewez_theme.dart                # Palet Warna, Gradient, Glow Shadow, & Style
│   └── utils/
│       └── brewez_currency.dart             # Utility Formatter Rupiah Indonesia (Rp xx.xxx)
├── data/
│   └── models/
│       ├── coffee_addon_model.dart          # Data Model Add-ons, Kategori, & Skema Harga
│       └── coffee_order_model.dart          # Data Model Order, Order Items, & PaymentType
└── presentation/
    └── widgets/
        ├── animated_cup_visualizer.dart     # [Core Visualizer] Hot Mug vs Iced Glass (Dual Wave & Steam)
        ├── interactive_addons_selector.dart # [Add-ons] Seksi Vertikal Susu, Sirup, Booster, Topping
        ├── coffee_filter_modal_sheet.dart   # [Filter] Modal Filter Rentang Harga, Sort, Min Rating
        ├── payment_modal_sheet.dart         # [Payment] Simulasi QRIS, E-Wallet, VA, Tunai, Promo Code
        ├── brewing_modal.dart               # [Brewing] 4-Step Progressive Barista Simulation
        ├── receipt_modal_sheet.dart         # [Receipt] Paper Ticket, Barcode, Queue Number, Status LUNAS
        ├── quick_customize_sheet.dart       # [Quick Custom] Modal sheet racikan dari kartu menu
        ├── cart_modal_sheet.dart            # [Cart] Modal Keranjang belanja multi-item
        ├── promo_banner_carousel.dart       # [Banner] Auto-sliding hero promo cards
        ├── coffee_mood_selector.dart        # [Mood] Filter mood chip interaktif
        ├── temperature_toggle.dart          # [Toggle] Switcher Hangat vs Dingin (Overflow Safe)
        ├── custom_sweetness_slider.dart     # [Slider] Stepped sweetness selector (0, 50, 70, 100%)
        ├── animated_size_selector.dart      # [Size] Selektor ukuran cup S / M / L
        ├── animated_brew_button.dart        # [Button] Tombol seduh dengan efek pegas tap-down
        ├── animated_coffee_card.dart        # [Card] Kartu kopi katalog dengan rating & quick add
        └── language_toggle_button.dart      # [Lang] Switcher ID / EN (hanya di Home header)
```

---

## 3. Alur Pemesanan End-to-End (User Flow)

```
[1. Racik & Kustomisasi Kopi]
       ↓ (Pilih Ukuran S/M/L, Suhu Hot/Iced, Level Gula, Susu, Sirup, Topping)
[2. Masuk Keranjang / Klik 'Seduh Sekarang']
       ↓
[3. Modal Pembayaran (PaymentModalSheet)]
       ↓ (Pilih QRIS / GoPay / ShopeePay / BCA VA / Tunai + Input Voucher BREWEZ50)
[4. Verifikasi Pembayaran Sukses (LUNAS)]
       ↓
[5. Live Barista Brewing 4 Tahap (BrewingModal)]
       ↓ (1. Grinding Biji → 2. Ekstraksi 9-Bar → 3. Tuang Susu/Es → 4. Garnish Siap Saji)
[6. Tiket Pengambilan & Struk Digital (ReceiptModalSheet)]
       ↓ (Nomor Antrian A-24, Barcode Scanner, Breakdown Harga, Simpan Struk / Pesan Lagi)
```

---

## 4. Bedah Teknis & Implementasi Animasi

Modul ini memanfaatkan perpaduan **AnimationController**, **CustomPainter**, **Trigonometri Gelombang Cairan**, dan **Physics-based Interpolation** untuk menghasilkan animasi 60–120 FPS tanpa membebani *main rendering thread*.

---

### 4.1. Fluid Liquid & Dual Wave Physics
- **File**: `presentation/widgets/animated_cup_visualizer.dart` (`_FluidWavePainter`)
- **Konsep**: Simulasi fluida organik menggunakan dua fungsi gelombang harmonik (*dual harmonic wave superposition*):
  
  $$\text{Wave 1 (Depan): } y_1(x) = \text{baseY} + A_1 \cdot \sin\left(\frac{2\pi \cdot x}{\lambda_1} + 2\pi \cdot t\right)$$
  $$\text{Wave 2 (Belakang): } y_2(x) = \text{baseY} + A_2 \cdot \cos\left(\frac{2\pi \cdot x}{\lambda_2} - 2\pi \cdot t \cdot 1.3\right)$$

- **Parameter Teknis**:
  - `_waveController`: durasi `2200ms`, `repeat()`.
  - $A_1 = 5.0\text{px}$, $A_2 = 4.0\text{px}$ (Amplitudo gelombang).
  - $\lambda_1 = \text{width} \times 0.8$, $\lambda_2 = \text{width} \times 0.6$ (Panjang gelombang).
  - Gelombang belakang dirender dengan opasitas 60% dan warna lebih pekat, sedangkan gelombang depan dilapisi *micro-foam cream layer* bergradasi lembut.
  - Seluruh kanvas cairan dibatasi (*clipped*) oleh `canvas.clipPath(cupPath)` agar tidak keluar dari bentuk dinding cangkir.

---

### 4.2. Bentuk Cup: Hot Ceramic Mug vs Iced Glass Tumbler
- **File**: `presentation/widgets/animated_cup_visualizer.dart`
- **Konsep**:
  - **Hot Ceramic Mug**:
    - Badan cangkir digambar dengan leher lebih lebar dan rasio aspek lebih pendek.
    - **Pegangan Keramik Samping (*Curved Ceramic Handle*)**: Digambar menggunakan kurva Bezier kubik ganda (`Path.cubicTo`) pada sisi kanan cangkir.
    - **Uap Panas Mengepul (*Steam Waves*)**: Tiga jalur uap vertikal yang berosilasi secara sinusoidal ke atas, dengan opasitas memudar saat mendekati puncak ($1.0 \to 0.0$) pada siklus `_steamController` (2800ms).
  - **Iced Glass Tumbler**:
    - Badan gelas silinder tinggi berdinding kaca transparan (*double glass gloss reflection*).
    - **Tetesan Embun (*Dew Drops*)**: Tetesan air kondensasi transparan pada kaca luar.
    - **Es Melayang Berputar (*Floating Ice Cubes*)**: Kubus kristal es 3D melayang dengan translasi vertikal osilatif ($Y \pm 6\text{px}$) dan rotasi halus ($\pm 0.08\text{ rad}$) menggunakan `_iceBobController` (1800ms, `repeat(reverse: true)`).

---

### 4.3. Parabolic Fly-to-Cart Particle Trajectory
- **File**: `brewez_coffee_page.dart` (`_buildFlyingParticle`)
- **Konsep**: Animasi proyektil partikel kopi dari koordinat tombol item menu ke koordinat ikon keranjang di kanan atas layar.
- **Formulasi Matematika**:
  - Diberikan koordinat awal $(x_0, y_0)$ dan target $(x_1, y_1)$ dengan $t \in [0, 1]$:
    
    $$x(t) = x_0 + (x_1 - x_0) \cdot t$$
    $$y(t) = y_0 + (y_1 - y_0) \cdot t - \sin(t \cdot \pi) \cdot H$$
    $$\text{Scale}(t) = 1.0 - (0.4 \cdot t)$$

  - Komponen $-\sin(t \cdot \pi) \cdot 80$ menghasilkan elevasi lengkungan parabola ke atas setinggi 80px sebelum menukik masuk ke keranjang.
  - Begitu $t = 1.0$, `_cartBadgeController` memicu animasi *pop scale* pada badge keranjang (`Transform.scale(1.0 + badgeValue)`).

---

### 4.4. Laser Scanner QRIS & Pulse Verification
- **File**: `presentation/widgets/payment_modal_sheet.dart`
- **Konsep**:
  - Garis laser bergerak naik-turun secara mulus di atas QR Code simulation box:
    $$\text{Top}(t) = 10 + (t \cdot 150)$$
  - Dilengkapi efek pendaran cahaya neon menggunakan `BoxShadow(color: Colors.redAccent.withOpacity(0.8), blurRadius: 6, spreadRadius: 2)`.
  - Saat tombol bayar ditekan, tombol menampilkan spinner circular terisolasi, kemudian bertransisi menjadi badge hijau konfirmasi `Pembayaran Berhasil!`.

---

### 4.5. 4-Stage Live Barista Brewing Process
- **File**: `presentation/widgets/brewing_modal.dart`
- **Konsep**:
  - Timer berkala (1400ms per tahap) menggerakkan tahapan seduh dari tahap 0 hingga 3.
  - Ikon tengah berdenyut (*pulsing scale*) $1.0 \to 1.05$ menggunakan kurva `Curves.easeInOut`.
  - Saat mencapai tahap 4 (100%), warna lingkaran bertransisi dari gradasi kopi hangat ke gradasi hijau sukses, memunculkan tombol **"Lihat Tiket Pengambilan & Struk"**.

---

### 4.6. Micro-Interactions & Spring Physics
- **Animated Size & Sweetness Selector**: `AnimatedContainer` dengan kurva `Curves.easeOutCubic` (250ms) untuk pergeseran pill selektor.
- **Temperature Pill Slide**: `AnimatedAlign` dengan `FractionallySizedBox(widthFactor: 0.5)` bergeser halus dari `Alignment.centerLeft` (Hot) ke `Alignment.centerRight` (Iced).
- **Brew Button Tap-Down Spring**: `GestureDetector(onTapDown, onTapUp, onTapCancel)` menggerakkan skala tombol dari $1.0 \to 0.95 \to 1.0$ memberikan sensasi tombol fisik yang responsif.
- **Auto-Sliding Promo Carousel**: `PageController(viewportFraction: 0.92)` digerakkan otomatis setiap 4 detik menggunakan `animateToPage(curve: Curves.easeOutCubic)`.

---

## 5. Standarisasi Native Flutter Icons & Localization

Seluruh tampilan telah dibersihkan dari karakter emoji teks dan diganti dengan vektor `IconData` bawaan Flutter:
- **Mood Selector**: `Icons.coffee_rounded`, `Icons.bolt_rounded`, `Icons.spa_rounded`, `Icons.center_focus_strong_rounded`, `Icons.ac_unit_rounded`.
- **Kategori Add-ons**: `Icons.local_drink_rounded` (Susu), `Icons.eco_rounded` (Sirup), `Icons.bolt_rounded` (Booster), `Icons.auto_awesome_rounded` (Topping).
- **Cangkir Badges**: `Icons.water_drop_outlined` (Oat Milk), `Icons.spa_rounded` (Almond Milk), `Icons.grain_rounded` (Caramel), `Icons.cloud_rounded` (Cheese Foam), dll.
- **Tombol & Struk**: `Icons.receipt_long_rounded`, `Icons.download_rounded`, `Icons.check_circle_rounded`, `Icons.lock_outline_rounded`.

---

*Brewez Coffee Module — Developed with Flutter & Dart for Fluid Micro-Interactions.*
