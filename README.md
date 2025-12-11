# 📱 Flutter UI Clone Showcase  
Koleksi halaman UI hasil latihan & eksplorasi desain dari berbagai aplikasi populer di Indonesia.  
Project ini berisi beberapa halaman home seperti:

- **Bibit Home Page**
- **Gojek Home Page**
- **Livin Mandiri Home Page**
- **OVO Home Page**
- **ShopeePay Page**

Semua halaman dapat diakses melalui 1 halaman utama:  
`AllPagesDemo` — yang menampilkan daftar menu dari masing-masing UI clone.

---

## 🚀 Features
- Tampilan UI modern & clean  
- Menggunakan Flutter Icons (tanpa asset logo tambahan)  
- Navigasi simple dengan `Navigator.push`  
- Struktur kode rapi dan mudah dikembangkan  
- Cocok untuk belajar layouting dan UI replication  

---

## 📂 Project Structure (Table Version)

| File | Deskripsi |
|------|-----------|
| `lib/all_pages_demo.dart` | Halaman utama berisi list menu UI |
| `lib/page_menu/bibit_home_page.dart` | UI clone Bibit |
| `lib/page_menu/gojek_home_page.dart` | UI clone Gojek |
| `lib/page_menu/livin_home_page.dart` | UI clone Livin Mandiri |
| `lib/page_menu/ovo_home_page.dart` | UI clone OVO |
| `lib/page_menu/shopeepay_page.dart` | UI clone ShopeePay |
| `lib/page_menu/pintu_home_page.dart` | UI clone Pintu |

---

### 📸 Screenshots
<table>
  <tr>
    <td><img src="assets/screenshot/all_demo.png" width="250"></td>
    <td><img src="assets/screenshot/bibit_home.png" width="250"></td>
    <td><img src="assets/screenshot/gojek_home.png" width="250"></td>
    <td><img src="assets/screenshot/livin_home.png" width="250"></td>
  </tr>
  <tr>
    <th>All Pages Demo</th>
    <th>Bibit Home</th>
    <th>Gojek Home</th>
    <th>Livin Home</th>
  </tr>
</table>

<br>

<table>
  <tr>
    <td><img src="assets/screenshot/ovo_home.png" width="250"></td>
    <td><img src="assets/screenshot/shoppe_home.png" width="250"></td>
     <td><img src="assets/screenshot/pintu_home.png" width="250"></td>
  </tr>
  <tr>
    <th>OVO Home</th>
    <th>ShopeePay Home</th>
    <th>Pintu Home</th>
  </tr>
</table>


## 🧭 How to Run

```bash
flutter pub get
flutter run

🏗 How to Build (Release Build)
Build APK (universal)
flutter build apk --release

Build APK per ABI (lebih kecil)
flutter build apk --release --split-per-abi


Output ada di:

build/app/outputs/flutter-apk/

Build AppBundle (AAB) untuk Play Store
flutter build appbundle --release


Output ada di:

build/app/outputs/bundle/release/app-release.aab

🛠 Tech Stack
Flutter

Dart

Standard Material Widgets

No external UI libraries

📌 Notes
Project ini dibuat murni untuk keperluan belajar UI dan eksplorasi desain.
Tidak bermaksud meniru fungsi atau bisnis dari aplikasi asli.

🙌 Author
Developed with ❤️ by Zainal Salamun
