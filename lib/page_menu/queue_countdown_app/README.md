# 🚆 KAI Ticket Queue Countdown & Complete Booking Flow (Flutter)

Dokumentasi lengkap implementasi alur pemesanan tiket kereta api end-to-end: dari **Masa Antrean Countdown (Ticket War)** ➔ **Pemilihan Gerbong & Kursi Kereta** ➔ **Pengisian Data Penumpang & Layanan Tambahan** ➔ **Simulasi Pembayaran (QRIS Laser Scanner / BCA Virtual Account / E-Wallet)** ➔ **E-Tiket & Boarding Pass Resmi (Barcode & QR Gate Scanner)**.

---

## 🔁 Alur Pemesanan End-to-End (1 Flow Lengkap)

```
[1. Halaman Antrean Countdown (QueueCountdownPage)]
       ↓ (Menunggu hitung mundur / tombol cepat selesai antre)
[2. Dialog "Giliran Anda Tiba!"]
       ↓ (Klik "Mulai Pemesanan Tiket")
[3. Form Pemesanan & Pilih Kursi (PassengerBookingPreviewPage)]
       ↓ (Timer Sesi 15 Menit aktif)
       ↓ (Pilih Gerbong Eksekutif 1-4 & Kursi 2x2 lewat TrainSeatSelectorModal)
       ↓ (Isi Nama, NIK KTP, No. HP, Toggle Asuransi & Makanan Restorasi)
[4. Modal Pembayaran (TrainPaymentModalSheet)]
       ↓ (Pilih QRIS Dinamis dengan Laser Scanner / BCA VA / GoPay)
       ↓ (Input Voucher Promo: KAIHEMAT untuk Diskon Rp 15.000)
       ↓ (Klik "Bayar Sekarang" & Animasi Verifikasi Pembayaran)
[5. E-Tiket & Boarding Pass Resmi (TrainBoardingPassReceiptPage)]
       ↓ (Status LUNAS, Kode Booking KAI-984210, Barcode Gate Stasiun, Simpan ke Galeri)
```

---

## 📸 Rincian Komponen & Layar

| No | Komponen / Layar | Fitur & Fungsionalitas | File Sumber |
|---|---|---|---|
| **1** | **Queue Countdown Screen** | Banner peringatan oranye, animasi perlintasan kereta (lampu kedip + palang bergoyang + kereta melintas), timer hitung mundur detak detik (`Menit:Detik`), status antrean (`#142`), tips penumpang, dan jam pembaruan realtime. | `queue_countdown_page.dart` |
| **2** | **Carriage & Seat Selector** | Modal denah gerbong kereta eksekutif (layout 2x2: A, B [Lorong] C, D) baris 1–10 dengan status kursi Tersedia, Terisi, dan Dipilih. | `widgets/train_seat_selector_modal.dart` |
| **3** | **Passenger Form & Add-ons** | Pengisian identitas penumpang sesuai KTP, switch Asuransi Perjalanan KAI Care (+Rp 5.000), switch Nasi Goreng Restorasi (+Rp 35.000), dan breakdown rincian harga. | `pages/passenger_booking_preview_page.dart` |
| **4** | **Payment Simulation Sheet** | QRIS Dinamis (laser scan beam & timer 15:00), BCA Virtual Account (tombol Salin VA), E-Wallet GoPay, input voucher promo (`KAIHEMAT`), dan animasi proses verifikasi instan. | `widgets/train_payment_modal_sheet.dart` |
| **5** | **E-Tiket & Boarding Pass** | Desain tiket berlubang (*notched ticket perforation*), rute St. Gambir (08:30) ➔ St. Bandung (11:15), barcode vektor gate scanner, badge status LUNAS, tombol simpan tiket & kembali ke beranda. | `pages/train_boarding_pass_receipt_page.dart` |

---

## 📁 Struktur File Proyek

```
lib/page_menu/queue_countdown_app/
├── README.md                                 # Dokumentasi Teknis & Alur
├── queue_countdown_page.dart                 # [Layar 1] Antrean Countdown
├── widgets/
│   ├── railroad_crossing_visualizer.dart     # CustomPainter Animasi Perlintasan Kereta
│   ├── flip_countdown_timer.dart             # Kotak Countdown Live Ticking
│   ├── passenger_tips_card.dart              # Kartu Tips Pengisian Data Penumpang
│   ├── train_seat_selector_modal.dart        # [Layar 2] Modal Denah Kursi 2x2
│   └── train_payment_modal_sheet.dart        # [Layar 3] Modal Pembayaran QRIS/VA/E-Wallet
└── pages/
    ├── passenger_booking_preview_page.dart   # [Layar 2] Form Data Penumpang & Tiket
    └── train_boarding_pass_receipt_page.dart # [Layar 4] E-Tiket & Boarding Pass Resmi
```
