import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NovaChatView extends StatefulWidget {
  const NovaChatView({super.key});

  @override
  State<NovaChatView> createState() => _NovaChatViewState();
}

class _NovaChatViewState extends State<NovaChatView> {
  List<Map<String, String>> _messages = [
    {
      'role': 'assistant',
      'text':
          'Hello Alex! I am Nova, your AI assistant. How can I help you today?',
    },
  ];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMessages = prefs.getString('nova_chat_history');
    if (savedMessages != null) {
      try {
        final List<dynamic> decoded = jsonDecode(savedMessages);
        setState(() {
          _messages = decoded.map((e) => Map<String, String>.from(e)).toList();
        });
      } catch (e) {
        debugPrint('Failed to load chat history: $e');
      }
    }
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nova_chat_history', jsonEncode(_messages));
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;
    
    final userText = _controller.text;
    setState(() {
      _messages.add({'role': 'user', 'text': userText});
      _isLoading = true;
    });
    _saveMessages();
    _controller.clear();

    final apiUrl = dotenv.env['AI_API_URL'];
    final apiKey = dotenv.env['AI_API_KEY'];

    if (apiUrl == null || apiKey == null || apiUrl.isEmpty || apiKey.isEmpty) {
      if (mounted) {
        setState(() {
          _messages.add({
            'role': 'ai',
            'text': 'Error: API URL or Key not found in .env file.',
          });
          _isLoading = false;
        });
      }
      return;
    }

    try {
      final url = Uri.parse('$apiUrl/chat/completions');
      
      // Build messages array
      List<Map<String, String>> apiMessages = [
        {'role': 'system', 'content': 'You are Nova Intelligence, an advanced AI assistant.'}
      ];
      
      // OpenAI uses 'content' instead of 'text'
      for (var msg in _messages) {
        apiMessages.add({
          'role': msg['role'] ?? 'user',
          'content': msg['text'] ?? ''
        });
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-v4-flash',
          'messages': apiMessages,
          'stream': false,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String reply = data['choices']?[0]?['message']?['content'] ?? 'Sorry, I have no response.';
        
        // Strip think blocks if any
        final thinkRegex = RegExp(r'<think>[\s\S]*?</think>', dotAll: true);
        reply = reply.replaceAll(thinkRegex, '').trim();

        if (mounted) {
          setState(() {
            _messages.add({
              'role': 'assistant',
              'text': reply,
            });
          });
          _saveMessages();
        }
      } else {
        if (mounted) {
          setState(() {
            _messages.add({
              'role': 'assistant',
              'text': 'Error: Server returned status ${response.statusCode}',
            });
          });
          _saveMessages();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add({
            'role': 'assistant',
            'text': 'Error connecting to the server: $e',
          });
        });
        _saveMessages();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App Bar Area for Chat
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFF6366F1),
                child: Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nova Intelligence',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Online',
                    style: TextStyle(
                      color: const Color(0xFF10B981).withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _messages = [
                      {
                        'role': 'assistant',
                        'text':
                            'Hello Alex! I am Nova, your AI assistant. How can I help you today?',
                      },
                    ];
                  });
                  _saveMessages();
                },
              ),
            ],
          ),
        ),

        // Chat List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: _messages.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length) {
                return _buildLoadingBubble();
              }
              final msg = _messages[index];
              final isAi = msg['role'] == 'assistant';
              return _buildMessageBubble(msg['text'] ?? '', isAi);
            },
          ),
        ),

        // Input Area
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: 100,
              ), // padding for bottom nav
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E).withOpacity(0.7),
                border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.attach_file,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            onPressed: () {},
                          ),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Ask Nova anything...',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A3C),
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomLeft: const Radius.circular(0),
          ),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Nova is thinking...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isAi) {
    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color:
              isAi
                  ? const Color(0xFF2A2A3C)
                  : const Color(0xFF6366F1).withOpacity(0.9),
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomLeft:
                isAi ? const Radius.circular(0) : const Radius.circular(20),
            bottomRight:
                isAi ? const Radius.circular(20) : const Radius.circular(0),
          ),
          border:
              isAi ? Border.all(color: Colors.white.withOpacity(0.05)) : null,
          boxShadow:
              isAi
                  ? null
                  : [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
