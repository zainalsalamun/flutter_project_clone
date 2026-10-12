import 'package:flutter/material.dart';
import '../models/fundamental_module.dart';
import '../models/lesson_item.dart';

// Interactive Visualizers
import '../visualizers/dart_basics_interactive_visualizer_widget.dart';
import '../visualizers/lifecycle_visualizer_widget.dart';
import '../visualizers/three_trees_visualizer_widget.dart';
import '../visualizers/constraints_rule_visualizer_widget.dart';
import '../visualizers/state_flow_visualizer_widget.dart';
import '../visualizers/async_timeline_visualizer_widget.dart';
import '../visualizers/api_networking_visualizer_widget.dart';
import '../visualizers/state_management_master_visualizer_widget.dart';
import '../visualizers/custom_painter_live_visualizer_widget.dart';

class LessonsRepository {
  static final List<LessonItem> allLessons = [
    // =========================================================================
    // 1. DART: VARIABEL, TIPE DATA & IMMUTABILITAS
    // =========================================================================
    LessonItem(
      id: 'dart_variables_data_types',
      title: 'Variabel, Tipe Data & Immutabilitas',
      subtitle: 'Memahami type inference, mutable vs immutable, dan perbedaan mutlak var, final, serta const.',
      module: FundamentalModule.dartBasics,
      order: 1,
      readTimeMinutes: 7,
      level: 'Pemula',
      icon: Icons.data_object_rounded,
      summary:
          'Dart adalah bahasa strongly-typed dengan sistem type inference. Memahami perbedaan antara var, final, dan const sangat krusial untuk performa Flutter.',
      visualizerBuilder: (context) => const DartBasicsInteractiveVisualizerWidget(),
      sections: const [
        LessonSection(
          title: '1. Tipe Data Primitif & Type Inference',
          content:
              'Dart mendukung tipe data bawaan seperti `int`, `double`, `num` (induk int & double), `String`, dan `bool`. Dart juga mendukung inferensi tipe otomatis menggunakan kata kunci `var`.',
          codeSnippet: '''
int age = 25;
double score = 98.5;
String name = "Naltech";
bool isActive = true;

// Type inference: tipe otomatis ditentukan menjadi String saat inisialisasi
var city = "Jakarta"; 
// city = 100; // Error: Tipe tidak bisa diubah setelah ditentukan''',
        ),
        LessonSection(
          title: '2. Perbedaan Krusial: var vs final vs const',
          content:
              'Membedakan mutabilitas dan waktu evaluasi memori adalah fondasi optimasi widget Flutter:',
          bulletPoints: [
            '**var**: Variabel mutable. Nilainya dapat diganti kapan saja selama tipe datanya sama.',
            '**final**: Nilai immutable yang dievaluasi saat **runtime**. Hanya dapat diisi satu kali (single assignment).',
            '**const**: Nilai konstan mutlak yang dievaluasi saat **compile-time**. Nilai harus sudah diketahui sebelum program dijalankan.',
          ],
          codeSnippet: '''
var counter = 0;
counter = 1; // Valid

final currentTime = DateTime.now(); // Valid (nilai dihitung saat runtime)
// const invalidTime = DateTime.now(); // Compile Error! DateTime.now() butuh runtime

const double piValue = 3.14159; // Valid (compile-time constant)''',
          callout: 'Gunakan `const` untuk semua widget atau objek statis agar engine Flutter tidak mengalokasikan ulang memori saat rebuild.',
        ),
        LessonSection(
          title: '3. String Interpolation & Multiline String',
          content:
              'Dart menyediakan cara praktis untuk menggabungkan string tanpa operator penjumlahan string (+).',
          codeSnippet: '''
String item = "Laptop";
int qty = 3;
double price = 15000000;

// String interpolation sederhana (\$variabel) dan ekspresi (\${ekspresi})
String summary = "Beli \$qty unit \$item. Total: Rp \${qty * price}";

// Multiline String dengan petik tiga
String query = \'\'\'
SELECT * FROM users
WHERE is_active = true
ORDER BY created_at DESC;
\'\'\';''',
        ),
      ],
      keyTakeaways: const [
        'Dart bersifat strongly-typed namun mendukung type inference cerdas via `var`.',
        '`final` bernilai tetap setelah runtime initialization, sedangkan `const` bernilai tetap sejak proses kompilasi.',
        'Widget dengan `const` constructor dilewati (*skipped*) saat tree di-rebuild, menghemat siklus CPU.',
      ],
      quiz: const QuizQuestion(
        question: 'Mengapa baris kode `const time = DateTime.now();` menghasilkan compile-time error di Dart?',
        options: [
          'DateTime bukan tipe data bawaan Dart',
          'DateTime.now() dievaluasi saat runtime, sedangkan const memerlukan nilai compile-time yang pasti',
          'Kata kunci const hanya dapat digunakan untuk angka numerik',
          'Fungsi DateTime.now() mengembalikan nilai nullable',
        ],
        correctIndex: 1,
        explanation: 'Nilai `DateTime.now()` baru dapat diketahui ketika aplikasi berjalan (runtime), sehingga hanya dapat ditampung oleh variabel `final`, bukan `const`.',
      ),
    ),

    // =========================================================================
    // 2. DART: KOLEKSI DATA MODERN (LIST, SET, MAP)
    // =========================================================================
    LessonItem(
      id: 'dart_collections_operators',
      title: 'Koleksi Data Modern (List, Set, Map)',
      subtitle: 'Manipulasi data modern dengan Collection if, Collection for, dan Spread Operator (...).',
      module: FundamentalModule.dartBasics,
      order: 2,
      readTimeMinutes: 8,
      level: 'Pemula',
      icon: Icons.view_list_rounded,
      summary:
          'Koleksi data di Dart memiliki fitur deklaratif tingkat lanjut seperti Spread Operator dan Collection conditionals yang menjadi pondasi pembuatan dynamic UI Flutter.',
      sections: const [
        LessonSection(
          title: '1. List, Set, dan Map di Dart',
          content:
              'Dart menyediakan 3 tipe koleksi data utama yang semuanya mendukung generic typing `<T>`:',
          bulletPoints: [
            '**List**: Kumpulan data berurutan dengan indeks numerik (mengizinkan duplikat).',
            '**Set**: Kumpulan elemen unik tanpa duplikasi.',
            '**Map**: Kumpulan pasangan kunci-nilai (*key-value pairs*).',
          ],
          codeSnippet: '''
// List
List<String> fruits = ["Apel", "Jeruk", "Apel"]; // Ada 3 elemen

// Set (otomatis menghapus duplikat)
Set<String> uniqueFruits = {"Apel", "Jeruk", "Apel"}; // Hanya ada "Apel" dan "Jeruk"

// Map (Key-Value)
Map<String, dynamic> userProfile = {
  "id": "USR-101",
  "username": "zainal",
  "age": 25,
  "isVerified": true,
};''',
        ),
        LessonSection(
          title: '2. Spread Operator (... dan ...?)',
          content:
              'Spread operator menyisipkan seluruh elemen dari suatu koleksi ke koleksi lainnya secara langsung tanpa perlu looping manual.',
          codeSnippet: '''
List<String> defaultHeaders = ["Authorization", "Accept"];
List<String>? optionalHeaders;

List<String> requestHeaders = [
  "Content-Type",
  ...defaultHeaders,
  ...?optionalHeaders, // Null-aware spread: aman jika bernilai null
];
// Hasil: ["Content-Type", "Authorization", "Accept"]''',
        ),
        LessonSection(
          title: '3. Collection if dan Collection for',
          content:
              'Fitur ini memungkinkan penambahan elemen ke dalam list secara kondisional atau iteratif langsung dalam deklarasi list widget.',
          codeSnippet: '''
bool isLoggedIn = true;
var role = "admin";

List<Widget> navButtons = [
  const HomeButton(),
  const SettingsButton(),
  if (isLoggedIn) const LogoutButton(),
  if (role == "admin") ...[
    const AdminDashboardButton(),
    const AnalyticsButton(),
  ],
  for (var i = 1; i <= 3; i++) BadgeWidget(index: i),
];''',
          callout: 'Hindari penggunaan ternary `condition ? Widget() : const SizedBox()` jika Anda cukup menggunakan `if (condition) Widget()` di dalam children list.',
        ),
      ],
      keyTakeaways: const [
        'Set menjamin keunikan setiap item tanpa data kembar.',
        'Spread operator `...` dan `...?` menyederhanakan penggabungan koleksi data.',
        'Collection `if` dan `for` membuat komposisi widget UI deklaratif jauh lebih bersih dan terstruktur.',
      ],
      quiz: const QuizQuestion(
        question: 'Apa fungsi dari operator `...?` (null-aware spread operator) pada kode: `[...items, ...?extraItems]`?',
        options: [
          'Mengubah seluruh elemen ekstra menjadi string nullable',
          'Menyisipkan ekstra elemen hanya jika extraItems tidak bernilai null tanpa memicu crash',
          'Menghapus elemen duplikat di dalam extraItems',
          'Mengurutkan extraItems secara ascending',
        ],
        correctIndex: 1,
        explanation: 'Operator `...?` memeriksa apakah koleksi bernilai null; jika null, operator ini melewatinya tanpa menimbulkan runtime exception.',
      ),
    ),

    // =========================================================================
    // 3. DART: FUNGSI, PARAMETER FLEKSIBEL & ARROW SYNTAX
    // =========================================================================
    LessonItem(
      id: 'dart_functions_parameters',
      title: 'Fungsi, Parameter Fleksibel & Arrow Syntax',
      subtitle: 'Positional vs Named Parameters, Default Values, Arrow Syntax, dan Higher-Order Functions.',
      module: FundamentalModule.dartBasics,
      order: 3,
      readTimeMinutes: 8,
      level: 'Pemula',
      icon: Icons.functions_rounded,
      summary:
          'Fungsi di Dart adalah first-class objects yang dapat disimpan dalam variabel, dijadikan parameter, dan dikonfigurasi fleksibel dengan named parameters.',
      sections: const [
        LessonSection(
          title: '1. Positional vs Named Parameters',
          content:
              'Widget Flutter hampir seluruhnya menggunakan Named Parameters karena memberikan kejelasan nama argumen saat pemanggilan fungsi.',
          codeSnippet: '''
// 1. Positional Parameters (urutan wajib sesuai)
void sendEmail(String to, String subject) {
  print("To: \$to, Subject: \$subject");
}

// 2. Named Parameters (dibungkus {})
void createButton({
  required String label,
  VoidCallback? onPressed,
  Color color = Colors.blue, // Default parameter
  double elevation = 2.0,
}) {
  print("Button \$label created with elevation \$elevation");
}

void main() {
  // Pemanggilan Named Parameter jelas dan urutannya bebas
  createButton(
    label: "Simpan",
    color: Colors.green,
  );
}''',
        ),
        LessonSection(
          title: '2. Arrow Syntax (Fat Arrow =>)',
          content:
              'Arrow syntax adalah penulisan ringkas untuk fungsi yang hanya memiliki satu ekspresi *return*.',
          codeSnippet: '''
// Fungsi standar
int add(int a, int b) {
  return a + b;
}

// Menggunakan Arrow Syntax
int addArrow(int a, int b) => a + b;

bool isPositive(int number) => number > 0;''',
        ),
        LessonSection(
          title: '3. Higher-Order Functions pada Koleksi (map, where, fold)',
          content:
              'Dart menyediakan method fungsional bawaan untuk memproses data koleksi secara deklaratif tanpa perulangan for konvensional.',
          codeSnippet: '''
List<int> numbers = [1, 2, 3, 4, 5, 6];

// filter elemen genap
List<int> evens = numbers.where((n) => n % 2 == 0).toList(); // [2, 4, 6]

// transform elemen dikali 10
List<int> multiplied = numbers.map((n) => n * 10).toList(); // [10, 20, 30, ...]

// akumulasi total jumlah
int sum = numbers.fold(0, (prev, element) => prev + element); // 21''',
        ),
      ],
      keyTakeaways: const [
        'Named parameters dibungkus tanda kurung kurawal `{}` dan wajib menggunakan `required` jika tidak memiliki default value.',
        'Arrow syntax `=>` hanya berlaku untuk fungsi dengan satu baris ekspresi return.',
        'Method `.map()` dan `.where()` mengembalikan `Iterable`, panggil `.toList()` untuk mengonversinya kembali menjadi List.',
      ],
      quiz: const QuizQuestion(
        question: 'Bagaimana cara mendefinisikan parameter opsional bernama yang memiliki nilai baku (default value) 10?',
        options: [
          'void calculate(int value = 10);',
          'void calculate({int value = 10});',
          'void calculate([int value == 10]);',
          'void calculate({required int value : 10});',
        ],
        correctIndex: 1,
        explanation: 'Named parameter dibungkus tanda kurung kurawal `{}` dan nilai bawaannya ditentukan dengan tanda `=` seperti `{int value = 10}`.',
      ),
    ),

    // =========================================================================
    // 4. DART: OOP MENDALAM & CONSTRUCTORS
    // =========================================================================
    LessonItem(
      id: 'dart_oop_constructors',
      title: 'OOP Mendalam & Pola Konstruktor',
      subtitle: 'Class, Generative Constructor, Factory Constructor (JSON Deserialization), Const & Initializer List.',
      module: FundamentalModule.dartBasics,
      order: 4,
      readTimeMinutes: 9,
      level: 'Menengah',
      icon: Icons.category_rounded,
      summary:
          'Konstruktor di Dart memiliki fitur canggih seperti Factory Constructor untuk serialisasi JSON dan Const Constructor untuk penghematan alokasi memori.',
      sections: const [
        LessonSection(
          title: '1. Class, Fields, dan Generative Constructor',
          content:
              'Dart menyediakan *syntactic sugar* `this.fieldName` pada constructor untuk langsung menginisialisasi properti tanpa boilerplate panjang.',
          codeSnippet: '''
class Product {
  final String id;
  final String title;
  final double price;

  // Generative constructor dengan named parameters
  const Product({
    required this.id,
    required this.title,
    required this.price,
  });
}''',
        ),
        LessonSection(
          title: '2. Named Constructor & Initializer List',
          content:
              'Dart tidak mendukung method overloading. Sebagai gantinya, Dart menggunakan **Named Constructors** untuk menyediakan beberapa cara instansiasi objek.',
          codeSnippet: '''
class Coordinate {
  final double x;
  final double y;

  // Generative standard
  Coordinate(this.x, this.y);

  // Named constructor: Coordinate.origin()
  Coordinate.origin()
      : x = 0.0,
        y = 0.0; // Initializer list

  // Named constructor dengan validasi assertion
  Coordinate.horizontal(double xPos)
      : x = xPos,
        y = 0.0 {
    print("Horizontal coordinate created at \$xPos");
  }
}''',
        ),
        LessonSection(
          title: '3. Factory Constructor & Pola Deserialisasi JSON',
          content:
              'Keyword `factory` digunakan pada constructor yang tidak selalu membuat instance baru dari class-nya, melainkan dapat menjalankan logika parsing, mengembalikan sub-class, atau mengambil instance dari memori cache.',
          codeSnippet: '''
class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  // Factory constructor untuk pemrosesan API Response JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Anonim',
      email: json['email'] as String? ?? '',
    );
  }

  // Serialisasi objek ke JSON Map
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
  };
}''',
          callout: 'Factory constructor adalah standar industri di Flutter untuk deserialisasi model data dari REST API atau Firebase.',
        ),
      ],
      keyTakeaways: const [
        'Dart menggunakan Named Constructor (misal: `Class.named()`) karena tidak ada method overloading.',
        'Initializer list (setelah tanda titik dua `:`) dieksekusi sebelum body constructor dijalankan.',
        '`factory` constructor mengizinkan logika komputasi sebelum mengembalikan instance objek.',
      ],
      quiz: const QuizQuestion(
        question: 'Kapan sebaiknya Anda menggunakan kata kunci `factory` pada sebuah constructor di Dart?',
        options: [
          'Ketika constructor tidak membutuhkan parameter apa pun',
          'Ketika Anda perlu melakukan komputasi atau mengembalikan instance yang diproses dari data eksternal (seperti JSON)',
          'Ketika constructor hanya boleh dipanggil dari file yang sama',
          'Ketika seluruh field bertipe boolean',
        ],
        correctIndex: 1,
        explanation: '`factory` constructor sangat ideal untuk deserialisasi JSON dan implementasi Singleton pattern karena fleksibilitasnya dalam mengembalikan objek yang diproses.',
      ),
    ),

    // =========================================================================
    // 5. DART: SOUND NULL SAFETY & ERROR HANDLING
    // =========================================================================
    LessonItem(
      id: 'dart_null_safety_error',
      title: 'Sound Null Safety & Penanganan Error',
      subtitle: 'Nullable (?), Null-aware operators (??, ?., ??=), late variables, dan try-catch-finally.',
      module: FundamentalModule.dartBasics,
      order: 5,
      readTimeMinutes: 9,
      level: 'Pemula',
      icon: Icons.shield_rounded,
      summary:
          'Sistem Sound Null Safety di Dart menjamin tidak ada crash "The method was called on null" saat runtime jika kode lolos kompilasi.',
      sections: const [
        LessonSection(
          title: '1. Prinsip Sound Null Safety (Non-Nullable by Default)',
          content:
              'Semua tipe data secara default tidak boleh bernilai null. Jika suatu variabel diizinkan untuk tidak memiliki nilai, Anda wajib menambahkan tanda tanya `?` setelah tipe datanya.',
          codeSnippet: '''
String name = "Zainal"; // Wajib memiliki nilai String
// name = null; // Compile Error!

String? optionalBio; // Boleh bernilai null
optionalBio = null; // Valid''',
        ),
        LessonSection(
          title: '2. Operator Null-Aware Penting',
          content: 'Kuasai 4 operator null-aware berikut untuk menyederhanakan kode Anda:',
          bulletPoints: [
            '**`?.` (Null-aware access)**: Menjalankan property/method hanya jika objek tidak null (`user?.profile?.avatar`).',
            '**`??` (Null-coalescing)**: Memberikan nilai default cadangan jika sisi kiri bernilai null (`val ?? defaultVal`).',
            '**`??=` (Null-aware assignment)**: Mengisi nilai variabel hanya jika variabel tersebut saat ini bernilai null.',
            '**`!` (Bang / Null assertion operator)**: Menegaskan bahwa variabel pasti tidak null. Gunakan dengan sangat hati-hati!',
          ],
          codeSnippet: '''
String? token;
// Null coalescing
String activeToken = token ?? "GUEST_TOKEN";

// Null-aware assignment
token ??= "NEW_GENERATED_TOKEN";

// Bang operator (dapat memicu crash jika asumsi Anda salah!)
// print(token!.length);''',
          callout: 'Hindari penggunaan bang operator `!` kecuali Anda 100% yakin variabel tersebut sudah diisi nilai non-null.',
          isWarning: true,
        ),
        LessonSection(
          title: '3. Kata Kunci late & Exception Handling',
          content:
              'Kata kunci `late` digunakan untuk mendeklarasikan variabel non-nullable yang nilainya baru diinisialisasi nanti (misal di `initState()`). Tangani potensi error dengan `try-catch-finally`.',
          codeSnippet: '''
late final AnimationController animController;

void initializeController(TickerProvider vsync) {
  animController = AnimationController(vsync: vsync);
}

// Exception Handling
Future<void> fetchData() async {
  try {
    final response = await httpGet('/api/data');
    processData(response);
  } on SocketException catch (e) {
    print("Koneksi internet terputus: \$e");
  } catch (e, stackTrace) {
    print("Terjadi error tak terduga: \$e");
  } finally {
    print("Selesai diproses (selalu dieksekusi)");
  }
}''',
        ),
      ],
      keyTakeaways: const [
        'Semua variabel non-nullable wajib diinisialisasi sebelum dibaca.',
        'Gunakan `??` untuk menyediakan fallback fallback nilai default secara bersih.',
        'Gunakan `on SpecificException` untuk menangkap jenis exception yang spesifik sebelum catch umum.',
      ],
      quiz: const QuizQuestion(
        question: 'Apa risiko terbesar dari penggunaan berlebihan tanda seru `!` (bang operator) pada variabel nullable?',
        options: [
          'Membuat ukuran APK membengkak',
          'Memicu runtime exception jika nilai variabel ternyata null saat aplikasi berjalan',
          'Memperlambat koneksi internet',
          'Mengubah tipe data variabel menjadi int',
        ],
        correctIndex: 1,
        explanation: 'Operator `!` memaksa compiler menganggap variabel tidak null. Jika saat runtime bernilai null, aplikasi akan langsung mengalami runtime exception (crash).',
      ),
    ),

    // =========================================================================
    // 6. DART: FITUR MODERN DART 3 (RECORDS & PATTERN MATCHING)
    // =========================================================================
    LessonItem(
      id: 'dart_modern_features',
      title: 'Fitur Modern Dart 3 (Records & Pattern Matching)',
      subtitle: 'Pengembalian multi-nilai dengan Records, Switch Expression deklaratif, dan Guard Clauses.',
      module: FundamentalModule.dartBasics,
      order: 6,
      readTimeMinutes: 8,
      level: 'Menengah',
      icon: Icons.auto_awesome_rounded,
      summary:
          'Dart 3 memperkenalkan Records untuk mengembalikan beberapa nilai sekaligus secara type-safe dan Switch Expressions yang sangat powerful untuk status UI.',
      sections: const [
        LessonSection(
          title: '1. Records: Multi-Value Return Tanpa Class Tambahan',
          content:
              'Records adalah tipe data anonim, immutable, dan agregat yang memungkinkan fungsi mengembalikan beberapa nilai sekaligus.',
          codeSnippet: '''
// Fungsi mengembalikan 2 nilai (String nama, int status code)
(String, int) fetchStatus() {
  return ("SUCCESS", 200);
}

// Named Records
({double lat, double lng}) getCoordinates() {
  return (lat: -6.2088, lng: 106.8456);
}

void main() {
  final (status, code) = fetchStatus(); // Destructuring
  print("Status: \$status, Code: \$code");

  final loc = getCoordinates();
  print("Latitude: \${loc.lat}, Longitude: \${loc.lng}");
}''',
        ),
        LessonSection(
          title: '2. Switch Expressions & Pattern Matching',
          content:
              'Switch di Dart 3 dapat bertindak sebagai *expression* yang mengembalikan nilai langsung secara ringkas tanpa keyword `break` dan `case`.',
          codeSnippet: '''
enum OrderStatus { pending, processing, shipped, delivered, cancelled }

String getStatusLabel(OrderStatus status) {
  return switch (status) {
    OrderStatus.pending => "Menunggu Pembayaran",
    OrderStatus.processing => "Sedang Diproses",
    OrderStatus.shipped => "Dalam Pengiriman",
    OrderStatus.delivered => "Pesanan Selesai",
    OrderStatus.cancelled => "Dibatalkan",
  };
}''',
          callout: 'Switch expression menjamin *exhaustive check*, artinya compiler akan memberikan error jika ada enum yang belum Anda tangani!',
        ),
        LessonSection(
          title: '3. Pattern Matching dengan Guard Clauses (when)',
          content:
              'Anda dapat menambahkan kondisi filter tambahan menggunakan kata kunci `when` pada pola matching.',
          codeSnippet: '''
String describeTemperature(int temp) {
  return switch (temp) {
    < 0 => "Membeku",
    >= 0 && <= 20 => "Sejuk",
    > 20 && <= 35 => "Normal Nyaman",
    _ when temp > 40 => "Gelombang Panas Ekstrem",
    _ => "Panas",
  };
}''',
        ),
      ],
      keyTakeaways: const [
        'Records menghilangkan kebutuhan membuat class DTO sederhana hanya untuk me-return dua nilai.',
        'Switch Expression mengembalikan nilai secara langsung dan memaksa seluruh kemungkinan ditangani.',
        'Destructuring memungkinkan pemecahan record atau list ke dalam variabel-variabel lokal seketika.',
      ],
      quiz: const QuizQuestion(
        question: 'Apa keunggulan utama dari Switch Expression di Dart 3 dibandingkan switch statement lama?',
        options: [
          'Switch expression membutuhkan keyword `break` di setiap cabang',
          'Switch expression mengembalikan nilai secara langsung dan menjamin pemeriksaan tuntas (exhaustive checking)',
          'Switch expression hanya bisa digunakan untuk angka integer',
          'Switch expression dijalankan secara asynchronous di background thread',
        ],
        correctIndex: 1,
        explanation: 'Switch expression di Dart 3 mengembalikan nilai langsung (*expression*) dan memvalidasi saat kompilasi bahwa seluruh kemungkinan nilai telah ditangani tanpa ada yang terlewat.',
      ),
    ),

    // =========================================================================
    // 7. DART: MIXIN, INTERFACE & EXTENSION METHODS
    // =========================================================================
    LessonItem(
      id: 'dart_mixins_extensions',
      title: 'Mixin, Interface & Extension Methods',
      subtitle: 'Pemanfaatan Mixin (with), Implements vs Extends, dan Extension Methods untuk memperluas fungsionalitas.',
      module: FundamentalModule.dartBasics,
      order: 7,
      readTimeMinutes: 8,
      level: 'Menengah',
      icon: Icons.extension_rounded,
      summary:
          'Mixin menyediakan komposisi kode tanpa pewarisan bertingkat. Extension Methods memungkinkan penambahan fungsi ke class bawaan (seperti BuildContext atau String) tanpa mengubah sumber aslinya.',
      sections: const [
        LessonSection(
          title: '1. Mixin: Berbagi Kode Tanpa Multiple Inheritance',
          content:
              'Dart tidak mendukung pewarisan ganda (*multiple inheritance*). Untuk mengatasi hal ini, Dart menggunakan **Mixin** dengan kata kunci `mixin` dan `with`.',
          codeSnippet: '''
mixin ValidationMixin {
  bool isValidEmail(String email) =>
      RegExp(r'^.+@.+\\..+\$').hasMatch(email);

  bool isStrongPassword(String pass) => pass.length >= 8;
}

class RegisterController with ValidationMixin {
  void submit(String email, String password) {
    if (isValidEmail(email) && isStrongPassword(password)) {
      print("Data valid, memproses pendaftaran...");
    }
  }
}''',
        ),
        LessonSection(
          title: '2. extends vs implements',
          content:
              'Setiap class di Dart secara implisit mendefinisikan interface. Pahami perbedaan mendasar antara `extends` dan `implements`:',
          bulletPoints: [
            '**extends (Inheritance)**: Mewarisi logika dan implementasi dari parent class (hanya bisa 1 superclass).',
            '**implements (Interface Contract)**: Wajib mengimplementasikan ulang SELURUH method dan field dari class target (bisa multiple interfaces).',
          ],
          codeSnippet: '''
abstract class AuthRepository {
  Future<void> login(String user, String pass);
}

class FirebaseAuthRepository implements AuthRepository {
  @override
  Future<void> login(String user, String pass) async {
    // Wajib menyediakan implementasi sendiri
  }
}''',
        ),
        LessonSection(
          title: '3. Extension Methods',
          content:
              'Extension methods menambahkan fungsi tambahan ke tipe data yang sudah ada (bahkan tipe data SDK Flutter) sehingga kode menjadi lebih ekspresif.',
          codeSnippet: '''
// Menambahkan method baru pada BuildContext
extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  Size get screenSize => MediaQuery.of(this).size;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

// Penggunaan di dalam widget
Widget build(BuildContext context) {
  // Jauh lebih ringkas dan bersih daripada Theme.of(context).colorScheme.primary
  final primaryColor = context.colors.primary; 
  return Container(color: primaryColor);
}''',
        ),
      ],
      keyTakeaways: const [
        'Mixin disematkan ke class menggunakan kata kunci `with`.',
        '`implements` mengharuskan penulisan ulang seluruh method (kontrak murni).',
        'Extension method pada `BuildContext` adalah *best practice* populer di Flutter untuk mempermudah akses tema dan ukuran layar.',
      ],
      quiz: const QuizQuestion(
        question: 'Kata kunci apa yang digunakan sebuah class untuk menyertakan dan menggunakan satu atau lebih Mixin di Dart?',
        options: [
          'extends',
          'implements',
          'with',
          'mixin of',
        ],
        correctIndex: 2,
        explanation: 'Kata kunci `with` digunakan untuk menyematkan satu atau lebih mixin ke dalam sebuah class (misal: `class MyWidgetState extends State<MyWidget> with SingleTickerProviderStateMixin`).',
      ),
    ),

    // =========================================================================
    // 8. WIDGET TREE & CORE ARCHITECTURE
    // =========================================================================
    LessonItem(
      id: 'the_three_trees',
      title: 'Arsitektur Tiga Pohon (The Three Trees)',
      subtitle: 'Membedah rahasia performa 120 FPS Flutter: Widget Tree, Element Tree & RenderObject Tree.',
      module: FundamentalModule.architecture,
      order: 8,
      readTimeMinutes: 10,
      level: 'Fundamental',
      icon: Icons.account_tree_rounded,
      summary:
          'Flutter memisahkan blueprint deklaratif ringan (Widget) dari struktur state hidup (Element) dan proses rendering GPU berat (RenderObject).',
      visualizerBuilder: (context) => const ThreeTreesVisualizerWidget(),
      sections: const [
        LessonSection(
          title: '1. Mengapa "Everything is a Widget"?',
          content:
              'Di Flutter, hampir semua elemen UI adalah Widget (mulai dari tombol, teks, padding, tema, hingga deteksi sentuhan). Namun, Widget hanyalah konfigurasi immutable (blueprint) yang sangat murah dibuat ulang setiap frame.',
        ),
        LessonSection(
          title: '2. Tiga Pohon di Balik Layar Flutter',
          content:
              'Framework Flutter mengelola 3 struktur pohon terpisah secara paralel untuk mengoptimalkan performa rendering grafis:',
          bulletPoints: [
            '**Widget Tree**: Blueprint konfigurasi ringan dan deklaratif. Dibuat ulang seketika setiap kali fungsi `build()` berjalan.',
            '**Element Tree**: Struktur jembatan hidup (*the real skeleton*) yang menyimpan referensi ke State dan mengelola lifecycle.',
            '**RenderObject Tree**: Objek komputasi berat yang menghitung ukuran layout (*layouting*), hit testing, dan menggambar piksel (*painting*) langsung ke engine Skia/Impeller.',
          ],
          callout: 'Saat `setState()` dipanggil, Element Tree memeriksa apakah Widget baru memiliki `runtimeType` dan `key` yang sama. Jika sama, RenderObject hanya di-update propertinya tanpa dibuat ulang dari nol!',
        ),
        LessonSection(
          title: '3. Peran Krusial BuildContext',
          content:
              '`BuildContext` sebenarnya adalah `Element` itu sendiri yang bertindak sebagai lokasi spesifik widget di dalam pohon. Itulah mengapa `Theme.of(context)` atau `Navigator.of(context)` dapat mencari data ke atas pohon (*up the tree*).',
          codeSnippet: '''
// BuildContext mencari InheritedWidget terdekat di atasnya
ThemeData theme = Theme.of(context);
MediaQueryData media = MediaQuery.of(context);
NavigatorState nav = Navigator.of(context);''',
        ),
      ],
      keyTakeaways: const [
        'Widget bersifat immutable dan murah; membuat ratusan widget per detik tidak menyebabkan lag.',
        'Element Tree menjaga kelangsungan hidup State dan mengontrol efisiensi daur ulang RenderObject.',
        'BuildContext adalah representasi lokasi Element di dalam widget tree.',
      ],
      quiz: const QuizQuestion(
        question: 'Pohon manakah yang bertanggung jawab menghitung ukuran fisik (layout) dan menggambar piksel ke GPU?',
        options: [
          'Widget Tree',
          'Element Tree',
          'RenderObject Tree',
          'State Tree',
        ],
        correctIndex: 2,
        explanation: 'RenderObject Tree bertugas melakukan kalkulasi layout (sizing/positioning) dan melukis (painting) piksel sesungguhnya ke layar.',
      ),
    ),

    // =========================================================================
    // 9. WIDGET LIFECYCLE
    // =========================================================================
    LessonItem(
      id: 'widget_lifecycle',
      title: 'Siklus Hidup Widget (StatefulWidget Lifecycle)',
      subtitle: 'Alur lengkap dari createState(), initState(), build() hingga dispose().',
      module: FundamentalModule.lifecycle,
      order: 9,
      readTimeMinutes: 9,
      level: 'Fundamental',
      icon: Icons.sync_rounded,
      summary:
          'Menguasai siklus hidup StatefulWidget adalah kunci utama mencegah kebocoran memori (memory leak) dan mengatur waktu inisialisasi data dengan tepat.',
      visualizerBuilder: (context) => const LifecycleVisualizerWidget(),
      sections: const [
        LessonSection(
          title: '1. Stateless vs StatefulWidget',
          content:
              'StatelessWidget bersifat statis dan tidak memiliki State internal yang berubah. StatefulWidget memiliki objek `State` pendamping yang persisten sepanjang masa hidup widget di layar.',
        ),
        LessonSection(
          title: '2. Urutan Alur Lifecycle Lengkap',
          content: 'Berikut adalah urutan kronologis eksekusi method pada StatefulWidget:',
          bulletPoints: [
            '**`createState()`**: Framework membuat objek State pendamping.',
            '**`initState()`**: Dijalankan SATU KALI. Tempat menginisialisasi controller, timer, atau fetch data awal.',
            '**`didChangeDependencies()`**: Dipanggil setelah initState atau saat `InheritedWidget` (Theme, Locale, Provider) yang didengar berubah.',
            '**`build()`**: Dipanggil berkali-kali untuk merender tampilan visual setiap kali `setState()` dijalankan.',
            '**`didUpdateWidget()`**: Dipanggil jika parent widget me-rebuild dan mengirimkan parameter/props baru.',
            '**`deactivate()`**: Widget dicopot sementara dari tree.',
            '**`dispose()`**: Dijalankan SATU KALI saat widget dihapus permanen. Wajib membersihkan Controllers & Subscriptions.',
          ],
          callout: 'Selalu panggil `super.initState()` di baris PERTAMA `initState()`, dan panggil `super.dispose()` di baris TERAKHIR `dispose()`.',
        ),
      ],
      keyTakeaways: const [
        'Jangan pernah memanggil `setState()` atau API request langsung di dalam method `build()`.',
        'Inisialisasi Controller (Animation/Scroll/Text) di `initState()` dan wajib di-dispose di `dispose()`.',
        '`didChangeDependencies()` adalah tempat aman untuk mengakses `BuildContext` bertipe InheritedWidget saat inisialisasi awal.',
      ],
      quiz: const QuizQuestion(
        question: 'Di method lifecycle manakah kita WAJIB melakukan `controller.dispose()` untuk mencegah memory leak?',
        options: [
          'deactivate()',
          'dispose()',
          'didUpdateWidget()',
          'initState()',
        ],
        correctIndex: 1,
        explanation: 'Method `dispose()` adalah tempat pembersihan memori permanen saat widget dihancurkan dari memori.',
      ),
    ),

    // =========================================================================
    // 10. LAYOUT & RENDERING RULES
    // =========================================================================
    LessonItem(
      id: 'layout_constraints_rule',
      title: 'Aturan Emas Layout & Rendering Flutter',
      subtitle: 'Memahami "Constraints go down, Sizes go up, Parent sets position" dan mengatasi Overflow.',
      module: FundamentalModule.layoutRules,
      order: 10,
      readTimeMinutes: 11,
      level: 'Fundamental',
      icon: Icons.view_quilt_rounded,
      summary:
          'Semua mekanisme layout di Flutter bekerja berdasarkan tiga aturan mutlak yang mengalirkan batasan ukuran dari atas ke bawah.',
      visualizerBuilder: (context) => const ConstraintsRuleVisualizerWidget(),
      sections: const [
        LessonSection(
          title: '1. Tiga Aturan Emas Layout',
          content: 'Setiap widget diatur posisinya menurut prinsip sederhana ini:',
          bulletPoints: [
            '**Constraints go DOWN**: Parent memberikan batasan (minWidth, maxWidth, minHeight, maxHeight) ke Child-nya.',
            '**Sizes go UP**: Child menentukan ukurannya sendiri di dalam batasan tersebut dan melapor ke Parent.',
            '**Parent sets POSITION**: Parent menentukan koordinat posisi (X, Y) dari Child tersebut.',
          ],
        ),
        LessonSection(
          title: '2. Bounded vs Unbounded Constraints',
          content:
              'Bounded constraints memiliki batas maksimal pasti (misal: maxWidth = 360). Unbounded constraints memiliki batas tak hingga (double.infinity), seperti pada sumbu scroll `ListView` atau `Row`.',
          callout: 'Penyebab error "RenderFlex children have non-zero flex but incoming height constraints are unbounded": Meletakkan ListView di dalam Column tanpa dibungkus Expanded atau SizedBox berketinggian tetap!',
          isWarning: true,
        ),
      ],
      keyTakeaways: const [
        'Widget tidak bisa memiliki ukuran semaunya; ukurannya selalu dibatasi oleh Constraints dari Parent-nya.',
        'Gunakan `Expanded` atau `Flexible` di dalam Row/Column untuk mencegah error RenderFlex overflow.',
      ],
      quiz: const QuizQuestion(
        question: 'Apa yang terjadi jika Anda memasukkan `ListView` langsung ke dalam `Column` tanpa `Expanded` atau tinggi fixed?',
        options: [
          'Aplikasi otomatis mengatur tinggi sesuai isi list',
          'Terjadi error crash Unbounded Height Constraints',
          'ListView otomatis berubah menjadi Row',
          'Tidak terjadi apa-apa dan berjalan lancar',
        ],
        correctIndex: 1,
        explanation: 'Column memberikan unbounded vertical constraint (tinggi tak hingga), sedangkan ListView default-nya ingin mengambil tinggi tak terhingga, sehingga memicu assertion crash.',
      ),
    ),

    // =========================================================================
    // 11. NAVIGATION & ROUTING
    // =========================================================================
    LessonItem(
      id: 'navigation_routing',
      title: 'Navigasi & Routing Modern',
      subtitle: 'Memahami Imperative Navigator 1.0 vs Declarative Routing (GoRouter) dan passing arguments.',
      module: FundamentalModule.navigation,
      order: 11,
      readTimeMinutes: 8,
      level: 'Fundamental',
      icon: Icons.alt_route_rounded,
      summary:
          'Navigasi di Flutter mengelola tumpukan layar (Route Stack) dengan kemampuan mengirim parameter dan menerima nilai balik.',
      sections: const [
        LessonSection(
          title: '1. Navigator 1.0 (Imperative Stack)',
          content:
              'Menggunakan tumpukan LIFO (Last In, First Out). Anda mendorong rute baru dengan `push` dan menutup layar dengan `pop`.',
          codeSnippet: '''
// Berpindah ke Halaman Baru
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const DetailPage(id: 42)),
);

// Menutup Halaman & Mengembalikan Nilai
Navigator.pop(context, "Data Tersimpan");

// Menerima Nilai Balik
final result = await Navigator.push(context, MaterialPageRoute(...));''',
        ),
        LessonSection(
          title: '2. Declarative Routing (GoRouter)',
          content:
              'Untuk aplikasi skala besar dan web, pendekatan deklaratif dengan package `go_router` sangat direkomendasikan karena mendukung Deep Linking, dynamic URL path parameters, dan nested shell navigation.',
        ),
      ],
      keyTakeaways: const [
        '`Navigator.pushReplacement` menggantikan layar saat ini tanpa menambah tumpukan back button (cocok untuk Splash Screen / Login).',
        '`Navigator.popUntil` dapat membersihkan seluruh tumpukan kembali ke halaman beranda awal.',
      ],
      quiz: const QuizQuestion(
        question: 'Method Navigator manakah yang paling tepat digunakan saat berpindah dari Splash Screen ke Home Page?',
        options: [
          'Navigator.push()',
          'Navigator.pushReplacement()',
          'Navigator.pop()',
          'Navigator.canPop()',
        ],
        correctIndex: 1,
        explanation: '`pushReplacement()` menggantikan Splash Screen dari tumpukan memori sehingga pengguna tidak bisa kembali ke Splash saat menekan tombol Back.',
      ),
    ),

    // =========================================================================
    // 12. STATE MANAGEMENT FUNDAMENTALS
    // =========================================================================
    LessonItem(
      id: 'state_management_intro',
      title: 'Pengelolaan State (State Management)',
      subtitle: 'Membedakan Ephemeral State vs App State, serta pengenalan ValueNotifier, Provider & BLoC.',
      module: FundamentalModule.stateManagement,
      order: 12,
      readTimeMinutes: 10,
      level: 'Fundamental',
      icon: Icons.dynamic_feed_rounded,
      summary:
          'State adalah data apa pun yang dibutuhkan aplikasi untuk membangun kembali (rebuild) antarmuka visual pada momen tertentu.',
      visualizerBuilder: (context) => const StateFlowVisualizerWidget(),
      sections: const [
        LessonSection(
          title: '1. Ephemeral State vs App State',
          content: 'Pahami kapan cukup menggunakan `setState` dan kapan butuh State Management:',
          bulletPoints: [
            '**Ephemeral (Local) State**: Data yang hanya relevan di satu widget saja (misal: tab aktif saat ini, animasi toggle, input teks sementara). Cukup gunakan `setState` atau `ValueNotifier`.',
            '**App (Global) State**: Data yang dibagikan ke banyak halaman di seluruh aplikasi (misal: keranjang belanja e-commerce, info user login, tema aplikasi dark/light mode). Membutuhkan Provider, BLoC, Riverpod, atau GetX.',
          ],
        ),
        LessonSection(
          title: '2. ValueNotifier & ValueListenableBuilder',
          content:
              'Alternatif ringan bawaan Flutter untuk meng-update UI tanpa me-rebuild seluruh widget tree parent:',
          codeSnippet: '''
final ValueNotifier<int> counter = ValueNotifier<int>(0);

// Hanya widget ini yang di-rebuild saat counter.value berubah!
ValueListenableBuilder<int>(
  valueListenable: counter,
  builder: (context, value, child) {
    return Text("Count: \$value");
  },
)''',
        ),
      ],
      keyTakeaways: const [
        'Jangan gunakan state management global untuk hal-hal sepele lokal seperti toggle visibility password.',
        '`ValueNotifier` adalah solusi bawaan Flutter yang sangat efisien untuk reaktivitas lokal tanpa package eksternal.',
      ],
      quiz: const QuizQuestion(
        question: 'Manakah contoh data yang termasuk ke dalam kategori App (Global) State?',
        options: [
          'Status password sedang disembunyikan (obscureText) pada form login',
          'Indeks tab yang sedang aktif di BottomNavigationBar',
          'Status autentikasi login pengguna dan profil akun',
          'Animasi progress bar di tombol saat ditekan',
        ],
        correctIndex: 2,
        explanation: 'Status autentikasi login dibutuhkan oleh berbagai rute dan widget di seluruh aplikasi, sehingga termasuk kategori Global App State.',
      ),
    ),

    // =========================================================================
    // 13. ASYNC, FUTURE & STREAM
    // =========================================================================
    LessonItem(
      id: 'async_future_stream',
      title: 'Asynchronous, Future & Stream',
      subtitle: 'Menguasai Future, async/await, FutureBuilder, Stream, dan StreamBuilder reaktif.',
      module: FundamentalModule.asyncNetworking,
      order: 13,
      readTimeMinutes: 10,
      level: 'Menengah',
      icon: Icons.cloud_sync_rounded,
      summary:
          'Operasi asynchronous memungkinkan aplikasi tetap responsif 60 FPS saat memuat data jaringan internet, membaca database, atau sensor.',
      visualizerBuilder: (context) => const AsyncTimelineVisualizerWidget(),
      sections: const [
        LessonSection(
          title: '1. Future vs Stream',
          content:
              '**Future** mewakili SATU nilai yang akan tersedia di masa depan (seperti response HTTP GET). **Stream** mewakili DERETAN nilai yang mengalir terus menerus sepanjang waktu (seperti posisi GPS, chat real-time WebSocket, atau download progress).',
        ),
        LessonSection(
          title: '2. FutureBuilder & StreamBuilder',
          content: 'Widget bawaan Flutter yang otomatis menangani status Loading, Success, dan Error:',
          codeSnippet: '''
FutureBuilder<UserProfile>(
  future: fetchUserProfile(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text("Error: \${snapshot.error}");
    } else if (snapshot.hasData) {
      return Text("Halo \${snapshot.data!.name}");
    }
    return const SizedBox();
  },
)''',
          callout: 'Hindari memanggil fungsi API langsung di dalam parameter `future: fetchUserProfile()`. Inisialisasi Future di `initState()` dan simpan ke variabel agar tidak terpanggil ulang setiap kali parent di-rebuild!',
          isWarning: true,
        ),
      ],
      keyTakeaways: const [
        'Future menghasilkan 1 nilai akhir; Stream menghasilkan rentetan banyak nilai berkelanjutan.',
        'Selalu simpan instance Future di variabel State agar tidak terjadi infinite network fetch saat widget rebuild.',
      ],
      quiz: const QuizQuestion(
        question: 'Kapan sebaiknya kita menggunakan `Stream` dibandingkan `Future`?',
        options: [
          'Saat mengambil 1 kali response detail artikel dari REST API',
          'Saat menerima pembaruan lokasi GPS live pengguna secara berkala',
          'Saat membaca file konfigurasi lokal saat startup',
          'Saat melakukan login autentikasi satu kali',
        ],
        correctIndex: 1,
        explanation: 'Pembaruan lokasi GPS terjadi terus-menerus berkali-kali sepanjang waktu, sehingga sangat tepat menggunakan Stream.',
      ),
    ),

    // =========================================================================
    // 14. THEMING & RESPONSIVE DESIGN
    // =========================================================================
    LessonItem(
      id: 'theming_responsive',
      title: 'Theming & Desain Responsif Multi-Platform',
      subtitle: 'Material 3 ColorScheme, Dark Mode otomatis, MediaQuery & LayoutBuilder.',
      module: FundamentalModule.themingResponsive,
      order: 14,
      readTimeMinutes: 7,
      level: 'Fundamental',
      icon: Icons.palette_rounded,
      summary:
          'Membangun aplikasi yang tampak konsisten dan beradaptasi secara elegan di berbagai ukuran layar ponsel, tablet, hingga desktop.',
      sections: const [
        LessonSection(
          title: '1. Material 3 ColorScheme & Theme',
          content:
              'Gunakan `ColorScheme.fromSeed` untuk menghasilkan palet warna Material 3 yang harmonis untuk mode terang (light) dan gelap (dark).',
          codeSnippet: '''
MaterialApp(
  theme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      brightness: Brightness.light,
    ),
  ),
  darkTheme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      brightness: Brightness.dark,
    ),
  ),
  themeMode: ThemeMode.system, // Mengikuti setting HP user
)''',
        ),
        LessonSection(
          title: '2. MediaQuery vs LayoutBuilder',
          content:
              '`MediaQuery.of(context).size` memberikan dimensi total layar perangkat. `LayoutBuilder` memberikan batasan ukuran maksimal (BoxConstraints) yang tersedia untuk widget spesifik tersebut.',
          codeSnippet: '''
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return Row(children: [...]); // Tampilan Tablet / Layar Lebar
    } else {
      return Column(children: [...]); // Tampilan Ponsel Standar
    }
  },
)''',
        ),
      ],
      keyTakeaways: const [
        '`LayoutBuilder` lebih fleksibel untuk komponen modular responsif dibanding `MediaQuery`.',
        'Material 3 ColorScheme mempermudah penyesuaian kontras teks dan permukaan secara otomatis.',
      ],
      quiz: const QuizQuestion(
        question: 'Widget apa yang paling tepat digunakan untuk mengubah layout berdasarkan ruang lebar yang tersedia untuk widget itu sendiri?',
        options: [
          'MediaQuery',
          'LayoutBuilder',
          'SizedBox',
          'Padding',
        ],
        correctIndex: 1,
        explanation: '`LayoutBuilder` menerima `BoxConstraints` spesifik milik parent, menjadikannya widget ideal untuk desain responsif modular.',
      ),
    ),

    // =========================================================================
    // 15. CLEAN ARCHITECTURE & PERFORMANCE
    // =========================================================================
    LessonItem(
      id: 'clean_architecture_performance',
      title: 'Clean Architecture & Optimasi Performa',
      subtitle: 'Kekuatan const constructor, isolasi rebuild, dan struktur folder profesional.',
      module: FundamentalModule.cleanArchitecture,
      order: 15,
      readTimeMinutes: 9,
      level: 'Menengah',
      icon: Icons.verified_rounded,
      summary:
          'Menulis kode Flutter yang mudah dirawat (maintainable), berskala besar (scalable), dan berjalan mulus tanpa frame drops.',
      sections: const [
        LessonSection(
          title: '1. Mengapa "const" Begitu Sakti di Flutter?',
          content:
              'Saat Anda menambahkan kata kunci `const` pada widget constructor, Flutter membuat canonical instance di memori saat compile-time. Saat widget tree di-rebuild, Flutter sama sekali TIDAK memanggil method `build()` pada widget const tersebut!',
          codeSnippet: '''
// BAIK: Flutter melewati (skip) rebuild widget ini!
const HeaderLogoWidget()

// KURANG OPTIMAL: Selalu dialokasikan ulang setiap frame
HeaderLogoWidget()''',
          callout: 'Gunakan linting rule `prefer_const_constructors` di analysis_options.yaml untuk memastikan Anda tidak melewatkan const.',
        ),
        LessonSection(
          title: '2. Pisahkan Widget Kecil (Extract Widget)',
          content:
              'Daripada membuat fungsi helper `Widget _buildHeader()`, SELALU ekstrak menjadi class mandiri `class HeaderWidget extends StatelessWidget`. Class widget memiliki siklus hidup sendiri dan memungkinkan Flutter mengisolasi proses rebuild hanya pada bagian yang berubah.',
        ),
        LessonSection(
          title: '3. Struktur Folder Feature-First (Clean)',
          content:
              'Organisasi folder berbasis fitur membuat proyek skala besar sangat teratur dan mudah dikembangkan oleh tim:',
          bulletPoints: [
            '`features/auth/presentation/` -> UI, Pages & Widgets',
            '`features/auth/domain/` -> Entities & UseCases (Business Logic murni)',
            '`features/auth/data/` -> Models, Data Sources & Repositories',
            '`core/` -> Utilities, Theme, Network Clients & Shared Widgets',
          ],
        ),
      ],
      keyTakeaways: const [
        'Selalu gunakan `const` jika nilai properti widget tidak berubah saat runtime.',
        'Ekstrak komponen UI ke dalam `StatelessWidget` terpisah, bukan helper method `_buildSomething()`.',
        'Gunakan Flutter DevTools CPU Profiler & Performance View untuk mendeteksi frame drops (jank).',
      ],
      quiz: const QuizQuestion(
        question: 'Mengapa mengekstrak widget menjadi class `StatelessWidget` lebih baik daripada membuat private method `Widget _buildCard()`?',
        options: [
          'Private method membuat file lebih besar ukurannya',
          'StatelessWidget class memungkinkan Flutter mengisolasi rebuild dan mendukung optimasi const constructor',
          'Private method tidak bisa menerima BuildContext',
          'StatelessWidget otomatis memiliki animasi bawaan',
        ],
        correctIndex: 1,
        explanation: 'Class widget memiliki element-nya sendiri sehingga proses rebuild dapat diisolasi secara presisi, serta mendukung alokasi memori `const` yang sangat efisien.',
      ),
    ),

    // =========================================================================
    // 16. REST API & INTERCEPTORS (DIO VS HTTP)
    // =========================================================================
    LessonItem(
      id: 'api_rest_dio_interceptors',
      title: 'Integrasi REST API & Network Interceptors',
      subtitle: 'Penggunaan Dio, HTTP Interceptors, Bearer Token JWT, dan Auto-Retry on 401 Unauthorized.',
      module: FundamentalModule.networkingApi,
      order: 16,
      readTimeMinutes: 10,
      level: 'Menengah',
      icon: Icons.http_rounded,
      summary:
          'Membangun lapisan jaringan profesional dengan Dio yang mendukung Interceptors otomatis untuk autentikasi, logging, dan pembaharuan token JWT.',
      visualizerBuilder: (context) => const ApiNetworkingVisualizerWidget(),
      sections: const [
        LessonSection(
          title: '1. Mengapa Memilih Dio Dibanding HTTP Standar?',
          content:
              'Package `http` cocok untuk request sederhana. Namun untuk aplikasi produksi skala menengah hingga enterprise, `dio` menjadi pilihan standar karena fitur bawaannya yang kaya:',
          bulletPoints: [
            '**Interceptors**: Mencegat dan memodifikasi request, response, serta error secara terpusat.',
            '**Global Configuration**: Base URL, connection timeout, dan default headers dalam satu instance.',
            '**Automatic JSON Decoding**: Otomatis mem-parsing payload JSON tanpa perlu `jsonDecode()` manual.',
            '**File Upload & Download Progress**: Dukungan `FormData` dan callback persentase progress.',
          ],
        ),
        LessonSection(
          title: '2. Pola Interceptor untuk Bearer Token JWT',
          content:
              'Interceptor memungkinkan penyisipan token autentikasi ke setiap request secara transparan tanpa mengotori setiap pemanggilan API di level repository.',
          codeSnippet: '''
class AuthInterceptor extends QueuedInterceptor {
  final Dio dio;
  AuthInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SecureStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer \$token';
    }
    handler.next(options); // Lanjutkan request
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expired: Lakukan refresh token secara otomatis
      final newToken = await refreshToken();
      err.requestOptions.headers['Authorization'] = 'Bearer \$newToken';
      
      // Kirim ulang request awal yang sempat gagal
      final retryResponse = await dio.fetch(err.requestOptions);
      return handler.resolve(retryResponse);
    }
    handler.next(err);
  }
}''',
          callout: 'Gunakan `QueuedInterceptor` agar jika ada beberapa request bersamaan saat token expired, request berikutnya akan mengantre sampai proses refresh token selesai.',
        ),
      ],
      keyTakeaways: const [
        'Interceptors menyentralisasi logika autentikasi, logging, dan penanganan error.',
        'Gunakan timeout yang jelas (misal: `connectTimeout: Duration(seconds: 10)`) agar aplikasi tidak macet tanpa kepastian saat jaringan lemot.',
      ],
      quiz: const QuizQuestion(
        question: 'Apa fungsi utama dari method `onError` pada Dio Interceptor ketika menerima response HTTP status 401?',
        options: [
          'Menghapus aplikasi dari HP pengguna',
          'Mencegat error untuk memperbarui token autentikasi (refresh token) dan mengulang kembali request yang gagal secara transparan',
          'Mengubah URL server menjadi localhost',
          'Mematikan koneksi internet perangkat',
        ],
        correctIndex: 1,
        explanation: 'Method `onError` di Interceptor dapat menangkap status 401 (Unauthorized), menjalankan prosedur refresh token di latar belakang, dan mencoba ulang request awal tanpa mengganggu pengalaman pengguna.',
      ),
    ),

    // =========================================================================
    // 17. SERIALISASI JSON & FREEZED
    // =========================================================================
    LessonItem(
      id: 'json_serialization_freezed',
      title: 'Serialisasi JSON Lanjutan & Immutabilitas',
      subtitle: 'Otomatisasi Model Data, Immutability, copyWith, dan Value Equality dengan Freezed.',
      module: FundamentalModule.networkingApi,
      order: 17,
      readTimeMinutes: 9,
      level: 'Menengah',
      icon: Icons.code_off_rounded,
      summary:
          'Menghilangkan bug *typo key* dan menulis ratusan baris boilerplate parsing JSON dengan generator kode Freezed dan JsonSerializable.',
      sections: const [
        LessonSection(
          title: '1. Bahaya Parsing JSON Manual di Flutter',
          content:
              'Menulis method `fromJson` dan `toJson` secara manual sangat rawan kesalahan ketik nama key string, tidak menjamin immutabilitas, serta membutuhkan ratusan baris kode untuk method `copyWith`, `toString`, dan `==` (equality operator).',
        ),
        LessonSection(
          title: '2. Mendefinisikan Model Data dengan Freezed',
          content:
              'Freezed menghasilkan data class immutable dengan dukungan union types, copyWith, dan parsing JSON otomatis:',
          codeSnippet: '''
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _\$UserModel {
  const factory UserModel({
    required String id,
    required String username,
    required String email,
    @Default(false) bool isPremium,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _\$UserModelFromJson(json);
}

void main() {
  const user1 = UserModel(id: '1', username: 'zainal', email: 'z@naltech.id');
  
  // copyWith membuat objek baru tanpa memodifikasi objek asli
  final updatedUser = user1.copyWith(isPremium: true);
  
  print(user1 == updatedUser); // false (Value Equality)
}''',
          callout: 'Jalankan `dart run build_runner build --delete-conflicting-outputs` di terminal untuk men-generate file *.freezed.dart dan *.g.dart.',
        ),
      ],
      keyTakeaways: const [
        '`Freezed` menjamin seluruh properti objek bersifat immutable (tidak bisa diubah secara tidak sengaja).',
        'Method `copyWith` sangat penting dalam arsitektur State Management reaktif seperti BLoC dan Riverpod.',
      ],
      quiz: const QuizQuestion(
        question: 'Mengapa method `copyWith` pada model data immutable sangat krusial dalam state management Flutter?',
        options: [
          'Untuk menghapus seluruh field menjadi null',
          'Untuk membuat salinan objek baru dengan beberapa properti yang diperbarui tanpa memodifikasi instance State yang lama',
          'Untuk mengonversi objek menjadi database SQLite',
          'Untuk mempercepat kompilasi aplikasi',
        ],
        correctIndex: 1,
        explanation: 'State management modern memerlukan instance objek baru saat terjadi perubahan state agar listener dan widget tree dapat mendeteksi perbedaan dan melakukan rebuild secara efisien.',
      ),
    ),

    // =========================================================================
    // 18. STORAGE & CACHING LOKAL
    // =========================================================================
    LessonItem(
      id: 'local_caching_persistence',
      title: 'Penyimpanan Data & Caching Lokal',
      subtitle: 'Memilih solusi storage yang tepat: SharedPreferences, Hive NoSQL, FlutterSecureStorage, dan Drift SQLite.',
      module: FundamentalModule.localStorage,
      order: 18,
      readTimeMinutes: 9,
      level: 'Menengah',
      icon: Icons.storage_rounded,
      summary:
          'Strategi memilih database lokal dan caching offline untuk memastikan aplikasi tetap dapat digunakan tanpa koneksi internet.',
      sections: const [
        LessonSection(
          title: '1. Matriks Pemilihan Solusi Storage Lokal',
          content: 'Setiap library penyimpanan memiliki karakteristik dan tujuan penggunaan berbeda:',
          bulletPoints: [
            '**SharedPreferences**: Menyimpan key-value sederhana non-sensitif (misal: setting tema dark/light, status onboard selesai).',
            '**FlutterSecureStorage**: Menyimpan data sensitif terenkripsi hardware (misal: Access Token JWT, API Key, PIN).',
            '**Hive / Isar**: Database NoSQL super cepat berbasis binary storage (ideal untuk cache artikel, daftar produk offline, draft form).',
            '**SQLite / Drift**: Database relasional SQL lengkap dengan relasi tabel, indexing kompleks, dan transaksi ACID.',
          ],
        ),
        LessonSection(
          title: '2. Strategi Cache-First untuk Mode Offline',
          content:
              'Pola arsitektur repository yang mengembalikan data cache seketika lalu memperbarui data dari server di latar belakang:',
          codeSnippet: '''
class NewsRepository {
  final ApiClient api;
  final LocalBox cache;

  Stream<List<Article>> getNewsFeed() async* {
    // 1. Pancarkan data cache lokal seketika (Fast UX)
    final cachedData = cache.getArticles();
    if (cachedData.isNotEmpty) yield cachedData;

    try {
      // 2. Fetch data terbaru dari REST API
      final remoteData = await api.fetchNews();
      await cache.saveArticles(remoteData);
      
      // 3. Pancarkan data baru yang segar
      yield remoteData;
    } catch (e) {
      // Jika internet offline, pengguna tetap melihat data cache sebelumnya
      if (cachedData.isEmpty) rethrow;
    }
  }
}''',
        ),
      ],
      keyTakeaways: const [
        'Jangan pernah menyimpan JWT Token atau password di SharedPreferences biasa karena tidak terenkripsi.',
        'Gunakan strategi Cache-First menggunakan `Stream` untuk pengalaman pengguna yang instan tanpa loading screen kosong.',
      ],
      quiz: const QuizQuestion(
        question: 'Library manakah yang paling aman digunakan untuk menyimpan Token Autentikasi JWT pada perangkat Android & iOS?',
        options: [
          'SharedPreferences biasa',
          'FlutterSecureStorage (menggunakan Keystore/Keychain)',
          'File teks di direktori Documents',
          'Cookies memory RAM',
        ],
        correctIndex: 1,
        explanation: '`FlutterSecureStorage` menggunakan sistem enkripsi hardware resmi (Android KeyStore dan iOS Keychain) yang aman dari serangan reverse-engineering.',
      ),
    ),

    // =========================================================================
    // 19. WEBSOCKET & REAL-TIME STREAMING
    // =========================================================================
    LessonItem(
      id: 'websocket_realtime',
      title: 'WebSocket & Komunikasi Real-Time Dua Arah',
      subtitle: 'Koneksi persistent dua arah, real-time chat, live tracking GPS, dan heartbeat reconnection.',
      module: FundamentalModule.networkingApi,
      order: 19,
      readTimeMinutes: 8,
      level: 'Menengah',
      icon: Icons.sync_alt_rounded,
      summary:
          'Berbeda dengan REST API yang berbasis request-response searah, WebSocket membuka koneksi persisten dua arah dengan latensi sangat rendah.',
      sections: const [
        LessonSection(
          title: '1. REST Polling vs WebSocket',
          content:
              'REST Polling membuang bandwidth karena klien harus berulang kali bertanya *"apakah ada pesan baru?"* setiap beberapa detik. WebSocket membuka satu koneksi TCP terbuka di mana server dapat langsung mengirim (*push*) pesan begitu data tersedia.',
        ),
        LessonSection(
          title: '2. Mengelola WebSocketChannel di Flutter',
          content:
              'Gunakan package `web_socket_channel` untuk menghubungkan stream data real-time dengan widget Flutter:',
          codeSnippet: '''
import 'package:web_socket_channel/web_socket_channel.dart';

class LiveChatService {
  late WebSocketChannel channel;

  void connect() {
    channel = WebSocketChannel.connect(
      Uri.parse('wss://echo.websocket.events'),
    );
  }

  // Mengirim pesan ke server
  void sendMessage(String text) {
    channel.sink.add(jsonEncode({"type": "chat", "msg": text}));
  }

  // Mendengarkan pesan masuk
  Stream get stream => channel.stream;

  void close() {
    channel.sink.close();
  }
}''',
          callout: 'Selalu panggil `channel.sink.close()` saat halaman ditutup atau pengguna logout untuk mencegah kebocoran koneksi server.',
        ),
      ],
      keyTakeaways: const [
        'WebSocket ideal untuk live chat, notifikasi instan, pergerakan kurir di peta, dan live stock trading.',
        'StreamBuilder dapat langsung dikombinasikan dengan `channel.stream` untuk merender data real-time.',
      ],
      quiz: const QuizQuestion(
        question: 'Kapan WebSocket jauh lebih unggul dibandingkan HTTP REST API biasa?',
        options: [
          'Saat mengambil detail profil statis pengguna satu kali saat login',
          'Saat aplikasi membutuhkan pengiriman data dua arah dengan latensi sangat rendah secara terus menerus (misal: live chat)',
          'Saat mengunduh berkas PDF berukuran besar',
          'Saat aplikasi hanya berjalan dalam mode offline',
        ],
        correctIndex: 1,
        explanation: 'WebSocket mempertahankan koneksi aktif terus-menerus sehingga server dapat mendorong data ke aplikasi seketika tanpa perlu request berulang.',
      ),
    ),

    // =========================================================================
    // 20. BLOC & CUBIT MASTERCLASS
    // =========================================================================
    LessonItem(
      id: 'bloc_cubit_patterns',
      title: 'BLoC & Cubit Masterclass',
      subtitle: 'Events, States, BlocBuilder, BlocListener, BlocConsumer, dan arsitektur skala enterprise.',
      module: FundamentalModule.advancedState,
      order: 20,
      readTimeMinutes: 11,
      level: 'Menengah',
      icon: Icons.hub_rounded,
      summary:
          'BLoC (Business Logic Component) adalah pola state management paling populer untuk aplikasi enterprise yang memisahkan logika presentasi dari logika bisnis secara mutlak.',
      visualizerBuilder: (context) => const StateManagementMasterVisualizerWidget(),
      sections: const [
        LessonSection(
          title: '1. Cubit vs BLoC: Kapan Menggunakan yang Mana?',
          content: 'Keduanya merupakan bagian dari library `flutter_bloc`:',
          bulletPoints: [
            '**Cubit**: Pendekatan lebih sederhana berbasis pemanggilan fungsi (`cubit.increment()`). Sangat cocok untuk fitur dengan alur state lurus tanpa event kompleks.',
            '**BLoC**: Pendekatan *Event-Driven* murni (`bloc.add(IncrementEvent())`). Sangat unggul saat Anda membutuhkan debounce/throttle event (seperti live search input) atau audit log seluruh alur event.',
          ],
        ),
        LessonSection(
          title: '2. Membedakan BlocBuilder, BlocListener & BlocConsumer',
          content:
              'Memilih widget consumer yang tepat sangat krusial untuk performa dan interaksi UI:',
          bulletPoints: [
            '**`BlocBuilder`**: Hanya untuk merender/membangun tampilan UI murni berdasarkan State.',
            '**`BlocListener`**: Hanya untuk menjalankan aksi sampingan (*side-effects*) satu kali seperti menampilkan SnackBar, Dialog, atau navigasi layar tanpa rebuild UI.',
            '**`BlocConsumer`**: Menggabungkan `builder` dan `listener` dalam satu widget untuk efisiensi kode.',
          ],
          codeSnippet: '''
BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage)),
      );
    } else if (state is AuthSuccess) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  },
  builder: (context, state) {
    if (state is AuthLoading) {
      return const CircularProgressIndicator();
    }
    return const LoginForm();
  },
)''',
          callout: 'Jangan pernah memanggil `Navigator.push()` atau `showSnackBar()` di dalam `BlocBuilder` karena builder dapat terpanggil berulang kali saat rebuild!',
          isWarning: true,
        ),
      ],
      keyTakeaways: const [
        'Pisahkan aksi render UI di `builder` dan aksi notifikasi/navigasi di `listener`.',
        'Gunakan `buildWhen` dan `listenWhen` untuk menyaring dan membatasi rebuild hanya saat state tertentu berubah.',
      ],
      quiz: const QuizQuestion(
        question: 'Widget apakah yang paling tepat digunakan jika Anda ingin menampilkan SnackBar saat login gagal dan berpindah halaman saat login sukses?',
        options: [
          'BlocBuilder',
          'BlocListener (atau BlocConsumer)',
          'StatelessWidget biasa',
          'AnimatedBuilder',
        ],
        correctIndex: 1,
        explanation: '`BlocListener` dirancang khusus untuk menangani aksi satu kali (*side-effects*) seperti SnackBar atau navigasi rute tanpa memicu rebuild tampilan.',
      ),
    ),

    // =========================================================================
    // 21. RIVERPOD 2.X MODERN ARCHITECTURE
    // =========================================================================
    LessonItem(
      id: 'riverpod_modern_patterns',
      title: 'Riverpod 2.x Modern Architecture',
      subtitle: 'AsyncNotifier, ProviderScope, ref.watch vs ref.read, family, dan autoDispose.',
      module: FundamentalModule.advancedState,
      order: 21,
      readTimeMinutes: 10,
      level: 'Menengah',
      icon: Icons.layers_rounded,
      summary:
          'Riverpod adalah framework state management compile-safe yang tidak bergantung pada BuildContext dan memiliki penanganan asynchronous bawaan via AsyncValue.',
      sections: const [
        LessonSection(
          title: '1. Keunggulan Riverpod 2.x',
          content:
              'Riverpod diciptakan oleh pembuat Provider untuk mengatasi batasan `InheritedWidget`. Riverpod tidak membutuhkan `BuildContext` untuk membaca provider, sepenuhnya compile-safe, dan mendukung caching otomatis.',
        ),
        LessonSection(
          title: '2. AsyncNotifier & AsyncValue',
          content:
              '`AsyncNotifier` secara elegan mengelola 3 status asynchronous (Loading, Error, Data) tanpa perlu membuat class Union State secara manual:',
          codeSnippet: '''
@riverpod
class UserProfileNotifier extends _\$UserProfileNotifier {
  @override
  Future<UserProfile> build(String userId) async {
    // Otomatis menjadi AsyncLoading -> AsyncData / AsyncError
    return ref.watch(apiClientProvider).fetchUser(userId);
  }

  Future<void> updateBio(String newBio) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return ref.read(apiClientProvider).updateBio(newBio);
    });
  }
}

// Di Widget
class ProfileView extends ConsumerWidget {
  final String userId;
  const ProfileView(this.userId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(userProfileNotifierProvider(userId));

    return asyncUser.when(
      data: (user) => Text("Halo \${user.name}"),
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text("Error: \$err"),
    );
  }
}''',
          callout: 'Gunakan `ref.watch()` di dalam method `build()` untuk mendengarkan perubahan data, dan gunakan `ref.read()` di dalam event callback tombol (onPressed).',
        ),
      ],
      keyTakeaways: const [
        'Modifier `.autoDispose` otomatis membersihkan memori state saat tidak ada widget yang mendengarkannya lagi.',
        'Modifier `.family` memungkinkan pengiriman parameter dinamis (seperti ID artikel) ke provider.',
        '`AsyncValue.when` menyederhanakan penanganan status loading dan error secara deklaratif.',
      ],
      quiz: const QuizQuestion(
        question: 'Di mana tempat yang paling tepat untuk menggunakan `ref.read()` pada Riverpod?',
        options: [
          'Langsung di dalam deklarasi method build()',
          'Di dalam fungsi callback interaksi pengguna seperti tombol onPressed atau onTap',
          'Di dalam constructor StatelessWidget',
          'Di file main.dart di luar ProviderScope',
        ],
        correctIndex: 1,
        explanation: '`ref.read()` digunakan untuk membaca nilai satu kali di dalam event handlers (seperti `onPressed`) tanpa berlangganan terhadap perubahan state berkelanjutan.',
      ),
    ),

    // =========================================================================
    // 22. EXPLICIT ANIMATIONS & STAGGERED
    // =========================================================================
    LessonItem(
      id: 'explicit_animations_deep_dive',
      title: 'Explicit Animations & Staggered Transitions',
      subtitle: 'AnimationController, CurvedAnimation, TweenSequence, AnimatedBuilder, dan simulasi fisika.',
      module: FundamentalModule.animationsCustomPainter,
      order: 22,
      readTimeMinutes: 10,
      level: 'Menengah',
      icon: Icons.animation_rounded,
      summary:
          'Kuasai kontrol penuh atas animasi kustom Flutter dengan mengatur durasi, kurva percepatan, transisi berantai, dan optimasi 120 FPS via AnimatedBuilder.',
      sections: const [
        LessonSection(
          title: '1. Komponen Utama Explicit Animation',
          content: 'Explicit animation membutuhkan 3 elemen utama yang bekerja bersama:',
          bulletPoints: [
            '**`AnimationController`**: Mengatur waktu dan nilai linear dari 0.0 hingga 1.0 sepanjang durasi tertentu.',
            '**`CurvedAnimation`**: Mengubah kurva percepatan linear menjadi kurva non-linear alami (misal: `Curves.easeInOutBack` atau `Curves.elasticOut`).',
            '**`Tween`**: Mengonversi nilai 0.0–1.0 menjadi rentang nilai target (misal: `ColorTween`, `SizeTween`, `OffsetTween`).',
          ],
        ),
        LessonSection(
          title: '2. Isolasi Rebuild Menggunakan AnimatedBuilder',
          content:
              'Alih-alih menambahkan listener `controller.addListener(() => setState(() {}))` yang me-rebuild seluruh layar, SELALU gunakan `AnimatedBuilder` dengan parameter `child` statis untuk performa tinggi:',
          codeSnippet: '''
class PulseButton extends StatefulWidget {
  const PulseButton({super.key});
  @override
  State<PulseButton> createState() => _PulseButtonState();
}

class _PulseButtonState extends State<PulseButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true); // Loop bolak-balik

    _scaleAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Wajib di-dispose!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnim.value,
          child: child, // child statis tidak di-rebuild berulang!
        );
      },
      child: const CustomHeavyButtonWidget(),
    );
  }
}''',
        ),
      ],
      keyTakeaways: const [
        'Wajib menyematkan `SingleTickerProviderStateMixin` untuk menyediakan `vsync` hemat daya layar.',
        'Wajib memanggil `_controller.dispose()` di dalam `dispose()` untuk mencegah kebocoran memori.',
        'Gunakan parameter `child` pada `AnimatedBuilder` untuk mencegah widget child yang berat ikut di-rebuild setiap tick frame.',
      ],
      quiz: const QuizQuestion(
        question: 'Mengapa parameter `child` pada `AnimatedBuilder` sangat dianjurkan untuk widget yang tidak berubah strukturnya?',
        options: [
          'Agar tombol memiliki warna gradient otomatis',
          'Untuk menghindari kalkulasi dan rebuild ulang widget child pada setiap frame animasi (60/120 FPS)',
          'Agar animasi berjalan secara asynchronous di web worker',
          'Untuk membatasi ukuran memori APK',
        ],
        correctIndex: 1,
        explanation: 'Parameter `child` memungkinkan widget turunan yang kompleks dibuat satu kali dan digunakan ulang (*reused*) pada setiap frame tanpa harus memanggil method `build()` berulang kali.',
      ),
    ),

    // =========================================================================
    // 23. CUSTOMPAINTER & CANVAS API
    // =========================================================================
    LessonItem(
      id: 'custom_painter_canvas_art',
      title: 'CustomPainter & Canvas API',
      subtitle: 'Menggambar grafis vektor langsung ke GPU: Path, Bezier Curves, Custom Gauges & Charts.',
      module: FundamentalModule.animationsCustomPainter,
      order: 23,
      readTimeMinutes: 10,
      level: 'Lanjutan',
      icon: Icons.brush_rounded,
      summary:
          'Kekuatan melukis piksel murni di Flutter tanpa batas: menggambar bentuk geometris khusus, kurva Bezier lengkung halus, dan diagram grafik performa tinggi.',
      visualizerBuilder: (context) => const CustomPainterLiveVisualizerWidget(),
      sections: const [
        LessonSection(
          title: '1. Anatomi Kelas CustomPainter',
          content:
              'Sebuah `CustomPainter` memiliki dua method utama yang wajib diimplementasikan:',
          bulletPoints: [
            '**`paint(Canvas canvas, Size size)`**: Tempat seluruh instruksi gambar (garis, lingkaran, path, text) dieksekusi.',
            '**`shouldRepaint(covariant CustomPainter oldDelegate)`**: Mengembalikan boolean apakah canvas perlu digambar ulang saat data berubah (sangat penting untuk optimasi frame rate).',
          ],
        ),
        LessonSection(
          title: '2. Menggambar Kurva Bezier dengan Path',
          content:
              'Kurva lengkung halus (seperti header bergelombang atau gelombang air) digambar menggunakan `Path.quadraticBezierTo`:',
          codeSnippet: '''
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.indigo
      ..style = PaintingStyle.fill;

    final path = Path()
      ..lineTo(0, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.5, // Control point X
        size.height,       // Control point Y
        size.width,        // End point X
        size.height * 0.7, // End point Y
      )
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}''',
        ),
      ],
      keyTakeaways: const [
        '`CustomPainter` menggambar langsung ke antarmuka Skia/Impeller sehingga sangat efisien dan ringan.',
        'Selalu kembalikan `false` pada `shouldRepaint` jika properti input tidak berubah untuk menghemat komputasi GPU.',
      ],
      quiz: const QuizQuestion(
        question: 'Apa fungsi utama dari method `shouldRepaint` pada sebuah class CustomPainter?',
        options: [
          'Mengubah warna background Scaffold',
          'Memberi tahu engine Flutter apakah canvas perlu dilukis ulang atau cukup menggunakan hasil render sebelumnya untuk menghemat GPU',
          'Menghapus cache memory secara paksa',
          'Mengaktifkan fitur dark mode',
        ],
        correctIndex: 1,
        explanation: 'Method `shouldRepaint` membandingkan properti lama dengan yang baru; jika bernilai false, Flutter melewati proses rendering canvas dan menghemat siklus GPU.',
      ),
    ),

    // =========================================================================
    // 24. UNIT TESTING & MOCKING LOGIC
    // =========================================================================
    LessonItem(
      id: 'unit_testing_mocktail',
      title: 'Unit Testing & Mocking Logic',
      subtitle: 'Pengujian logika bisnis, Repository, UseCases, dan simulasi mock data dengan Mocktail.',
      module: FundamentalModule.testingQa,
      order: 24,
      readTimeMinutes: 9,
      level: 'Menengah',
      icon: Icons.science_rounded,
      summary:
          'Menulis pengujian otomatis untuk memverifikasi logika bisnis murni berjalan benar dalam segala skenario sukses maupun gagal tanpa bergantung pada koneksi server sungguhan.',
      sections: const [
        LessonSection(
          title: '1. Piramida Testing di Flutter',
          content: 'Arsitektur pengujian yang sehat terdiri dari 3 lapisan:',
          bulletPoints: [
            '**Unit Tests (70%)**: Menguji unit terkecil (fungsi, class, repository) secara terisolasi. Paling cepat dijalankan.',
            '**Widget Tests (20%)**: Menguji interaksi komponen visual UI tanpa emulator perangkat penuh.',
            '**Integration Tests (10%)**: Menguji alur lengkap end-to-end pada emulator/perangkat sungguhan.',
          ],
        ),
        LessonSection(
          title: '2. Pola Arrange-Act-Assert dengan Mocktail',
          content:
              'Simulasikan dependensi eksternal (seperti HTTP client) untuk menguji kondisi sukses dan error secara terisolasi:',
          codeSnippet: '''
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late UserRepository repository;
  late MockHttpClient mockClient;

  setUp(() {
    mockClient = MockHttpClient();
    repository = UserRepository(mockClient);
  });

  group('fetchUserProfile', () {
    test('Mengembalikan UserModel ketika response status 200 OK', () async {
      // 1. Arrange (Persiapan ekspektasi mock)
      when(() => mockClient.get('/api/user/1')).thenAnswer(
        (_) async => HttpResponse(statusCode: 200, body: '{"id": "1", "name": "Zainal"}'),
      );

      // 2. Act (Eksekusi fungsi yang diuji)
      final user = await repository.fetchUserProfile('1');

      // 3. Assert (Asersi hasil verifikasi)
      expect(user.id, equals('1'));
      expect(user.name, equals('Zainal'));
      verify(() => mockClient.get('/api/user/1')).called(1);
    });
  });
}''',
        ),
      ],
      keyTakeaways: const [
        'Gunakan pola AAA (Arrange, Act, Assert) untuk struktur kode pengujian yang bersih dan jelas.',
        'Mocking memungkinkan pengujian skenario ekstrem (seperti error 500 atau timeout) yang sulit direproduksi di server produksi nyata.',
      ],
      quiz: const QuizQuestion(
        question: 'Mengapa kita sebaiknya menggunakan Mock Client daripada request jaringan sungguhan saat menjalankan Unit Test?',
        options: [
          'Agar kuota internet komputer tidak habis',
          'Agar pengujian berjalan cepat, deterministik, terisolasi, dan tidak gagal akibat gangguan server eksternal',
          'Karena Flutter melarang penggunaan internet pada laptop',
          'Agar database produksi terisi data uji',
        ],
        correctIndex: 1,
        explanation: 'Unit test harus berjalan cepat dan deterministik (selalu konsisten). Menggunakan mock mengisolasi kode dari fluktuasi koneksi internet dan kondisi server nyata.',
      ),
    ),

    // =========================================================================
    // 25. WIDGET & INTEGRATION TESTING
    // =========================================================================
    LessonItem(
      id: 'widget_integration_testing',
      title: 'Widget Testing & UI Automation',
      subtitle: 'Pengujian interaksi antarmuka dengan testWidgets, Finder, tester.pumpAndSettle, dan gestur pengguna.',
      module: FundamentalModule.testingQa,
      order: 25,
      readTimeMinutes: 9,
      level: 'Menengah',
      icon: Icons.fact_check_rounded,
      summary:
          'Memastikan antarmuka visual merespons sentuhan, menampilkan teks yang benar, dan berpindah state dengan benar menggunakan simulator headless Flutter Test Environment.',
      sections: const [
        LessonSection(
          title: '1. Anatomi Widget Testing',
          content:
              'Widget test berjalan di lingkungan headless test tanpa perlu menyalakan Android Emulator atau simulator iOS, sehingga dapat selesai dalam hitungan detik:',
          bulletPoints: [
            '**`tester.pumpWidget()`**: Merender widget tree awal di test environment.',
            '**`find.byType` / `find.text` / `find.byKey`**: Mencari lokasi widget di dalam pohon.',
            '**`tester.tap()` / `tester.enterText()`**: Mensimulasikan sentuhan dan ketikan keyboard user.',
            '**`tester.pumpAndSettle()`**: Menunggu seluruh animasi dan timer selesai berputar sebelum melakukan asersi.',
          ],
        ),
        LessonSection(
          title: '2. Contoh Uji Form Login',
          content: 'Memverifikasi alur validasi input form teks pada tombol submit:',
          codeSnippet: '''
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Menampilkan pesan error jika email kosong saat tombol ditekan',
      (WidgetTester tester) async {
    // 1. Render halaman login
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    // 2. Cari tombol Login dan tekan tanpa mengisi email
    final submitButton = find.widgetWithText(ElevatedButton, 'Masuk');
    await tester.tap(submitButton);

    // 3. Render ulang frame setelah interaksi (rebuild)
    await tester.pumpAndSettle();

    // 4. Asersi pesan error validasi muncul di layar
    expect(find.text('Email tidak boleh kosong'), findsOneWidget);
  });
}''',
          callout: 'Selalu panggil `tester.pumpAndSettle()` setelah men-tap tombol yang memicu animasi atau proses async agar frame UI ter-update sempurna.',
        ),
      ],
      keyTakeaways: const [
        '`tester.pumpAndSettle()` menunggu hingga tidak ada lagi frame animasi yang dijadwalkan.',
        'Gunakan `ValueKey` pada widget penting untuk mempermudah pencarian via `find.byKey(const Key("submit_btn"))`.',
      ],
      quiz: const QuizQuestion(
        question: 'Apa fungsi dari perintah `await tester.pumpAndSettle()` pada Widget Testing Flutter?',
        options: [
          'Mematikan aplikasi seketika',
          'Menunggu secara berulang hingga seluruh frame animasi dan operasi microtask selesai diselesaikan',
          'Menghubungkan emulator ke Wi-Fi',
          'Menghapus seluruh widget dari memori',
        ],
        correctIndex: 1,
        explanation: '`pumpAndSettle()` terus memompa frame hingga tidak ada lagi animasi atau pembaruan terjadwal yang sedang berlangsung, memastikan layar sudah dalam kondisi stabil untuk diuji.',
      ),
    ),
  ];
}
