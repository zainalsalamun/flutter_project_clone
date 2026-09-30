import 'package:flutter/material.dart';
import '../models/widget_category.dart';
import '../models/widget_item.dart';

// Showcases
import '../showcases/buttons/gradient_button_showcase.dart';
import '../showcases/buttons/loading_button_showcase.dart';
import '../showcases/buttons/neumorphic_button_showcase.dart';
import '../showcases/buttons/expandable_fab_showcase.dart';
import '../showcases/buttons/slide_to_act_showcase.dart';

import '../showcases/inputs/modern_floating_input_showcase.dart';
import '../showcases/inputs/otp_pin_input_showcase.dart';
import '../showcases/inputs/animated_dropdown_showcase.dart';
import '../showcases/inputs/gradient_slider_showcase.dart';

import '../showcases/cards/glassmorphic_card_showcase.dart';
import '../showcases/cards/expandable_accordion_showcase.dart';
import '../showcases/cards/ticket_pass_card_showcase.dart';
import '../showcases/cards/flip_card_showcase.dart';

import '../showcases/navigation/floating_pill_navbar_showcase.dart';
import '../showcases/navigation/glass_appbar_showcase.dart';
import '../showcases/navigation/sliding_segmented_tab_showcase.dart';

import '../showcases/dialogs/animated_status_dialog_showcase.dart';
import '../showcases/dialogs/modern_bottom_sheet_showcase.dart';
import '../showcases/dialogs/floating_toast_showcase.dart';

import '../showcases/loaders/skeleton_shimmer_showcase.dart';
import '../showcases/loaders/pulsing_dot_spinner_showcase.dart';
import '../showcases/loaders/circular_gradient_progress_showcase.dart';

import '../showcases/badges/status_pill_badge_showcase.dart';
import '../showcases/badges/tag_chip_selector_showcase.dart';

import '../showcases/animations/interactive_rating_showcase.dart';
import '../showcases/animations/swipeable_action_item_showcase.dart';

// Batch 1 Showcases
import '../showcases/inputs/day_night_switch_showcase.dart';
import '../showcases/animations/animated_rolling_counter_showcase.dart';
import '../showcases/cards/holographic_card_showcase.dart';
import '../showcases/animations/confetti_burst_button_showcase.dart';
import '../showcases/animations/mini_sparkline_chart_showcase.dart';

// Batch 2 Showcases
import '../showcases/cards/scratch_card_showcase.dart';
import '../showcases/cards/pricing_tier_card_showcase.dart';
import '../showcases/navigation/multi_step_stepper_showcase.dart';
import '../showcases/badges/avatar_group_stack_showcase.dart';
import '../showcases/animations/audio_waveform_showcase.dart';
import '../showcases/animations/shimmer_gradient_text_showcase.dart';
import '../showcases/inputs/signature_drawing_pad_showcase.dart';

// Option A: Visual & Media Showcases
import '../showcases/animations/before_after_slider_showcase.dart';
import '../showcases/badges/story_avatar_ring_showcase.dart';
import '../showcases/animations/pinch_zoom_viewer_showcase.dart';

// Option B: Gamification & Gauges Showcases
import '../showcases/animations/spin_lucky_wheel_showcase.dart';
import '../showcases/animations/radial_gauge_meter_showcase.dart';
import '../showcases/animations/retro_flip_clock_showcase.dart';

// Batch Basic 1: Form & Security Essentials
import '../showcases/inputs/animated_checkbox_radio_showcase.dart';
import '../showcases/inputs/password_strength_meter_showcase.dart';
import '../showcases/inputs/credit_card_input_showcase.dart';

// Batch Basic 2: Feedback & Layout Essentials
import '../showcases/cards/empty_state_card_showcase.dart';
import '../showcases/loaders/striped_linear_progress_showcase.dart';
import '../showcases/badges/bouncing_notification_bell_showcase.dart';

// Option 1: Security & Biometrics Showcases
import '../showcases/inputs/pattern_lock_showcase.dart';
import '../showcases/inputs/fingerprint_scanner_showcase.dart';
import '../showcases/inputs/inline_date_time_picker_showcase.dart';

// Option A: E-Commerce & Transaction Pro Showcases
import '../showcases/cards/perforated_voucher_card_showcase.dart';
import '../showcases/buttons/morphing_quantity_stepper_showcase.dart';
import '../showcases/inputs/dashed_upload_dropzone_showcase.dart';

// Option B: Navigation & Overlays Showcases
import '../showcases/navigation/radial_speed_dial_fab_showcase.dart';
import '../showcases/dialogs/filter_bottom_sheet_showcase.dart';
import '../showcases/dialogs/in_app_notification_banner_showcase.dart';

// Option C: Social & Messaging Pro Showcases
import '../showcases/animations/voice_note_player_showcase.dart';
import '../showcases/animations/floating_hearts_reaction_showcase.dart';
import '../showcases/inputs/mention_hashtag_input_showcase.dart';

// Option D: Creative & Canvas FX Showcases
import '../showcases/animations/particle_fireworks_showcase.dart';
import '../showcases/cards/foldable_3d_origami_card_showcase.dart';
import '../showcases/animations/liquid_wave_progress_showcase.dart';

// Option E: Finance, Charts & Math Showcases
import '../showcases/animations/donut_budget_chart_showcase.dart';
import '../showcases/animations/candlestick_chart_showcase.dart';
import '../showcases/cards/split_bill_calculator_showcase.dart';

// Option F: Sensors, Audio & Device Mockup Showcases
import '../showcases/cards/device_frame_mockup_showcase.dart';
import '../showcases/animations/compass_heading_dial_showcase.dart';
import '../showcases/animations/sound_equalizer_bars_showcase.dart';

// Option G: Games & Interactive Physics Showcases
import '../showcases/animations/slot_machine_spinner_showcase.dart';
import '../showcases/animations/pop_it_fidget_board_showcase.dart';
import '../showcases/cards/swipeable_card_deck_showcase.dart';
import '../showcases/animations/plinko_peg_drop_showcase.dart';
import '../showcases/animations/claw_machine_arcade_showcase.dart';
import '../showcases/animations/whack_a_mole_arcade_showcase.dart';

// Option H: Auth, Security & Onboarding Pro Showcases
import '../showcases/inputs/face_id_biometric_scanner_showcase.dart';
import '../showcases/navigation/story_onboarding_carousel_showcase.dart';
import '../showcases/inputs/captcha_slider_puzzle_showcase.dart';

// Option I: Maps, Travel & Logistics Showcases
import '../showcases/cards/flight_boarding_pass_fold_showcase.dart';
import '../showcases/navigation/courier_delivery_route_tracker_showcase.dart';
import '../showcases/cards/seat_selection_matrix_showcase.dart';

// Option J: AI, Prompting & Audio Wave Showcases
import '../showcases/inputs/ai_prompt_suggestion_cloud_showcase.dart';
import '../showcases/inputs/multimodal_attachment_tray_showcase.dart';
import '../showcases/animations/ai_voice_ripple_sphere_showcase.dart';

// Option K: Interactive Data Grids & Hierarchy Showcases
import '../showcases/cards/kanban_drag_drop_board_showcase.dart';
import '../showcases/cards/sticky_header_data_table_showcase.dart';
import '../showcases/navigation/expandable_tree_view_hierarchy_showcase.dart';

// Option L: Health, Fitness & Activity Rings Showcases
import '../showcases/animations/apple_watch_activity_rings_showcase.dart';
import '../showcases/animations/hydration_water_intake_tracker_showcase.dart';
import '../showcases/animations/sleep_quality_hypnogram_chart_showcase.dart';

// Option M: Media, Camera & Live Filters Showcases
import '../showcases/animations/story_camera_filter_wheel_showcase.dart';
import '../showcases/animations/audio_pitch_tuner_dial_showcase.dart';
import '../showcases/animations/video_scrubber_thumbnail_strip_showcase.dart';

// Option N: Smart Home & IoT Automation Showcases
import '../showcases/cards/smart_thermostat_dial_showcase.dart';
import '../showcases/cards/smart_lighting_scene_showcase.dart';
import '../showcases/animations/energy_consumption_flow_graph_showcase.dart';

// Option O: AR, 3D Spatial & Vision Pro Showcases
import '../showcases/cards/spatial_parallax_tilt_card_showcase.dart';
import '../showcases/animations/interactive_360_turntable_showcase.dart';
import '../showcases/navigation/vision_spatial_hud_window_showcase.dart';

// Option P: Automotive, EV & Telematics Showcases
import '../showcases/cards/ev_battery_state_of_charge_showcase.dart';
import '../showcases/cards/tpms_vehicle_wireframe_showcase.dart';
import '../showcases/animations/regen_braking_g_force_matrix_showcase.dart';

// Option Q: Crypto, Web3 & FinTech Pro Showcases
import '../showcases/animations/order_book_depth_chart_showcase.dart';
import '../showcases/animations/pro_candlestick_chart_showcase.dart';
import '../showcases/dialogs/web3_wallet_connect_sheet_showcase.dart';
import '../showcases/animations/crypto_fear_greed_meter_showcase.dart';
import '../showcases/cards/staking_yield_calculator_showcase.dart';
import '../showcases/animations/amm_liquidity_pool_curve_showcase.dart';

class WidgetCatalogRegistry {
  static final List<WidgetItem> allWidgets = [
    // ------------------- BUTTONS -------------------
    WidgetItem(
      id: 'btn_gradient',
      title: 'Gradient Scale Button',
      description:
          'Tombol dengan background gradient warna modern dilengkapi animasi scale down saat ditekan (tactile micro-interaction).',
      category: WidgetCategory.buttons,
      difficulty: WidgetDifficulty.beginner,
      icon: Icons.smart_button_rounded,
      tags: ['Button', 'Gradient', 'Scale Animation', 'Shadow'],
      usageTips:
          'Gunakan LinearGradient untuk transisi warna menarik dan padukan dengan InkWell untuk efek ripple Material.',
      codeSnippet: '''
Container(
  height: 50,
  decoration: BoxDecoration(
    gradient: const LinearGradient(
      colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF6366F1).withValues(alpha: 0.35),
        blurRadius: 14,
        offset: const Offset(0, 6),
      ),
    ],
  ),
  child: Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {},
      child: const Center(
        child: Text('Explore Universe', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    ),
  ),
)''',
      previewBuilder: (context) => const GradientButtonShowcase(),
    ),

    WidgetItem(
      id: 'btn_loading_morph',
      title: 'Loading Morphing Button',
      description:
          'Tombol yang bertransisi dinamis menjadi circular loading spinner saat diklik, lalu menampilkan icon success/error.',
      category: WidgetCategory.buttons,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.hourglass_top_rounded,
      tags: ['Button', 'Loading State', 'AnimatedContainer', 'Morph'],
      usageTips:
          'Cocok digunakan untuk form submission atau tombol pembayaran agar pengguna tahu proses sedang berjalan.',
      codeSnippet: '''
AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  width: isLoading ? 50 : 280,
  height: 50,
  decoration: BoxDecoration(
    color: const Color(0xFF6366F1),
    borderRadius: BorderRadius.circular(isLoading ? 25 : 14),
  ),
  child: Center(
    child: isLoading
        ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)
        : const Text('Submit Form', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
  ),
)''',
      previewBuilder: (context) => const LoadingButtonShowcase(),
    ),

    WidgetItem(
      id: 'btn_neumorphic',
      title: 'Neumorphic Soft Button',
      description:
          'Tombol gaya Neumorphism 3D dengan efek bayangan ganda (highlight putih dan shadow gelap) saat ditekan atau aktif.',
      category: WidgetCategory.buttons,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.layers_rounded,
      tags: ['Neumorphism', 'Soft UI', 'Dual BoxShadow', 'Custom Design'],
      usageTips:
          'Gunakan warna background abu-abu terang (misal #E2E8F0) dan atur offset shadow berlawanan arah.',
      codeSnippet: '''
AnimatedContainer(
  duration: const Duration(milliseconds: 150),
  width: 64,
  height: 64,
  decoration: BoxDecoration(
    color: const Color(0xFFE2E8F0),
    borderRadius: BorderRadius.circular(18),
    boxShadow: isPressed
        ? [
            BoxShadow(color: Colors.white.withValues(alpha: 0.9), offset: const Offset(3, 3), blurRadius: 4),
            BoxShadow(color: const Color(0xFF94A3B8).withValues(alpha: 0.5), offset: const Offset(-3, -3), blurRadius: 4),
          ]
        : [
            const BoxShadow(color: Colors.white, offset: Offset(-5, -5), blurRadius: 10),
            BoxShadow(color: const Color(0xFF94A3B8).withValues(alpha: 0.6), offset: const Offset(5, 5), blurRadius: 10),
          ],
  ),
  child: const Icon(Icons.lightbulb, color: Colors.amber),
)''',
      previewBuilder: (context) => const NeumorphicButtonShowcase(),
    ),

    WidgetItem(
      id: 'btn_expandable_fab',
      title: 'Expandable Speed Dial FAB',
      description:
          'Floating action button dengan animasi ekspansi speed dial melengkung untuk memunculkan sub-menu tindakan cepat.',
      category: WidgetCategory.buttons,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.add_circle_outline_rounded,
      tags: ['FAB', 'Speed Dial', 'Animation', 'Trigonometry'],
      usageTips:
          'Hitung posisi sudut melingkar menggunakan math.cos dan math.sin berdasarkan progress animasi.',
      codeSnippet: '''
// Menggunakan Transform.rotate dan kalkulasi offset radial:
final offset = Offset.fromDirection(
  directionInDegrees * (math.pi / 180.0) + math.pi,
  progress.value * maxDistance,
);
Transform.translate(offset: offset, child: child);''',
      previewBuilder: (context) => const ExpandableFabShowcase(),
    ),

    WidgetItem(
      id: 'btn_slide_to_act',
      title: 'Slide to Confirm Action',
      description:
          'Komponen geser (swipe slider) untuk konfirmasi transaksi penting agar tidak terjadi ketidaksengajaan klik.',
      category: WidgetCategory.buttons,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.swipe_right_rounded,
      tags: ['GestureDetector', 'Slide to Act', 'Payment Confirm', 'Slider'],
      usageTips:
          'Hitung horizontal drag delta dan clamp posisinya terhadap lebar maksimal container.',
      codeSnippet: '''
GestureDetector(
  onHorizontalDragUpdate: (details) {
    setState(() {
      _dragPosition = (_dragPosition + details.delta.dx).clamp(0.0, maxDrag);
    });
  },
  onHorizontalDragEnd: (details) {
    if (_dragPosition >= maxDrag * 0.85) {
      onConfirmed();
    } else {
      setState(() => _dragPosition = 0);
    }
  },
  child: Container(/* Thumb Widget */),
)''',
      previewBuilder: (context) => const SlideToActShowcase(),
    ),

    // ------------------- INPUTS -------------------
    WidgetItem(
      id: 'input_modern_glow',
      title: 'Modern Glowing TextField',
      description:
          'Input text dengan highlight border neon glow, smooth focus state, dan toggle reveal password terintegrasi.',
      category: WidgetCategory.inputs,
      difficulty: WidgetDifficulty.beginner,
      icon: Icons.text_fields_rounded,
      tags: ['TextField', 'FocusNode', 'Password Reveal', 'Border Glow'],
      usageTips:
          'Gunakan FocusNode listener untuk mengubah warna border dan shadow secara dinamis.',
      codeSnippet: '''
AnimatedContainer(
  duration: const Duration(milliseconds: 200),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(
      color: isFocused ? const Color(0xFF6366F1) : Colors.grey.shade300,
      width: isFocused ? 1.8 : 1.0,
    ),
    boxShadow: isFocused ? [
      BoxShadow(
        color: const Color(0xFF6366F1).withValues(alpha: 0.2),
        blurRadius: 10,
        spreadRadius: 1,
      ),
    ] : null,
  ),
  child: TextField(/* ... */),
)''',
      previewBuilder: (context) => const ModernFloatingInputShowcase(),
    ),

    WidgetItem(
      id: 'input_otp_pin',
      title: 'OTP 6-Digit Auto-Focus PIN',
      description:
          'Form input 6 digit kode OTP/PIN verifikasi dengan auto-advance focus ke digit berikutnya dan support tombol backspace.',
      category: WidgetCategory.inputs,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.pin_rounded,
      tags: ['OTP', 'PIN Input', 'FocusNode', 'Verification'],
      usageTips:
          'Gunakan kumpulan TextEditingController dan FocusNode terpisah untuk tiap digit box.',
      codeSnippet: '''
TextField(
  controller: _controllers[index],
  focusNode: _focusNodes[index],
  textAlign: TextAlign.center,
  keyboardType: TextInputType.number,
  inputFormatters: [
    LengthLimitingTextInputFormatter(1),
    FilteringTextInputFormatter.digitsOnly,
  ],
  onChanged: (val) {
    if (val.isNotEmpty && index < length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
  },
)''',
      previewBuilder: (context) => const OtpPinInputShowcase(),
    ),

    WidgetItem(
      id: 'input_animated_dropdown',
      title: 'Animated Custom Dropdown',
      description:
          'Menu dropdown pilihan kustom dengan animasi slide expand, icon penjelas, dan status item terpilih.',
      category: WidgetCategory.inputs,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.arrow_drop_down_circle_outlined,
      tags: ['Dropdown', 'AnimatedSize', 'Custom Selector', 'Accordion'],
      usageTips:
          'Bungkus daftar opsi dalam AnimatedSize untuk mendapatkan efek ekspansi yang sangat mulus tanpa package pihak ketiga.',
      codeSnippet: '''
AnimatedSize(
  duration: const Duration(milliseconds: 250),
  curve: Curves.easeInOut,
  child: isExpanded
      ? Container(
          child: Column(
            children: items.map((e) => ListTile(title: Text(e))).toList(),
          ),
        )
      : const SizedBox.shrink(),
)''',
      previewBuilder: (context) => const AnimatedDropdownShowcase(),
    ),

    WidgetItem(
      id: 'input_gradient_slider',
      title: 'Gradient Track Slider',
      description:
          'Slider kustom dengan active track gradient multi-warna menggunakan kustom SliderTrackShape.',
      category: WidgetCategory.inputs,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.tune_rounded,
      tags: ['Slider', 'SliderTrackShape', 'SweepGradient', 'Custom Paint'],
      usageTips:
          'Implementasikan subclass dari SliderTrackShape dan buat shader gradient pada method paint().',
      codeSnippet: '''
class _GradientSliderTrackShape extends SliderTrackShape {
  final List<Color> colors;
  _GradientSliderTrackShape({required this.colors});

  @override
  void paint(PaintingContext context, Offset offset, /* ... */) {
    final gradient = LinearGradient(colors: colors);
    final activePaint = Paint()..shader = gradient.createShader(trackRect);
    context.canvas.drawRRect(activeRRect, activePaint);
  }
}''',
      previewBuilder: (context) => const GradientSliderShowcase(),
    ),

    // ------------------- CARDS -------------------
    WidgetItem(
      id: 'card_glassmorphism',
      title: 'Glassmorphism Frosted Card',
      description:
          'Kartu efek kaca buram (*frosted glass*) dengan BackdropFilter blur, border bercahaya, dan gradien latar belakang.',
      category: WidgetCategory.cards,
      difficulty: WidgetDifficulty.beginner,
      icon: Icons.blur_on_rounded,
      tags: ['Glassmorphism', 'BackdropFilter', 'Frosted Glass', 'UI Design'],
      usageTips:
          'Selalu bungkus BackdropFilter dalam ClipRRect agar efek blur tidak bocor ke luar kartu.',
      codeSnippet: '''
ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: /* Content */,
    ),
  ),
)''',
      previewBuilder: (context) => const GlassmorphicCardShowcase(),
    ),

    WidgetItem(
      id: 'card_accordion',
      title: 'Expandable Accordion Card',
      description:
          'Kartu FAQ / Accordion lipat interaktif dengan animasi rotasi chevron dan CrossFade transisi konten.',
      category: WidgetCategory.cards,
      difficulty: WidgetDifficulty.beginner,
      icon: Icons.unfold_more_rounded,
      tags: ['Accordion', 'Expandable', 'AnimatedCrossFade', 'FAQ Card'],
      usageTips:
          'AnimatedCrossFade memberikan transisi perubahan tinggi otomatis yang bersih saat kartu dibuka.',
      codeSnippet: '''
AnimatedCrossFade(
  firstChild: const SizedBox(width: double.infinity),
  secondChild: Padding(padding: EdgeInsets.only(top: 14), child: content),
  crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
  duration: const Duration(milliseconds: 250),
)''',
      previewBuilder: (context) => const ExpandableAccordionShowcase(),
    ),

    WidgetItem(
      id: 'card_ticket_pass',
      title: 'Boarding Pass & Ticket Card',
      description:
          'Kartu tiket penerbangan / event dengan notch lekukan setengah lingkaran di sisi kiri-kanan serta garis putus-putus.',
      category: WidgetCategory.cards,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.confirmation_number_outlined,
      tags: ['Ticket', 'Boarding Pass', 'Dotted Line', 'Cutout Notch'],
      usageTips:
          'Gunakan border radius pada container setengah lingkaran untuk membentuk lubang sobekan tiket.',
      codeSnippet: '''
Row(
  children: [
    Container(
      width: 14,
      height: 28,
      decoration: BoxDecoration(
        color: scaffoldBgColor,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(14)),
      ),
    ),
    Expanded(child: LayoutBuilder(/* Dashed Line Generator */)),
    Container(
      width: 14,
      height: 28,
      decoration: BoxDecoration(
        color: scaffoldBgColor,
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
      ),
    ),
  ],
)''',
      previewBuilder: (context) => const TicketPassCardShowcase(),
    ),

    WidgetItem(
      id: 'card_flip_3d',
      title: '3D Flip Card Animation',
      description:
          'Kartu bolak-balik 3D interaktif dengan efek perspektif Transform Matrix4 saat disentuh.',
      category: WidgetCategory.cards,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.flip_camera_android_rounded,
      tags: ['3D Animation', 'Matrix4', 'Perspective', 'Card Flip'],
      usageTips:
          'Gunakan setEntry(3, 2, 0.001) pada Matrix4 untuk memberikan kedalaman perspektif 3D yang realistis.',
      codeSnippet: '''
Transform(
  transform: Matrix4.identity()
    ..setEntry(3, 2, 0.001) // 3D Perspective
    ..rotateY(animation.value * math.pi),
  alignment: Alignment.center,
  child: isUnder
      ? Transform(transform: Matrix4.identity()..rotateY(math.pi), child: backWidget)
      : frontWidget,
)''',
      previewBuilder: (context) => const FlipCardShowcase(),
    ),

    // ------------------- NAVIGATION -------------------
    WidgetItem(
      id: 'nav_floating_pill',
      title: 'Floating Pill Bottom NavBar',
      description:
          'Bottom navigation bar melayang berbentuk kapsul modern dengan animasi label ekspansi pada tab yang aktif.',
      category: WidgetCategory.navigation,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.navigation_rounded,
      tags: ['NavBar', 'Floating Pill', 'AnimatedContainer', 'Tab Navigation'],
      usageTips:
          'Tempatkan di dalam Stack di atas konten utama dengan alignment Alignment.bottomCenter.',
      codeSnippet: '''
AnimatedContainer(
  duration: const Duration(milliseconds: 250),
  padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 12, vertical: 8),
  decoration: BoxDecoration(
    color: isSelected ? activeColor : Colors.transparent,
    borderRadius: BorderRadius.circular(24),
  ),
  child: Row(
    children: [
      Icon(icon, color: Colors.white),
      if (isSelected) Text(label, style: const TextStyle(color: Colors.white)),
    ],
  ),
)''',
      previewBuilder: (context) => const FloatingPillNavBarShowcase(),
    ),

    WidgetItem(
      id: 'nav_glass_appbar',
      title: 'Glassmorphic Floating AppBar',
      description:
          'AppBar transparan bergaya kaca buram (*frosted glass*) melayang di atas konten daftar yang dapat di-scroll.',
      category: WidgetCategory.navigation,
      difficulty: WidgetDifficulty.beginner,
      icon: Icons.view_headline_rounded,
      tags: ['AppBar', 'Glassmorphism', 'BackdropFilter', 'Header'],
      usageTips:
          'Gunakan Padding bagian atas pada ListView agar konten pertama tidak tertutup AppBar.',
      codeSnippet: '''
BackdropFilter(
  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    color: Colors.white.withValues(alpha: 0.25),
    child: Row(/* Header items */),
  ),
)''',
      previewBuilder: (context) => const GlassAppBarShowcase(),
    ),

    WidgetItem(
      id: 'nav_sliding_tab',
      title: 'Sliding Segmented Tab Bar',
      description:
          'Segmented control / tab bar dengan indikator pill putih yang meluncur mulus mengikuti tab pilihan.',
      category: WidgetCategory.navigation,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.tab_rounded,
      tags: ['Segmented Control', 'Tab Bar', 'AnimatedPositioned', 'Slider'],
      usageTips:
          'Hitung posisi `left: selectedIndex * tabWidth` dalam Stack dengan AnimatedPositioned.',
      codeSnippet: '''
AnimatedPositioned(
  duration: const Duration(milliseconds: 250),
  curve: Curves.easeInOutCubic,
  left: selectedIndex * tabWidth,
  width: tabWidth,
  child: Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
    ),
  ),
)''',
      previewBuilder: (context) => const SlidingSegmentedTabShowcase(),
    ),

    // ------------------- DIALOGS & SHEETS -------------------
    WidgetItem(
      id: 'dialog_animated_status',
      title: 'Animated Pop-In Status Modal',
      description:
          'Modal dialog konfirmasi dengan animasi scale bouncing dan visual icon status (Success, Error, Warning).',
      category: WidgetCategory.dialogs,
      difficulty: WidgetDifficulty.beginner,
      icon: Icons.chat_bubble_outline_rounded,
      tags: ['Dialog', 'Modal', 'ScaleTransition', 'Status Alert'],
      usageTips:
          'Gunakan showGeneralDialog dan atur transitionBuilder dengan ScaleTransition & Curves.easeOutBack.',
      codeSnippet: '''
showGeneralDialog(
  context: context,
  transitionDuration: const Duration(milliseconds: 300),
  transitionBuilder: (context, anim1, anim2, child) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
      child: FadeTransition(opacity: anim1, child: child),
    );
  },
  pageBuilder: (context, _, __) => const StatusModalDialog(/* ... */),
);''',
      previewBuilder: (context) => const AnimatedStatusDialogShowcase(),
    ),

    WidgetItem(
      id: 'sheet_modern_action',
      title: 'Modern Draggable BottomSheet',
      description:
          'Bottom sheet modern dengan drag pill handle, border melengkung besar, dan menu aksi berikon.',
      category: WidgetCategory.dialogs,
      difficulty: WidgetDifficulty.beginner,
      icon: Icons.vertical_align_top_rounded,
      tags: ['BottomSheet', 'ModalSheet', 'ActionSheet', 'Modern UI'],
      usageTips:
          'Atur backgroundColor: Colors.transparent pada showModalBottomSheet agar border radius atas terlihat rapi.',
      codeSnippet: '''
showModalBottomSheet(
  context: context,
  backgroundColor: Colors.transparent,
  builder: (context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    child: /* Sheet content */,
  ),
);''',
      previewBuilder: (context) => const ModernBottomSheetShowcase(),
    ),

    WidgetItem(
      id: 'dialog_floating_toast',
      title: 'Glowing Floating Toast Bar',
      description:
          'Notifikasi toast kustom melayang dengan aksen border glow, icon penjelas, dan tombol dismiss.',
      category: WidgetCategory.dialogs,
      difficulty: WidgetDifficulty.beginner,
      icon: Icons.notifications_active_outlined,
      tags: ['Toast', 'SnackBar', 'Floating Notification', 'Alert'],
      usageTips:
          'Gunakan SnackBarBehavior.floating dengan margin horizontal dan background transparent.',
      codeSnippet: '''
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    behavior: SnackBarBehavior.floating,
    content: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withValues(alpha: 0.5), width: 1.5),
      ),
      child: /* Toast row */,
    ),
  ),
);''',
      previewBuilder: (context) => const FloatingToastShowcase(),
    ),

    // ------------------- LOADERS -------------------
    WidgetItem(
      id: 'loader_skeleton_shimmer',
      title: 'Skeleton Shimmer Loader',
      description:
          'Animasi skeleton shimmer berkilau murni Flutter tanpa dependency eksternal untuk placeholder loading.',
      category: WidgetCategory.loaders,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.view_sidebar_rounded,
      tags: ['Shimmer', 'Skeleton Loading', 'ShaderMask', 'LinearGradient'],
      usageTips:
          'Gunakan ShaderMask dengan LinearGradient bergerak untuk efek kilauan cahaya halus.',
      codeSnippet: '''
ShaderMask(
  blendMode: BlendMode.srcATop,
  shaderCallback: (bounds) {
    return LinearGradient(
      colors: [baseColor, highlightColor, baseColor],
      stops: [
        (_controller.value - 0.3).clamp(0.0, 1.0),
        _controller.value.clamp(0.0, 1.0),
        (_controller.value + 0.3).clamp(0.0, 1.0),
      ],
    ).createShader(bounds);
  },
  child: child,
)''',
      previewBuilder: (context) => const SkeletonShimmerShowcase(),
    ),

    WidgetItem(
      id: 'loader_pulsing_spinner',
      title: 'Pulsing Dot & Radar Wave',
      description:
          'Spinner animasi ombak titik (*dot wave*) dan gelombang radar melingkar (*radar pulse*) yang memukau.',
      category: WidgetCategory.loaders,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.grain_rounded,
      tags: ['Pulse', 'Wave Animation', 'Sinusoidal', 'Spinner'],
      usageTips:
          'Gunakan fungsi math.sin dengan fase delay berbeda pada tiap dot untuk menghasilkan efek ombak.',
      codeSnippet: '''
final delay = index * 0.2;
final progress = (_controller.value - delay) % 1.0;
final sinVal = math.sin(progress * math.pi);
final bounceOffset = (sinVal > 0 ? sinVal : 0.0) * 12;
Transform.translate(offset: Offset(0, -bounceOffset), child: DotWidget());''',
      previewBuilder: (context) => const PulsingDotSpinnerShowcase(),
    ),

    WidgetItem(
      id: 'loader_circular_gradient',
      title: 'Circular Gradient Progress Bar',
      description:
          'Progress bar melingkar kustom dengan garis lengkung gradien halus dibuat menggunakan CustomPainter.',
      category: WidgetCategory.loaders,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.donut_large_rounded,
      tags: ['CustomPainter', 'Progress Bar', 'SweepGradient', 'Arc'],
      usageTips:
          'Gunakan canvas.drawArc dengan SweepGradient shader dan strokeCap: StrokeCap.round.',
      codeSnippet: '''
final rect = Rect.fromCircle(center: center, radius: radius);
final progressPaint = Paint()
  ..shader = gradient.createShader(rect)
  ..strokeWidth = strokeWidth
  ..strokeCap = StrokeCap.round
  ..style = PaintingStyle.stroke;

canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, progressPaint);''',
      previewBuilder: (context) => const CircularGradientProgressShowcase(),
    ),

    // ------------------- BADGES & CHIPS -------------------
    WidgetItem(
      id: 'badge_pulsing_status',
      title: 'Pulsing Live Status Badge',
      description:
          'Badge indikator status (Online, Live, Standby) dengan lampu titik berkedip (*pulsing radar dot*).',
      category: WidgetCategory.badges,
      difficulty: WidgetDifficulty.beginner,
      icon: Icons.fiber_manual_record_rounded,
      tags: ['Status Badge', 'Live Indicator', 'Pulse Animation', 'Pill'],
      usageTips:
          'Sangat cocok untuk indikator status koneksi, CCTV live stream, atau server monitor.',
      codeSnippet: '''
Stack(
  alignment: Alignment.center,
  children: [
    Transform.scale(
      scale: 1.0 + (_controller.value * 0.8),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: (1.0 - _controller.value) * 0.6),
        ),
      ),
    ),
    Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
  ],
)''',
      previewBuilder: (context) => const StatusPillBadgeShowcase(),
    ),

    WidgetItem(
      id: 'badge_tag_selector',
      title: 'Dynamic Tag Chip Selector',
      description:
          'Kumpulan tag / filter chips multi-select dengan highlight warna aksen dan animasi centang aktif.',
      category: WidgetCategory.badges,
      difficulty: WidgetDifficulty.beginner,
      icon: Icons.label_rounded,
      tags: ['FilterChip', 'Tag Selector', 'Multi-Select', 'Chips'],
      usageTips:
          'Gunakan Set<String> untuk mengelola state tag yang dipilih secara efisien.',
      codeSnippet: '''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: tags.map((tag) {
    final isSelected = selectedTags.contains(tag);
    return FilterTagChip(label: tag, isSelected: isSelected, onSelected: (val) {/* ... */});
  }).toList(),
)''',
      previewBuilder: (context) => const TagChipSelectorShowcase(),
    ),

    // ------------------- ANIMATIONS -------------------
    WidgetItem(
      id: 'anim_rating_reaction',
      title: 'Interactive Rating with Emoji Reactions',
      description:
          'Komponen rating bintang interaktif 1-5 dengan perubahan reaksi emoji dinamis dan animasi scale.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.beginner,
      icon: Icons.star_rate_rounded,
      tags: ['Rating Bar', 'Emoji Reaction', 'Feedback', 'Interactive'],
      usageTips:
          'Kombinasikan AnimatedSwitcher dengan ScaleTransition untuk transisi pergantian emoji yang hidup.',
      codeSnippet: '''
AnimatedSwitcher(
  duration: const Duration(milliseconds: 300),
  transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
  child: Text(feeling['emoji']!, key: ValueKey('emoji_\$rating'), style: const TextStyle(fontSize: 48)),
)''',
      previewBuilder: (context) => const InteractiveRatingShowcase(),
    ),

    WidgetItem(
      id: 'anim_swipeable_dismiss',
      title: 'Swipeable Action List Item',
      description:
          'Item daftar yang dapat digeser kiri/kanan untuk aksi cepat seperti Archive (hijau) atau Delete (merah).',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.swipe_rounded,
      tags: ['Dismissible', 'Swipe Action', 'List Item', 'Delete/Archive'],
      usageTips:
          'Gunakan properti background dan secondaryBackground pada widget bawaan Dismissible.',
      codeSnippet: '''
Dismissible(
  key: Key(item.id),
  background: Container(color: Colors.green, child: Icon(Icons.archive)),
  secondaryBackground: Container(color: Colors.red, child: Icon(Icons.delete)),
  onDismissed: (direction) {
    // Handle action
  },
  child: ListTile(title: Text(item.title)),
)''',
      previewBuilder: (context) => const SwipeableActionItemShowcase(),
    ),

    // ------------------- BATCH 1 NEW WIDGETS -------------------
    WidgetItem(
      id: 'input_day_night_switch',
      title: 'Day & Night Theme Switch',
      description:
          'Switch toggle tema siang/malam dengan transisi animasi langit, matahari berputar, bulan kawah, dan bintang berkelip.',
      category: WidgetCategory.inputs,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.nightlight_round,
      tags: ['Day Night Switch', 'Theme Toggle', 'Animation', 'Custom Design'],
      usageTips:
          'Gunakan Color.lerp untuk transisi warna langit dan RadialGradient untuk efek cahaya bulan dan matahari.',
      codeSnippet: '''
DayNightSwitch(
  isNight: isNight,
  onChanged: (val) {
    setState(() => isNight = val);
  },
)''',
      previewBuilder: (context) => const DayNightSwitchShowcase(),
    ),

    WidgetItem(
      id: 'anim_rolling_counter',
      title: 'Animated Rolling Counter (Odometer)',
      description:
          'Penghitung angka saldo/metrik yang bergulir naik dan turun seperti mesin odometer mekanik klasik.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.pin_invoke_rounded,
      tags: ['Odometer', 'Rolling Digits', 'Currency Counter', 'Transform'],
      usageTips:
          'Bagi setiap digit angka dan gunakan Stack vertikal dengan Transform.translate untuk animasi gulir angka 0-9.',
      codeSnippet: '''
AnimatedRollingCounter(
  value: currentBalance,
  textStyle: const TextStyle(
    color: Colors.white,
    fontSize: 32,
    fontWeight: FontWeight.bold,
  ),
)''',
      previewBuilder: (context) => const AnimatedRollingCounterShowcase(),
    ),

    WidgetItem(
      id: 'card_holographic_3d',
      title: '3D Holographic Foil Card',
      description:
          'Kartu kredit platinum interaktif dengan pantulan cahaya pelangi (*holographic rainbow shimmer*) dan efek kemiringan 3D saat disentuh.',
      category: WidgetCategory.cards,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.style_rounded,
      tags: ['Holographic', '3D Card', 'Matrix4', 'Rainbow Foil'],
      usageTips:
          'Gunakan GestureDetector onPanUpdate untuk mengatur sudut Matrix4 rotateX/rotateY dan gradien lapisan foil.',
      codeSnippet: '''
Transform(
  transform: Matrix4.identity()
    ..setEntry(3, 2, 0.002) // 3D Perspective
    ..rotateX(rotateX)
    ..rotateY(rotateY),
  child: Container(
    child: Stack(
      children: [
        // Rainbow foil layer with shifting alignment
        Opacity(opacity: 0.35, child: RainbowGradientOverlay()),
        // Card content
      ],
    ),
  ),
)''',
      previewBuilder: (context) => const HolographicCardShowcase(),
    ),

    WidgetItem(
      id: 'btn_confetti_burst',
      title: 'Confetti Particle Burst Button',
      description:
          'Tombol aksi reward/selesai yang meletuskan ledakan partikel kembang api / confetti warna-warni 360° menggunakan simulasi fisika murni.',
      category: WidgetCategory.buttons,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.celebration_rounded,
      tags: ['Confetti', 'Particle Physics', 'CustomPainter', 'Burst'],
      usageTips:
          'Gunakan CustomPainter dengan perhitungan gravitasi (y + acceleration) dan rotasi partikel selama progress animasi.',
      codeSnippet: '''
ConfettiBurstButton(
  text: 'Claim 5,000 XP Reward ',
  gradient: const LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
  ),
  onBurst: () {
    // Action reward
  },
)''',
      previewBuilder: (context) => const ConfettiBurstButtonShowcase(),
    ),

    WidgetItem(
      id: 'anim_sparkline_chart',
      title: 'Mini Sparkline Trend Chart',
      description:
          'Grafik garis tren statistik mini (naik/turun) dengan kurva Bezier halus, gradien area bawah, dan titik indikator akhir.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.show_chart_rounded,
      tags: ['Sparkline', 'Chart', 'Bezier Curve', 'CustomPainter'],
      usageTips:
          'Gunakan path.cubicTo untuk membentuk kurva data yang mulus dan ShaderMask/LinearGradient untuk arsiran gradien di bawah garis.',
      codeSnippet: '''
MiniSparklineChart(
  data: [42.0, 43.5, 41.2, 45.0, 48.2, 52.4, 55.8, 62.0],
  lineColor: const Color(0xFF10B981),
  gradientColor: const Color(0xFF10B981).withValues(alpha: 0.25),
)''',
      previewBuilder: (context) => const MiniSparklineChartShowcase(),
    ),

    // ------------------- BATCH 2 NEW WIDGETS -------------------
    WidgetItem(
      id: 'card_scratch_voucher',
      title: 'Scratch-to-Reveal Voucher Card',
      description:
          'Kartu kupon gosok interaktif di mana pengguna menggosok layar dengan jari untuk mengikis lapisan perak dan memunculkan kode diskon.',
      category: WidgetCategory.cards,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.card_giftcard_rounded,
      tags: ['Scratch Card', 'Coupon', 'CustomPainter', 'BlendMode.clear'],
      usageTips:
          'Gunakan canvas.saveLayer dan Paint dengan BlendMode.clear untuk menghapus piksel lapisan foil saat digosok.',
      codeSnippet: '''
// Scratch painter using BlendMode.clear
final clearPaint = Paint()
  ..blendMode = BlendMode.clear
  ..strokeCap = StrokeCap.round
  ..strokeWidth = 32;

for (int i = 0; i < points.length - 1; i++) {
  if (points[i] != null && points[i + 1] != null) {
    canvas.drawLine(points[i]!, points[i + 1]!, clearPaint);
  }
}''',
      previewBuilder: (context) => const ScratchCardShowcase(),
    ),

    WidgetItem(
      id: 'card_pricing_tier',
      title: 'Modern SaaS Pricing Tier Switcher',
      description:
          'Kartu paket langganan bertingkat (Starter vs Pro) dengan switcher periode tagihan Bulanan/Tahunan dan badge "Most Popular".',
      category: WidgetCategory.cards,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.sell_rounded,
      tags: ['Pricing Tier', 'SaaS Card', 'Billing Switch', 'Subscription'],
      usageTips:
          'Bungkus toggle bulanan/tahunan dengan AnimatedContainer dan tampilkan badge diskon persentase hemat.',
      codeSnippet: '''
PricingTierCardShowcase() // Toggle Monthly/Annual with highlight tier
''',
      previewBuilder: (context) => const PricingTierCardShowcase(),
    ),

    WidgetItem(
      id: 'nav_multi_step_stepper',
      title: 'Multi-Step Checkout Stepper',
      description:
          'Indikator alur langkah horizontal interaktif (Alamat -> Pengiriman -> Pembayaran -> Selesai) dengan animasi garis pengisian dan transisi step.',
      category: WidgetCategory.navigation,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.linear_scale_rounded,
      tags: ['Stepper', 'Checkout Wizard', 'Progress Line', 'Multi-Step'],
      usageTips:
          'Gunakan AnimatedContainer pada lingkaran node dan garis penghubung untuk transisi perubahan step yang halus.',
      codeSnippet: '''
MultiStepStepperShowcase() // Animated checkout step nodes with next/previous
''',
      previewBuilder: (context) => const MultiStepStepperShowcase(),
    ),

    WidgetItem(
      id: 'badge_avatar_group_stack',
      title: 'Overlapping Avatar Group Stack',
      description:
          'Kumpulan foto avatar tim yang saling bertumpuk dengan border rapi, titik status online hijau, dan badge "+N lainnya" yang interaktif.',
      category: WidgetCategory.badges,
      difficulty: WidgetDifficulty.beginner,
      icon: Icons.groups_rounded,
      tags: ['Avatar Stack', 'Team Group', 'Online Status', 'Overlap'],
      usageTips:
          'Gunakan Stack dengan posisi Positioned(left: index * (size - overlap)) untuk menciptakan efek bertumpuk.',
      codeSnippet: '''
OverlappingAvatarStack(
  avatars: memberAvatars,
  extraCount: 2,
  radius: 18,
  overlap: 12,
)''',
      previewBuilder: (context) => const AvatarGroupStackShowcase(),
    ),

    WidgetItem(
      id: 'anim_audio_waveform',
      title: 'Audio Waveform Voice Player',
      description:
          'Visualizer gelombang audio rekaman suara dengan bar frekuensi yang berdenyut saat dimainkan, tombol play/pause, dan timestamp.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.graphic_eq_rounded,
      tags: ['Audio Waveform', 'Equalizer', 'Voice Note', 'Sine Wave'],
      usageTips:
          'Gunakan math.sin dengan fase delay yang bervariasi pada AnimationController untuk menganimasikan equalizer bar.',
      codeSnippet: '''
AudioWaveformShowcase() // Live oscillating frequency bars on play
''',
      previewBuilder: (context) => const AudioWaveformShowcase(),
    ),

    WidgetItem(
      id: 'anim_shimmer_gradient_text',
      title: 'Luxury Shimmer Gradient Text',
      description:
          'Efek teks berkilau mewah dengan gradien warna emas / neon yang bergerak halus menggunakan ShaderMask animasi.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.text_format_rounded,
      tags: ['Shimmer Text', 'ShaderMask', 'Gradient', 'Luxury Gold'],
      usageTips:
          'Gunakan ShaderMask dengan BlendMode.srcIn dan animasi LinearGradient stops untuk mengalirkan kilauan cahaya pada teks.',
      codeSnippet: '''
ShaderMask(
  blendMode: BlendMode.srcIn,
  shaderCallback: (bounds) {
    return LinearGradient(
      colors: colors,
      begin: Alignment(-2.5 + (controller.value * 5.0), -0.3),
      end: Alignment(0.5 + (controller.value * 5.0), 0.3),
      tileMode: TileMode.clamp,
    ).createShader(bounds);
  },
  child: Text('FLUTTER TITAN', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
)''',
      previewBuilder: (context) => const ShimmerGradientTextShowcase(),
    ),

    WidgetItem(
      id: 'input_digital_signature_pad',
      title: 'Digital Signature & Drawing Pad',
      description:
          'Papan tanda tangan digital dan canvas gambar modal popup (Dialog & Bottom Sheet) bebas hambatan gestur tab, dengan multi-warna tinta, pengatur ketebalan, mode eraser, undo/redo, serta verifikasi simpan.',
      category: WidgetCategory.inputs,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.draw_rounded,
      tags: [
        'Signature',
        'Drawing Pad',
        'CustomPainter',
        'Modal Dialog',
        'Bottom Sheet',
        'Undo/Redo',
      ],
      usageTips:
          'Sangat disarankan membuka canvas tanda tangan di dalam Dialog Modal atau Bottom Sheet agar gestur touch drag tidak bentrok dengan horizontal scroll TabBar atau vertical scroll page.',
      codeSnippet: '''
// 1. Membuka Canvas Tanda Tangan via Modal Dialog / Bottom Sheet
final strokes = await showDialog<List<DrawnStroke>>(
  context: context,
  builder: (context) => const SignatureDialogModal(),
);

// 2. CustomPainter untuk render stroke halus (Bézier Curve)
class SignaturePainter extends CustomPainter {
  final List<DrawnStroke> strokes;
  SignaturePainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    for (var stroke in strokes) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.width
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      final path = Path()..moveTo(stroke.points.first.dx, stroke.points.first.dy);
      for (int i = 0; i < stroke.points.length - 1; i++) {
        final p0 = stroke.points[i];
        final p1 = stroke.points[i + 1];
        path.quadraticBezierTo(p0.dx, p0.dy, (p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}''',
      previewBuilder: (context) => const SignatureDrawingPadShowcase(),
    ),

    // ------------------- OPTION A: VISUAL & MEDIA -------------------
    WidgetItem(
      id: 'anim_before_after_slider',
      title: 'Before / After Comparison Slider',
      description:
          'Slider pembanding visual Sebelum vs Sesudah dengan drag divider lentur, mode auto-scan, dan pemilih preset tema komparasi.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.compare_rounded,
      tags: [
        'Before After',
        'Comparison Lens',
        'ClipRect',
        'Drag Slider',
        'Image Diff',
      ],
      usageTips:
          'Gunakan ClipRect dengan CustomClipper<Rect> berbasis koordinat horizontal pan drag untuk membelah dua layer tampilan secara presisi.',
      codeSnippet: '''
Stack(
  children: [
    // 1. Layer Sebelum (Full Background)
    BeforeImageLayer(),
    
    // 2. Layer Sesudah (Dipotong ClipRect)
    ClipRect(
      clipper: HorizontalSplitClipper(splitPosition: sliderPosition),
      child: AfterImageLayer(),
    ),
    
    // 3. Draggable Divider Line & Thumb
    Positioned(
      left: width * sliderPosition - 1.5,
      child: DividerLineHandle(),
    ),
  ],
)''',
      previewBuilder: (context) => const BeforeAfterSliderShowcase(),
    ),

    WidgetItem(
      id: 'badge_story_avatar_ring',
      title: 'Story Status Avatar with Animated Ring',
      description:
          'Avatar status bergaya Instagram/TikTok Story dengan cincin gradien berputar (SweepGradient), badge LIVE berdenyut, dan modal Story Viewer interaktif.',
      category: WidgetCategory.badges,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.donut_large_rounded,
      tags: [
        'Story Ring',
        'Avatar',
        'SweepGradient',
        'RotationTransition',
        'Story Viewer',
      ],
      usageTips:
          'Gunakan RotationTransition yang membungkus SweepGradient border untuk animasi putaran cincin gradien halus tanpa frame lag.',
      codeSnippet: '''
RotationTransition(
  turns: rotateController,
  child: Container(
    width: 72,
    height: 72,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      gradient: SweepGradient(
        colors: [Color(0xFFF59E0B), Color(0xFFEC4899), Color(0xFF8B5CF6), Color(0xFFF59E0B)],
      ),
    ),
  ),
)''',
      previewBuilder: (context) => const StoryAvatarRingShowcase(),
    ),

    WidgetItem(
      id: 'anim_pinch_zoom_viewer',
      title: 'Pinch-to-Zoom & Pan Image Viewer',
      description:
          'Kontrol zoom multi-touch (Pinch) dan geser (Pan) dengan InteractiveViewer, animasi double-tap quick zoom, rotasi 90°, pembaca skala dinamis, dan inersia lentur.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.zoom_in_rounded,
      tags: [
        'InteractiveViewer',
        'Pinch to Zoom',
        'Pan Gesture',
        'Matrix4',
        'Double Tap Zoom',
      ],
      usageTips:
          'Kombinasikan TransformationController dengan Matrix4Tween pada AnimationController untuk transisi animasi zoom dan reset center yang mulus.',
      codeSnippet: '''
GestureDetector(
  onDoubleTapDown: (details) => zoomToPosition(details.localPosition),
  child: InteractiveViewer(
    transformationController: transformController,
    minScale: 0.8,
    maxScale: 4.5,
    boundaryMargin: const EdgeInsets.all(80),
    child: HighDetailGraphicCanvas(),
  ),
)''',
      previewBuilder: (context) => const PinchZoomViewerShowcase(),
    ),

    // ------------------- OPTION B: GAMIFICATION & GAUGES -------------------
    WidgetItem(
      id: 'anim_spin_lucky_wheel',
      title: 'Spin the Lucky Wheel (Roda Putar)',
      description:
          'Roda putar berhadiah interaktif dengan segmen CustomPainter, animasi deselerasi fisika, jarum penunjuk, dan dialog popup pemenang.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.donut_small_rounded,
      tags: [
        'Lucky Wheel',
        'Spin Wheel',
        'Gamification',
        'CustomPainter',
        'Deceleration',
      ],
      usageTips:
          'Gunakan Tween<double> dengan CurvedAnimation(curve: Curves.easeOutQuart) untuk menghasilkan efek putaran roda yang melambat secara alami.',
      codeSnippet: '''
AnimatedBuilder(
  animation: controller,
  builder: (context, child) {
    return Transform.rotate(
      angle: animation.value,
      child: CustomPaint(
        size: const Size(240, 240),
        painter: WheelPainter(sectors: sectors),
      ),
    );
  },
)''',
      previewBuilder: (context) => const SpinLuckyWheelShowcase(),
    ),

    WidgetItem(
      id: 'anim_radial_gauge_meter',
      title: 'Radial Speedometer & Gauge Meter',
      description:
          'Indikator busur gauge multi-zona (Eco/Green, Dynamic/Cyan, Sport+/Red) dengan jarum penunjuk beranimasi, mode auto-cruise, dan pembaca digital.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.speed_rounded,
      tags: [
        'Speedometer',
        'Radial Gauge',
        'SweepGradient',
        'Animated Needle',
        'CustomPainter',
      ],
      usageTips:
          'Gunakan SweepGradient pada lintasan busur canvas dan hitung sudut jarum dengan rumus: startAngle + (sweepAngle * progress).',
      codeSnippet: '''
CustomPaint(
  size: const Size(250, 180),
  painter: RadialGaugePainter(value: currentSpeed),
)''',
      previewBuilder: (context) => const RadialGaugeMeterShowcase(),
    ),

    WidgetItem(
      id: 'anim_retro_flip_clock',
      title: 'Retro Flip Clock & Countdown Timer',
      description:
          'Tampilan jam mekanik 3D retro split-flap dengan mode Live Real-Time Clock, Flash Sale Countdown, dan animasi lipatan kartu per detik.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.flip_camera_android_rounded,
      tags: [
        'Flip Clock',
        'Countdown Timer',
        'Split Flap',
        '3D Transform',
        'Matrix4',
      ],
      usageTips:
          'Gunakan Transform dengan Matrix4.identity()..setEntry(3, 2, 0.003)..rotateX(angle) untuk efek perspektif lipatan kartu 3D yang realistis.',
      codeSnippet: '''
Transform(
  alignment: Alignment.center,
  transform: Matrix4.identity()
    ..setEntry(3, 2, 0.003)
    ..rotateX(flipAngle),
  child: FlipDigitCard(digit: currentDigit),
)''',
      previewBuilder: (context) => const RetroFlipClockShowcase(),
    ),

    // ------------------- BATCH BASIC 1: FORM & SECURITY -------------------
    WidgetItem(
      id: 'input_animated_checkbox_radio',
      title: 'Animated Checkbox & Radio Tile',
      description:
          'Checkbox kustom persegi, bulat, indeterminate, dan kartu radio seleksi metode pembayaran dengan transisi centang beranimasi.',
      category: WidgetCategory.inputs,
      difficulty: WidgetDifficulty.beginner,
      icon: Icons.check_box_rounded,
      tags: [
        'Checkbox',
        'Radio Button',
        'Selection Tile',
        'AnimatedContainer',
        'Forms',
      ],
      usageTips:
          'Gunakan AnimatedContainer dengan border dan shape dinamis untuk transisi state seleksi yang smooth dan responsif.',
      codeSnippet: '''
AnimatedContainer(
  duration: const Duration(milliseconds: 200),
  width: 22,
  height: 22,
  decoration: BoxDecoration(
    color: isChecked ? activeColor : Colors.transparent,
    shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
    borderRadius: isCircular ? null : BorderRadius.circular(6),
    border: Border.all(color: isChecked ? activeColor : Colors.grey.shade400, width: 2),
  ),
  child: isChecked ? const Icon(Icons.check_rounded, size: 14, color: Colors.white) : null,
)''',
      previewBuilder: (context) => const AnimatedCheckboxRadioShowcase(),
    ),

    WidgetItem(
      id: 'input_password_strength_meter',
      title: 'Password Strength Meter & Checklist',
      description:
          'Input password dengan bar kekuatan 4 segmen berwarna (Lemah s/d Sangat Kuat), checklist kriteria keamanan live, dan generator password acak.',
      category: WidgetCategory.inputs,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.password_rounded,
      tags: [
        'Password',
        'Strength Meter',
        'Validation',
        'Checklist',
        'Security',
      ],
      usageTips:
          'Validasi string password secara real-time dengan RegExp (huruf besar, kecil, angka, simbol) dan perbarui indikator bar segmen.',
      codeSnippet: '''
// Validasi RegExp
final hasMinLength = text.length >= 8;
final hasUppercase = text.contains(RegExp(r'[A-Z]'));
final hasNumber = text.contains(RegExp(r'[0-9]'));
final hasSpecialChar = text.contains(RegExp(r'[!@#\\\$%^&*]'));

// 4-Segment Strength Bar
Row(
  children: List.generate(4, (index) => Expanded(
    child: Container(
      margin: const EdgeInsets.only(right: 4),
      height: 5,
      color: index < strengthScore ? strengthColor : Colors.grey.shade200,
    ),
  )),
)''',
      previewBuilder: (context) => const PasswordStrengthMeterShowcase(),
    ),

    WidgetItem(
      id: 'input_credit_card_formatter',
      title: 'Credit Card Input & Live Preview',
      description:
          'Input kartu kredit dengan spasi otomatis tiap 4 digit, deteksi otomatis logo penerbit (Visa/Mastercard/BCA/JCB), format MM/YY, dan Live Virtual Card.',
      category: WidgetCategory.inputs,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.credit_card_rounded,
      tags: [
        'Credit Card',
        'TextInputFormatter',
        'Card Brand Detection',
        'Virtual Card',
        'Payment Form',
      ],
      usageTips:
          'Implementasikan TextInputFormatter khusus untuk menyisipkan spasi pada kelipatan 4 digit angka dan garis miring pada tanggal kedaluwarsa.',
      codeSnippet: '''
TextField(
  keyboardType: TextInputType.number,
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(16),
    CardNumberInputFormatter(), // Menyisipkan spasi tiap 4 digit
  ],
)''',
      previewBuilder: (context) => const CreditCardInputShowcase(),
    ),

    // ------------------- BATCH BASIC 2: FEEDBACK & LAYOUT -------------------
    WidgetItem(
      id: 'card_empty_state_placeholder',
      title: 'Illustrative Empty State Card',
      description:
          'Tampilan state kosong ilustratif (Keranjang Kosong, Offline/No Internet, Not Found, No Orders) dengan aura bercahaya dan tombol Call-to-Action.',
      category: WidgetCategory.cards,
      difficulty: WidgetDifficulty.beginner,
      icon: Icons.inbox_rounded,
      tags: [
        'Empty State',
        'Placeholder',
        'Error State',
        'Illustration',
        'CTA',
      ],
      usageTips:
          'Gunakan AnimatedSwitcher untuk transisi halus antar preset state kosong saat pengguna beralih konteks/tab.',
      codeSnippet: '''
AnimatedSwitcher(
  duration: const Duration(milliseconds: 300),
  child: Column(
    children: [
      IconAuraContainer(icon: preset.icon, color: preset.color),
      Text(preset.title, style: TextStyle(fontWeight: FontWeight.bold)),
      Text(preset.description),
      ActionButton(label: preset.buttonLabel),
    ],
  ),
)''',
      previewBuilder: (context) => const EmptyStateCardShowcase(),
    ),

    WidgetItem(
      id: 'loader_striped_linear_progress',
      title: 'Striped Linear Progress & Storage Bar',
      description:
          'Progress bar garis diagonal zebra beranimasi mengalir (barber shop), bar multi-segment penyimpanan perangkat, dan milestone bertahap.',
      category: WidgetCategory.loaders,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.horizontal_split_rounded,
      tags: [
        'Progress Bar',
        'Striped Animation',
        'CustomPainter',
        'Segmented Bar',
        'Step Progress',
      ],
      usageTips:
          'Gambar garis strip diagonal miring dengan CustomPainter menggunakan Path berulang yang digeser berdasarkan animationOffset controller.',
      codeSnippet: '''
CustomPaint(
  size: Size.infinite,
  painter: StripedProgressPainter(
    progress: progressValue,
    animationOffset: stripeController.value,
    primaryColor: Color(0xFF6366F1),
    secondaryColor: Color(0xFF818CF8),
  ),
)''',
      previewBuilder: (context) => const StripedLinearProgressShowcase(),
    ),

    WidgetItem(
      id: 'badge_bouncing_notification_bell',
      title: 'Bouncing Bell & Notification Counter',
      description:
          'Lonceng notifikasi dengan animasi dering goyang (ringing wobble), badge angka merah membal (bounce scale), dan live stream simulasi notifikasi.',
      category: WidgetCategory.badges,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.notifications_active_rounded,
      tags: [
        'Notification Bell',
        'Badge Counter',
        'Shake Animation',
        'Elastic Bounce',
        'Live Stream',
      ],
      usageTips:
          'Kombinasikan Transform.rotate dengan fungsi sinus untuk efek goyangan lonceng dan ScaleTransition kurva elasticOut untuk badge membal.',
      codeSnippet: '''
Stack(
  clipBehavior: Clip.none,
  children: [
    // Ringing Bell
    Transform.rotate(
      angle: sin(shakeController.value * pi * 6) * 0.25,
      child: Icon(Icons.notifications_rounded),
    ),
    // Bouncing Badge
    Positioned(
      top: -4, right: -4,
      child: ScaleTransition(
        scale: badgeScaleAnimation, // Curves.elasticOut
        child: BadgePill(count: unreadCount),
      ),
    ),
  ],
)''',
      previewBuilder: (context) => const BouncingNotificationBellShowcase(),
    ),

    // ------------------- OPTION 1: SECURITY & BIOMETRICS -------------------
    WidgetItem(
      id: 'input_pattern_lock_screen',
      title: 'Pattern Lock Screen (9 Titik)',
      description:
          'Papan pola kunci 9 titik interaktif dengan tarikan garis sentuh halus, pelacakan koordinat sentuh, validasi pola, dan feedback getar warna.',
      category: WidgetCategory.inputs,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.pattern_rounded,
      tags: [
        'Pattern Lock',
        'Security',
        '9-Dot Grid',
        'CustomPainter',
        'GestureDetector',
      ],
      usageTips:
          'Hitung jarak sentuhan pan drag terhadap pusat masing-masing dari 9 titik untuk mencatat urutan kunci secara real-time.',
      codeSnippet: '''
GestureDetector(
  onPanStart: (details) => startPattern(details.localPosition),
  onPanUpdate: (details) => updatePattern(details.localPosition),
  onPanEnd: (details) => validatePattern(selectedDots),
  child: CustomPaint(
    painter: PatternPainter(
      selectedDots: selectedDots,
      currentTouchPoint: currentTouchPoint,
      statusColor: statusColor,
    ),
  ),
)''',
      previewBuilder: (context) => const PatternLockShowcase(),
    ),

    WidgetItem(
      id: 'input_fingerprint_pulse_scanner',
      title: 'Fingerprint Biometric Pulse Scanner',
      description:
          'Sensor sidik jari dengan gelombang radar berpendar (pulse rings), sinar laser pemindai vertikal, interaksi tahan sentuhan, dan simulasi status.',
      category: WidgetCategory.inputs,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.fingerprint_rounded,
      tags: [
        'Biometric',
        'Fingerprint',
        'Pulse Rings',
        'Laser Scan',
        'Hold to Authenticate',
      ],
      usageTips:
          'Gunakan AnimationController hold progress untuk mengisi circular progress bar selama tombol sensor ditekan tahan.',
      codeSnippet: '''
GestureDetector(
  onTapDown: (_) => startHoldScan(),
  onTapUp: (_) => cancelHoldScan(),
  child: Stack(
    alignment: Alignment.center,
    children: [
      PulseRadarRings(progress: pulseController.value),
      CircularProgressIndicator(value: holdProgressController.value),
      FingerprintSensorButton(icon: Icons.fingerprint_rounded),
      ScanningLaserBeam(position: laserController.value),
    ],
  ),
)''',
      previewBuilder: (context) => const FingerprintScannerShowcase(),
    ),

    WidgetItem(
      id: 'input_inline_date_time_picker',
      title: 'Inline Date & Time Picker Card',
      description:
          'Pemilih tanggal kalender bulanan mini dan selector slot jam/menit (WIB) modern yang menyatu langsung di dalam card antarmuka.',
      category: WidgetCategory.inputs,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.calendar_month_rounded,
      tags: [
        'Calendar',
        'Date Picker',
        'Time Picker',
        'Inline Scheduler',
        'Booking',
      ],
      usageTips:
          'Gunakan GridView 7-kolom dengan perhitungan hari pertama bulan (weekday offset) untuk kalender bulanan yang fleksibel.',
      codeSnippet: '''
GridView.builder(
  itemCount: 35,
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
  itemBuilder: (context, index) {
    final day = index - firstWeekday + 1;
    final isSelected = date == selectedDate;
    return DayCell(day: day, isSelected: isSelected);
  },
)''',
      previewBuilder: (context) => const InlineDateTimePickerShowcase(),
    ),

    WidgetItem(
      id: 'card_perforated_voucher',
      title: 'Perforated Promo Voucher Card',
      description:
          'Kupon promo e-commerce dengan lekukan gerigi (semicircular notches), garis robek putus-putus (perforated line), copy kode voucher 1-tap, dan barcode vector.',
      category: WidgetCategory.cards,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.confirmation_number_rounded,
      tags: [
        'Voucher',
        'Coupon',
        'Perforated',
        'Discount',
        'Ticket Notch',
        'Barcode',
        'E-Commerce',
      ],
      usageTips:
          'Gunakan CustomClipper dengan arcToPoint (clockwise: false) untuk membuat lengkungan lubang potongan tiket (notch) di sisi kiri dan kanan.',
      codeSnippet: '''
ClipPath(
  clipper: PerforatedTicketClipper(notchRadius: 12, notchPositionRatio: 0.32),
  child: Container(
    color: Colors.white,
    child: Row(
      children: [
        DiscountBadge(discount: '50% OFF'),
        DashedDividerLine(),
        VoucherDetails(code: 'DISKON50K', onClaim: claimVoucher),
      ],
    ),
  ),
)''',
      previewBuilder: (context) => const PerforatedVoucherCardShowcase(),
    ),

    WidgetItem(
      id: 'btn_morphing_quantity_stepper',
      title: 'Morphing Quantity Stepper',
      description:
          'Tombol CTA "Tambah ke Keranjang" yang bermetamorfosis secara mulus menjadi tombol pengatur kuantitas [-] [qty] [+] dengan feedback transisi ukuran dan warna.',
      category: WidgetCategory.buttons,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.add_shopping_cart_rounded,
      tags: [
        'Stepper',
        'Morphing Button',
        'Counter',
        'Cart CTA',
        'Micro-interaction',
        'E-Commerce',
      ],
      usageTips:
          'Gunakan AnimatedContainer dan AnimatedSwitcher untuk mengubah bentuk tombol pill menjadi bar stepper saat quantity > 0.',
      codeSnippet: '''
AnimatedContainer(
  duration: Duration(milliseconds: 250),
  decoration: BoxDecoration(
    color: quantity > 0 ? primaryColor.withOpacity(0.1) : primaryColor,
    borderRadius: BorderRadius.circular(20),
  ),
  child: AnimatedSwitcher(
    duration: Duration(milliseconds: 200),
    child: quantity > 0
        ? Row(children: [
            IconButton(icon: Icon(Icons.remove), onPressed: decrement),
            Text('\$quantity'),
            IconButton(icon: Icon(Icons.add), onPressed: increment),
          ])
        : TextButton(onPressed: addToCart, child: Text('Tambah')),
  ),
)''',
      previewBuilder: (context) => const MorphingQuantityStepperShowcase(),
    ),

    WidgetItem(
      id: 'input_dashed_upload_dropzone',
      title: 'Dashed File Upload Dropzone',
      description:
          'Area dropzone unggah berkas/gambar beranimasi dengan border putus-putus kustom, simulasi progress pengunggahan live, dan daftar berkas terunggah.',
      category: WidgetCategory.inputs,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.cloud_upload_outlined,
      tags: [
        'Dropzone',
        'File Upload',
        'Dashed Border',
        'Progress Bar',
        'Attachment',
        'E-Commerce',
      ],
      usageTips:
          'Gunakan CustomPainter dengan Path computeMetrics extractPath untuk merender garis border putus-putus dengan lengkungan sudut (RRect) yang presisi.',
      codeSnippet: '''
CustomPaint(
  painter: DashedRRectPainter(
    color: isDragging ? activeColor : borderColor,
    strokeWidth: 1.6,
    dashWidth: 7.0,
    gap: 5.0,
    borderRadius: 20.0,
  ),
  child: DropzoneContainer(
    onTap: pickFile,
    child: Column(
      children: [
        Icon(Icons.cloud_upload_rounded),
        Text('Tarik & Lepas Berkas di Sini'),
      ],
    ),
  ),
)''',
      previewBuilder: (context) => const DashedUploadDropzoneShowcase(),
    ),

    WidgetItem(
      id: 'nav_radial_speed_dial_fab',
      title: 'Radial Speed Dial Arc FAB',
      description:
          'Tombol FAB melingkar yang mekar membentuk busur radial kuadran seperempat lingkaran dengan rotasi ikon 45°, kalkulasi trigonometri sinus/cosinus, dan animasi pegas halus.',
      category: WidgetCategory.navigation,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.speed_rounded,
      tags: [
        'FAB',
        'Speed Dial',
        'Radial Menu',
        'Arc Menu',
        'Floating Button',
        'Trigonometry',
        'Navigation',
      ],
      usageTips:
          'Gunakan rumus polar ke kartesius (dx = cos(theta) * R * progress, dy = sin(theta) * R * progress) untuk menyusun tombol sub-aksi di sepanjang busur lingkaran.',
      codeSnippet: '''
Transform.translate(
  offset: Offset(
    cos(angle) * radius * expandAnimation.value,
    sin(angle) * radius * expandAnimation.value,
  ),
  child: RadialSubActionButton(
    icon: action.icon,
    label: action.label,
    onTap: action.onTap,
  ),
)''',
      previewBuilder: (context) => const RadialSpeedDialFabShowcase(),
    ),

    WidgetItem(
      id: 'dialog_filter_bottom_sheet',
      title: 'Filter Sheet with Sticky Actions',
      description:
          'Modal bottom sheet filter e-commerce lengkap dengan sticky drag header, reset filter 1-tap, dual price range slider, multi-select chip kategori, dan sticky footer hasil live.',
      category: WidgetCategory.dialogs,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.filter_alt_rounded,
      tags: [
        'Filter',
        'Bottom Sheet',
        'Sticky Header',
        'Sticky Footer',
        'Range Slider',
        'Modal Drawer',
        'E-Commerce',
      ],
      usageTips:
          'Gunakan showModalBottomSheet dengan isScrollControlled: true dan bungkus dalam Column(Header, Expanded(ListView), StickyFooter) untuk header/footer tetap.',
      codeSnippet: '''
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  builder: (context) => FilterBottomSheet(
    onApply: (filters) => applyFilters(filters),
  ),
)''',
      previewBuilder: (context) => const FilterBottomSheetShowcase(),
    ),

    WidgetItem(
      id: 'dialog_in_app_notification_banner',
      title: 'In-App Top Notification Banner',
      description:
          'Sistem banner notifikasi atas mengambang (slide down from top) dengan timer hitung mundur auto-dismiss, gesture geser atas untuk menutup, dan tombol aksi cepat.',
      category: WidgetCategory.dialogs,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.notifications_active_rounded,
      tags: [
        'Notification',
        'Top Banner',
        'In-App Toast',
        'Auto Dismiss',
        'Slide Animation',
        'Alert',
      ],
      usageTips:
          'Padukan SlideTransition, FadeTransition, dan LinearProgressIndicator terbalik (1.0 -> 0.0) untuk membuat banner notifikasi dynamic yang menutup otomatis.',
      codeSnippet: '''
SlideTransition(
  position: slideAnimation,
  child: Container(
    margin: EdgeInsets.all(12),
    child: Column(
      children: [
        NotificationHeader(icon: icon, title: title, action: 'Balas'),
        LinearProgressIndicator(value: remainingTimerProgress),
      ],
    ),
  ),
)''',
      previewBuilder: (context) => const InAppNotificationBannerShowcase(),
    ),

    WidgetItem(
      id: 'anim_voice_note_player',
      title: 'Voice Note Waveform Player',
      description:
          'Bubble pesan suara perpesanan (audio voice note) dengan gelombang suara interaktif yang bisa di-scrubbing (drag/tap seek), playback timer, pengatur kecepatan 1.0x-2.0x, dan read receipts.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.graphic_eq_rounded,
      tags: [
        'Voice Note',
        'Audio Player',
        'Waveform',
        'Scrubbing',
        'Audio Speed',
        'Messaging',
        'Chat',
      ],
      usageTips:
          'Gunakan LayoutBuilder dan GestureDetector onTapDown/onHorizontalDragUpdate untuk mengkalkulasi fraksi posisi scrubbing relatif terhadap lebar widget waveform.',
      codeSnippet: '''
GestureDetector(
  onHorizontalDragUpdate: (details) {
    final fraction = details.localPosition.dx / constraints.maxWidth;
    seekToPosition(fraction);
  },
  child: WaveformBarList(
    amplitudes: audioAmplitudes,
    progress: currentSeconds / totalSeconds,
    activeColor: primaryColor,
  ),
)''',
      previewBuilder: (context) => const VoiceNotePlayerShowcase(),
    ),

    WidgetItem(
      id: 'anim_floating_hearts_reaction',
      title: 'Double-Tap & Floating Hearts Stream',
      description:
          'Interaksi like ala media sosial dengan efek ledakan hati besar di tengah foto saat double-tap, serta pemancar balon hati (floating hearts) yang melayang ke atas dengan pergerakan kurva sinusoidal.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.favorite_rounded,
      tags: [
        'Reaction',
        'Floating Hearts',
        'Double Tap',
        'Like Animation',
        'Particle Stream',
        'Social Media',
      ],
      usageTips:
          'Gunakan formula dx = initialX + sin(time * frequency) * amplitude untuk menghasilkan lintasan goyangan meliuk alami pada partikel hati yang naik.',
      codeSnippet: '''
GestureDetector(
  onDoubleTap: triggerBigExplodingHeart,
  child: Stack(
    children: [
      MediaImageCard(),
      ...floatingParticles.map((p) => FloatingHeart(particle: p)),
      if (showBigHeart) BigHeartScaleFade(controller: heartController),
    ],
  ),
)''',
      previewBuilder: (context) => const FloatingHeartsReactionShowcase(),
    ),

    WidgetItem(
      id: 'input_mention_hashtag_autocomplete',
      title: 'Mention & Hashtag Auto-Complete',
      description:
          'Input teks cerdas dengan deteksi realtime karakter @ (mention pengguna) dan # (tagar), floating suggestion list dengan avatar, serta parsing highlight RichText.',
      category: WidgetCategory.inputs,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.alternate_email_rounded,
      tags: [
        'Mention',
        'Hashtag',
        'Auto Complete',
        'Suggestions',
        'RichText',
        'TextField',
        'Social',
      ],
      usageTips:
          'Gunakan listener pada TextEditingController untuk mendeteksi posisi kursor terhadap karakter pemicu (@ atau #) dan tampilkan daftar rekomendasi yang relevan.',
      codeSnippet: '''
TextField(
  controller: textController,
  onChanged: (text) => checkTriggers(text, textController.selection),
),
if (showSuggestions)
  SuggestionList(
    items: matchingUsersOrHashtags,
    onSelect: (item) => insertTag(item),
  ),
''',
      previewBuilder: (context) => const MentionHashtagInputShowcase(),
    ),

    WidgetItem(
      id: 'anim_particle_fireworks_canvas',
      title: 'Particle Fireworks Celebration Canvas',
      description:
          'Simulasi kembang api partikel berbasis CustomPainter & fisika partikel realistis (luncuran roket, ledakan radial 45+ partikel, gravitasi, spark glow, dan mode pesta auto).',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.celebration_rounded,
      tags: [
        'Fireworks',
        'Canvas',
        'CustomPainter',
        'Particles',
        'Physics',
        'Celebration',
        'FX',
      ],
      usageTips:
          'Gunakan CustomPainter dengan Ticker/AnimationController untuk memperbarui posisi spark particle (vx, vy + gravity) dan memudarkan opasitas (alpha fade).',
      codeSnippet: '''
CustomPaint(
  size: Size.infinite,
  painter: FireworksCanvasPainter(
    rockets: activeRockets,
    sparks: activeSparks,
  ),
)''',
      previewBuilder: (context) => const ParticleFireworksShowcase(),
    ),

    WidgetItem(
      id: 'card_foldable_3d_origami',
      title: 'Foldable 3D Origami Paper Card',
      description:
          'Kartu lipat 3D origami 3-segmen dengan perspektif Matrix4 rotateX, simulasi bayangan pencahayaan lipatan kertas, slider derajat lipatan, dan toggle otomatis.',
      category: WidgetCategory.cards,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.layers_rounded,
      tags: [
        'Origami',
        '3D Matrix',
        'Foldable Card',
        'Perspective',
        'Paper Fold',
        'Transform',
      ],
      usageTips:
          'Terapkan Matrix4.identity()..setEntry(3, 2, 0.002)..rotateX(angle) dengan alignment bottomCenter/topCenter untuk efek lipatan engsel kertas 3D.',
      codeSnippet: '''
Transform(
  alignment: Alignment.bottomCenter,
  transform: Matrix4.identity()
    ..setEntry(3, 2, 0.002)
    ..rotateX((1.0 - foldRatio) * math.pi),
  child: OrigamiTopFlap(),
)''',
      previewBuilder: (context) => const Foldable3dOrigamiCardShowcase(),
    ),

    WidgetItem(
      id: 'anim_liquid_wave_progress',
      title: 'Fluid Liquid Wave Container',
      description:
          'Wadah cairan bergelombang sinus ganda (dual sinusoidal wave) organik dengan partikel gelembung udara mengapung, multiple shape mode (bola/kapsul/kotak), dan persentase kapasitas.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.waves_rounded,
      tags: [
        'Liquid Wave',
        'Wave Animation',
        'Sinusoidal',
        'Bubbles',
        'Progress Indicator',
        'Capacity',
      ],
      usageTips:
          'Gunakan rumus sinus y = baseY + sin(x * freq + animPhase) * amp pada CustomPainter untuk menghasilkan gelombang cairan yang mengalir dinamis.',
      codeSnippet: '''
CustomPaint(
  painter: LiquidWavePainter(
    progress: fillPercentage,
    animationValue: waveController.value,
    bubbles: bubbleParticles,
    frontColor: Color(0xFF06B6D4),
    backColor: Color(0xFF3B82F6),
  ),
)''',
      previewBuilder: (context) => const LiquidWaveProgressShowcase(),
    ),

    WidgetItem(
      id: 'anim_donut_budget_chart',
      title: 'Interactive Donut Budget Chart',
      description:
          'Diagram donat (donut chart) vektor dengan animasi sapuan rotasi masuk (sweep angle), interaksi tap irisan yang menonjol keluar (slice pop-out), dan rincian alokasi pengeluaran bulanan.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.donut_large_rounded,
      tags: [
        'Donut Chart',
        'Pie Chart',
        'Budget',
        'Finance',
        'CustomPainter',
        'Data Visualization',
        'Slice Selection',
      ],
      usageTips:
          'Gunakan rumus atan2(dy, dx) pada GestureDetector onTapDown untuk mendeteksi indeks irisan busur lingkaran yang disentuh oleh pengguna.',
      codeSnippet: '''
CustomPaint(
  size: Size(200, 200),
  painter: DonutChartPainter(
    items: budgetItems,
    sweepProgress: sweepAnimation.value,
    selectedIndex: selectedSliceIndex,
  ),
)''',
      previewBuilder: (context) => const DonutBudgetChartShowcase(),
    ),

    WidgetItem(
      id: 'anim_candlestick_crypto_chart',
      title: 'Candlestick Stock & Crypto Chart',
      description:
          'Grafik candle bar trading pasar modal/kripto (Open, High, Low, Close) dengan sumbu wicks, volume bars sub-panel, garis bidik crosshair interaktif, dan pergantian timeframe.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.candlestick_chart_rounded,
      tags: [
        'Candlestick',
        'Crypto',
        'Stock Chart',
        'Trading',
        'Crosshair',
        'Finance',
        'OHLC',
      ],
      usageTips:
          'Hitung minPrice dan maxPrice dari seluruh candle untuk menormalkan skala sumbu Y vertikal pada CustomPainter secara proporsional.',
      codeSnippet: '''
GestureDetector(
  onHorizontalDragUpdate: (details) => updateCrosshair(details.localPosition.dx),
  child: CustomPaint(
    painter: CandlestickPainter(
      candles: candleData,
      hoveredIndex: hoveredIndex,
    ),
  ),
)''',
      previewBuilder: (context) => const CandlestickChartShowcase(),
    ),

    WidgetItem(
      id: 'card_split_bill_calculator',
      title: 'Split Bill & Tip Calculator',
      description:
          'Kalkulator pintar pembagi tagihan patungan dan tip dengan visualisasi tumpukan avatar interaktif, pajak PB1, dan 1-tap bagikan rincian tagihan ke clipboard.',
      category: WidgetCategory.cards,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.receipt_long_rounded,
      tags: [
        'Split Bill',
        'Tip Calculator',
        'Finance',
        'Dining',
        'Avatar Stack',
        'Bill Sharing',
      ],
      usageTips:
          'Padukan stepper jumlah orang dengan Transform.translate untuk membuat tumpukan avatar pembagi tagihan yang ekspansif secara dinamis.',
      codeSnippet: '''
int tipAmount = (billAmount * tipPercentage / 100).round();
int grandTotal = billAmount + tipAmount + taxAmount;
int perPerson = (grandTotal / peopleCount).round();

SplitBreakdownBanner(
  perPersonAmount: perPerson,
  onShare: () => shareReceiptToClipboard(),
)''',
      previewBuilder: (context) => const SplitBillCalculatorShowcase(),
    ),

    WidgetItem(
      id: 'card_device_frame_mockup',
      title: 'Smartphone Device Frame Mockup',
      description:
          'Bingkai mockup smartphone modern (Dynamic Island iPhone 16 & Punch-Hole Android) lengkap dengan tombol hardware samping, live status bar 5G/baterai, dan mini app interaktif.',
      category: WidgetCategory.cards,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.phone_iphone_rounded,
      tags: [
        'Device Frame',
        'Mockup',
        'Dynamic Island',
        'iPhone',
        'Android',
        'Chassis',
        'Hardware Buttons',
      ],
      usageTips:
          'Bungkus layar aplikasi di dalam ClipRRect dengan borderRadius chassis untuk menampilkan preview mockup smartphone yang realistis.',
      codeSnippet: '''
Container(
  decoration: BoxDecoration(
    color: titaniumChassisColor,
    borderRadius: BorderRadius.circular(34),
    border: Border.all(color: Colors.white24, width: 2.5),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(28),
    child: EmbeddedLiveApp(),
  ),
)''',
      previewBuilder: (context) => const DeviceFrameMockupShowcase(),
    ),

    WidgetItem(
      id: 'anim_compass_heading_dial',
      title: 'Compass & Gyro 360° Heading Dial',
      description:
          'Dial kompas taktis 360° dengan skala derajat mikro, mata angin cardinal (U, T, S, B), jarum magnetik dwi-warna berputar, interaksi drag manual, dan mode auto-gyro.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.explore_rounded,
      tags: [
        'Compass',
        'Gyroscope',
        'Heading Dial',
        'Sensors',
        'Navigation',
        'Tactical',
        'CustomPainter',
      ],
      usageTips:
          'Gunakan canvas.rotate(-headingRad) pada CustomPainter untuk memutar dial derajat berlawanan arah jarum kompas yang tetap menghadap Utara.',
      codeSnippet: '''
GestureDetector(
  onPanUpdate: (details) => updateHeadingAngle(details.localPosition),
  child: CustomPaint(
    painter: CompassDialPainter(headingDegrees: currentHeading),
  ),
)''',
      previewBuilder: (context) => const CompassHeadingDialShowcase(),
    ),

    WidgetItem(
      id: 'anim_sound_equalizer_bars',
      title: 'Sound Equalizer Spectrum Visualizer',
      description:
          'Visualisator spektrum frekuensi audio 16-channel dengan bar LED multi-segmen bergradasi (Hijau-Kuning-Merah), falling peak caps beranimasi gravitasi, dan preset DSP.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.graphic_eq_rounded,
      tags: [
        'Equalizer',
        'Audio Spectrum',
        'LED Bars',
        'DSP',
        'Sound Visualizer',
        'Peak Hold',
        'Music',
      ],
      usageTips:
          'Hitung level aktif per segmen LED dan simpan array peakCaps terpisah yang berkurang secara linier untuk efek falling peak caps yang realistis.',
      codeSnippet: '''
CustomPaint(
  painter: EqualizerBarsPainter(
    levels: channelFrequencyLevels,
    peakCaps: fallingPeakHoldCaps,
  ),
)''',
      previewBuilder: (context) => const SoundEqualizerBarsShowcase(),
    ),

    WidgetItem(
      id: 'anim_slot_machine_spinner',
      title: 'Casino Slot Machine 3-Reel Spinner',
      description:
          'Mesin slot kasino 3-reel dengan fisika rolling drum beranimasi independen, tarikan tuas lever pegas 3D, deteksi jackpot kombinasi simbol, dan manajemen koin taruhan.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.casino_rounded,
      tags: [
        'Slot Machine',
        'Casino',
        'Lever Physics',
        'Spinner',
        'Reels',
        'Jackpot',
        'Game UX',
      ],
      usageTips:
          'Gunakan ClipRect dan Transform.translate dengan staggered timer berurutan untuk setiap reel agar reel berhenti bergantian secara realistis.',
      codeSnippet: '''
Transform.translate(
  offset: Offset(0, -currentScrollOffset),
  child: Column(
    children: reelSymbols.map((s) => Text(s)).toList(),
  ),
)''',
      previewBuilder: (context) => const SlotMachineSpinnerShowcase(),
    ),

    WidgetItem(
      id: 'anim_pop_it_fidget_board',
      title: 'Pop-It Silicone Fidget Board',
      description:
          'Papan sensorik silikon 6x6 gelembung pelangi interaktif dengan fisika cekung/cembung 3D, animasi balik papan Matrix4 Y-axis, haptic feedback, dan mode speed run timer.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.bubble_chart_rounded,
      tags: [
        'Pop It',
        'Fidget',
        'Silicone',
        '3D Concave',
        'Matrix4 Flip',
        'Haptic',
        'Sensory Toy',
      ],
      usageTips:
          'Kombinasikan RadialGradient dengan alignment offset berlawanan untuk menciptakan ilusi kedalaman 3D cembung (unpopped) dan cekung (popped).',
      codeSnippet: '''
AnimatedContainer(
  duration: Duration(milliseconds: 160),
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    gradient: RadialGradient(
      colors: isPopped ? [darkColor, baseColor] : [lightColor, baseColor],
      center: isPopped ? Alignment(0.2, 0.2) : Alignment(-0.35, -0.35),
    ),
  ),
)''',
      previewBuilder: (context) => const PopItFidgetBoardShowcase(),
    ),

    WidgetItem(
      id: 'card_swipeable_deck',
      title: 'Swipeable Card Deck Tinder-Style',
      description:
          'Tumpukan kartu profil interaktif dengan fisika rotasi drag dinamis, stempel LIKE/NOPE/SUPER LIKE bergradasi opacity, animasi fly-off release, dan tombol Undo rewind.',
      category: WidgetCategory.cards,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.style_rounded,
      tags: [
        'Swipe Cards',
        'Tinder',
        'Card Deck',
        'Pan Gesture',
        'Physics Rotation',
        'Stamp Overlay',
        'Undo',
      ],
      usageTips:
          'Gunakan GestureDetector onPanUpdate untuk menghitung rotasi (dx / screenWidth * 0.35 rad) dan tampilkan badge LIKE/NOPE dengan opacity terkalibrasi.',
      codeSnippet: '''
Transform.translate(
  offset: dragOffset,
  child: Transform.rotate(
    angle: (dragOffset.dx / screenWidth) * 0.35,
    child: CardContent(),
  ),
)''',
      previewBuilder: (context) => const SwipeableCardDeckShowcase(),
    ),

    WidgetItem(
      id: 'anim_plinko_peg_drop',
      title: 'Plinko Peg Drop Carnival Physics',
      description:
          'Papan permainan Plinko pasak segitiga dengan simulasi fisika gravitasi pantulan bola real-time, jejak neon glow trail, slot multiplier dinamis (0.4x - 5.0x), dan multi-ball drop.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.sports_esports_rounded,
      tags: [
        'Plinko',
        'Pachinko',
        'Peg Drop',
        'Gravity Physics',
        'Collision',
        'Multiplier',
        'Carnival',
      ],
      usageTips:
          'Hitung vektor elastisitas pantulan bola saat jarak ke pusat peg < pegRadius + ballRadius di dalam loop Timer periodic 16ms (60 FPS).',
      codeSnippet: '''
CustomPaint(
  painter: PlinkoBoardPainter(
    balls: activeBalls,
    numPegRows: 7,
  ),
)''',
      previewBuilder: (context) => const PlinkoPegDropShowcase(),
    ),

    WidgetItem(
      id: 'anim_claw_machine_arcade',
      title: 'Tokyo Crane Claw Machine Arcade',
      description:
          'Mesin capit arcade retro dengan rel crane horizontal yang dapat digerakkan joystick D-Pad, animasi turun-naik kabel kerek bermotor, cakar mekanik 3-cabang, dan rak hadiah kapsul.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.videogame_asset_rounded,
      tags: [
        'Claw Machine',
        'Crane Game',
        'Joystick',
        'Arcade',
        'CustomPainter',
        'Capsule Toy',
        'Trophy Shelf',
      ],
      usageTips:
          'Gunakan CustomPainter untuk menggambar 3 capit cakar mekanik yang meregang saat turun dan mencengkeram erat saat mencapai dasar kabinet.',
      codeSnippet: '''
CustomPaint(
  painter: ClawProngsPainter(
    isClosed: isGrabbingPrize,
    accentColor: neonPink,
  ),
)''',
      previewBuilder: (context) => const ClawMachineArcadeShowcase(),
    ),

    WidgetItem(
      id: 'anim_whack_a_mole_arcade',
      title: 'Whack-A-Mole Carnival Game',
      description:
          'Game karnaval pukul tikus tanah grid 3x3 dengan varian tikus biasa (+100 PTS), raja emas (+300 PTS), jebakan bom (-150 PTS), animasi visual hantaman palu, dan timer 30 detik.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.sports_baseball_rounded,
      tags: [
        'Whack-A-Mole',
        'Carnival',
        'Hammer Strike',
        'Game Loop',
        'Combo Multiplier',
        'Floating Score',
        'Arcade',
      ],
      usageTips:
          'Gunakan Stack dengan Positioned untuk merender animasi sliding mole keluar dari lubang dan efek partikel skor melayang saat dipukul.',
      codeSnippet: '''
GestureDetector(
  onTapDown: (_) => handleHoleTapped(index),
  child: AnimatedScale(
    scale: hole.isHit ? 0.75 : 1.0,
    child: MoleAvatar(hole: hole),
  ),
)''',
      previewBuilder: (context) => const WhackAMoleArcadeShowcase(),
    ),

    WidgetItem(
      id: 'input_face_id_biometric_scanner',
      title: 'Face ID Biometric Scanner',
      description:
          'Simulasi autentikasi biometrik wajah modern dengan laser scanning line bolak-balik, titik mesh biometrik, sudut viewfinder [ ], deteksi status match/fail, dan haptic feedback.',
      category: WidgetCategory.inputs,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.face_retouching_natural_rounded,
      tags: [
        'Face ID',
        'Biometrics',
        'Scanner',
        'Security',
        'Mesh',
        'Laser Beam',
        'Auth',
      ],
      usageTips:
          'Gunakan CustomPainter untuk sudut viewfinder dan padukan dengan AnimatedBuilder Tween untuk menggerakkan garis laser vertikal secara mulus.',
      codeSnippet: '''
CustomPaint(
  painter: FaceMeshPainter(
    state: scanState,
    accentColor: statusColor,
  ),
)''',
      previewBuilder: (context) => const FaceIdBiometricScannerShowcase(),
    ),

    WidgetItem(
      id: 'nav_story_onboarding_carousel',
      title: 'Story Onboarding Carousel',
      description:
          'Pengalaman onboarding interaktif bergaya Instagram/Snapchat Story dengan bar progres tersegmentasi otomatis, navigasi tap kiri/kanan, dan gesture tahan untuk pause.',
      category: WidgetCategory.navigation,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.amp_stories_rounded,
      tags: [
        'Story',
        'Onboarding',
        'Carousel',
        'Progress Bar',
        'Gesture',
        'Instagram Story',
        'Slides',
      ],
      usageTips:
          'Bagi gestur tap pada layar (dx < 0.3x = Previous, dx > 0.7x = Next) dan gunakan AnimationController.stop/forward pada gesture onLongPressStart/End.',
      codeSnippet: '''
Row(
  children: List.generate(storyCount, (idx) => 
    Expanded(
      child: LinearProgressIndicator(value: segmentProgress[idx]),
    ),
  ),
)''',
      previewBuilder: (context) => const StoryOnboardingCarouselShowcase(),
    ),

    WidgetItem(
      id: 'input_captcha_slider_puzzle',
      title: 'Captcha Slider Puzzle Verification',
      description:
          'Verifikasi keamanan anti-bot dengan menggeser potongan puzzle ke lubang sasaran dengan deteksi toleransi piksel (Δx <= 0.04), animasi flash match, dan getar error.',
      category: WidgetCategory.inputs,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.extension_rounded,
      tags: [
        'Captcha',
        'Puzzle Slider',
        'Security',
        'Verification',
        'CustomPainter',
        'Anti-Bot',
        'Fintech',
      ],
      usageTips:
          'Gambar path potongan puzzle dengan arcToPoint untuk tab tonjolan samping & soket cekung, lalu sinkronkan posisi pieceX dengan nilai Slider.',
      codeSnippet: '''
CustomPaint(
  size: Size(46, 46),
  painter: PuzzlePiecePainter(
    isCutoutHole: false,
    fillColor: brandCyan,
  ),
)''',
      previewBuilder: (context) => const CaptchaSliderPuzzleShowcase(),
    ),

    WidgetItem(
      id: 'card_flight_boarding_pass_fold',
      title: 'Flight Boarding Pass Fold Card',
      description:
          'Tiket boarding pass maskapai penerbangan digital dengan perforated notch samping, rute bandara (CGK -> HND), detail fasilitas lipat-buka, dan barcode scanner CustomPainter.',
      category: WidgetCategory.cards,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.flight_takeoff_rounded,
      tags: [
        'Boarding Pass',
        'Flight Ticket',
        'Travel',
        'Perforated',
        'Foldable',
        'Barcode',
        'Airline',
      ],
      usageTips:
          'Gunakan ClipRect dan SizeTransition / Align heightFactor untuk membuat efek lipat accordion fasilitas penerbangan yang elegan.',
      codeSnippet: '''
ClipRect(
  child: Align(
    alignment: Alignment.topCenter,
    heightFactor: foldAnimation.value,
    child: FlightItineraryDetails(),
  ),
)''',
      previewBuilder: (context) => const FlightBoardingPassFoldShowcase(),
    ),

    WidgetItem(
      id: 'nav_courier_delivery_route_tracker',
      title: 'Courier Delivery Route Tracker',
      description:
          'Peta rute kurir dinamis berbasis kurva Bezier dengan animasi pergerakan motor, radar ripple denyut, status pipeline pesanan bertingkat, dan kartu driver ETA.',
      category: WidgetCategory.navigation,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.delivery_dining_rounded,
      tags: [
        'Courier Tracker',
        'Maps',
        'Delivery Route',
        'Bezier Path',
        'Radar Ripple',
        'ETA',
        'Logistics',
      ],
      usageTips:
          'Gunakan PathMetric computeMetrics dan getTangentForOffset untuk mendapatkan koordinat dan rotasi motor sepanjang garis rute lengkung.',
      codeSnippet: '''
final metrics = path.computeMetrics().first;
final tangent = metrics.getTangentForOffset(metrics.length * progress);
canvas.drawCircle(tangent.position, 8, courierPaint);
''',
      previewBuilder: (context) => const CourierDeliveryRouteTrackerShowcase(),
    ),

    WidgetItem(
      id: 'card_seat_selection_matrix',
      title: 'Interactive Seat Selection Matrix',
      description:
          'Grid pemilihan kursi bioskop/pesawat 6x8 dengan lorong aisle pemisah, status kursi (Available, VIP Gold, Selected, Occupied), layar proyektor lengkung, dan kalkulator harga.',
      category: WidgetCategory.cards,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.event_seat_rounded,
      tags: [
        'Seat Matrix',
        'Cinema',
        'Airplane',
        'Seat Picker',
        'VIP Seats',
        'Pricing Cart',
        'Booking',
      ],
      usageTips:
          'Gunakan Set<String> untuk mengelola kursi terpilih dan hitung total harga otomatis berdasarkan prefix baris kursi (VIP A/B vs Reguler).',
      codeSnippet: '''
GestureDetector(
  onTap: () => toggleSeat(seatId),
  child: AnimatedContainer(
    duration: Duration(milliseconds: 150),
    decoration: BoxDecoration(
      color: isSelected ? Colors.green : defaultColor,
      border: Border.all(color: isVip ? Colors.amber : Colors.transparent),
    ),
  ),
)''',
      previewBuilder: (context) => const SeatSelectionMatrixShowcase(),
    ),

    WidgetItem(
      id: 'input_ai_prompt_suggestion_cloud',
      title: 'AI Prompt Suggestion Cloud',
      description:
          'Awan kartu prompt AI cerdas dengan filter kategori (Coding, Penulisan, Kreatif, Data), template teks siap pakai, dan integrasi input bar dengan efek ketik otomatis.',
      category: WidgetCategory.inputs,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.psychology_rounded,
      tags: [
        'AI Prompt',
        'Prompt Cloud',
        'Suggestion',
        'Chatbot',
        'LLM',
        'Category Filter',
        'Typewriter',
      ],
      usageTips:
          'Gunakan TextEditingController untuk mengisi nilai prompt template saat kartu diklik dan jalankan Timer periodic untuk efek respon AI real-time.',
      codeSnippet: '''
TextField(
  controller: inputController,
  decoration: InputDecoration(
    hintText: 'Pilih prompt rekomendasi di atas...',
  ),
)''',
      previewBuilder: (context) => const AiPromptSuggestionCloudShowcase(),
    ),

    WidgetItem(
      id: 'input_multimodal_attachment_tray',
      title: 'Multimodal Attachment Tray',
      description:
          'Baki lampiran berkas multi-format (Gambar, PDF, Audio, CSV) dengan cincin progres upload interaktif, tombol hapus badge X, dan modal pemilihan berkas.',
      category: WidgetCategory.inputs,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.attach_file_rounded,
      tags: [
        'Multimodal',
        'Attachment Tray',
        'File Upload',
        'Progress Ring',
        'Composer',
        'Media Picker',
      ],
      usageTips:
          'Gunakan ListView.separated horizontal di atas TextField input bar untuk menampilkan kartu berkas terlampir dengan circular progress ring.',
      codeSnippet: '''
Stack(
  children: [
    AttachmentCard(file: item),
    Positioned(
      top: -4, right: -4,
      child: RemoveBadgeButton(onTap: () => remove(item.id)),
    ),
  ],
)''',
      previewBuilder: (context) => const MultimodalAttachmentTrayShowcase(),
    ),

    WidgetItem(
      id: 'anim_ai_voice_ripple_sphere',
      title: 'AI Voice Ripple Sphere Visualizer',
      description:
          'Visualisator bola suara 3D pendar radial bergaya Siri / Gemini Live dengan gelombang ripple organik berdenyut, cincin orbit rotasi, dan transisi multi-state (Idle, Listening, Thinking, Speaking).',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.record_voice_over_rounded,
      tags: [
        'Voice Sphere',
        'Audio Visualizer',
        'Gemini Live',
        'Siri Ripple',
        'Orbital Glow',
        'AI Assistant',
        'Microphone',
      ],
      usageTips:
          'Kombinasikan RadialGradient dengan MaskFilter.blur dan hitung radius ripple konsentris di dalam CustomPainter sesuai fase state percakapan suara.',
      codeSnippet: '''
CustomPaint(
  size: Size(280, 280),
  painter: VoiceSpherePainter(
    progress: animController.value,
    state: activeAiState,
  ),
)''',
      previewBuilder: (context) => const AiVoiceRippleSphereShowcase(),
    ),

    WidgetItem(
      id: 'card_kanban_drag_drop_board',
      title: 'Kanban Drag & Drop Task Board',
      description:
          'Papan manajemen tugas Agile/Scrum dengan 3 kolom alur kerja (To Do, In Progress, Done), interaksi drag & drop kartu dengan LongPressDraggable, dan indikator progres subtask.',
      category: WidgetCategory.cards,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.view_kanban_rounded,
      tags: [
        'Kanban Board',
        'Drag and Drop',
        'Agile',
        'Task Management',
        'Scrum',
        'Draggable',
        'Workflow',
      ],
      usageTips:
          'Gunakan LongPressDraggable dengan delay 150ms dan DragTarget dengan onAcceptWithDetails untuk memindahkan data objek task antar kolom status.',
      codeSnippet: '''
DragTarget<KanbanTask>(
  onAcceptWithDetails: (details) => moveTask(details.data, columnId),
  builder: (context, candidates, rejected) {
    return ColumnView();
  },
)''',
      previewBuilder: (context) => const KanbanDragDropBoardShowcase(),
    ),

    WidgetItem(
      id: 'card_sticky_header_data_table',
      title: 'Enterprise Sticky Header Data Table',
      description:
          'Tabel data 2-arah (horizontal + vertikal) dengan baris header sticky, sorting multi-kolom ASC/DESC, pencarian instan, seleksi batch checkbox, dan footer kontrol paginasi.',
      category: WidgetCategory.cards,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.table_chart_rounded,
      tags: [
        'Data Table',
        'Sticky Header',
        'Sortable',
        'Pagination',
        'Batch Action',
        'Enterprise',
        'Filter',
      ],
      usageTips:
          'Bungkus baris data dalam SingleChildScrollView(scrollDirection: Axis.horizontal) dengan header terpisah untuk menjaga posisi header tetap pinned di atas.',
      codeSnippet: '''
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Column(
    children: [
      StickyHeaderRow(onSort: handleSort),
      ...dataRows.map((row) => DataRowItem(row: row)),
    ],
  ),
)''',
      previewBuilder: (context) => const StickyHeaderDataTableShowcase(),
    ),

    WidgetItem(
      id: 'nav_expandable_tree_view_hierarchy',
      title: 'Expandable Tree View File Hierarchy',
      description:
          'Struktur explorer file & folder pohon rekursif bergaya IDE dengan ikon ekstensi berkas khusus (Dart, JSON, MD, PNG), garis panduan indentasi, dan panel detail berkas.',
      category: WidgetCategory.navigation,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.account_tree_rounded,
      tags: [
        'Tree View',
        'File Hierarchy',
        'Recursive',
        'IDE Explorer',
        'Folder Tree',
        'Expandable',
        'Breadcrumbs',
      ],
      usageTips:
          'Gunakan fungsi rekursif buildTreeNode(node, depth) dengan padding kiri depth * 18.0 untuk menampilkan cabang pohon dengan kedalaman tak terbatas.',
      codeSnippet: '''
Widget buildTreeNode(TreeNode node, int depth) {
  return Column(
    children: [
      NodeTile(depth: depth, node: node),
      if (node.isFolder && node.isExpanded)
        ...node.children.map((child) => buildTreeNode(child, depth + 1)),
    ],
  );
}''',
      previewBuilder: (context) => const ExpandableTreeViewHierarchyShowcase(),
    ),

    WidgetItem(
      id: 'anim_apple_watch_activity_rings',
      title: 'Apple Watch Activity Rings',
      description:
          'Tiga cincin aktivitas konsentris bergaya Apple Watch (Move Merah, Exercise Hijau, Stand Biru) dengan StrokeCap.round, efek overlap saat melebihi 100%, dan tombol increment.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.donut_large_rounded,
      tags: [
        'Activity Rings',
        'Apple Watch',
        'Fitness',
        'CustomPainter',
        'Arc Progress',
        'Health',
        'Concentric',
      ],
      usageTips:
          'Hitung sweepAngle = 2 * pi * progress untuk setiap cincin konsentris dan gambar bayangan pada ujung cap saat progress > 1.0.',
      codeSnippet: '''
CustomPaint(
  size: Size(280, 280),
  painter: ActivityRingsPainter(
    moveProgress: moveProgress,
    exerciseProgress: exerciseProgress,
    standProgress: standProgress,
  ),
)''',
      previewBuilder: (context) => const AppleWatchActivityRingsShowcase(),
    ),

    WidgetItem(
      id: 'anim_hydration_water_intake_tracker',
      title: 'Hydration Water Intake Tracker',
      description:
          'Pelacak asupan air minum harian dengan visual botol kaca bergelombang sinus dinamis, porsi cepat (+250ml s/d +1000ml), dan riwayat log minum harian.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.opacity_rounded,
      tags: [
        'Hydration',
        'Water Tracker',
        'Liquid Wave',
        'Sinusoidal',
        'Health',
        'Daily Log',
        'Bottles',
      ],
      usageTips:
          'Gunakan CustomPainter gelombang sinus pada path botol ClipRRect dengan progress Y = size.height * (1.0 - fillProgress).',
      codeSnippet: '''
CustomPaint(
  size: Size(170, 260),
  painter: WaterWavePainter(
    waveProgress: animValue,
    fillProgress: intakeMl / targetMl,
  ),
)''',
      previewBuilder: (context) => const HydrationWaterIntakeTrackerShowcase(),
    ),

    WidgetItem(
      id: 'anim_sleep_quality_hypnogram_chart',
      title: 'Sleep Quality Hypnogram Chart',
      description:
          'Grafik gelombang bertingkat siklus tidur (Terjaga, REM, Tidur Ringan, Tidur Nyenyak) dengan badge skor kualitas tidur, rincian durasi fase, dan scrubber gestur.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.nights_stay_rounded,
      tags: [
        'Sleep Chart',
        'Hypnogram',
        'Health Wave',
        'Oura Ring',
        'Apple Health',
        'Sleep Stages',
        'Scrubber',
      ],
      usageTips:
          'Gambar garis step wave menggunakan Path moveTo dan lineTo horizontal-vertikal antar fase tidur pada CustomPainter.',
      codeSnippet: '''
CustomPaint(
  size: Size.infinite,
  painter: HypnogramChartPainter(
    points: sleepDataPoints,
    scrubFraction: activeScrubPos,
  ),
)''',
      previewBuilder: (context) => const SleepQualityHypnogramChartShowcase(),
    ),

    // ------------------- OPTION M: MEDIA, CAMERA & LIVE FILTERS -------------------
    WidgetItem(
      id: 'anim_story_camera_filter_wheel',
      title: 'Story Camera & Filter Wheel',
      description:
          'Kamera viewfinder interaktif bergaya Instagram/TikTok Stories dengan carousel wheel filter live (Cyberpunk, Golden Hour, Vintage, Noir), shutter foto, dan hold-to-record video.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.camera_rounded,
      tags: [
        'Camera',
        'Story',
        'Filter Wheel',
        'Instagram',
        'TikTok',
        'Live Filter',
        'Shutter',
        'Video Record',
      ],
      usageTips:
          'Gunakan ColorFiltered dengan color filter dinamis (BlendMode) dan carousel ScrollController horizontal bersinkronisasi.',
      codeSnippet: '''
ColorFiltered(
  colorFilter: ColorFilter.mode(filter.tintColor, filter.blendMode),
  child: CameraViewfinder(),
)''',
      previewBuilder: (context) => const StoryCameraFilterWheelShowcase(),
    ),

    WidgetItem(
      id: 'anim_audio_pitch_tuner_dial',
      title: 'Instrument Pitch Tuner Dial',
      description:
          'Tuner alat musik & vokal kromatik presisi dengan gauge jarum cent (-50 ke +50 cent), indikator green lock-in saat in-tune, strobe wheel Peterson, dan simulator petikan senar (Gitar, Bass, Ukulele, Biola).',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.tune_rounded,
      tags: [
        'Audio Tuner',
        'Pitch Detector',
        'Needle Gauge',
        'Chromatic',
        'Guitar Tuner',
        'Strobe',
        'Pluck Physics',
      ],
      usageTips:
          'Gunakan rumus frekuensi f = f0 * 2^(cents / 1200) dan lukis busur gauge presisi dengan CustomPainter.',
      codeSnippet: '''
CustomPaint(
  size: Size(280, 190),
  painter: TunerArcPainter(
    cents: currentCents,
    isInTune: currentCents.abs() <= 3.0,
    gaugeColor: isInTune ? Color(0xFF10B981) : Colors.amber,
  ),
)''',
      previewBuilder: (context) => const AudioPitchTunerDialShowcase(),
    ),

    WidgetItem(
      id: 'anim_video_scrubber_thumbnail_strip',
      title: 'Video Scrubber & Filmstrip Strip',
      description:
          'Scrubber timeline video presisi dengan filmstrip track thumbnail berbingkai, loupe gelembung pembesar timestamp melayang, layer waveform audio, dan mode trimmer in/out bounds.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.video_library_rounded,
      tags: [
        'Video Scrubber',
        'Filmstrip',
        'Timeline',
        'Thumbnail Strip',
        'Magnifier Loupe',
        'Video Trimmer',
        'Jog Dial',
      ],
      usageTips:
          'Gunakan GestureDetector horizontal drag pada track dengan interpolasi nilai posisi waktu dan letakkan playhead cursor red bar.',
      codeSnippet: '''
GestureDetector(
  onHorizontalDragUpdate: (details) {
    final norm = (details.localPosition.dx / trackWidth).clamp(0.0, 1.0);
    setState(() => currentPosition = norm * totalDuration);
  },
  child: FilmstripTrack(...),
)''',
      previewBuilder: (context) => const VideoScrubberThumbnailStripShowcase(),
    ),

    // ------------------- OPTION N: SMART HOME & IOT AUTOMATION -------------------
    WidgetItem(
      id: 'card_smart_thermostat_dial',
      title: 'Smart Thermostat & Climate Dial',
      description:
          'Dial putar sirkular 270 derajat pengatur temperatur target ruangan dengan indikator ambient suhu vs target, cincin glow denyut dinamis, dan selektor mode HVAC (Cool, Heat, Eco, Fan).',
      category: WidgetCategory.cards,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.thermostat_rounded,
      tags: [
        'Thermostat',
        'Smart Home',
        'IoT',
        'Rotary Dial',
        'Radial Drag',
        'HVAC',
        'Climate Control',
      ],
      usageTips:
          'Gunakan math.atan2 untuk menghitung rotasi sudut sentuh relatif ke titik pusat dial dan transformasikan ke rentang suhu 15-32°C.',
      codeSnippet: '''
GestureDetector(
  onPanUpdate: (details) {
    final angle = math.atan2(dy, dx);
    final temp = minTemp + ((norm / sweep) * (maxTemp - minTemp));
    setState(() => targetTemp = temp);
  },
  child: CustomPaint(painter: ThermostatDialPainter(...)),
)''',
      previewBuilder: (context) => const SmartThermostatDialShowcase(),
    ),

    WidgetItem(
      id: 'card_smart_lighting_scene',
      title: 'Smart Lighting & Ambience Studio',
      description:
          'Studio pencahayaan pintar dengan simulasi cone cahaya ruangan real-time, roda warna spektrum HSV RGB, slider temperatur Kelvin (2000K-6500K), dan preset scene mood instan.',
      category: WidgetCategory.cards,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.lightbulb_rounded,
      tags: [
        'Smart Lighting',
        'Color Wheel',
        'Kelvin Temperature',
        'HSV',
        'Ambient Light',
        'Mood Scene',
        'IoT',
      ],
      usageTips:
          'Gunakan RadialGradient untuk memproyeksikan kerucut cahaya lampu dan konversikan temperatur Kelvin ke ruang warna RGB.',
      codeSnippet: '''
Container(
  decoration: BoxDecoration(
    gradient: RadialGradient(
      center: Alignment(0.0, -0.6),
      colors: [activeColor.withOpacity(brightness), Colors.transparent],
    ),
  ),
  child: RoomSceneMockup(),
)''',
      previewBuilder: (context) => const SmartLightingSceneShowcase(),
    ),

    WidgetItem(
      id: 'anim_energy_consumption_flow_graph',
      title: 'Smart Energy & Power Flow Graph',
      description:
          'Grafik topologi aliran daya real-time animasi dengan partikel bergerak pada jalur busur (Solar Panel -> Inverter -> Baterai -> Rumah -> Grid) dan kalkulasi mandiri energi independen.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.bolt_rounded,
      tags: [
        'Energy Flow',
        'Solar Power',
        'Powerwall',
        'IoT Topology',
        'Particle Streams',
        'Grid Net Metering',
        'Smart Grid',
      ],
      usageTips:
          'Gunakan CustomPainter dengan animasi Controller progress bergerak linear sepanjang garis Offset.lerp antar node sumber dan beban.',
      codeSnippet: '''
CustomPaint(
  painter: EnergyFlowTopologyPainter(
    progress: animValue,
    solarKw: solarKw,
    homeKw: homeKw,
    batteryKw: batteryKw,
    gridKw: gridKw,
  ),
)''',
      previewBuilder: (context) => const EnergyConsumptionFlowGraphShowcase(),
    ),

    // ------------------- OPTION Q: CRYPTO, WEB3 & FINTECH PRO -------------------
    WidgetItem(
      id: 'anim_order_book_depth_chart',
      title: 'Order Book & Market Depth Chart',
      description:
          'Visualisasi kedalaman pasar kripto/saham dual-tone (Bid Wall hijau vs Ask Wall merah) dengan live order book ladder, kalkulator spread, dan touch crosshair hover volume.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.candlestick_chart_rounded,
      tags: [
        'Crypto',
        'Order Book',
        'Market Depth',
        'Bid Ask Wall',
        'FinTech',
        'Exchange',
        'Trading',
      ],
      usageTips:
          'Gunakan CustomPainter dengan Shader LinearGradient untuk mengisi area kurva akumulatif total volume pesanan beli dan jual.',
      codeSnippet: '''
CustomPaint(
  painter: DepthChartPainter(
    bids: bidList,
    asks: askList,
    maxTotal: maxVolume,
    midPrice: midPrice,
  ),
)''',
      previewBuilder: (context) => const OrderBookDepthChartShowcase(),
    ),

    WidgetItem(
      id: 'anim_pro_candlestick_chart',
      title: 'Pro Candlestick & Technical Indicator Chart',
      description:
          'Chart trading profesional candlestick (OHLCV) dengan indikator garis Moving Average (MA20 & MA50), volume histogram sub-chart, timeframe selector, dan crosshair tooltip interaktif.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.show_chart_rounded,
      tags: [
        'Candlestick',
        'Trading Chart',
        'OHLCV',
        'Moving Average',
        'MA20',
        'MA50',
        'Crypto',
        'Stocks',
      ],
      usageTips:
          'Hitung batas min/max harga secara dinamis dari list candle dan petakan koordinat open, high, low, close ke sumbu Y kanvas.',
      codeSnippet: '''
CustomPaint(
  painter: CandlestickPainter(
    candles: candleDataList,
    ma20: ma20Values,
    ma50: ma50Values,
    selectedIndex: crosshairIndex,
    showVolume: true,
  ),
)''',
      previewBuilder: (context) => const ProCandlestickChartShowcase(),
    ),

    WidgetItem(
      id: 'dialog_web3_wallet_connect_sheet',
      title: 'Web3 Multi-Chain Wallet & DeFi Asset Sheet',
      description:
          'Manajemen dompet Web3 multi-chain modern (Ethereum, Arbitrum, Polygon, Solana, Base) dengan ENS domain, status gas gwei, generator QR code, portfolio saldo token, dan simulator signature transaksi.',
      category: WidgetCategory.dialogs,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.account_balance_wallet_rounded,
      tags: [
        'Web3',
        'Crypto Wallet',
        'DeFi',
        'Multi-Chain',
        'ENS',
        'Gas Tracker',
        'Token Swap',
        'Ethereum',
      ],
      usageTips:
          'Gunakan ClipRRect dan LinearGradient futuristik dengan modal bottom sheet untuk menampilkan multi-chain switcher dan transaksi swapping.',
      codeSnippet: '''
showModalBottomSheet(
  context: context,
  builder: (ctx) => Web3WalletConnectSheet(),
);''',
      previewBuilder: (context) => const Web3WalletConnectSheetShowcase(),
    ),

    WidgetItem(
      id: 'anim_crypto_fear_greed_meter',
      title: 'Crypto Fear & Greed Sentiment Dial',
      description:
          'Gauge meter sentimen pasar kripto interaktif 180° dengan jarum animasi easing, 5 zona warna sentimen (Extreme Fear hingga Extreme Greed), pengatur skor live, horizon histori 30 hari, dan rincian faktor pendorong pasar (volatilitas, volume, dominansi).',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.speed_rounded,
      tags: [
        'Crypto',
        'Fear & Greed',
        'Sentiment Gauge',
        'CustomPainter',
        'FinTech',
        'Market Analytics',
        'Animation',
      ],
      usageTips:
          'Gunakan CustomPainter dengan arc bertingkat warna dan transform matrix rotasi jarum dengan CurvedAnimation untuk transisi perubahan skor yang halus.',
      codeSnippet: '''
CustomPaint(
  painter: FearGreedMeterPainter(
    score: currentScore,
    needleColor: tier.color,
  ),
)''',
      previewBuilder: (context) => const CryptoFearGreedMeterShowcase(),
    ),

    WidgetItem(
      id: 'card_staking_yield_calculator',
      title: 'DeFi Staking APY & Yield Compounding Calculator',
      description:
          'Kalkulator imbal hasil staking aset kripto multi-token interaktif dengan slider nominal deposit, pilihan durasi penguncian berperingkat APY boost (Flexible, 30, 90, 365 hari), frekuensi bunga majemuk (Harian, Bulanan, Sederhana), dan proyeksi total yield/return.',
      category: WidgetCategory.cards,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.savings_rounded,
      tags: [
        'DeFi',
        'Staking',
        'APY Calculator',
        'Compound Interest',
        'Yield Farming',
        'FinTech',
        'Crypto',
      ],
      usageTips:
          'Gunakan rumus bunga majemuk A = P * (1 + r/n)^(n*t) untuk menghitung proyeksi total return berdasarkan pilihan frekuensi compound.',
      codeSnippet: '''
StakingYieldCard(
  selectedAsset: currentAsset,
  depositAmount: amount,
  lockDays: duration.days,
  compoundMode: mode,
)''',
      previewBuilder: (context) => const StakingYieldCalculatorShowcase(),
    ),

    WidgetItem(
      id: 'anim_amm_liquidity_pool_curve',
      title: 'AMM Constant Product Liquidity Pool Curve Simulator',
      description:
          'Visualizer kurva likuiditas AMM (Automated Market Maker) dengan formula invariant x * y = k, simulator interaktif swap ETH/USDC, kurva hiperbolik CustomPainter, titik tangen harga spot, dan badge estimasi slippage / price impact realtime.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.show_chart_rounded,
      tags: [
        'AMM',
        'DeFi',
        'Liquidity Pool',
        'Constant Product',
        'Uniswap',
        'Price Impact',
        'Slippage',
        'CustomPainter',
      ],
      usageTips:
          'Gunakan formula Constant Product x * y = k untuk memetakan kurva hiperbolik dan menghitung pergeseran titik koordinat (x, y) saat terjadi swap token.',
      codeSnippet: '''
CustomPaint(
  painter: AmmCurvePainter(
    initialX: poolX,
    initialY: poolY,
    deltaX: swapAmountX,
  ),
)''',
      previewBuilder: (context) => const AmmLiquidityPoolCurveShowcase(),
    ),

    WidgetItem(
      id: 'card_spatial_parallax_tilt_card',
      title: '3D Spatial Parallax Tilt Card',
      description:
          'Kartu spasial gaya visionOS dengan efek multi-layer depth parallax yang merespons sentuhan drag dan simulator gyroscope, specular glare sheen yang bereaksi terhadap sudut kemiringan matriks 3D, serta frosted glassmorphism berbalut pendar neon.',
      category: WidgetCategory.cards,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.view_in_ar_rounded,
      tags: [
        'Spatial',
        '3D Card',
        'Parallax',
        'VisionOS',
        'Matrix4',
        'Gyroscope',
        'Specular Glare',
        'Glassmorphism',
      ],
      usageTips:
          'Gunakan Matrix4.identity()..setEntry(3, 2, 0.0015)..rotateX()..rotateY() untuk memberikan distorsi perspektif 3D yang nyata pada widget.',
      codeSnippet: '''
Transform(
  transform: Matrix4.identity()
    ..setEntry(3, 2, 0.0015)
    ..rotateX(pitchAngle)
    ..rotateY(yawAngle),
  alignment: Alignment.center,
  child: SpatialCardContent(),
)''',
      previewBuilder: (context) => const SpatialParallaxTiltCardShowcase(),
    ),

    WidgetItem(
      id: 'anim_interactive_360_turntable',
      title: '360° 3D Spatial Mesh Turntable',
      description:
          'Viewer model 3D turntable 360° matematika murni (tanpa library 3D eksternal) dengan kalkulasi rotasi Euler, proyeksi perspektif 2D dari 3D, depth sorting polygon (Painter algorithm), pencahayaan directional Lambertian, dan slider exploded view disassembly komponen.',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.threed_rotation_rounded,
      tags: [
        '3D Mesh',
        'Turntable',
        '360 View',
        'Exploded View',
        'CustomPainter',
        'Spatial',
        'Vector Math',
        'Lambertian Shading',
      ],
      usageTips:
          'Gunakan rotasi matriks Y dan X pada vektor 3D, hitung normal vektor bidang dengan cross product untuk menentukan intensitas pencahayaan Lambertian.',
      codeSnippet: '''
CustomPaint(
  painter: Turntable3DPainter(
    yaw: yawAngle,
    pitch: pitchAngle,
    exploded: explodedFactor,
    renderMode: mode,
  ),
)''',
      previewBuilder: (context) => const Interactive360TurntableShowcase(),
    ),

    WidgetItem(
      id: 'nav_vision_spatial_hud_window',
      title: 'Vision Spatial Depth HUD & 360° Soundstage',
      description:
          'Antarmuka jendela spasial visionOS melayang dengan pengaturan jarak kedalaman virtual (Z-Depth scaling), kanvas medan audio 3D polar 360° interaktif (drag sound sources untuk atur panning & volume), serta transisi lingkungan virtual ambient skybox.',
      category: WidgetCategory.navigation,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.spatial_audio_rounded,
      tags: [
        'VisionOS',
        'Spatial Audio',
        'Z-Depth',
        'Soundstage',
        'HUD',
        'Floating Window',
        'Polar Radar',
        'Skybox',
      ],
      usageTips:
          'Gunakan koordinat polar (radius dan sudut azimut atan2) untuk memetakan posisi pemancar audio 3D relatif terhadap kepala pengguna.',
      codeSnippet: '''
SpatialSoundstageRadar(
  sources: audioSourceList,
  onSourceMoved: (source, angle, dist) {
    updateSpatialAudio(source, angle, dist);
  },
)''',
      previewBuilder: (context) => const VisionSpatialHudWindowShowcase(),
    ),

    WidgetItem(
      id: 'card_ev_battery_state_of_charge',
      title: 'EV Battery State-of-Charge & Fast Charging Hub',
      description:
          'Dashboard telematika baterai kendaraan listrik (EV) dengan busur radial SoC 240°, animasi pendar charging berdenyut, simulator sumber daya (AC Home 7.4kW, DC Fast 150kW, Supercharger 250kW), estimasi jarak km tersisa, slider batas target charge limit harian, dan pre-conditioning pemanas baterai.',
      category: WidgetCategory.cards,
      difficulty: WidgetDifficulty.intermediate,
      icon: Icons.ev_station_rounded,
      tags: [
        'EV',
        'Electric Vehicle',
        'Battery SoC',
        'Fast Charging',
        'Supercharger',
        'Range Telematics',
        'Radial Gauge',
      ],
      usageTips:
          'Gunakan CustomPainter dengan SweepGradient dan StrokeCap.round untuk merender gauge busur baterai yang presisi.',
      codeSnippet: '''
CustomPaint(
  painter: EvRadialBatteryArcPainter(
    soc: currentBatterySoc,
    targetLimit: targetLimit,
    isCharging: isPluggedIn,
  ),
)''',
      previewBuilder: (context) => const EvBatteryStateOfChargeShowcase(),
    ),

    WidgetItem(
      id: 'card_tpms_vehicle_wireframe',
      title: 'TPMS Vehicle Wireframe & Pressure Diagnostics',
      description:
          'Sistem pemantauan tekanan ban mobil (TPMS) dengan visualisasi cetak biru (blueprint) sasis kendaraan aerodinamis, 4 sensor ban individual (PSI/Bar & temperatur °C), kode warna status bahaya/kurang/normal, simulator kebocoran ban, dan rasio distribusi tenaga AWD.',
      category: WidgetCategory.cards,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.directions_car_rounded,
      tags: [
        'TPMS',
        'Tire Pressure',
        'Vehicle Blueprint',
        'Chassis Wireframe',
        'Automotive',
        'AWD Split',
        'Diagnostics',
      ],
      usageTips:
          'Gunakan Path bezier curve untuk menggambar kontur sasis mobil top-down dan RRect untuk posisi roda dengan indikator pendar peringatan.',
      codeSnippet: '''
CustomPaint(
  painter: CarBlueprintPainter(
    tires: tireDataList,
    selectedPosition: activeTire,
  ),
)''',
      previewBuilder: (context) => const TpmsVehicleWireframeShowcase(),
    ),

    WidgetItem(
      id: 'anim_regen_braking_g_force_matrix',
      title: 'Dynamic G-Force Telemetry & Regen Braking Cluster',
      description:
          'Cluster performa dinamis EV dengan diagram gesekan 2D G-Force interaktif (lateral cornering G vs longitudinal accel/brake G) lengkap dengan jejak retensi puncak, spedometer digital responsif, gauge daya dua arah (akselerasi kW vs pengereman regeneratif kW), dan selektor profil berkendara (Eco, Comfort, Sport, Track).',
      category: WidgetCategory.animations,
      difficulty: WidgetDifficulty.advanced,
      icon: Icons.speed_rounded,
      tags: [
        'G-Force',
        'Friction Circle',
        'Regen Braking',
        'One-Pedal Drive',
        'Speedometer',
        'EV Telematics',
        'Drive Modes',
      ],
      usageTips:
          'Petakan koordinat drag sentuh ke lingkaran radius G-Force dan hitung konversi gaya inersia deselerasi ke daya pemulihan energi baterai.',
      codeSnippet: '''
CustomPaint(
  painter: GForceFrictionCirclePainter(
    lateralG: latG,
    longitudinalG: longG,
    trail: gHistoryTrail,
    themeColor: modeColor,
  ),
)''',
      previewBuilder: (context) => const RegenBrakingGForceMatrixShowcase(),
    ),
  ];
}
