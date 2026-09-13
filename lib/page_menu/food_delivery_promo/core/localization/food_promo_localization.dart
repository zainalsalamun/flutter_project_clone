import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/bloc/language/language_bloc.dart';

enum FoodLanguage { id, en }

class FoodPromoCopy {
  const FoodPromoCopy(this.language);

  final FoodLanguage language;

  static FoodPromoCopy of(BuildContext context) {
    final language = context.watch<LanguageBloc>().state.language;
    return FoodPromoCopy(language);
  }

  bool get _id => language == FoodLanguage.id;

  String get goodEvening => _id ? 'Selamat malam' : 'Good evening';
  String get deliverToHome => _id ? 'Antar ke Rumah' : 'Deliver to Home';
  String get searchFood => _id ? 'Cari makanan...' : 'Search food...';
  String get explore => _id ? 'Jelajahi' : 'Explore';
  String get exploreSubtitle =>
      _id
          ? 'Temukan restoran populer dan makanan pilihan.'
          : 'Discover trending restaurants and curated meals.';
  String get profile => _id ? 'Profil' : 'Profile';
  String get profileSubtitle =>
      _id
          ? 'Kelola alamat, pembayaran, voucher, dan preferensi.'
          : 'Manage address, payment, vouchers, and preferences.';
  String get home => _id ? 'Beranda' : 'Home';
  String get orders => _id ? 'Pesanan' : 'Orders';
  String get ordersSubtitle =>
      _id
          ? 'Pesanan aktif dan riwayat food delivery tampil di sini.'
          : 'Your active and past food delivery orders appear here.';
  String get favorites => _id ? 'Favorit' : 'Favorites';
  String get favoritesSubtitle =>
      _id
          ? 'Makanan yang kamu sukai akan terkumpul di tab ini.'
          : 'Food items you love will be collected in this tab.';
  String get favoritesEmpty =>
      _id ? 'Belum ada favorit' : 'No favorites yet';
  String get favoritesEmptySubtitle =>
      _id
          ? 'Tekan ikon hati pada makanan yang kamu sukai untuk menambahkannya ke favorit.'
          : 'Tap the heart icon on any food to save it to your favorites.';
  String get chooseSize => _id ? 'Pilih ukuran' : 'Choose size';
  String get base => _id ? 'Dasar' : 'Base';
  String get addOns => _id ? 'Tambahan' : 'Add-ons';
  String get addOnsLower => _id ? 'tambahan' : 'add-ons';
  String get quantity => _id ? 'Jumlah' : 'Quantity';
  String get addToCart => _id ? 'Tambah ke Keranjang' : 'Add to Cart';
  String get addedToCart => _id ? 'Masuk keranjang' : 'Added to cart';
  String get loading => _id ? 'Memproses' : 'Loading';
  String get cart => _id ? 'Keranjang' : 'Cart';
  String get checkout => _id ? 'Checkout' : 'Checkout';
  String get deliveryAddress => _id ? 'Alamat Pengiriman' : 'Delivery Address';
  String get addressValue =>
      _id
          ? 'Rumah - Jl. Jendral Sudirman No. 45'
          : 'Home - Jl. Jendral Sudirman No. 45';
  String get paymentMethod => _id ? 'Metode Pembayaran' : 'Payment Method';
  String get paymentValue =>
      _id ? 'Saldo QRIS FoodPay' : 'QRIS FoodPay balance';
  String get promo => _id ? 'Promo' : 'Promo';
  String get promoValue =>
      _id ? 'WEEKENDMEAL digunakan' : 'WEEKENDMEAL applied';
  String get subtotal => _id ? 'Subtotal' : 'Subtotal';
  String get delivery => _id ? 'Ongkir' : 'Delivery';
  String get serviceFee => _id ? 'Biaya Layanan' : 'Service Fee';
  String get discount => _id ? 'Diskon' : 'Discount';
  String get total => _id ? 'Total' : 'Total';
  String get placeOrder => _id ? 'Buat Pesanan' : 'Place Order';
  String get success => _id ? 'Berhasil' : 'Success';
  String get orderConfirmed => _id ? 'Pesanan Dikonfirmasi' : 'Order Confirmed';
  String get foodPrepared =>
      _id ? 'Makananmu sedang disiapkan.' : 'Your food is being prepared.';
  String get trackOrder => _id ? 'Lacak Pesanan' : 'Track Order';
  String get backToHome => _id ? 'Kembali ke beranda' : 'Back to home';
  String get orderTracking => _id ? 'Lacak Pesanan' : 'Order Tracking';
  String get trackingSubtitle =>
      _id
          ? 'Driver bergerak mengikuti setiap tahap persiapan.'
          : 'Driver is moving through each preparation step.';
  List<String> get trackingSteps =>
      _id
          ? ['Dikonfirmasi', 'Disiapkan', 'Siap', 'Diantar', 'Terkirim']
          : ['Confirmed', 'Preparing', 'Ready', 'On The Way', 'Delivered'];
  String get cartEmpty => _id ? 'Keranjang kosong' : 'Cart is empty';
  String get cartEmptySubtitle =>
      _id
          ? 'Tap kartu makanan, atur pesanan, lalu lihat makanan terbang ke keranjang.'
          : 'Tap a food card, customize it, and watch it fly into your cart.';

  String category(String value) {
    if (!_id) return value;
    return switch (value) {
      'All' => 'Semua',
      'Burger' => 'Burger',
      'Pizza' => 'Pizza',
      'Chicken' => 'Ayam',
      'Noodles' => 'Mie',
      'Drinks' => 'Minuman',
      'Dessert' => 'Dessert',
      _ => value,
    };
  }

  String optionLabel(String value) {
    if (!_id) return value;
    return switch (value) {
      'Regular' => 'Reguler',
      'Large' => 'Besar',
      'Extra Large' => 'Ekstra Besar',
      'Extra Cheese' => 'Keju Ekstra',
      'Egg' => 'Telur',
      'Beef' => 'Daging',
      'Sauce' => 'Saus',
      _ => value,
    };
  }
}
