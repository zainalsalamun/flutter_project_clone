import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NovaVisionView extends StatefulWidget {
  const NovaVisionView({super.key});

  @override
  State<NovaVisionView> createState() => _NovaVisionViewState();
}

class _NovaVisionViewState extends State<NovaVisionView> {
  final TextEditingController _promptController = TextEditingController();
  final List<String> _generatedImages = [];
  bool _isGenerating = false;

  void _generateArt() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    FocusScope.of(context).unfocus();
    
    setState(() {
      _isGenerating = true;
    });

    final apiUrl = dotenv.env['AI_API_URL'];
    final apiKey = dotenv.env['AI_API_KEY'];

    if (apiUrl == null || apiKey == null || apiUrl.isEmpty || apiKey.isEmpty) {
      if (mounted) {
        setState(() {
          _generatedImages.insert(0, "Error: API URL or Key not found in .env file.");
          _isGenerating = false;
        });
      }
      return;
    }

    try {
      final url = Uri.parse('$apiUrl/chat/completions');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-v4-flash',
          'messages': [
            {'role': 'system', 'content': 'You are an AI that generates creative textual representations, ascii art, or detailed image descriptions.'},
            {'role': 'user', 'content': prompt}
          ],
          'stream': false,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String reply = data['choices']?[0]?['message']?['content'] ?? 'No output.';
        
        final thinkRegex = RegExp(r'<think>[\s\S]*?</think>', dotAll: true);
        reply = reply.replaceAll(thinkRegex, '').trim();

        if (mounted) {
          setState(() {
            _generatedImages.insert(0, reply);
            _isGenerating = false;
          });
          _promptController.clear();
        }
      } else {
        if (mounted) {
          setState(() {
            _generatedImages.insert(0, "Error: ${response.statusCode}");
            _isGenerating = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _generatedImages.insert(0, "Error: $e");
          _isGenerating = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Vision Gallery',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.2), // Amber
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFF59E0B).withOpacity(0.5),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.workspace_premium,
                      color: Color(0xFFF59E0B),
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Free API',
                      style: TextStyle(
                        color: Color(0xFFF59E0B),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Input Generator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1E1E2E),
                  const Color(0xFF1E1E2E).withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.brush, color: Color(0xFF8B5CF6), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Imagine anything...',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _promptController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText:
                          'A cyberpunk city with flying cars in neon light...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.2),
                      ),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _generateArt(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isGenerating ? null : _generateArt,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      disabledBackgroundColor: const Color(0xFF8B5CF6).withOpacity(0.5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: _isGenerating ? 0 : 8,
                      shadowColor: const Color(0xFF8B5CF6).withOpacity(0.5),
                    ),
                    child: _isGenerating
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Generate Art',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Gallery Grid
        Expanded(
          child: _generatedImages.isEmpty
              ? Center(
                  child: Text(
                    'No art generated yet.\nTry typing a prompt above!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 14,
                    ),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: 100,
                  ), // padding for bottom nav
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _generatedImages.length,
                  itemBuilder: (context, index) {
                    return _buildRealGalleryItem(_generatedImages[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildRealGalleryItem(String content) {
    bool isUrl = content.startsWith('http');

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: const Color(0xFF2A2A3C),
            child: isUrl 
              ? Image.network(
                  content,
                  headers: const {
                    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                  },
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('Image load error: $error');
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cloud_off, color: Colors.redAccent, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          'Free API Overloaded\nPlease try again later',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  },
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    content,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.favorite_border, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Icon(Icons.download_rounded, color: Colors.white, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
