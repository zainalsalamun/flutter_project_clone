import 'package:flutter/material.dart';

class DartBasicsInteractiveVisualizerWidget extends StatefulWidget {
  const DartBasicsInteractiveVisualizerWidget({super.key});

  @override
  State<DartBasicsInteractiveVisualizerWidget> createState() =>
      _DartBasicsInteractiveVisualizerWidgetState();
}

class _DartBasicsInteractiveVisualizerWidgetState
    extends State<DartBasicsInteractiveVisualizerWidget> {
  int _selectedTopicIndex = 0;

  final List<Map<String, dynamic>> _topics = [
    {
      'title': '1. final vs const vs var',
      'code': '''
var name = "Zainal";         // Tipe diinferensi String, nilai mutable
final time = DateTime.now(); // Nilai dihitung saat runtime, immutable
const pi = 3.14159;          // Nilai konstan mutlak saat compile-time''',
      'output': 'name: Zainal (mutable)\ntime: 2026-09-23 20:45:00 (runtime constant)\npi: 3.14159 (compile-time constant)',
      'explanation':
          'Gunakan const jika nilai sudah diketahui sebelum aplikasi dijalankan. Gunakan final jika nilai baru diketahui saat aplikasi berjalan namun tidak akan pernah berubah lagi.',
    },
    {
      'title': '2. Collection if and Spread Operator',
      'code': '''
bool isAdmin = true;
var baseRoles = ["Viewer", "Editor"];
var allRoles = [
  ...baseRoles,              // Spread operator
  if (isAdmin) "SuperAdmin", // Collection if
  for (var i = 1; i <= 2; i++) "Group \$i", // Collection for
];''',
      'output': 'allRoles: [Viewer, Editor, SuperAdmin, Group 1, Group 2]',
      'explanation':
          'Collection if, Collection for, dan Spread Operator (...) adalah fitur Dart yang sangat sering digunakan di dalam daftar children widget Flutter.',
    },
    {
      'title': '3. Pattern Matching and Records (Dart 3)',
      'code': '''
// Record pengembalian multi-nilai
(String, int) getUserInfo() => ("Zainal", 25);

// Switch Expression & Pattern Matching
String describeRole(String role) {
  return switch (role) {
    "admin" => "Akses penuh ke seluruh sistem",
    "editor" => "Dapat mengedit artikel",
    "viewer" => "Hanya dapat membaca data",
    _ => "Peran tidak dikenal",
  };
}''',
      'output': 'getUserInfo() -> (Zainal, 25)\ndescribeRole("admin") -> "Akses penuh ke seluruh sistem"',
      'explanation':
          'Dart 3 menghadirkan Records untuk mengembalikan multi-nilai tanpa class DTO khusus, dan Switch Expression untuk pengkondisian ringkas dan aman.',
    },
    {
      'title': '4. Factory and Named Constructors',
      'code': '''
class User {
  final String name;
  final int age;

  // Generative constructor
  const User({required this.name, required this.age});

  // Factory constructor dari JSON Map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json["name"] as String,
      age: json["age"] as int,
    );
  }
}''',
      'output': 'User.fromJson({"name": "Zainal", "age": 25}) -> Instance of User',
      'explanation':
          'Factory constructor memungkinkan pembuatan instance melalui logika pemrosesan data (seperti parsing JSON dari API) atau mengembalikan instance yang di-cache.',
    },
    {
      'title': '5. Sound Null Safety Operators',
      'code': '''
String? nullableName;
String displayName = nullableName ?? "Guest"; // Null coalescing

int? length = nullableName?.length; // Safe navigation

nullableName ??= "Default User"; // Null-aware assignment''',
      'output': 'displayName: "Guest"\nlength: null\nnullableName after ??=: "Default User"',
      'explanation':
          'Operator null-aware (?, ??, ?., ??=) mencegah runtime NullPointerException dan menyederhanakan fallback data null.',
    },
    {
      'title': '6. Mixins and Extension Methods',
      'code': '''
mixin LoggerMixin {
  void log(String msg) => print("[LOG]: \$msg");
}

class ApiService with LoggerMixin {
  void fetchData() => log("Fetching data...");
}

extension StringUtils on String {
  String get capitalize => isEmpty ? "" : "\${this[0].toUpperCase()}\${substring(1)}";
}''',
      'output': 'ApiService().fetchData() -> [LOG]: Fetching data...\n"naltech".capitalize -> "Naltech"',
      'explanation':
          'Mixin menyediakan pembagian fungsionalitas lintas hierarki class. Extension method menambahkan method baru ke tipe data tanpa mengubah class aslinya.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final cur = _topics[_selectedTopicIndex];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(Icons.terminal_rounded, color: Color(0xFF38BDF8), size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Simulator Konsep Dasar Dart',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Topic Selector Pills
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _topics.length,
              separatorBuilder: (context, index) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final isSel = _selectedTopicIndex == index;
                final t = _topics[index];
                return InkWell(
                  onTap: () => setState(() => _selectedTopicIndex = index),
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSel ? const Color(0xFF0284C7) : const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSel ? const Color(0xFF38BDF8) : const Color(0xFF334155),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      t['title'].toString().split('. ')[1],
                      style: TextStyle(
                        color: isSel ? Colors.white : Colors.white70,
                        fontSize: 11,
                        fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Code Container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.code_rounded, color: Color(0xFF38BDF8), size: 16),
                    const SizedBox(width: 6),
                    Text(
                      cur['title'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SelectableText(
                  (cur['code'] as String).trim(),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: Color(0xFF7DD3FC),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Output Console Box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF020617),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Output Evaluasi:',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  cur['output'] as String,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: Color(0xFF4ADE80),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Explanation Box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF0284C7).withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded, color: Color(0xFF38BDF8), size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    cur['explanation'] as String,
                    style: const TextStyle(color: Color(0xFFBAE6FD), fontSize: 11, height: 1.35),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
