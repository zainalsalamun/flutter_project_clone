# Panduan Lengkap Publish `flutter_sonner` ke Pub.dev

Dokumen ini berisi panduan langkah demi langkah untuk memvalidasi dan mempublikasikan package **`flutter_sonner`** ke [pub.dev](https://pub.dev/).

---

## 1. Verifikasi Persyaratan pub.dev

Pastikan Anda memiliki:
1. Akun Google aktif (digunakan untuk login ke pub.dev).
2. Repositori GitHub untuk package ini (opsional tapi sangat disarankan untuk skor transparansi).
3. URL repository di `pubspec.yaml` sudah disesuaikan dengan akun GitHub Anda.

---

## 2. Struktur Package yang Sudah Disiapkan

Package Anda di folder `packages/flutter_sonner` sudah memiliki standar resmi pub.dev:

```
packages/flutter_sonner/
├── lib/
│   ├── flutter_sonner.dart              # Ekspor API publik
│   └── src/
│       ├── controller/
│       │   └── sonner_controller.dart   # Manajemen state, stacking & timers
│       ├── model/
│       │   ├── sonner_item.dart         # Model toast & action
│       │   └── sonner_theme.dart        # Kustomisasi tema (dark/light)
│       ├── ui/
│       │   ├── components/
│       │   │   └── loading_spinner.dart # Spinner animasi loading
│       │   ├── sonner_overlay.dart      # Overlay global di atas widget tree
│       │   └── toast_card.dart          # Kartu animasi 3D & swipe gesture
│       └── utils/
│           └── sonner_position.dart     # Posisi (Dynamic Island, bottom, dll.)
├── test/
│   ├── sonner_controller_test.dart      # Unit test logika controller
│   └── toast_card_test.dart             # Widget test interaksi UI
├── example/                             # Wajib ada untuk skor pub.dev
│   ├── pubspec.yaml
│   └── lib/main.dart                    # Interactive showcase demo playground
├── CHANGELOG.md                         # Catatan rilis per versi
├── LICENSE                              # Lisensi resmi (MIT)
├── README.md                            # Dokumentasi lengkap + badges
└── pubspec.yaml                         # Metadata package
```

---

## 3. Langkah Menjalankan Demo Secara Lokal

Sebelum di-publish, coba jalankan demo app untuk melihat animasinya:

```bash
cd packages/flutter_sonner/example
flutter pub get
flutter run
```

---

## 4. Langkah Menjalankan Tes & Analisis

Jalankan perintah berikut di dalam direktori `packages/flutter_sonner`:

```bash
cd packages/flutter_sonner

# 1. Pastikan dependencies terpasang
flutter pub get

# 2. Analisis kode (pastikan 0 warning / 0 error untuk 140/140 pub points)
flutter analyze

# 3. Jalankan unit test dan widget test
flutter test
```

---

## 5. Simulasi Publish (`dry-run`)

Sebelum benar-benar mengunggah ke pub.dev, jalankan validasi resmi:

```bash
dart pub publish --dry-run
```

Perintah ini akan memeriksa:
* Apakah file `README.md`, `LICENSE`, dan `CHANGELOG.md` sudah valid.
* Apakah format `pubspec.yaml` sudah benar.
* Apakah ada file sensitif yang tidak sengaja terikut.

---

## 6. Publikasi ke Pub.dev

Jika tahap `--dry-run` sudah tidak ada kendala:

```bash
dart pub publish
```

1. Terminal akan menampilkan URL otentikasi Google.
2. Buka URL tersebut di browser, login dengan akun Google Anda, dan klik Izinkan (*Authorize*).
3. Terminal akan mengunggah package.
4. Dalam beberapa menit, package Anda akan live di:
   `https://pub.dev/packages/flutter_sonner`

---

## 7. Tips Memaksimalkan Popularitas Package

1. **Buat GIF Preview di README**: Rekam screen recorder dari folder `example/`, convert ke format GIF/WebP, upload ke GitHub repository, lalu pasang di bagian atas `README.md`.
2. **Promosikan ke Komunitas**:
   * Bagikan di Reddit: `r/FlutterDev` dengan judul *"I built flutter_sonner: An opinionated, spring-animated stacked toast inspired by Sonner"*.
   * Bagikan di Twitter/X dan LinkedIn dengan menyertakan video singkat 10 detik.
   * Komunitas Telegram / Discord Flutter Indonesia.
3. **Dapatkan Badge "Flutter Favorite"**:
   * Jaga Pub Points di 140/140.
   * Cepat tanggap jika ada issue atau request dari pengguna lain di GitHub.
