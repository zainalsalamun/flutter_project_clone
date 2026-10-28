# AURA HABIT - DESIGN SPECIFICATION & SYSTEM

Dokumen spesifikasi desain dan arsitektur halaman untuk aplikasi pemantau kebiasaan dan asisten kesehatan harian. Desain ini mengadopsi struktur fungsional dari referensi dengan pembaruan visual total: penggantian maskot kartun menjadi identitas visual modern, ikonografi vektor presisi, dan kepatuhan penuh terhadap aturan bebas emoji.

---

## 1. Identitas Brand dan Nama Aplikasi

* **Nama Aplikasi**: Aura Habit (opsi alternatif: HabitPulse / ZenFlow Daily)
* **Tagline**: Mindful Routines, Measurable Growth
* **Konsep**: Pendamping kebiasaan harian cerdas dengan pendekatan visual modern, bersih, dan berbobot data tanpa elemen kartun berlebihan.
* **Perbedaan Utama dari Gambar Referensi**:
  * Mengganti maskot beruang dan katak kartun dengan elemen "Aura Companion" (vektor geometris minimalis / orb dinamis dengan gradient halus dan mikro-animasi).
  * Mengganti ikon kartun dengan ikonografi outline dan rounded modern (Material 3 dan Cupertino crisp vectors).
  * Menghilangkan seluruh penggunaan emoji pada label teks, kartu metrik, status kebiasaan, dan navigasi (100% bebas emoji).

---

## 2. Struktur dan Penamaan Halaman (Page Architecture)

Aplikasi ini dibagi menjadi 3 layar utama yang dihubungkan melalui sebuah Root Navigation Wrapper:

### A. Root Navigation Wrapper
* **Nama Kelas**: `AuraHabitMainWrapper`
* **File**: `lib/page_menu/aura_habit_app/screens/aura_habit_main_wrapper.dart`
* **Peran**: Mengelola Bottom Navigation Bar 4 tab (Home, Tracker, Habits, Settings) dan transisi antar halaman.

### B. Halaman 1: Asisten Kebiasaan AI (AI Habit Assistant)
* **Nama Halaman / Kelas**: `AuraHabitAssistantScreen`
* **File**: `lib/page_menu/aura_habit_app/screens/assistant/aura_habit_assistant_screen.dart`
* **Deskripsi Visual & Fungsional**:
  * **Header**: Tombol kembali atau tutup modal dan status indikator koneksi asisten cerdas.
  * **Hero Centerpiece**: Aura Mindful Companion (vektor grafis lingkaran berlapis glowing gradient, bukan gambar kartun binatang) dengan partikel orbit metrik (buku, hidrasi, aktivitas).
  * **Teks Sambutan**:
    * Headline: "Bagaimana saya dapat membantumu hari ini?" (Hello, How can I help you?)
    * Sub-headline: "Partner cerdas untuk membangun kebiasaan positif dan konsisten."
  * **Quick Suggestion Chips**:
    * Chip 1: [Icon Lightbulb] Tips Kebiasaan (Habit Tips)
    * Chip 2: [Icon Target] Target Baru (Set-up Goals)
    * Chip 3: [Icon Calendar] Jadwal Rutin (Routines Schedule)
  * **Interactive Prompt Input**:
    * Textfield rounded melengkung dengan placeholder "Ketik pertanyaan atau target...".
    * Aksi lampiran file / foto menggunakan ikon paperclip dan kamera.
    * Tombol kirim bundar dengan ikon panah atas (Send Icon).

### C. Halaman 2: Dashboard Kebiasaan Harian (Daily Routine Home)
* **Nama Halaman / Kelas**: `AuraHabitHomeScreen`
* **File**: `lib/page_menu/aura_habit_app/screens/home/aura_habit_home_screen.dart`
* **Deskripsi Visual & Fungsional**:
  * **Top Bar**:
    * Ikon menu navigasi kiri (drawer).
    * Search and Quick AI trigger pill di tengah.
    * Profil avatar / badge status harian di kanan dengan pesan sambutan singkat "Mulai dari langkah kecil".
  * **Greeting Banner**:
    * Teks sapaan personal: "Halo, Lukman"
    * Subteks motivasi: "Siap melangkah hari ini?"
  * **Trio Metrik Cepat (Quick Stat Cards)**:
    * Card 1: Air Minum (Water) - 3 Gelas (Target: 8 Gelas) dengan ikon tetesan air biru.
    * Card 2: Waktu Tidur (Sleep) - 8.5 Jam dengan ikon bulan sabit indigo.
    * Card 3: Olahraga (Exercise) - 18.6 Km dengan ikon sepeda / lari emerald.
  * **Progres Harian (Today's Progress Card)**:
    * Kontainer berlatar gradient Night Navy gelap kontras tinggi.
    * Indikator progres tersegmentasi (3 dari 5 kebiasaan selesai).
    * Badge info: "Tersisa 2 kebiasaan".
    * Chip langkah berikutnya: "Berikutnya: Jalan santai 20 menit".
  * **Daftar Kebiasaan Hari Ini (Today's Habits)**:
    * Header list dengan tombol switch tampilan dan tombol tambah "+".
    * Item 1: Minum Air Berkala (Tiap 30 menit) - Status: Selesai (Checkmark hijau).
    * Item 2: Latihan Fisik (30 menit) - Status: Belum selesai (Outline lingkaran).
    * Item 3: Menulis Jurnal (Akhir hari) - Status: Belum selesai.
  * **Bottom Navigation Bar**:
    * Tab Home (Aktif), Tracker, Habits, Settings.

### D. Halaman 3: Pelacak & Analisis Kebiasaan (Habit Tracker & Analytics)
* **Nama Halaman / Kelas**: `AuraHabitAnalyticsScreen`
* **File**: `lib/page_menu/aura_habit_app/screens/analytics/aura_habit_analytics_screen.dart`
* **Deskripsi Visual & Fungsional**:
  * **Top Bar**:
    * Judul: "Pelacak Kebiasaan" (My Habits Tracker).
    * Aksi filter periode (Mingguan / Bulanan) dan tombol bagikan pencapaian (Share).
  * **Kartu Perayaan Streak (Streak Achievement Card)**:
    * Ikon lencana api energi dengan cincin konsentris bercahaya (solar ring vector).
    * Teks: "4 Hari Beruntun" (4 Days Streak).
    * Subteks motivasi: "Konsistensi yang mengagumkan".
  * **Kalender Garis Waktu Mingguan (Weekly Timeline Strip)**:
    * Hari dalam seminggu: Min, Sen, Sel, Rab, Kam, Jum, Sab.
    * Tanggal dinamis dengan indikator titik progres terhubung.
    * Penanda aktif pada hari berjalan dengan ring bercahaya.
    * Label ringkasan: "4 dari 6 kebiasaan tercapai hari ini".
  * **Analisis Data & Grafik Mini (Analytics Grid)**:
    * Bar Chart Tidur (Sleep Time): Grafik batang 7 hari (S, M, T, W, T, F, S) dengan batang puncak terisi penuh.
    * Radial Activity Meter: Indikator putaran melingkar untuk waktu olahraga ("3 Jam Hari Ini").
  * **Detail Rincian Rutinitas (Habits Detail Breakdown)**:
    * Hidrasi: Titik-titik progres volume air (3/8 gelas terisi) dengan label evaluasi "Perlu Ditingkatkan".
    * Olahraga: Progres durasi latihan mingguan.

---

## 3. Sistem Desain & Token Visual

### A. Palet Warna (Color Palette)
* **Canvas Background**: `#F8F9FD` (Soft Cool Lavender Slate)
* **Card Surface**: `#FFFFFF` (Pure Crisp White)
* **Border Color**: `#E5E7EB` (Subtle 1px border)
* **Dark Contrast Card**: `#16192E` ke `#23224B` (Night Navy Gradient)
* **Primary Brand Accent**: `#6366F1` (Indigo Vibrant) & `#8B5CF6` (Soft Purple)
* **Aura Glow**: `#A5B4FC` (Soft Pastel Iris)
* **Status Berhasil (Success)**: `#10B981` (Emerald Green)
* **Status Air (Hydration)**: `#0EA5E9` (Cyan Sky)
* **Status Tidur (Rest)**: `#8B5CF6` (Lavender Violet)
* **Status Olahraga (Workout)**: `#10B981` (Mint Emerald)
* **Teks Utama (Text Primary)**: `#0F172A` (Deep Slate Black)
* **Teks Sekunder (Text Secondary)**: `#64748B` (Slate Grey)
* **Teks Redup (Text Muted)**: `#94A3B8` (Cool Grey)

### B. Tipografi
* **Font Utama**: Plus Jakarta Sans (Google Fonts)
* **Skala Ukuran**:
  * Display Header: 24sp / Bold (700)
  * Section Title: 18sp / SemiBold (600)
  * Card Metric Number: 22sp / Bold (700)
  * Body Text: 14sp / Medium (500)
  * Caption & Micro-label: 12sp / Regular (400) atau SemiBold (600)

### C. Penggantian Ikon dan Grafis (Tanpa Emoji)
* **Aturan Mutlak Tanpa Emoji**: Seluruh elemen teks hanya menggunakan huruf alfabet, angka, dan tanda baca standar.
* **Ikon Hidrasi**: Menggunakan `Icons.water_drop_outlined` / `Icons.local_drink_rounded`.
* **Ikon Tidur**: Menggunakan `Icons.nightlight_round` / `Icons.bedtime_outlined`.
* **Ikon Olahraga**: Menggunakan `Icons.directions_bike_rounded` / `Icons.fitness_center_rounded`.
* **Ikon Lencana Streak**: Menggunakan `Icons.local_fire_department_rounded` / `Icons.bolt_rounded` di dalam kontainer lingkaran berlapis solar ring.
* **Maskot**: Diganti dengan `AuraCompanionOrb` (kustomisasi CustomPainter berupa orb energi lembut dan partikel geometri elegan).

---

## 4. Rencana Struktur Berkas (File Structure)

```
lib/page_menu/aura_habit_app/
├── DESIGN.md                                 # Dokumen spesifikasi desain ini
├── aura_habit_page.dart                      # Entry point terintegrasi untuk AllPagesDemo
├── core/
│   ├── aura_colors.dart                      # Token warna resmi
│   └── aura_typography.dart                  # Definisi gaya teks GoogleFonts
├── models/
│   ├── habit_item.dart                       # Model entitas kebiasaan harian
│   └── habit_daily_metric.dart               # Model metrik hidrasi, tidur, aktivitas
├── widgets/
│   ├── aura_companion_orb.dart               # Maskot visual modern pengganti kartun
│   ├── habit_metric_card.dart                # Kartu metrik 3 kolom (Air, Tidur, Olahraga)
│   ├── habit_progress_banner.dart            # Kartu gelap progres segmented 3/5
│   ├── habit_checklist_tile.dart             # Baris item kebiasaan dengan checkbox custom
│   ├── weekly_streak_calendar.dart           # Baris kalender mingguan interaktif
│   └── sleep_bar_chart_card.dart             # Grafik mini batang tidur mingguan
└── screens/
    ├── aura_habit_main_wrapper.dart          # Wrapper 4 tab bottom navigation
    ├── assistant/
    │   └── aura_habit_assistant_screen.dart  # Layar Asisten AI (Screen 1)
    ├── home/
    │   └── aura_habit_home_screen.dart       # Layar Dashboard Harian (Screen 2)
    └── analytics/
        └── aura_habit_analytics_screen.dart  # Layar Analisis & Streak (Screen 3)
```
