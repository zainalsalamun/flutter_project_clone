import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AiPromptSuggestionCloudShowcase extends StatefulWidget {
  const AiPromptSuggestionCloudShowcase({super.key});

  @override
  State<AiPromptSuggestionCloudShowcase> createState() =>
      _AiPromptSuggestionCloudShowcaseState();
}

class _PromptItem {
  final String id;
  final String category;
  final String icon;
  final String title;
  final String promptText;
  final Color accentColor;

  const _PromptItem({
    required this.id,
    required this.category,
    required this.icon,
    required this.title,
    required this.promptText,
    required this.accentColor,
  });
}

class _AiPromptSuggestionCloudShowcaseState
    extends State<AiPromptSuggestionCloudShowcase> {
  final List<_PromptItem> _allPrompts = const [
    _PromptItem(
      id: '1',
      category: 'Coding',
      icon: '',
      title: 'Refactor Kode Flutter',
      promptText:
          'Tolong refactor widget Flutter ini menjadi komponen modular yang clean dan gunakan StatelessWidget dengan ChangeNotifierProvider.',
      accentColor: Color(0xFF38BDF8),
    ),
    _PromptItem(
      id: '2',
      category: 'Coding',
      icon: '',
      title: 'Optimasi Performa 60 FPS',
      promptText:
          'Analisis bottleneck rendering pada ListView.builder dan berikan strategi caching gambar serta `const constructor`.',
      accentColor: Color(0xFF818CF8),
    ),
    _PromptItem(
      id: '3',
      category: 'Penulisan',
      icon: '',
      title: 'Release Notes Aplikasi',
      promptText:
          'Buatkan rilis changelog update versi v2.4.0 yang engaging untuk Google Play Store dengan emoji dan format rapi.',
      accentColor: Color(0xFFF472B6),
    ),
    _PromptItem(
      id: '4',
      category: 'Penulisan',
      icon: '',
      title: 'Copywriting Landing Page',
      promptText:
          'Tuliskan headline hero section, sub-headline, dan 3 nilai jual utama (USP) untuk aplikasi fintech pencatat keuangan.',
      accentColor: Color(0xFFFB923C),
    ),
    _PromptItem(
      id: '5',
      category: 'Ide Kreatif',
      icon: '',
      title: 'Konsep Micro-Interaction UI',
      promptText:
          'Berikan 5 ide mikro-interaksi tombol favorit/like yang unik dengan efek haptic dan animasi partikel meletup.',
      accentColor: Color(0xFFA78BFA),
    ),
    _PromptItem(
      id: '6',
      category: 'Ide Kreatif',
      icon: '',
      title: 'Nama Fitur AI Canggih',
      promptText:
          'Beri 10 usulan nama fitur asisten cerdas berbasis AI yang terdengar modern, ramah, dan mudah diingat pengguna.',
      accentColor: Color(0xFFFACC15),
    ),
    _PromptItem(
      id: '7',
      category: 'Analisis Data',
      icon: '',
      title: 'Formula SQL Query Kueri',
      promptText:
          'Buatkan query PostgreSQL untuk menghitung Monthly Active Users (MAU) dan Churn Rate selama 6 bulan terakhir.',
      accentColor: Color(0xFF34D399),
    ),
    _PromptItem(
      id: '8',
      category: 'Analisis Data',
      icon: '',
      title: 'Visualisasi Metrik Retensi',
      promptText:
          'Bagaimana cara terbaik memvisualisasikan funnel konversi onboarding pengguna dari sign up hingga checkout pertama?',
      accentColor: Color(0xFF2DD4BF),
    ),
  ];

  String _selectedCategory = 'Semua';
  final List<String> _categories = [
    'Semua',
    'Coding',
    'Penulisan',
    'Ide Kreatif',
    'Analisis Data',
  ];

  final TextEditingController _inputController = TextEditingController();
  String _simulatedAiResponse = '';
  bool _isGenerating = false;
  Timer? _typewriterTimer;

  @override
  void dispose() {
    _inputController.dispose();
    _typewriterTimer?.cancel();
    super.dispose();
  }

  void _applyPrompt(_PromptItem item) {
    HapticFeedback.lightImpact();
    setState(() {
      _inputController.text = item.promptText;
      _simulatedAiResponse = '';
    });
  }

  void _sendPrompt() {
    final text = _inputController.text.trim();
    if (text.isEmpty || _isGenerating) return;

    HapticFeedback.mediumImpact();
    _typewriterTimer?.cancel();

    setState(() {
      _isGenerating = true;
      _simulatedAiResponse = '';
    });

    final dummyResponse =
        ' [AI Assistant]: Menerima instruksi "$text".\n\n'
        'Berikut adalah rekomendasi arsitektur terbaik untuk implementasi kebutuhan Anda:\n'
        '1. Pisahkan layer domain & data secara independen.\n'
        '2. Terapkan state management reaktif dengan 60 FPS repaint boundary.\n'
        '3. Gunakan token caching untuk respon instan tanpa network overhead.\n\n'
        'Semoga solusi ini membantu proyek Anda meluncur lebih cepat!';

    int charIndex = 0;
    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 20), (
      timer,
    ) {
      if (!mounted) return;

      if (charIndex < dummyResponse.length) {
        setState(() {
          _simulatedAiResponse += dummyResponse[charIndex];
          charIndex++;
        });
      } else {
        timer.cancel();
        setState(() {
          _isGenerating = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredPrompts =
        _selectedCategory == 'Semua'
            ? _allPrompts
            : _allPrompts
                .where((p) => p.category == _selectedCategory)
                .toList();

    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // HEADER INFO
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1E293B),
                  const Color(0xFF334155).withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF818CF8).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF818CF8).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Color(0xFF818CF8),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AI Prompt Suggestion Cloud',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Awan prompt cerdas dengan filter kategori, template instan, dan integrasi input bar dengan efek ketik.',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // CATEGORY PILL FILTER CHIPS
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  _categories.map((cat) {
                    final isSel = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSel,
                        onSelected: (val) {
                          if (val) setState(() => _selectedCategory = cat);
                        },
                        selectedColor: const Color(0xFF818CF8),
                        backgroundColor: const Color(0xFF1E293B),
                        labelStyle: TextStyle(
                          color: isSel ? Colors.white : Colors.white70,
                          fontWeight:
                              isSel ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // PROMPT CARDS CLOUD GRID
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                filteredPrompts.map((item) {
                  return _buildPromptCard(item);
                }).toList(),
          ),

          const SizedBox(height: 24),

          // INTERACTIVE CHAT INPUT BAR
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF818CF8).withValues(alpha: 0.3),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: Color(0xFF818CF8),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Prompt Aktif:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (_inputController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () => setState(() => _inputController.clear()),
                        child: const Text(
                          'Hapus',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _inputController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText:
                        'Pilih prompt di atas atau ketik instruksi baru...',
                    hintStyle: const TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isGenerating
                          ? 'AI sedang menyusun respon...'
                          : 'Siap dikirim',
                      style: TextStyle(
                        color:
                            _isGenerating
                                ? const Color(0xFF818CF8)
                                : Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _isGenerating ? null : _sendPrompt,
                      icon:
                          _isGenerating
                              ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Icon(Icons.send_rounded, size: 16),
                      label: const Text(
                        'Kirim ke AI',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF818CF8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // SIMULATED AI RESPONSE CARD
          if (_simulatedAiResponse.isNotEmpty) ...[
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1B4B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF818CF8).withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                _simulatedAiResponse,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPromptCard(_PromptItem item) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 10) / 2;

        return InkWell(
          onTap: () => _applyPrompt(item),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: cardWidth > 140 ? cardWidth : double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: item.accentColor.withValues(alpha: 0.35),
              ),
              boxShadow: [
                BoxShadow(
                  color: item.accentColor.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: item.accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.icon,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.promptText,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 10.5,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Gunakan ->',
                      style: TextStyle(
                        color: item.accentColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
