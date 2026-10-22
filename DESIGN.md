# DESIGN SYSTEM & ANTI-AI SLOP MANIFESTO

> Panduan komprehensif sistem desain terstruktur & aturan keras (*hard constraints*) untuk membangun antarmuka web dan mobile berkualitas tinggi (*craftsmanship level*), fungsional, padat data (*high density*), dan bebas dari pola generik buatan AI (*Anti-AI Slop*).
> Terinspirasi oleh standar desain **Linear.app, Vercel, GitHub, Stripe, dan Shadcn UI**.

---

## 1. DEFINISI AI SLOP & PRINSIP UTAMA

### Apa itu AI Slop dalam UI/UX?
*AI Slop* adalah hasil rancangan visual antarmuka yang terlihat sangat generik, kaku, dan minim karakter karena model AI secara berulang menghasilkan pola "aman" yang murahan:
- Gradien ungu/violet/neon mencolok di mana-mana.
- *Glassmorphism* berlebihan dengan blur besar yang mengaburkan teks.
- Grid 3 kartu melayang (*floating cards*) yang monoton tanpa hierarki informasi nyata.
- Radius sudut melengkung ekstrem (*pill shape* / 24–32px) yang tidak konsisten.
- Kartu-kartu dekoratif tanpa utilitas analitik yang jelas.

---

## 2. 🚫 DAFTAR LARANGAN KERAS (BANNED PATTERNS)

| Larangan | Alasan | Standar Pengganti |
| :--- | :--- | :--- |
| ❌ **Gratuitous Purple/Violet Neon Gradients** | Terlihat seperti template SaaS murah | Gunakan warna solid, matte, atau aksen *steel blue* / *amber* / *slate* yang tegas |
| ❌ **Neon Glow Lights & Multi-Colored Shadows** | Mengurangi keterbacaan & merusak kontras | Border solid `1px` beresolusi tinggi dengan shadow redup/nol (`0 1px 2px rgba(0,0,0,0.15)`) |
| ❌ **Monotonous Floating Card Grids** | Membuang ruang layar & minim hierarki | Gunakan **High-Density Data Tables**, **Kanban Boards**, atau **Collapsible Lists** |
| ❌ **Extreme/Inconsistent Border Radius** | Menghilangkan kesan presisi rekayasa | Batasi skala radius: `4px` (badge/tag), `6px` (button/input), `8px` (kartu), max `10px` (container) |
| ❌ **Vague Placeholders & Decorative Blobs** | Menandakan desain tanpa pemahaman domain | Gunakan data realistis, label spesifik industri, dan metrik kontekstual |

---

## 3. 🎨 PALET WARNA (STRICT DUAL-THEME SYSTEM)

Sistem warna menggunakan 4 layer utama (Base, Surface, Border, Text) dengan kontras tinggi yang memenuhi standar aksesibilitas **WCAG AA (rasio kontras minimal 4.5:1)**.

### A. Dark Theme Palette (Industrial Matte Dark)
```
Canvas Base:    #0B0E14   (Pure Matte Void)
Card Surface:   #141A23   (Deep Slate Surface)
Sub-surface:    #0F141C   (Input Fields, Table Header, Inset Panels)
Border Neutral: #222C3A   (1px Crisp Border)
Border Active:  #3B82F6   (Focus Ring / Active Tab)
```

| Token | Hex Code | Penggunaan |
| :--- | :--- | :--- |
| **`bg-canvas`** | `#0B0E14` | Background utama seluruh layar |
| **`card-surface`** | `#141A23` | Kontainer kartu, drawer, modal, navbar |
| **`card-hover`** | `#1B2330` | State hover pada baris tabel & kartu kanban |
| **`input-surface`**| `#0F141C` | Latar belakang input text & header tabel |
| **`border-base`**  | `#222C3A` | Garis batas tipis `1px solid` |
| **`text-primary`** | `#F1F5F9` | Judul, nilai metrik, teks utama |
| **`text-secondary`**| `#94A3B8` | Label deskripsi, status sekunder |
| **`text-muted`**   | `#64748B` | Timestamp, subtitle, ID badge |

---

### B. Light Theme Palette (Clean High-Contrast Light)
```
Canvas Base:    #F8FAFC   (Soft Slate White)
Card Surface:   #FFFFFF   (Clean White)
Sub-surface:    #F1F5F9   (Input Fields, Table Header, Inset Panels)
Border Neutral: #CBD5E1   (High-Contrast Crisp Border)
Border Active:  #2563EB   (Focus Ring / Active Tab)
```

| Token | Hex Code | Penggunaan |
| :--- | :--- | :--- |
| **`bg-canvas`** | `#F8FAFC` | Background utama seluruh layar |
| **`card-surface`** | `#FFFFFF` | Kontainer kartu, drawer, modal, navbar |
| **`card-hover`** | `#F1F5F9` | State hover pada baris tabel & kartu kanban |
| **`input-surface`**| `#F8FAFC` | Latar belakang input text & header tabel |
| **`border-base`**  | `#CBD5E1` | Garis batas solid `1px` (bukan border abu-abu pudar) |
| **`text-primary`** | `#0F172A` | Judul, angka metrik, teks utama |
| **`text-secondary`**| `#334155` | Label deskripsi, isi tabel |
| **`text-muted`**   | `#64748B` | Timestamp, subtitle, ID badge |

---

### C. Semantic Functional Accents
Warna fungsional digunakan secara disiplin hanya untuk mengindikasikan status, keparahan, atau aksi kunci:

| Status / Severity | Dark Hex | Light Hex | Makna & Indikasi |
| :--- | :--- | :--- | :--- |
| 🔴 **Critical / Destructive** | `#EF4444` | `#DC2626` | Bug sistemik, error blocking, delete action |
| 🟠 **High Priority** | `#F97316` | `#EA580C` | Membutuhkan respon cepat |
| 🟡 **Medium / Warning** | `#EAB308` | `#D97706` | Warning, degradasi performa non-blocking |
| 🔵 **In Progress / Ocean** | `#0284C7` | `#0284C7` | Sedang dikerjakan oleh tim teknis |
| 🟣 **Ready for Re-Test** | `#7C3AED` | `#7C3AED` | Siap diverifikasi oleh QA |
| 🟢 **Done / Success** | `#10B981` | `#059669` | Terverifikasi selesai, normal, sehat |

---

## 4. 📐 SISTEM SPACING & GEOMETRI (8-POINT GRID)

Semua komponen, padding, margin, dan jarak antar elemen **WAJIB** mengikuti skala kelipatan 4px / 8px:

```
+-----------+-----+-------------------------------------------------------+
| Token     | Px  | Kasus Penggunaan                                      |
+-----------+-----+-------------------------------------------------------+
| space-xs  | 4px | Jarak ikon ke teks mini, dot indicator ke label       |
| space-sm  | 8px | Padding badge, gap horizontal antar filter            |
| space-md  | 12px| Jarak antar form field, padding vertikal baris tabel  |
| space-lg  | 16px| Padding internal kartu, margin antar container         |
| space-xl  | 20px| Padding drawer inspeksi & modal form                  |
| space-2xl | 24px| Padding kanvas desktop widescreen                     |
| space-3xl | 32px| Section separator & empty state padding               |
+-----------+-----+-------------------------------------------------------+
```

### Aturan Radius Sudut (Corner Radii)
- `4px`: Badge kecil, tag platform, indicator dot.
- `6px`: Dropdown picker, button, segmented control button.
- `8px`: Textfield input, sub-card, kanban issue card.
- `10px` - `12px`: Container kartu besar, drawer, dialog modal.

---

## 5. 🔠 TIPOGRAFI & DENSITAS DATA

1. **Tabular Numerals & Monospace**:
   - Gunakan font `monospace` untuk Nomor Tiket (`#01`, `TICK-101`), waktu/timestamp (`14:23:05`), dan nilai metrik telemetri.
2. **Uppercase Labeling**:
   - Header kolom tabel dan section title menggunakan huruf kapital (*ALL-CAPS*) dengan `letterSpacing: 0.5px` - `0.8px` dan ukuran font `10px` - `12px` berbobot `FontWeight.w700`.
3. **Hierarchy & Weight**:
   - H1 / Page Header: `16px` - `18px`, `FontWeight.w700`
   - Card Title / Activity: `13px` - `14px`, `FontWeight.w600` / `w700`
   - Body Description: `12px` - `13px`, `FontWeight.w400`, `lineHeight: 1.4`
   - Captions / Subtitles: `11px`, `FontWeight.w400`

---

## 6. 📱 PANDUAN RESPONSIVE LAYOUT (WEB VS MOBILE)

### A. Web Desktop Layout (Widescreen >= 768px)
- **Top Filter Toolbar**: Horizontal row memanjang berisi Search Bar, Dropdown Platform, Dropdown Priority, Dropdown Status, Dropdown PIC Dev, Reset Filter, dan Toggle View Mode.
- **Data Table Mode**: Kolom padat dengan sorting, badge status warna tegas, assignee avatar, dan action button.
- **Kanban Board Mode**: Kolom status workflow (`Open`, `In Progress`, `Ready to Re-Test`, `Done`) yang memudahkan pemindahan status tiket.
- **Split Inspector Drawer**: Panel samping (*slide-over drawer*) berukuran lebar `380px - 400px` di sebelah kanan layar saat item dipilih, sehingga user tidak kehilangan konteks daftar tabel utama.

### B. Mobile Layout (Viewport < 768px)
- **Horizontal Scrollable Filter Bar**: Filter chips dapat digeser secara horizontal tanpa memakan ruang vertikal.
- **Mobile Card Feed**: Mengubah tabel menjadi kartu interaktif dengan tap target minimal `44px`, ringkasan issue 2-baris, dan avatar developer.
- **Bottom Sheet Modal**: Mengklik kartu pada mobile akan membuka Bottom Sheet geser ke atas (`85% height`) untuk inspeksi langkah reproduksi issue dan link lampiran.

---

## 7. ✅ DEVELOPER CHECKLIST UNTUK VERIFIKASI ANTI-SLOP

Sebelum menganggap sebuah fitur UI selesai, verifikasi daftar periksa berikut:

- [ ] **Bebas Gradien Ungu**: Tidak ada background atau tombol yang menggunakan gradien ungu generik.
- [ ] **Bebas Glowing Shadow**: Tidak ada box shadow berwarna neon.
- [ ] **Dual-Theme Tested**: Uji tampilan di Dark Mode (`#0B0E14`) dan Light Mode (`#F8FAFC`). Pastikan teks tidak pudar atau tidak terlihat.
- [ ] **8-Point Spacing**: Semua margin dan padding menggunakan nilai skala 4/8/12/16/20/24.
- [ ] **High Data Density**: Menampilkan data substantif yang relevan bagi pengguna teknis/bisnis.
- [ ] **Dynamic & Reaktif**: Semua dropdown, filter, dan data berasal dari state/enum dinamis tanpa teks hardcoded statis.
