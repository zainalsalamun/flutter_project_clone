import 'package:flutter/material.dart';

enum BrewezLanguage { en, id }

class BrewezLocalization {
  static final ValueNotifier<BrewezLanguage> currentLanguage =
      ValueNotifier<BrewezLanguage>(BrewezLanguage.id);

  static bool get isIndonesian => currentLanguage.value == BrewezLanguage.id;

  static void setLanguage(BrewezLanguage lang) {
    currentLanguage.value = lang;
  }

  static void toggleLanguage() {
    currentLanguage.value = currentLanguage.value == BrewezLanguage.id
        ? BrewezLanguage.en
        : BrewezLanguage.id;
  }

  static String tr(String key) {
    final lang = currentLanguage.value;
    return _localizedValues[lang]?[key] ??
        _localizedValues[BrewezLanguage.en]?[key] ??
        key;
  }

  static final Map<BrewezLanguage, Map<String, String>> _localizedValues = {
    BrewezLanguage.en: {
      // Home Page
      'app_title': 'Brewez Coffee Lounge',
      'location': 'Jakarta, Indonesia',
      'search_hint': 'Search your favorite roast...',
      'search_results_for': 'Results for',
      'filter_title': 'Filter & Sort Brews',
      'sort_by': 'Sort By',
      'sort_popular': 'Highest Rating',
      'sort_price_low': 'Price: Low to High',
      'sort_price_high': 'Price: High to Low',
      'sort_name': 'Name (A - Z)',
      'price_range': 'Price Range',
      'min_rating': 'Minimum Rating',
      'reset_filter': 'Reset',
      'apply_filter': 'Apply Filters',
      'search_no_results': 'No coffee brews found',
      'search_no_results_sub': 'Try searching with different keywords or reset your filters.',
      'popular_brews': 'Popular Brews',
      'see_all': 'See all',
      'all_menu_title': 'All Coffee Menu',
      'all_menu_sub': 'Explore all crafted artisan brews',
      'view_grid': 'Grid View',
      'view_list': 'List View',
      'showing_menu_count': 'Showing brews',
      'special_moments': 'Special Moments',
      'all_coffee': 'All Coffee',
      'espresso': 'Espresso',
      'latte': 'Latte',
      'cappuccino': 'Cappuccino',
      'macchiato': 'Macchiato',
      'cold_brew': 'Cold Brew',

      // Mood Selector
      'mood_title': 'How is your mood today?',
      'mood_all': 'All Moods',
      'mood_energy': 'Need Energy',
      'mood_chill': 'Relax & Chill',
      'mood_focus': 'Deep Focus',
      'mood_refresh': 'Ice Fresh',

      // Promo Banners
      'promo_1_tag': 'Special Weekend',
      'promo_1_title': 'Buy 1 Get 1 FREE\non All Espresso',
      'promo_2_tag': 'Happy Hour 2PM-5PM',
      'promo_2_title': '50% Off Oat Milk\nUpgrade Today',
      'promo_3_tag': 'Sweet Treat',
      'promo_3_title': 'Free Cinnamon Topping\nwith Every Caramel Latte',

      // Quick Customize
      'quick_customize': 'Customize Your Brew',
      'add_to_cart_btn': 'Add to Cart',

      // Detail Page
      'cup_size': 'Cup Size',
      'hot_brew': 'Hot (Mug)',
      'iced_cold': 'Iced (Glass)',
      'sweetness_level': 'Sweetness Level',
      'sweet_0': 'Unsweetened (Bold & Pure)',
      'sweet_50': 'Half Sweet (Balanced Notes)',
      'sweet_70': 'Regular Sweet (Recommended)',
      'sweet_100': 'Extra Sweet (Rich & Creamy)',
      'custom_addons': 'Custom Ingredients & Add-ons',
      'description_title': 'Description',
      'coffee_desc':
          'Crafted with 100% freshly roasted Arabica beans, blended smoothly with silky micro-foam milk and artisanal syrups for an exquisite and refreshing experience.',
      'total_price': 'Total Price',
      'brew_now': 'Brew Now',
      'free_badge': 'FREE',

      // Addon Categories
      'category_milk': 'Milk Choice (Single Select)',
      'category_syrup': 'Syrups & Sweeteners',
      'category_booster': 'Espresso & Ice Boosters',
      'category_topping': 'Foam & Toppings',

      // Addons
      'addon_fresh_milk': 'Fresh Milk',
      'addon_fresh_milk_sub': 'Standard dairy milk',
      'addon_oat_milk': 'Oat Milk',
      'addon_oat_milk_sub': 'Creamy plant-based',
      'addon_almond_milk': 'Almond Milk',
      'addon_almond_milk_sub': 'Nutty fragrant milk',

      'addon_palm_sugar': 'Organic Palm Sugar',
      'addon_palm_sugar_sub': 'Authentic sweetness',
      'addon_caramel': 'Caramel Drizzle',
      'addon_caramel_sub': 'Golden dripping syrup',
      'addon_vanilla': 'Vanilla Syrup',
      'addon_vanilla_sub': 'Sweet floral aroma',

      'addon_extra_ice': 'Extra Ice Cubes',
      'addon_extra_ice_sub': 'Chilled crystal ice',
      'addon_extra_shot': 'Extra Espresso Shot',
      'addon_extra_shot_sub': 'Double strength boost',

      'addon_cinnamon': 'Cinnamon Dust',
      'addon_cinnamon_sub': 'Warm aromatic spice',
      'addon_cheese_foam': 'Cream Cheese Foam',
      'addon_cheese_foam_sub': 'Thick velvety topping',

      // Brewing Modal
      'step_1_title': 'Grinding Fresh Beans',
      'step_1_desc': 'Selecting premium Arabica roast',
      'step_2_title': 'Extracting & Blending',
      'step_2_desc': '9-bar extraction & crafting ingredients',
      'step_3_title': 'Perfect Cup Ready!',
      'step_3_desc': 'Freshly customized and ready to enjoy',
      'brewing_progress': 'Brewing in progress...',
      'enjoy_drink': 'Enjoy Your Drink',
      'sugar_label': 'Sugar',
      'hot_badge': 'Hot',
      'iced_badge': 'Iced',
      'enjoy_snack': 'Enjoy your freshly brewed',

      // Cart
      'my_cart': 'My Coffee Cart',
      'cart_empty': 'Your cart is empty',
      'cart_empty_sub': 'Add some delicious coffee brews to get started!',
      'checkout_btn': 'Checkout & Pay',
      'items_count': 'items',
      'cart_added_toast': 'Added to your cart!',
      'order_placed': 'Order Placed Successfully!',

      // Payment & Checkout
      'checkout_title': 'Payment & Checkout',
      'order_summary': 'Order Summary',
      'payment_method': 'Payment Method',
      'promo_code_hint': 'Promo code (try: BREWEZ50)',
      'apply_btn': 'Apply',
      'promo_applied': 'Promo Applied!',
      'invalid_promo': 'Invalid promo code',
      'subtotal_label': 'Subtotal',
      'discount_label': 'Discount',
      'service_fee': 'Service Fee',
      'total_payment': 'Total Payment',
      'pay_now_btn': 'Pay Now',
      'pay_success_toast': 'Payment Verified! Starting Brew...',
      'scan_qris_sim': 'Simulate Scan & Pay QRIS',
      'transfer_va_sim': 'Simulate Bank Transfer',
      'pay_ewallet_sim': 'Simulate E-Wallet Payment',
      'pay_cash_sim': 'Confirm & Pay at Cashier',
      'copy_va': 'Copy VA',
      'va_copied': 'VA Number copied to clipboard!',
      'qris_merchant': 'NMID: ID102938475 • BREWEZ LOUNGE',
      'qris_expires_in': 'Expires in',

      // Receipt & Ticket
      'receipt_title': 'Pickup Ticket & Receipt',
      'pickup_queue_label': 'PICKUP QUEUE NUMBER',
      'order_id_label': 'Order ID',
      'order_time_label': 'Order Time',
      'payment_status_paid': 'LUNAS / PAID',
      'payment_via': 'Payment Via',
      'pickup_barcode_hint': 'Show this barcode/ticket to barista when picking up',
      'download_receipt_btn': 'Save Receipt',
      'receipt_saved_toast': 'Receipt saved to gallery',
      'order_more_btn': 'Order More Coffee',
      'view_receipt_btn': 'View Pickup Ticket & Receipt',
      'step_4_title': 'Quality Check & Garnish',
      'step_4_desc': 'Final aroma touch and cup ready to serve',
    },
    BrewezLanguage.id: {
      // Home Page
      'app_title': 'Brewez Coffee Lounge',
      'location': 'Jakarta, Indonesia',
      'search_hint': 'Cari kopi favoritmu...',
      'search_results_for': 'Hasil pencarian untuk',
      'filter_title': 'Filter & Urutkan Kopi',
      'sort_by': 'Urutkan Berdasarkan',
      'sort_popular': 'Rating Tertinggi',
      'sort_price_low': 'Harga: Termurah',
      'sort_price_high': 'Harga: Termahal',
      'sort_name': 'Nama (A - Z)',
      'price_range': 'Rentang Harga',
      'min_rating': 'Rating Minimal',
      'reset_filter': 'Reset',
      'apply_filter': 'Terapkan Filter',
      'search_no_results': 'Tidak ada kopi yang cocok',
      'search_no_results_sub': 'Coba gunakan kata kunci lain atau reset filter pilihanmu.',
      'popular_brews': 'Kopi Populer',
      'see_all': 'Lihat semua',
      'all_menu_title': 'Semua Menu Kopi',
      'all_menu_sub': 'Jelajahi seluruh racikan kopi pilihan',
      'view_grid': 'Tampilan Grid',
      'view_list': 'Tampilan List',
      'showing_menu_count': 'Menampilkan pilihan',
      'special_moments': 'Promo Spesial',
      'all_coffee': 'Semua Kopi',
      'espresso': 'Espresso',
      'latte': 'Latte',
      'cappuccino': 'Cappuccino',
      'macchiato': 'Macchiato',
      'cold_brew': 'Cold Brew',

      // Mood Selector
      'mood_title': 'Bagaimana suasana hatimu?',
      'mood_all': 'Semua Pilihan',
      'mood_energy': 'Butuh Energi',
      'mood_chill': 'Santai & Chill',
      'mood_focus': 'Fokus Kerja',
      'mood_refresh': 'Segar Dingin',

      // Promo Banners
      'promo_1_tag': 'Spesial Akhir Pekan',
      'promo_1_title': 'Beli 1 Gratis 1\nSemua Varian Espresso',
      'promo_2_tag': 'Happy Hour 14:00-17:00',
      'promo_2_title': 'Diskon 50% Susu Oat\nUpgrade Hari Ini',
      'promo_3_tag': 'Manis Spesial',
      'promo_3_title': 'Gratis Taburan Kayu Manis\nSetiap Caramel Latte',

      // Quick Customize
      'quick_customize': 'Kustomisasi Racikan Kopimu',
      'add_to_cart_btn': 'Tambahkan ke Keranjang',

      // Detail Page
      'cup_size': 'Ukuran Cangkir',
      'hot_brew': 'Hangat (Mug)',
      'iced_cold': 'Dingin (Gelas)',
      'sweetness_level': 'Tingkat Kemanisan',
      'sweet_0': 'Tanpa Gula (Murni & Pekat)',
      'sweet_50': 'Sedikit Manis (Rasa Seimbang)',
      'sweet_70': 'Manis Pas (Rekomendasi Barista)',
      'sweet_100': 'Ekstra Manis (Kental & Manis)',
      'custom_addons': 'Kustomisasi Racikan & Bahan',
      'description_title': 'Deskripsi',
      'coffee_desc':
          'Diracik dari 100% biji Arabika pilihan yang baru dipanggang, dipadukan secara halus dengan susu micro-foam lembut dan sirup spesial untuk cita rasa kopi premium.',
      'total_price': 'Total Harga',
      'brew_now': 'Seduh Sekarang',
      'free_badge': 'GRATIS',

      // Addon Categories
      'category_milk': 'Pilihan Susu (Pilih 1)',
      'category_syrup': 'Sirup & Pemanis',
      'category_booster': 'Booster Espresso & Es',
      'category_topping': 'Topping & Foam Spesial',

      // Addons
      'addon_fresh_milk': 'Fresh Milk (Susu Segar)',
      'addon_fresh_milk_sub': 'Susu sapi standar barista',
      'addon_oat_milk': 'Susu Oat (Oat Milk)',
      'addon_oat_milk_sub': 'Lembut & bebas laktosa',
      'addon_almond_milk': 'Susu Almond',
      'addon_almond_milk_sub': 'Aroma kacang gurih',

      // Syrups
      'addon_palm_sugar': 'Gula Aren Organik',
      'addon_palm_sugar_sub': 'Manis legit alami',
      'addon_caramel': 'Saus Karamel',
      'addon_caramel_sub': 'Lelehan sirup keemasan',
      'addon_vanilla': 'Sirup Vanilla',
      'addon_vanilla_sub': 'Aroma manis floral',

      // Boosters
      'addon_extra_ice': 'Ekstra Es Kristal',
      'addon_extra_ice_sub': 'Es batu kristal melimpah',
      'addon_extra_shot': 'Ekstra 1 Shot Espresso',
      'addon_extra_shot_sub': '2x lipat lebih pekat',

      // Topping
      'addon_cinnamon': 'Bubuk Kayu Manis',
      'addon_cinnamon_sub': 'Taburan rempah wangi',
      'addon_cheese_foam': 'Cream Cheese Foam',
      'addon_cheese_foam_sub': 'Busa keju gurih creamy',

      // Brewing Modal
      'step_1_title': 'Menggiling Biji Kopi',
      'step_1_desc': 'Memilih biji Arabika panggang segar',
      'step_2_title': 'Mengekstraksi & Meracik Bahan',
      'step_2_desc': 'Ekstraksi 9-bar dan memadukan komposisi bahan',
      'step_3_title': 'Menyiapkan Susu & Foam',
      'step_3_desc': 'Susu micro-foam lembut & perpaduan es kristal',
      'step_4_title': 'Kopi Siap Disajikan!',
      'step_4_desc': 'Finishing touch aroma dan siap dinikmati',
      'brewing_progress': 'Sedang menyeduh kopi...',
      'enjoy_drink': 'Nikmati Kopimu',
      'sugar_label': 'Gula',
      'hot_badge': 'Hangat',
      'iced_badge': 'Dingin',
      'enjoy_snack': 'Selamat menikmati racikan spesial',

      // Cart
      'my_cart': 'Keranjang Kopiku',
      'cart_empty': 'Keranjangmu masih kosong',
      'cart_empty_sub': 'Pilih racikan kopi favoritmu untuk memulai!',
      'checkout_btn': 'Checkout & Bayar',
      'items_count': 'item',
      'cart_added_toast': 'Berhasil masuk ke keranjang!',
      'order_placed': 'Pesanan Berhasil Dibuat!',

      // Payment & Checkout
      'checkout_title': 'Pembayaran & Checkout',
      'order_summary': 'Ringkasan Pesanan',
      'payment_method': 'Metode Pembayaran',
      'promo_code_hint': 'Kode promo (coba: BREWEZ50)',
      'apply_btn': 'Pakai',
      'promo_applied': 'Promo Digunakan!',
      'invalid_promo': 'Kode promo tidak valid',
      'subtotal_label': 'Subtotal',
      'discount_label': 'Diskon Promo',
      'service_fee': 'Biaya Layanan',
      'total_payment': 'Total Pembayaran',
      'pay_now_btn': 'Bayar Sekarang',
      'pay_success_toast': 'Pembayaran Berhasil! Memulai Seduh...',
      'scan_qris_sim': 'Simulasi Scan & Bayar QRIS',
      'transfer_va_sim': 'Simulasi Transfer Bank',
      'pay_ewallet_sim': 'Simulasi Bayar E-Wallet',
      'pay_cash_sim': 'Konfirmasi & Bayar di Kasir',
      'copy_va': 'Salin VA',
      'va_copied': 'Nomor Virtual Account disalin!',
      'qris_merchant': 'NMID: ID102938475 • BREWEZ LOUNGE',
      'qris_expires_in': 'Kadaluarsa dalam',

      // Receipt & Ticket
      'receipt_title': 'Tiket Pengambilan & Struk',
      'pickup_queue_label': 'NOMOR ANTRIAN PENGAMBILAN',
      'order_id_label': 'ID Pesanan',
      'order_time_label': 'Waktu Pesanan',
      'payment_status_paid': 'LUNAS / PAID',
      'payment_via': 'Metode Bayar',
      'pickup_barcode_hint': 'Tunjukkan tiket/barcode ini ke barista saat mengambil kopi',
      'download_receipt_btn': 'Simpan Struk',
      'receipt_saved_toast': 'Struk berhasil disimpan ke galeri',
      'order_more_btn': 'Pesan Kopi Lagi',
      'view_receipt_btn': 'Lihat Tiket Pengambilan & Struk',
    },
  };
}
