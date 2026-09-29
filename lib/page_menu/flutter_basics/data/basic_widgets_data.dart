import 'package:flutter/material.dart';
import '../models/basic_widget_category.dart';
import '../models/basic_widget_model.dart';

// Layout Showcases
import '../showcases/layout/container_basic_showcase.dart';
import '../showcases/layout/row_column_basic_showcase.dart';
import '../showcases/layout/stack_positioned_basic_showcase.dart';
import '../showcases/layout/expanded_flexible_basic_showcase.dart';
import '../showcases/layout/wrap_basic_showcase.dart';
import '../showcases/layout/align_center_basic_showcase.dart';
import '../showcases/layout/sizedbox_padding_basic_showcase.dart';
import '../showcases/layout/single_child_scrollview_basic_showcase.dart';
import '../showcases/layout/scaffold_drawer_basic_showcase.dart';
import '../showcases/layout/aspect_ratio_fitted_box_basic_showcase.dart';
import '../showcases/layout/interactive_viewer_basic_showcase.dart';

// Typography & Media Showcases
import '../showcases/typography/text_style_basic_showcase.dart';
import '../showcases/typography/richtext_basic_showcase.dart';
import '../showcases/typography/image_basic_showcase.dart';
import '../showcases/typography/icon_basic_showcase.dart';
import '../showcases/typography/circle_avatar_basic_showcase.dart';
import '../showcases/typography/clip_rrect_oval_basic_showcase.dart';
import '../showcases/typography/hero_basic_showcase.dart';

// Buttons Showcases
import '../showcases/buttons/material_buttons_basic_showcase.dart';
import '../showcases/buttons/fab_basic_showcase.dart';
import '../showcases/buttons/segmented_button_basic_showcase.dart';
import '../showcases/buttons/gesture_inkwell_basic_showcase.dart';
import '../showcases/buttons/animated_container_basic_showcase.dart';
import '../showcases/buttons/navigation_bar_basic_showcase.dart';
import '../showcases/buttons/tabbar_tabview_basic_showcase.dart';

// Inputs Showcases
import '../showcases/inputs/textfield_basic_showcase.dart';
import '../showcases/inputs/checkbox_switch_radio_basic_showcase.dart';
import '../showcases/inputs/slider_basic_showcase.dart';
import '../showcases/inputs/dropdown_basic_showcase.dart';

// Lists Showcases
import '../showcases/lists/listview_basic_showcase.dart';
import '../showcases/lists/gridview_basic_showcase.dart';
import '../showcases/lists/listtile_card_basic_showcase.dart';
import '../showcases/lists/divider_basic_showcase.dart';
import '../showcases/lists/datatable_basic_showcase.dart';
import '../showcases/lists/refresh_indicator_basic_showcase.dart';
import '../showcases/lists/dismissible_basic_showcase.dart';

// Feedback Showcases
import '../showcases/feedback/dialog_basic_showcase.dart';
import '../showcases/feedback/snackbar_basic_showcase.dart';
import '../showcases/feedback/bottom_sheet_basic_showcase.dart';
import '../showcases/feedback/progress_indicator_basic_showcase.dart';
import '../showcases/feedback/tooltip_badge_basic_showcase.dart';

class BasicWidgetsData {
  static final List<BasicWidgetModel> allWidgets = [
    // ==========================================
    // 1. LAYOUT & STRUCTURE
    // ==========================================
    BasicWidgetModel(
      id: 'container',
      name: 'Container',
      category: BasicWidgetCategory.layout,
      icon: Icons.check_box_outline_blank_rounded,
      summary:
          'Widget kotak serbaguna pengatur ukuran, padding, margin, border, warna, dan dekorasi.',
      description:
          'Container adalah widget dasar paling populer di Flutter yang menggabungkan kemampuan melukis (painting), penataan posisi (positioning), dan ukuran (sizing). Di dalamnya terdapat perpaduan widget Padding, Align, DecoratedBox, ConstrainedBox, dan Transform.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'width / height',
          type: 'double?',
          description: 'Dimensi lebar dan tinggi kotak',
        ),
        BasicWidgetProperty(
          name: 'padding',
          type: 'EdgeInsetsGeometry?',
          description: 'Jarak bagian dalam kotak ke child',
        ),
        BasicWidgetProperty(
          name: 'margin',
          type: 'EdgeInsetsGeometry?',
          description: 'Jarak bagian luar kotak ke widget sekitarnya',
        ),
        BasicWidgetProperty(
          name: 'decoration',
          type: 'Decoration?',
          description:
              'BoxDecoration untuk border, warna, borderRadius, dan shadow',
        ),
        BasicWidgetProperty(
          name: 'alignment',
          type: 'AlignmentGeometry?',
          description: 'Posisi child di dalam container',
        ),
      ],
      codeSnippet: '''
Container(
  width: 200,
  height: 120,
  padding: const EdgeInsets.all(16),
  margin: const EdgeInsets.all(8),
  alignment: Alignment.center,
  decoration: BoxDecoration(
    color: Colors.indigo,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.indigo.withOpacity(0.3),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: const Text('Hello Container', style: TextStyle(color: Colors.white)),
)''',
      usageTips: const [
        'Jangan berikan color: Colors.blue jika sudah ada decoration: BoxDecoration(...). Letakkan color di dalam BoxDecoration.',
        'Jika hanya butuh memberi jarak tanpa dekorasi, gunakan SizedBox atau Padding agar rendering lebih ringan.',
      ],
      previewBuilder: (context) => const ContainerBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'row_column',
      name: 'Row & Column',
      category: BasicWidgetCategory.layout,
      icon: Icons.view_column_rounded,
      summary:
          'Menyusun daftar widget child secara horizontal (Row) atau vertikal (Column).',
      description:
          'Row dan Column adalah fondasi layout linear di Flutter. Row menyusun child di sumbu horizontal (X-axis), sedangkan Column menyusun child di sumbu vertikal (Y-axis). Pengaturan jarak dan perataan dikendalikan lewat mainAxisAlignment dan crossAxisAlignment.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'mainAxisAlignment',
          type: 'MainAxisAlignment',
          description:
              'Perataan child di sepanjang sumbu utama (start, center, spaceBetween, dll)',
          defaultValue: 'start',
        ),
        BasicWidgetProperty(
          name: 'crossAxisAlignment',
          type: 'CrossAxisAlignment',
          description: 'Perataan child di sumbu silang tegak lurus',
          defaultValue: 'center',
        ),
        BasicWidgetProperty(
          name: 'mainAxisSize',
          type: 'MainAxisSize',
          description:
              'Apakah mengambil ruang maksimal (max) atau membungkus child (min)',
          defaultValue: 'max',
        ),
        BasicWidgetProperty(
          name: 'children',
          type: 'List<Widget>',
          description: 'Daftar widget yang akan disusun berurutan',
        ),
      ],
      codeSnippet: '''
// Horizontal Layout
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: const [
    Icon(Icons.star),
    Text('Rating 5.0'),
    Icon(Icons.chevron_right),
  ],
)

// Vertical Layout
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: const [
    Text('Judul Utama', style: TextStyle(fontWeight: FontWeight.bold)),
    SizedBox(height: 4),
    Text('Sub-deskripsi konten'),
  ],
)''',
      usageTips: const [
        'Hati-hati RenderFlex overflow! Jika child di dalam Row teksnya panjang, bungkus dengan Expanded atau Flexible.',
        'Gunakan mainAxisSize: MainAxisSize.min jika Column berada di dalam BottomSheet atau Card agar tidak memakan seluruh tinggi layar.',
      ],
      previewBuilder: (context) => const RowColumnBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'stack_positioned',
      name: 'Stack & Positioned',
      category: BasicWidgetCategory.layout,
      icon: Icons.layers_rounded,
      summary:
          'Menumpuk widget berlapis-lapis secara z-index dan menentukan koordinatnya.',
      description:
          'Stack memungkinkan widget diletakkan saling tumpang tindih dari bawah ke atas. Widget pertama adalah layer paling dasar, dan widget terakhir berada di layer paling atas. Gunakan widget Positioned untuk menempatkan child pada koordinat presisi (top, left, right, bottom).',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'alignment',
          type: 'AlignmentGeometry',
          description: 'Perataan untuk child yang non-positioned',
          defaultValue: 'topStart',
        ),
        BasicWidgetProperty(
          name: 'clipBehavior',
          type: 'Clip',
          description:
              'Memotong child yang keluar dari batas Stack (Clip.hardEdge atau Clip.none)',
          defaultValue: 'hardEdge',
        ),
        BasicWidgetProperty(
          name: 'Positioned (top/left/right/bottom)',
          type: 'double?',
          description: 'Jarak piksel dari tepi Stack',
        ),
      ],
      codeSnippet: '''
Stack(
  clipBehavior: Clip.none,
  children: [
    Container(
      width: 200,
      height: 120,
      color: Colors.blue.shade100,
    ),
    Positioned(
      top: -10,
      right: -10,
      child: CircleAvatar(
        radius: 14,
        backgroundColor: Colors.red,
        child: Text('3', style: TextStyle(color: Colors.white, fontSize: 11)),
      ),
    ),
  ],
)''',
      usageTips: const [
        'Widget Positioned hanya boleh diletakkan sebagai direct child dari Stack.',
        'Jika ingin overlay keluar dari batas container (misal badge mengambang), ubah clipBehavior menjadi Clip.none.',
      ],
      previewBuilder: (context) => const StackPositionedBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'expanded_flexible',
      name: 'Expanded, Flexible & Spacer',
      category: BasicWidgetCategory.layout,
      icon: Icons.unfold_more_rounded,
      summary:
          'Membagi ruang kosong di dalam Row atau Column secara proporsional sesuai rasio flex.',
      description:
          'Expanded memaksa child mengisi seluruh sisa ruang yang tersedia di Row/Column. Flexible memberikan fleksibilitas apakah child harus memenuhi ruang (FlexFit.tight) atau cukup seperlunya (FlexFit.loose). Spacer adalah shorthand praktis untuk Expanded(child: SizedBox()).',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'flex',
          type: 'int',
          description: 'Faktor bobot proporsi ruang (default 1)',
          defaultValue: '1',
        ),
        BasicWidgetProperty(
          name: 'fit',
          type: 'FlexFit',
          description:
              'FlexFit.tight (isi penuh) vs FlexFit.loose (maksimal seperlunya)',
          defaultValue: 'tight',
        ),
      ],
      codeSnippet: '''
Row(
  children: [
    Expanded(
      flex: 2, // Mengambil 2/3 ruang
      child: Container(color: Colors.blue, height: 50),
    ),
    const SizedBox(width: 8),
    Expanded(
      flex: 1, // Mengambil 1/3 ruang
      child: Container(color: Colors.green, height: 50),
    ),
  ],
)''',
      usageTips: const [
        'Expanded dan Flexible HANYA boleh diletakkan di dalam Row, Column, atau Flex.',
        'Gunakan Spacer() jika Anda hanya ingin mendorong widget ke ujung kanan/kiri di dalam Row.',
      ],
      previewBuilder: (context) => const ExpandedFlexibleBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'wrap',
      name: 'Wrap',
      category: BasicWidgetCategory.layout,
      icon: Icons.wrap_text_rounded,
      summary:
          'Menyusun widget horizontal/vertikal dan otomatis pindah ke baris baru saat tidak muat.',
      description:
          'Berbeda dengan Row yang akan menyebabkan RenderFlex overflow jika isinya melebihi lebar layar, Wrap akan secara otomatis memindahkan widget berikutnya ke baris (atau kolom) baru di bawahnya.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'spacing',
          type: 'double',
          description: 'Jarak horizontal antar widget di baris yang sama',
          defaultValue: '0.0',
        ),
        BasicWidgetProperty(
          name: 'runSpacing',
          type: 'double',
          description: 'Jarak vertikal antar baris baru',
          defaultValue: '0.0',
        ),
        BasicWidgetProperty(
          name: 'alignment',
          type: 'WrapAlignment',
          description: 'Perataan widget di setiap baris',
          defaultValue: 'start',
        ),
      ],
      codeSnippet: '''
Wrap(
  spacing: 8.0, // horizontal gap
  runSpacing: 8.0, // vertical gap
  children: [
    Chip(label: Text('Flutter')),
    Chip(label: Text('Dart')),
    Chip(label: Text('Stateful')),
    Chip(label: Text('Material 3')),
  ],
)''',
      usageTips: const [
        'Sangat ideal untuk daftar Tags, Filter Chips, Kategori Produk, atau Badges dinamis.',
      ],
      previewBuilder: (context) => const WrapBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'align_center',
      name: 'Align & Center',
      category: BasicWidgetCategory.layout,
      icon: Icons.center_focus_strong_rounded,
      summary: 'Menentukan letak perataan posisi child di dalam parent-nya.',
      description:
          'Align menempatkan child pada posisi tertentu di dalam dirinya sendiri dan menyesuaikan ukurannya berdasarkan ukuran child. Center adalah subclass khusus dari Align dengan alignment: Alignment.center.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'alignment',
          type: 'AlignmentGeometry',
          description: 'Posisi perataan (center, topLeft, bottomRight, dll)',
          defaultValue: 'center',
        ),
        BasicWidgetProperty(
          name: 'widthFactor / heightFactor',
          type: 'double?',
          description: 'Pengali ukuran parent terhadap child',
        ),
      ],
      codeSnippet: '''
// Center child
Center(
  child: Text('Tepat di Tengah Layar'),
)

// Custom Alignment
Align(
  alignment: Alignment.topRight,
  child: IconButton(
    icon: Icon(Icons.close),
    onPressed: () {},
  ),
)''',
      usageTips: const [
        'Gunakan Alignment(x, y) dengan nilai antara -1.0 s/d 1.0 untuk koordinat presisi.',
      ],
      previewBuilder: (context) => const AlignCenterBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'sizedbox_padding',
      name: 'SizedBox & Padding',
      category: BasicWidgetCategory.layout,
      icon: Icons.space_bar_rounded,
      summary:
          'Memberikan dimensi ukuran pasti atau jarak ruang kosong di sekeliling widget.',
      description:
          'SizedBox memberikan ukuran lebar atau tinggi yang tetap untuk child atau sebagai pemisah (spacer). Padding memberikan ruang jarak di dalam boundary widget.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'SizedBox.width / height',
          type: 'double?',
          description: 'Dimensi lebar dan tinggi fixed',
        ),
        BasicWidgetProperty(
          name: 'Padding.padding',
          type: 'EdgeInsetsGeometry',
          description: 'EdgeInsets.all, .symmetric, atau .only',
        ),
      ],
      codeSnippet: '''
// SizedBox sebagai spacer
Column(
  children: [
    Text('Item 1'),
    const SizedBox(height: 16), // Jarak 16px
    Text('Item 2'),
  ],
)

// Padding
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: Text('Konten dengan padding aman'),
)''',
      usageTips: const [
        'Gunakan const SizedBox(...) di mana saja untuk menghemat alokasi memori saat build widget tree.',
      ],
      previewBuilder: (context) => const SizedBoxPaddingBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'single_child_scrollview',
      name: 'SingleChildScrollView',
      category: BasicWidgetCategory.layout,
      icon: Icons.swap_vert_rounded,
      summary:
          'Membuat satu kotak widget dapat digulir jika ukurannya melebihi layar.',
      description:
          'SingleChildScrollView membungkus satu child (biasanya Column) agar dapat di-scroll saat keyboard muncul atau saat layar perangkat kecil, mencegah RenderFlex overflow.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'scrollDirection',
          type: 'Axis',
          description: 'Arah scroll (Axis.vertical atau Axis.horizontal)',
          defaultValue: 'vertical',
        ),
        BasicWidgetProperty(
          name: 'physics',
          type: 'ScrollPhysics?',
          description:
              'BouncingScrollPhysics (iOS style) atau ClampingScrollPhysics (Android style)',
        ),
        BasicWidgetProperty(
          name: 'padding',
          type: 'EdgeInsetsGeometry?',
          description: 'Padding di dalam viewport scroll',
        ),
      ],
      codeSnippet: '''
SingleChildScrollView(
  physics: const BouncingScrollPhysics(),
  padding: const EdgeInsets.all(16),
  child: Column(
    children: [
      TextField(),
      TextField(),
      ElevatedButton(onPressed: () {}, child: Text('Submit')),
    ],
  ),
)''',
      usageTips: const [
        'Untuk daftar data dinamis yang panjang ratusan item, gunakan ListView.builder bukan SingleChildScrollView agar memori efisien.',
      ],
      previewBuilder: (context) => const SingleChildScrollViewBasicShowcase(),
    ),

    // ==========================================
    // 2. TYPOGRAPHY & MEDIA
    // ==========================================
    BasicWidgetModel(
      id: 'text_style',
      name: 'Text & TextStyle',
      category: BasicWidgetCategory.typography,
      icon: Icons.title_rounded,
      summary:
          'Menampilkan teks dengan format ukuran, bobot huruf, warna, dan dekorasi.',
      description:
          'Text adalah widget paling fundamental untuk menampilkan deretan karakter string. Melalui TextStyle, developer dapat menyesuaikan fontSize, fontWeight, color, letterSpacing, line height, dan text decoration.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'style',
          type: 'TextStyle?',
          description: 'Konfigurasi font, ukuran, bobot, warna, dll',
        ),
        BasicWidgetProperty(
          name: 'maxLines',
          type: 'int?',
          description: 'Batas maksimal baris teks',
        ),
        BasicWidgetProperty(
          name: 'overflow',
          type: 'TextOverflow',
          description: 'TextOverflow.ellipsis (...) jika teks terpotong',
          defaultValue: 'clip',
        ),
        BasicWidgetProperty(
          name: 'textAlign',
          type: 'TextAlign',
          description: 'Rata kiri, kanan, tengah, atau justify',
          defaultValue: 'start',
        ),
      ],
      codeSnippet: '''
Text(
  'Selamat Datang di Flutter!',
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  textAlign: TextAlign.center,
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.indigo,
    letterSpacing: 0.5,
  ),
)''',
      usageTips: const [
        'Selalu tentukan maxLines dan overflow: TextOverflow.ellipsis jika teks berasal dari API dinamis agar tidak overflow.',
      ],
      previewBuilder: (context) => const TextStyleBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'richtext',
      name: 'RichText & TextSpan',
      category: BasicWidgetCategory.typography,
      icon: Icons.format_color_text_rounded,
      summary:
          'Menggabungkan beberapa potongan teks dengan style dan interaksi berbeda dalam satu paragraf.',
      description:
          'RichText (atau Text.rich) memungkinkan pembuatan teks multi-style di mana sebagian kata tebal, sebagian berwarna biru sebagai tautan yang bisa diklik, atau menyematkan icon inline via WidgetSpan.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'text',
          type: 'InlineSpan',
          description: 'TextSpan root beserta daftar children TextSpan',
        ),
        BasicWidgetProperty(
          name: 'WidgetSpan',
          type: 'InlineSpan',
          description:
              'Menyematkan widget apapun (icon, button, badge) di dalam teks',
        ),
      ],
      codeSnippet: '''
Text.rich(
  TextSpan(
    text: 'Belum punya akun? ',
    style: TextStyle(color: Colors.grey),
    children: [
      TextSpan(
        text: 'Daftar Sekarang',
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
    ],
  ),
)''',
      usageTips: const [
        'Gunakan `Text.rich(...)` karena mewarisi DefaultTextStyle dari context secara otomatis.',
      ],
      previewBuilder: (context) => const RichTextBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'image',
      name: 'Image & BoxFit',
      category: BasicWidgetCategory.typography,
      icon: Icons.image_rounded,
      summary:
          'Menampilkan gambar dari asset lokal, file, memori, atau URL network.',
      description:
          'Image widget mendukung Image.asset, Image.network, Image.file, dan Image.memory. Mengatur penskalaan gambar dilakukan melalui BoxFit (cover, contain, fill, fitWidth).',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'fit',
          type: 'BoxFit',
          description:
              'BoxFit.cover, contain, fill, fitWidth, fitHeight, scaleDown',
          defaultValue: 'contain',
        ),
        BasicWidgetProperty(
          name: 'errorBuilder',
          type: 'ImageErrorWidgetBuilder?',
          description: 'Widget fallback jika gagal memuat gambar',
        ),
        BasicWidgetProperty(
          name: 'loadingBuilder',
          type: 'ImageLoadingBuilder?',
          description: 'Widget indikator progress saat memuat',
        ),
      ],
      codeSnippet: '''
Image.network(
  'https://picsum.photos/300/200',
  width: double.infinity,
  height: 180,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) => Container(
    color: Colors.grey.shade200,
    child: Icon(Icons.broken_image, color: Colors.grey),
  ),
)''',
      usageTips: const [
        'Bungkus Image dengan ClipRRect(borderRadius: BorderRadius.circular(...)) untuk memberi sudut melengkung pada gambar.',
      ],
      previewBuilder: (context) => const ImageBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'icon',
      name: 'Icon & IconButton',
      category: BasicWidgetCategory.typography,
      icon: Icons.star_outline_rounded,
      summary:
          'Menampilkan glyph icon vektor Material Icons dan tombol interaktif icon.',
      description:
          'Icon merender glyph visual dari font ikon (Icons.*). IconButton membungkus Icon dengan interaksi tap dan efek ripple Material Design.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'icon',
          type: 'IconData',
          description: 'Nama ikon dari class Icons (misal Icons.favorite)',
        ),
        BasicWidgetProperty(
          name: 'size',
          type: 'double?',
          description: 'Ukuran ikon dalam logical pixels (default 24)',
        ),
        BasicWidgetProperty(
          name: 'color',
          type: 'Color?',
          description: 'Warna ikon',
        ),
        BasicWidgetProperty(
          name: 'tooltip',
          type: 'String?',
          description: 'Deskripsi aksesibilitas dan teks hover',
        ),
      ],
      codeSnippet: '''
IconButton(
  icon: const Icon(Icons.favorite_rounded),
  color: Colors.red,
  iconSize: 28,
  tooltip: 'Sukai Konten',
  onPressed: () {
    print('Disukai!');
  },
)''',
      usageTips: const [
        'Selalu berikan parameter tooltip pada IconButton demi keramahan aksesibilitas screen reader.',
      ],
      previewBuilder: (context) => const IconBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'circle_avatar',
      name: 'CircleAvatar',
      category: BasicWidgetCategory.typography,
      icon: Icons.account_circle_rounded,
      summary: 'Lingkaran foto profil pengguna atau inisial nama.',
      description:
          'CircleAvatar adalah widget bawaan Flutter untuk menampilkan gambar profil bundar, inisial huruf nama, atau icon avatar dengan radius yang dapat disesuaikan.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'radius',
          type: 'double',
          description: 'Jari-jari lingkaran avatar (default 20.0)',
          defaultValue: '20.0',
        ),
        BasicWidgetProperty(
          name: 'backgroundImage',
          type: 'ImageProvider?',
          description: 'NetworkImage atau AssetImage untuk foto profil',
        ),
        BasicWidgetProperty(
          name: 'backgroundColor',
          type: 'Color?',
          description: 'Warna latar jika tidak ada gambar',
        ),
      ],
      codeSnippet: '''
CircleAvatar(
  radius: 28,
  backgroundColor: Colors.indigo,
  child: Text('ZS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
)''',
      usageTips: const [
        'Gabungkan dengan Stack dan Positioned jika ingin menambahkan badge indikator status online berwarna hijau di sudut avatar.',
      ],
      previewBuilder: (context) => const CircleAvatarBasicShowcase(),
    ),

    // ==========================================
    // 3. BUTTONS & INTERACTIONS
    // ==========================================
    BasicWidgetModel(
      id: 'material_buttons',
      name: 'Elevated, Filled & Outlined Button',
      category: BasicWidgetCategory.buttons,
      icon: Icons.smart_button_rounded,
      summary:
          'Kumpulan tombol Material Design 3 untuk aksi utama dan sekunder.',
      description:
          'Flutter menyediakan berbagai varian tombol: ElevatedButton (dengan bayangan), FilledButton (kontras tegas M3), FilledButton.tonal (kontras lembut), OutlinedButton (garis tepi), dan TextButton (tanpa background).',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'onPressed',
          type: 'VoidCallback?',
          description:
              'Callback saat tombol ditekan (jika null, tombol disabled)',
        ),
        BasicWidgetProperty(
          name: 'style',
          type: 'ButtonStyle?',
          description:
              'Kustomisasi warna, padding, bentuk sudut, dan elevation',
        ),
        BasicWidgetProperty(
          name: 'icon',
          type: 'Widget?',
          description: 'Ikon tombol via constructor .icon(...)',
        ),
      ],
      codeSnippet: '''
// Primary Action
FilledButton.icon(
  onPressed: () {},
  icon: const Icon(Icons.send),
  label: const Text('Kirim'),
)

// Secondary Action
OutlinedButton(
  onPressed: () {},
  child: const Text('Batal'),
)''',
      usageTips: const [
        'Untuk membuat tombol berstatus disabled, cukup kirimkan onPressed: null.',
      ],
      previewBuilder: (context) => const MaterialButtonsBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'fab',
      name: 'FloatingActionButton',
      category: BasicWidgetCategory.buttons,
      icon: Icons.add_circle_outline_rounded,
      summary: 'Tombol aksi melayang utama aplikasi (Primary Call to Action).',
      description:
          'FloatingActionButton (FAB) adalah tombol melayang melingkar di atas UI untuk aksi terpenting di halaman (misal: buat postingan baru, tambah item). Mendukung FAB standar, mini (.small), dan extended (.extended).',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'heroTag',
          type: 'Object?',
          description: 'Tag animasi Hero (wajib unik jika ada >1 FAB)',
        ),
        BasicWidgetProperty(
          name: 'backgroundColor',
          type: 'Color?',
          description: 'Warna latar tombol',
        ),
        BasicWidgetProperty(
          name: 'elevation',
          type: 'double',
          description: 'Tinggi bayangan melayang (default 6.0)',
          defaultValue: '6.0',
        ),
      ],
      codeSnippet: '''
FloatingActionButton.extended(
  onPressed: () {},
  icon: const Icon(Icons.add),
  label: const Text('Tambah Baru'),
  backgroundColor: Colors.indigo,
)''',
      usageTips: const [
        'Gunakan Scaffold(floatingActionButton: ...) agar otomatis diposisikan dengan rapi sesuai standar Material.',
      ],
      previewBuilder: (context) => const FabBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'segmented_button',
      name: 'SegmentedButton',
      category: BasicWidgetCategory.buttons,
      icon: Icons.splitscreen_rounded,
      summary:
          'Komponen Material 3 untuk memilih satu atau beberapa opsi tersegmentasi.',
      description:
          'SegmentedButton adalah penerus modern dari ToggleButtons di Material 3. Menggunakan Set<T> yang type-safe dan mendukung single maupun multiple selection.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'segments',
          type: 'List<ButtonSegment<T>>',
          description: 'Daftar segmen opsi dengan value, icon, dan label',
        ),
        BasicWidgetProperty(
          name: 'selected',
          type: 'Set<T>',
          description: 'Kumpulan nilai opsi yang sedang aktif terpilih',
        ),
        BasicWidgetProperty(
          name: 'multiSelectionEnabled',
          type: 'bool',
          description: 'Apakah boleh memilih lebih dari satu segmen',
          defaultValue: 'false',
        ),
      ],
      codeSnippet: '''
SegmentedButton<String>(
  segments: const [
    ButtonSegment(value: 'day', label: Text('Hari')),
    ButtonSegment(value: 'week', label: Text('Minggu')),
    ButtonSegment(value: 'month', label: Text('Bulan')),
  ],
  selected: {_selectedMode},
  onSelectionChanged: (newSet) => setState(() => _selectedMode = newSet.first),
)''',
      usageTips: const [
        'Sangat cocok untuk filter rentang waktu (Day/Week/Month) atau mode tampilan.',
      ],
      previewBuilder: (context) => const SegmentedButtonBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'gesture_inkwell',
      name: 'GestureDetector & InkWell',
      category: BasicWidgetCategory.buttons,
      icon: Icons.touch_app_rounded,
      summary:
          'Mendeteksi sentuhan tap, double tap, long press, pan, drag, dan efek ripple.',
      description:
          'GestureDetector mendeteksi semua interaksi sentuh tingkat rendah. InkWell membungkus gesture tap dengan efek gelombang riak air (ripple wave) khas Material Design.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'onTap',
          type: 'VoidCallback?',
          description: 'Aksi saat disentuh satu kali',
        ),
        BasicWidgetProperty(
          name: 'onDoubleTap',
          type: 'VoidCallback?',
          description: 'Aksi saat disentuh dua kali cepat',
        ),
        BasicWidgetProperty(
          name: 'onLongPress',
          type: 'VoidCallback?',
          description: 'Aksi saat disentuh dan ditahan',
        ),
      ],
      codeSnippet: '''
InkWell(
  onTap: () => print('Card tapped!'),
  borderRadius: BorderRadius.circular(12),
  splashColor: Colors.indigo.withOpacity(0.2),
  child: Container(
    padding: const EdgeInsets.all(16),
    child: const Text('Klik saya dengan efek ripple!'),
  ),
)''',
      usageTips: const [
        'Agar efek ripple InkWell terlihat di atas Container yang memiliki warna, gunakan Ink(...) di dalamnya atau letakkan warna di Material(color: ...).',
      ],
      previewBuilder: (context) => const GestureInkwellBasicShowcase(),
    ),

    // ==========================================
    // 4. FORMS & INPUTS
    // ==========================================
    BasicWidgetModel(
      id: 'textfield',
      name: 'TextField & InputDecoration',
      category: BasicWidgetCategory.inputs,
      icon: Icons.edit_note_rounded,
      summary:
          'Kotak input teks pengguna dengan dekorasi label, icon, hint, dan validasi.',
      description:
          'TextField dan TextFormField menerima input teks keyboard dari pengguna. Melalui InputDecoration, tampilan kotak input dapat disesuaikan dengan border, warna filled, prefixIcon, suffixIcon, dan error message.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'controller',
          type: 'TextEditingController?',
          description:
              'Controller untuk membaca atau mengubah teks secara programmatic',
        ),
        BasicWidgetProperty(
          name: 'obscureText',
          type: 'bool',
          description: 'Menyembunyikan teks dengan bulatan (untuk password)',
          defaultValue: 'false',
        ),
        BasicWidgetProperty(
          name: 'decoration',
          type: 'InputDecoration',
          description: 'Label, hint, prefixIcon, suffixIcon, border, filled',
        ),
        BasicWidgetProperty(
          name: 'keyboardType',
          type: 'TextInputType?',
          description: 'Jenis keyboard (emailAddress, number, phone, dll)',
        ),
      ],
      codeSnippet: '''
TextField(
  controller: _emailController,
  keyboardType: TextInputType.emailAddress,
  decoration: InputDecoration(
    labelText: 'Alamat Email',
    hintText: 'nama@domain.com',
    prefixIcon: const Icon(Icons.email_outlined),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    filled: true,
  ),
)''',
      usageTips: const [
        'Selalu panggil controller.dispose() di dalam lifecycle dispose() State untuk mencegah memory leak.',
      ],
      previewBuilder: (context) => const TextFieldBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'checkbox_switch_radio',
      name: 'Checkbox, Switch & Radio',
      category: BasicWidgetCategory.inputs,
      icon: Icons.check_circle_outline_rounded,
      summary:
          'Komponen input pemilihan boolean toggle, centang persetujuan, dan opsi tunggal.',
      description:
          'Checkbox digunakan untuk opsi ya/tidak atau persetujuan. Switch digunakan untuk toggle on/off pengaturan instan. Radio digunakan untuk memilih satu opsi eksklusif dari beberapa pilihan.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'Checkbox.value',
          type: 'bool?',
          description: 'Nilai status checked',
        ),
        BasicWidgetProperty(
          name: 'Switch.value',
          type: 'bool',
          description: 'Nilai status toggle on/off',
        ),
        BasicWidgetProperty(
          name: 'Radio.groupValue',
          type: 'T',
          description: 'Nilai opsi yang saat ini aktif di grup radio',
        ),
      ],
      codeSnippet: '''
// Checkbox ListTile
CheckboxListTile(
  value: _agreed,
  title: const Text('Setujui syarat & ketentuan'),
  onChanged: (val) => setState(() => _agreed = val ?? false),
)

// Switch
Switch(
  value: _isDarkMode,
  onChanged: (val) => setState(() => _isDarkMode = val),
)''',
      usageTips: const [
        'Gunakan varian CheckboxListTile, SwitchListTile, dan RadioListTile agar area sentuh mencakup seluruh baris beserta teks label.',
      ],
      previewBuilder: (context) => const CheckboxSwitchRadioBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'slider',
      name: 'Slider & RangeSlider',
      category: BasicWidgetCategory.inputs,
      icon: Icons.tune_rounded,
      summary:
          'Memilih nilai numerik berkelanjutan atau bertingkat melalui geseran jari.',
      description:
          'Slider memungkinkan pengguna memilih satu nilai dari rentang min s/d max. RangeSlider memungkinkan pemilihan dua nilai sekaligus (rentang awal dan rentang akhir).',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'value',
          type: 'double',
          description: 'Nilai slider saat ini',
        ),
        BasicWidgetProperty(
          name: 'min / max',
          type: 'double',
          description: 'Nilai batas minimum dan maksimum (default 0.0 s/d 1.0)',
        ),
        BasicWidgetProperty(
          name: 'divisions',
          type: 'int?',
          description:
              'Jumlah langkah diskrit jika ingin nilai bulat bertingkat',
        ),
        BasicWidgetProperty(
          name: 'label',
          type: 'String?',
          description: 'Teks tooltip pop-up saat slider digeser',
        ),
      ],
      codeSnippet: '''
Slider(
  value: _volume,
  min: 0,
  max: 100,
  divisions: 10,
  label: '\${_volume.round()}%',
  activeColor: Colors.indigo,
  onChanged: (newVal) => setState(() => _volume = newVal),
)''',
      usageTips: const [
        'Pastikan nilai value selalu berada di antara min dan max untuk menghindari assertion failure crash.',
      ],
      previewBuilder: (context) => const SliderBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'dropdown',
      name: 'DropdownButton',
      category: BasicWidgetCategory.inputs,
      icon: Icons.arrow_drop_down_circle_rounded,
      summary:
          'Menu pilihan pop-up dropdown untuk memilih satu item dari daftar.',
      description:
          'DropdownButton menampilkan nilai terpilih saat ini dan membuka menu overlay popup saat disentuh. DropdownButtonFormField mengintegrasikannya dengan Form validator.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'value',
          type: 'T?',
          description: 'Item yang sedang terpilih saat ini',
        ),
        BasicWidgetProperty(
          name: 'items',
          type: 'List<DropdownMenuItem<T>>?',
          description: 'Daftar menu pilihan',
        ),
        BasicWidgetProperty(
          name: 'onChanged',
          type: 'ValueChanged<T?>?',
          description: 'Callback saat item baru dipilih',
        ),
      ],
      codeSnippet: '''
DropdownButton<String>(
  value: _selectedCity,
  items: ['Jakarta', 'Bandung', 'Surabaya'].map((city) {
    return DropdownMenuItem(value: city, child: Text(city));
  }).toList(),
  onChanged: (newVal) => setState(() => _selectedCity = newVal),
)''',
      usageTips: const [
        'Pastikan nilai value ada di dalam daftar items atau bernilai null, jika tidak Flutter akan melempar assertion error.',
      ],
      previewBuilder: (context) => const DropdownBasicShowcase(),
    ),

    // ==========================================
    // 5. LISTS, GRIDS & TABLES
    // ==========================================
    BasicWidgetModel(
      id: 'listview',
      name: 'ListView',
      category: BasicWidgetCategory.lists,
      icon: Icons.view_list_rounded,
      summary: 'Daftar scrollable linear dengan render lazy yang hemat memori.',
      description:
          'ListView adalah widget scrollable paling sering digunakan di Flutter. Dengan ListView.builder, hanya item yang terlihat di viewport layar yang akan di-render ke memori.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'itemCount',
          type: 'int?',
          description: 'Jumlah total item di dalam list',
        ),
        BasicWidgetProperty(
          name: 'itemBuilder',
          type: 'NullableIndexedWidgetBuilder',
          description: 'Fungsi pembuat widget per index',
        ),
        BasicWidgetProperty(
          name: 'separatorBuilder',
          type: 'IndexedWidgetBuilder',
          description: 'Pemisah antar item (khusus ListView.separated)',
        ),
      ],
      codeSnippet: '''
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text('Item #\${index + 1}'),
      leading: const Icon(Icons.star),
    );
  },
)''',
      usageTips: const [
        'Jika ListView diletakkan di dalam Column, bungkus ListView dengan Expanded atau berikan shrinkWrap: true.',
      ],
      previewBuilder: (context) => const ListViewBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'gridview',
      name: 'GridView',
      category: BasicWidgetCategory.lists,
      icon: Icons.grid_view_rounded,
      summary:
          'Menyusun item dalam bentuk grid multi-kolom 2 dimensi yang dapat di-scroll.',
      description:
          'GridView menyusun widget dalam kisi-kisi dua dimensi. Menggunakan GridView.count atau GridView.builder dengan SliverGridDelegateWithFixedCrossAxisCount.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'crossAxisCount',
          type: 'int',
          description: 'Jumlah kolom dalam satu baris grid',
        ),
        BasicWidgetProperty(
          name: 'childAspectRatio',
          type: 'double',
          description:
              'Rasio perbandingan lebar terhadap tinggi item (width / height)',
          defaultValue: '1.0',
        ),
        BasicWidgetProperty(
          name: 'crossAxisSpacing / mainAxisSpacing',
          type: 'double',
          description: 'Jarak renggang horizontal dan vertikal antar item',
        ),
      ],
      codeSnippet: '''
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    childAspectRatio: 1.2,
  ),
  itemCount: 8,
  itemBuilder: (context, index) {
    return Card(child: Center(child: Text('Card #\${index + 1}')));
  },
)''',
      usageTips: const [
        'Gunakan childAspectRatio untuk mengatur proporsi tinggi kartu agar pas dan tidak overflow.',
      ],
      previewBuilder: (context) => const GridViewBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'listtile_card',
      name: 'ListTile & Card',
      category: BasicWidgetCategory.lists,
      icon: Icons.credit_card_rounded,
      summary:
          'Baris standar berisi leading icon, title, subtitle, trailing action, dan kartu elevasi.',
      description:
          'ListTile adalah komponen baris standar Material Design yang memiliki slot leading, title, subtitle, dan trailing. Card memberikan permukaan berelevasi dengan bayangan halus dan sudut melengkung.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'leading',
          type: 'Widget?',
          description: 'Widget di sisi paling kiri (avatar, icon)',
        ),
        BasicWidgetProperty(
          name: 'title / subtitle',
          type: 'Widget?',
          description: 'Judul utama dan baris deskripsi tambahan',
        ),
        BasicWidgetProperty(
          name: 'trailing',
          type: 'Widget?',
          description: 'Widget di sisi paling kanan (panah, badge, switch)',
        ),
        BasicWidgetProperty(
          name: 'Card.elevation',
          type: 'double?',
          description: 'Tinggi bayangan kartu di atas latar',
        ),
      ],
      codeSnippet: '''
Card(
  elevation: 3,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  child: ListTile(
    leading: const CircleAvatar(child: Icon(Icons.person)),
    title: const Text('Zainal Salamun'),
    subtitle: const Text('Flutter Developer'),
    trailing: const Icon(Icons.chevron_right),
    onTap: () {},
  ),
)''',
      usageTips: const [
        'ListTile sudah memiliki built-in padding dan touch target yang memenuhi pedoman Material Design.',
      ],
      previewBuilder: (context) => const ListTileCardBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'divider',
      name: 'Divider & VerticalDivider',
      category: BasicWidgetCategory.lists,
      icon: Icons.horizontal_rule_rounded,
      summary:
          'Garis tipis pemisah visual antar konten secara horizontal maupun vertikal.',
      description:
          'Divider menggambar garis pemisah horizontal tipis. VerticalDivider menggambar garis vertikal di dalam Row yang dibungkus IntrinsicHeight.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'thickness',
          type: 'double?',
          description: 'Ketebalan garis pemisah',
        ),
        BasicWidgetProperty(
          name: 'indent / endIndent',
          type: 'double?',
          description:
              'Jarak indentasi ruang kosong di pangkal dan ujung garis',
        ),
        BasicWidgetProperty(
          name: 'color',
          type: 'Color?',
          description: 'Warna garis',
        ),
      ],
      codeSnippet: '''
Divider(
  thickness: 1.5,
  indent: 16,
  endIndent: 16,
  color: Colors.grey.shade300,
)''',
      usageTips: const [
        'Untuk VerticalDivider di dalam Row, bungkus Row dengan IntrinsicHeight agar tinggi garis terdefinisi.',
      ],
      previewBuilder: (context) => const DividerBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'datatable',
      name: 'DataTable',
      category: BasicWidgetCategory.lists,
      icon: Icons.table_chart_rounded,
      summary:
          'Menampilkan data tabular dalam bentuk kolom, baris, sorting, dan checkbox selector.',
      description:
          'DataTable menyajikan data terstruktur dalam format tabel dengan header kolom yang dapat di-sortir dan baris data yang dapat dipilih via checkbox.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'columns',
          type: 'List<DataColumn>',
          description: 'Daftar kolom header tabel',
        ),
        BasicWidgetProperty(
          name: 'rows',
          type: 'List<DataRow>',
          description: 'Daftar baris sel data (DataCell)',
        ),
        BasicWidgetProperty(
          name: 'sortColumnIndex',
          type: 'int?',
          description: 'Index kolom yang sedang diurutkan',
        ),
      ],
      codeSnippet: '''
DataTable(
  columns: const [
    DataColumn(label: Text('Nama')),
    DataColumn(label: Text('Role')),
  ],
  rows: const [
    DataRow(cells: [DataCell(Text('Zainal')), DataCell(Text('Engineer'))]),
  ],
)''',
      usageTips: const [
        'Bungkus DataTable dengan SingleChildScrollView(scrollDirection: Axis.horizontal) jika tabel memiliki banyak kolom.',
      ],
      previewBuilder: (context) => const DataTableBasicShowcase(),
    ),

    // ==========================================
    // 6. FEEDBACK, DIALOGS & OVERLAYS
    // ==========================================
    BasicWidgetModel(
      id: 'dialog',
      name: 'AlertDialog & SimpleDialog',
      category: BasicWidgetCategory.feedback,
      icon: Icons.chat_bubble_outline_rounded,
      summary:
          'Jendela dialog modal untuk konfirmasi tindakan penting atau memilih opsi.',
      description:
          'AlertDialog menampilkan pesan peringatan atau konfirmasi aksi penting dengan tombol aksi (Batal/Lanjut). SimpleDialog menampilkan daftar opsi langsung untuk dipilih.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'title',
          type: 'Widget?',
          description: 'Judul dialog',
        ),
        BasicWidgetProperty(
          name: 'content',
          type: 'Widget?',
          description: 'Badan pesan penjelasan dialog',
        ),
        BasicWidgetProperty(
          name: 'actions',
          type: 'List<Widget>?',
          description: 'Daftar tombol aksi di bagian bawah',
        ),
      ],
      codeSnippet: '''
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Konfirmasi'),
    content: const Text('Apakah Anda yakin ingin keluar?'),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
      FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Ya')),
    ],
  ),
);''',
      usageTips: const [
        'Selalu sediakan tombol Navigator.pop(context) pada action dialog untuk menutup jendela.',
      ],
      previewBuilder: (context) => const DialogBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'snackbar',
      name: 'SnackBar & ScaffoldMessenger',
      category: BasicWidgetCategory.feedback,
      icon: Icons.message_rounded,
      summary:
          'Notifikasi pop-up sementara di bagian bawah layar untuk memberi informasi cepat.',
      description:
          'SnackBar memberikan feedback singkat tentang operasi aplikasi (misal: "Item tersimpan", "Gagal koneksi"). Dipanggil melalui ScaffoldMessenger.of(context).showSnackBar().',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'content',
          type: 'Widget',
          description: 'Pesan teks atau widget konten notifikasi',
        ),
        BasicWidgetProperty(
          name: 'behavior',
          type: 'SnackBarBehavior',
          description: 'SnackBarBehavior.floating atau .fixed',
          defaultValue: 'fixed',
        ),
        BasicWidgetProperty(
          name: 'action',
          type: 'SnackBarAction?',
          description: 'Tombol aksi cepat seperti UNDO',
        ),
        BasicWidgetProperty(
          name: 'duration',
          type: 'Duration',
          description: 'Durasi tampil sebelum hilang otomatis',
          defaultValue: '4 detik',
        ),
      ],
      codeSnippet: '''
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: const Text('Perubahan berhasil disimpan!'),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.green.shade700,
    action: SnackBarAction(
      label: 'UNDO',
      textColor: Colors.white,
      onPressed: () {},
    ),
  ),
);''',
      usageTips: const [
        'Panggil `hideCurrentSnackBar()` sebelum `showSnackBar()` jika ingin notifikasi baru langsung menggantikan notifikasi sebelumnya.',
      ],
      previewBuilder: (context) => const SnackbarBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'bottom_sheet',
      name: 'Modal BottomSheet',
      category: BasicWidgetCategory.feedback,
      icon: Icons.vertical_align_top_rounded,
      summary: 'Panel lembar modal yang meluncur naik dari tepi bawah layar.',
      description:
          'Modal BottomSheet dipanggil via showModalBottomSheet untuk menampilkan opsi menu tambahan, filter pencarian, atau formulir input singkat tanpa berpindah halaman.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'isScrollControlled',
          type: 'bool',
          description:
              'Mengizinkan bottom sheet mengambil tinggi dinamis lebih dari 50% layar',
          defaultValue: 'false',
        ),
        BasicWidgetProperty(
          name: 'shape',
          type: 'ShapeBorder?',
          description: 'Bentuk sudut atas melengkung (RoundedRectangleBorder)',
        ),
      ],
      codeSnippet: '''
showModalBottomSheet(
  context: context,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
  builder: (context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Pilih Opsi', style: TextStyle(fontWeight: FontWeight.bold)),
          ListTile(title: Text('Opsi A'), onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  },
);''',
      usageTips: const [
        'Gunakan mainAxisSize: MainAxisSize.min pada Column di dalam builder agar tinggi BottomSheet pas sesuai isi konten.',
      ],
      previewBuilder: (context) => const BottomSheetBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'progress_indicator',
      name: 'Progress Indicators',
      category: BasicWidgetCategory.feedback,
      icon: Icons.hourglass_top_rounded,
      summary:
          'Indikator proses memuat data berputar (Circular) atau garis horizontal (Linear).',
      description:
          'CircularProgressIndicator dan LinearProgressIndicator menampilkan status tunggu loading. Mendukung mode indeterminate (berputar terus tanpa batas) dan determinate (dengan persentase 0.0 s/d 1.0).',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'value',
          type: 'double?',
          description:
              'Nilai progress 0.0 s/d 1.0 (jika null, akan berputar tanpa henti)',
        ),
        BasicWidgetProperty(
          name: 'color',
          type: 'Color?',
          description: 'Warna utama progress bar',
        ),
        BasicWidgetProperty(
          name: 'strokeWidth',
          type: 'double',
          description: 'Ketebalan garis melingkar (Circular)',
          defaultValue: '4.0',
        ),
      ],
      codeSnippet: '''
// Indeterminate
CircularProgressIndicator(color: Colors.indigo)

// Determinate (75%)
LinearProgressIndicator(
  value: 0.75,
  color: Colors.green,
  backgroundColor: Colors.green.shade100,
)''',
      usageTips: const [
        'Bungkus LinearProgressIndicator dengan ClipRRect(borderRadius: BorderRadius.circular(...)) untuk membuat ujung progress bar melengkung halus.',
      ],
      previewBuilder: (context) => const ProgressIndicatorBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'tooltip_badge',
      name: 'Tooltip & Badge',
      category: BasicWidgetCategory.feedback,
      icon: Icons.mark_chat_unread_rounded,
      summary:
          'Label penjelasan saat hover/tahan dan lencana angka notifikasi pada icon.',
      description:
          'Tooltip menampilkan petunjuk teks penjelasan saat pengguna mengarahkan kursor atau menahan lama widget. Badge menambahkan lencana angka notifikasi atau dot kecil di sudut widget.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'Tooltip.message',
          type: 'String',
          description: 'Pesan teks petunjuk yang muncul',
        ),
        BasicWidgetProperty(
          name: 'Badge.label',
          type: 'Widget?',
          description: 'Widget teks angka pada lencana notifikasi',
        ),
        BasicWidgetProperty(
          name: 'Badge.isLabelVisible',
          type: 'bool',
          description: 'Menyembunyikan badge jika angka 0',
          defaultValue: 'true',
        ),
      ],
      codeSnippet: '''
Badge(
  label: const Text('4'),
  backgroundColor: Colors.red,
  child: IconButton(
    icon: const Icon(Icons.notifications),
    onPressed: () {},
  ),
)''',
      usageTips: const [
        'Badge adalah widget bawaan resmi sejak Flutter 3.7+ sehingga tidak memerlukan package eksternal lagi.',
      ],
      previewBuilder: (context) => const TooltipBadgeBasicShowcase(),
    ),

    // ==========================================
    // 7. COMPREHENSIVE ADDITIONS (10 ESSENTIALS)
    // ==========================================
    BasicWidgetModel(
      id: 'scaffold_drawer',
      name: 'Scaffold, AppBar & Drawer',
      category: BasicWidgetCategory.layout,
      icon: Icons.web_stories_rounded,
      summary:
          'Kerangka utama halaman aplikasi dengan AppBar, Drawer sidebar menu, dan FAB.',
      description:
          'Scaffold mengimplementasikan struktur visual dasar Material Design untuk satu halaman utuh (AppBar di atas, Body di tengah, Drawer menu samping, BottomNavigationBar di bawah, dan FloatingActionButton).',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'appBar',
          type: 'PreferredSizeWidget?',
          description: 'Header bar di bagian atas layar',
        ),
        BasicWidgetProperty(
          name: 'drawer',
          type: 'Widget?',
          description: 'Panel sidebar navigasi yang meluncur dari kiri',
        ),
        BasicWidgetProperty(
          name: 'body',
          type: 'Widget?',
          description: 'Konten utama halaman',
        ),
        BasicWidgetProperty(
          name: 'floatingActionButton',
          type: 'Widget?',
          description: 'Tombol aksi melayang utama',
        ),
      ],
      codeSnippet: '''
Scaffold(
  appBar: AppBar(title: const Text('Judul Halaman')),
  drawer: Drawer(
    child: ListView(
      children: const [
        DrawerHeader(child: Text('Menu Navigasi')),
        ListTile(title: Text('Beranda')),
      ],
    ),
  ),
  body: const Center(child: Text('Konten Halaman')),
)''',
      usageTips: const [
        'Hampir setiap layar baru (Route) di Flutter harus menggunakan Scaffold sebagai root widget-nya.',
      ],
      previewBuilder: (context) => const ScaffoldDrawerBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'aspect_ratio_fitted_box',
      name: 'AspectRatio & FittedBox',
      category: BasicWidgetCategory.layout,
      icon: Icons.aspect_ratio_rounded,
      summary:
          'Mengunci rasio dimensi (16:9, 1:1) dan menskalakan ukuran child otomatis.',
      description:
          'AspectRatio memaksa child memiliki perbandingan lebar terhadap tinggi tertentu. FittedBox menskalakan dan memposisikan child di dalam parent agar pas sesuai opsi BoxFit.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'aspectRatio',
          type: 'double',
          description: 'Perbandingan width / height (contoh 16/9, 1.0, 4/3)',
        ),
        BasicWidgetProperty(
          name: 'FittedBox.fit',
          type: 'BoxFit',
          description: 'BoxFit.contain, scaleDown, cover, fitWidth',
          defaultValue: 'contain',
        ),
      ],
      codeSnippet: '''
AspectRatio(
  aspectRatio: 16 / 9, // Rasio video
  child: FittedBox(
    fit: BoxFit.contain,
    child: Image.network('https://picsum.photos/400/225'),
  ),
)''',
      usageTips: const [
        'Sangat direkomendasikan untuk pemutar video player, thumbnail foto produk, atau kartu profil persegi.',
      ],
      previewBuilder: (context) => const AspectRatioFittedBoxBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'interactive_viewer',
      name: 'InteractiveViewer',
      category: BasicWidgetCategory.layout,
      icon: Icons.pinch_rounded,
      summary:
          'Memberikan kemampuan pinch-to-zoom dan pan (geser canvas) pada widget.',
      description:
          'InteractiveViewer memungkinkan pengguna memperbesar/memperkecil (zoom in / zoom out) dan menggeser (pan/drag) konten di dalamnya, sangat ideal untuk peta, grafik, atau galeri foto detail.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'minScale / maxScale',
          type: 'double',
          description:
              'Batas minimal dan maksimal pembesaran zoom (contoh 0.5 s/d 4.0)',
        ),
        BasicWidgetProperty(
          name: 'panEnabled',
          type: 'bool',
          description: 'Mengaktifkan geser dua arah',
          defaultValue: 'true',
        ),
        BasicWidgetProperty(
          name: 'scaleEnabled',
          type: 'bool',
          description: 'Mengaktifkan pinch to zoom',
          defaultValue: 'true',
        ),
      ],
      codeSnippet: '''
InteractiveViewer(
  minScale: 0.5,
  maxScale: 3.0,
  child: Image.asset('assets/images/map_floor.png'),
)''',
      usageTips: const [
        'Gunakan TransformationController jika ingin me-reset posisi zoom ke ukuran semula via tombol.',
      ],
      previewBuilder: (context) => const InteractiveViewerBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'clip_rrect_oval',
      name: 'ClipRRect & ClipOval',
      category: BasicWidgetCategory.typography,
      icon: Icons.content_cut_rounded,
      summary:
          'Memotong bentuk widget menjadi sudut melengkung halus, elips, atau lingkaran.',
      description:
          'ClipRRect memotong child menggunakan BorderRadius rounded. ClipOval memotong child menjadi bentuk lingkaran sempurna atau oval elips.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'borderRadius',
          type: 'BorderRadiusGeometry',
          description: 'Radius lengkungan sudut (BorderRadius.circular)',
        ),
        BasicWidgetProperty(
          name: 'clipBehavior',
          type: 'Clip',
          description: 'Clip.antiAlias atau Clip.hardEdge',
          defaultValue: 'antiAlias',
        ),
      ],
      codeSnippet: '''
// Rounded Rectangle Clip
ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: Image.network('https://picsum.photos/200'),
)

// Circle / Oval Clip
ClipOval(
  child: Container(width: 80, height: 80, color: Colors.blue),
)''',
      usageTips: const [
        'Gunakan ClipRRect untuk membuat kartu gambar bergaya modern dengan sudut tumpul rapi.',
      ],
      previewBuilder: (context) => const ClipRRectOvalBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'hero_animation',
      name: 'Hero Animation',
      category: BasicWidgetCategory.typography,
      icon: Icons.flight_takeoff_rounded,
      summary:
          'Animasi transisi terbang yang mulus untuk elemen gambar antar dua halaman.',
      description:
          'Hero membuat elemen visual (seperti avatar atau poster) "terbang" dan bertransformasi secara mulus dari posisi di layar pertama ke posisi di layar tujuan saat Navigator.push dipanggil.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'tag',
          type: 'Object',
          description:
              'Identifier unik yang SAMA di kedua halaman asal dan tujuan',
        ),
        BasicWidgetProperty(
          name: 'child',
          type: 'Widget',
          description: 'Widget yang akan dianimasikan transisinya',
        ),
      ],
      codeSnippet: '''
// Di Layar 1 (Thumbnail)
Hero(
  tag: 'profile_hero_tag',
  child: Image.network('https://picsum.photos/100'),
)

// Di Layar 2 (Detail Fullscreen)
Hero(
  tag: 'profile_hero_tag',
  child: Image.network('https://picsum.photos/400'),
)''',
      usageTips: const [
        'Pastikan tag Hero unik per item pada ListView (misal: "item_hero_\${item.id}") untuk mencegah konflik.',
      ],
      previewBuilder: (context) => const HeroBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'animated_container',
      name: 'AnimatedContainer & AnimatedOpacity',
      category: BasicWidgetCategory.buttons,
      icon: Icons.animation_rounded,
      summary:
          'Animasi perubahan ukuran, warna, radius, dan transparansi otomatis tanpa controller.',
      description:
          'AnimatedContainer dan AnimatedOpacity adalah widget Implicit Animation bawaan Flutter yang secara otomatis menginterpolasi perubahan nilai properti saat setState dipanggil.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'duration',
          type: 'Duration',
          description: 'Durasi waktu animasi berlangsung (contoh 300ms)',
        ),
        BasicWidgetProperty(
          name: 'curve',
          type: 'Curve',
          description:
              'Kurva percepatan (Curves.easeInOut, fastOutSlowIn, dll)',
          defaultValue: 'linear',
        ),
      ],
      codeSnippet: '''
AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  width: _isExpanded ? 200 : 100,
  height: _isExpanded ? 200 : 100,
  decoration: BoxDecoration(
    color: _isExpanded ? Colors.indigo : Colors.blue,
    borderRadius: BorderRadius.circular(_isExpanded ? 30 : 10),
  ),
)''',
      usageTips: const [
        'Solusi termudah dan tercepat untuk membuat UI interaktif responsif tanpa repot mengelola AnimationController.',
      ],
      previewBuilder: (context) => const AnimatedContainerBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'navigation_bar',
      name: 'NavigationBar (Material 3)',
      category: BasicWidgetCategory.buttons,
      icon: Icons.navigation_rounded,
      summary: 'Bilah navigasi tab bawah modern standar Material Design 3.',
      description:
          'NavigationBar adalah komponen navigasi bawah resmi Material 3 dengan pill indicator pill animasi halus dan dukungan NavigationDestination.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'selectedIndex',
          type: 'int',
          description: 'Index tab yang sedang aktif saat ini',
          defaultValue: '0',
        ),
        BasicWidgetProperty(
          name: 'destinations',
          type: 'List<Widget>',
          description: 'Daftar item NavigationDestination',
        ),
        BasicWidgetProperty(
          name: 'onDestinationSelected',
          type: 'ValueChanged<int>?',
          description: 'Callback saat tab baru disentuh',
        ),
      ],
      codeSnippet: '''
NavigationBar(
  selectedIndex: _currentIndex,
  onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
  destinations: const [
    NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
    NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
  ],
)''',
      usageTips: const [
        'Gunakan NavigationBar menggantikan BottomNavigationBar lama untuk estetika standar Material 3.',
      ],
      previewBuilder: (context) => const NavigationBarBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'tabbar_tabview',
      name: 'TabBar & TabBarView',
      category: BasicWidgetCategory.buttons,
      icon: Icons.tab_rounded,
      summary:
          'Navigasi tab horizontal di bagian atas dengan sinkronisasi gestur swipe.',
      description:
          'TabBar menampilkan deretan tab pilihan di atas, dan TabBarView menampilkan halaman konten yang tersinkronisasi secara otomatis saat di-swipe maupun saat tab disentuh.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'tabs',
          type: 'List<Widget>',
          description: 'Daftar Tab widget (icon & text)',
        ),
        BasicWidgetProperty(
          name: 'isScrollable',
          type: 'bool',
          description: 'Apakah tab dapat digulir jika jumlah tab banyak',
          defaultValue: 'false',
        ),
        BasicWidgetProperty(
          name: 'indicatorColor',
          type: 'Color?',
          description: 'Warna garis indikator tab aktif',
        ),
      ],
      codeSnippet: '''
DefaultTabController(
  length: 3,
  child: Scaffold(
    appBar: AppBar(
      bottom: const TabBar(
        tabs: [
          Tab(text: 'Populer'),
          Tab(text: 'Trending'),
          Tab(text: 'Terbaru'),
        ],
      ),
    ),
    body: const TabBarView(
      children: [
        Center(child: Text('Konten Populer')),
        Center(child: Text('Konten Trending')),
        Center(child: Text('Konten Terbaru')),
      ],
    ),
  ),
)''',
      usageTips: const [
        'Bungkus dengan DefaultTabController jika tidak ingin membuat TabController manual dengan TickerProvider.',
      ],
      previewBuilder: (context) => const TabBarTabViewBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'refresh_indicator',
      name: 'RefreshIndicator',
      category: BasicWidgetCategory.lists,
      icon: Icons.refresh_rounded,
      summary:
          'Fitur tarik ke bawah untuk memuat ulang data (Pull-to-Refresh).',
      description:
          'RefreshIndicator membungkus widget scrollable (seperti ListView atau SingleChildScrollView) untuk mendeteksi gestur overscroll ke bawah dan menampilkan indikator loading melingkar.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'onRefresh',
          type: 'RefreshCallback',
          description: 'Future Function() async yang mengunduh data baru',
        ),
        BasicWidgetProperty(
          name: 'color',
          type: 'Color?',
          description: 'Warna animasi putaran loading',
        ),
        BasicWidgetProperty(
          name: 'strokeWidth',
          type: 'double',
          description: 'Ketebalan garis spinner',
          defaultValue: '2.0',
        ),
      ],
      codeSnippet: '''
RefreshIndicator(
  onRefresh: () async {
    await Future.delayed(const Duration(seconds: 2));
    // Fetch data baru dari API
  },
  child: ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) => ListTile(title: Text(items[index])),
  ),
)''',
      usageTips: const [
        'Fungsi onRefresh wajib mengembalikan Future (async) agar spinner otomatis berhenti saat request selesai.',
      ],
      previewBuilder: (context) => const RefreshIndicatorBasicShowcase(),
    ),

    BasicWidgetModel(
      id: 'dismissible',
      name: 'Dismissible',
      category: BasicWidgetCategory.lists,
      icon: Icons.swipe_rounded,
      summary:
          'Menggeser item list ke kanan/kiri untuk menghapus atau mengarsipkan (Swipe-to-Action).',
      description:
          'Dismissible memungkinkan item daftar disingkirkan dengan gestur swipe horizontal. Dilengkapi latar warna dan ikon aksi di balik item saat digeser.',
      keyProperties: const [
        BasicWidgetProperty(
          name: 'key',
          type: 'Key',
          description:
              'Key unik wajib untuk melacak identitas item di widget tree',
        ),
        BasicWidgetProperty(
          name: 'background',
          type: 'Widget?',
          description: 'Tampilan latar saat swipe ke kanan (misal Arsip)',
        ),
        BasicWidgetProperty(
          name: 'secondaryBackground',
          type: 'Widget?',
          description: 'Tampilan latar saat swipe ke kiri (misal Hapus)',
        ),
        BasicWidgetProperty(
          name: 'onDismissed',
          type: 'DismissDirectionCallback?',
          description: 'Callback saat item selesai disingkirkan',
        ),
      ],
      codeSnippet: '''
Dismissible(
  key: Key(item.id),
  background: Container(color: Colors.green, child: Icon(Icons.archive)),
  secondaryBackground: Container(color: Colors.red, child: Icon(Icons.delete)),
  onDismissed: (direction) {
    // Hapus data dari list state
  },
  child: ListTile(title: Text(item.name)),
)''',
      usageTips: const [
        'Wajib memperbarui state list di dalam onDismissed agar item tidak muncul kembali yang memicu crash key mismatch.',
      ],
      previewBuilder: (context) => const DismissibleBasicShowcase(),
    ),
  ];
}
