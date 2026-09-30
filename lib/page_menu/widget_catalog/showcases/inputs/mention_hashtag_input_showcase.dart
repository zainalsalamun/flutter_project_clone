import 'package:flutter/material.dart';

class MentionHashtagInputShowcase extends StatefulWidget {
  const MentionHashtagInputShowcase({super.key});

  @override
  State<MentionHashtagInputShowcase> createState() =>
      _MentionHashtagInputShowcaseState();
}

class _MentionHashtagInputShowcaseState
    extends State<MentionHashtagInputShowcase> {
  final TextEditingController _textController = TextEditingController(
    text:
        'Halo tim! Coba cek komponen baru dari @zainalsalamun untuk project #FlutterDev kita ',
  );

  bool _showSuggestions = false;
  String _currentTrigger = ''; // '@' or '#'
  String _currentQuery = '';
  int _triggerIndex = -1;

  final List<Map<String, String>> _usersList = [
    {
      'name': 'Zainal Salamun',
      'username': 'zainalsalamun',
      'role': 'Lead Mobile Dev',
      'avatarColor': '0xFF6366F1',
    },
    {
      'name': 'Siti Rahmawati',
      'username': 'siti_rahma',
      'role': 'Product Designer',
      'avatarColor': '0xFFEC4899',
    },
    {
      'name': 'Budi Prakoso',
      'username': 'budi_flutter',
      'role': 'Senior Flutter Eng',
      'avatarColor': '0xFF10B981',
    },
    {
      'name': 'Dimas Anggara',
      'username': 'dimas_tech',
      'role': 'Backend Architect',
      'avatarColor': '0xFFF59E0B',
    },
  ];

  final List<Map<String, String>> _hashtagsList = [
    {'tag': 'FlutterDev', 'count': '18.4k postingan'},
    {'tag': 'MobileUI', 'count': '9.2k postingan'},
    {'tag': 'DartLang', 'count': '6.7k postingan'},
    {'tag': 'CleanArchitecture', 'count': '4.1k postingan'},
    {'tag': 'WidgetCatalog', 'count': '2.5k postingan'},
  ];

  @override
  void initState() {
    super.initState();
    _textController.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _textController.removeListener(_handleTextChange);
    _textController.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    final text = _textController.text;
    final selection = _textController.selection;

    if (!selection.isValid || selection.baseOffset == 0) {
      if (_showSuggestions) setState(() => _showSuggestions = false);
      return;
    }

    final cursorPosition = selection.baseOffset;
    final textBeforeCursor = text.substring(0, cursorPosition);

    final lastAt = textBeforeCursor.lastIndexOf('@');
    final lastHash = textBeforeCursor.lastIndexOf('#');

    int activeTriggerPos = -1;
    String triggerChar = '';

    if (lastAt > lastHash && lastAt != -1) {
      activeTriggerPos = lastAt;
      triggerChar = '@';
    } else if (lastHash > lastAt && lastHash != -1) {
      activeTriggerPos = lastHash;
      triggerChar = '#';
    }

    if (activeTriggerPos != -1) {
      final queryCandidate = textBeforeCursor.substring(activeTriggerPos + 1);
      // Valid if query candidate doesn't contain spaces
      if (!queryCandidate.contains(' ')) {
        setState(() {
          _showSuggestions = true;
          _currentTrigger = triggerChar;
          _currentQuery = queryCandidate.toLowerCase();
          _triggerIndex = activeTriggerPos;
        });
        return;
      }
    }

    if (_showSuggestions) {
      setState(() => _showSuggestions = false);
    }
  }

  void _insertMention(String username) {
    _replaceTriggerWith('@$username ');
  }

  void _insertHashtag(String tag) {
    _replaceTriggerWith('#$tag ');
  }

  void _replaceTriggerWith(String replacement) {
    final text = _textController.text;
    final beforeTrigger = text.substring(0, _triggerIndex);
    final afterCursor =
        _textController.selection.isValid &&
                _textController.selection.baseOffset <= text.length
            ? text.substring(_textController.selection.baseOffset)
            : '';

    final newText = '$beforeTrigger$replacement$afterCursor';
    final newCursorPos = beforeTrigger.length + replacement.length;

    _textController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPos),
    );

    setState(() => _showSuggestions = false);
  }

  List<TextSpan> _buildFormattedTextSpans(String text) {
    final List<TextSpan> spans = [];
    final words = text.split(' ');

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      final suffix = i == words.length - 1 ? '' : ' ';

      if (word.startsWith('@') && word.length > 1) {
        spans.add(
          TextSpan(
            text: '$word$suffix',
            style: const TextStyle(
              color: Color(0xFF6366F1),
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else if (word.startsWith('#') && word.length > 1) {
        spans.add(
          TextSpan(
            text: '$word$suffix',
            style: const TextStyle(
              color: Color(0xFF06B6D4),
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: '$word$suffix',
            style: const TextStyle(color: Color(0xFF0F172A)),
          ),
        );
      }
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers =
        _usersList.where((u) {
          return u['username']!.toLowerCase().contains(_currentQuery) ||
              u['name']!.toLowerCase().contains(_currentQuery);
        }).toList();

    final filteredHashtags =
        _hashtagsList.where((h) {
          return h['tag']!.toLowerCase().contains(_currentQuery);
        }).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------------- 1. SMART INPUT WITH FLOATING SUGGESTIONS ----------------
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Suggestions Box (Visible when @ or # is typed)
              if (_showSuggestions) ...[
                Container(
                  constraints: const BoxConstraints(maxHeight: 160),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: [
                      // Header tag
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 6, 14, 4),
                        child: Text(
                          _currentTrigger == '@'
                              ? 'Rekomendasi Pengguna (@)'
                              : 'Tagar Populer (#)',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                      if (_currentTrigger == '@')
                        ...filteredUsers.map((user) {
                          final colorVal = int.parse(user['avatarColor']!);
                          return ListTile(
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            leading: CircleAvatar(
                              radius: 14,
                              backgroundColor: Color(colorVal),
                              child: Text(
                                user['name']![0],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              user['name']!,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '@${user['username']} • ${user['role']}',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            onTap: () => _insertMention(user['username']!),
                          );
                        })
                      else
                        ...filteredHashtags.map((h) {
                          return ListTile(
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            leading: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF06B6D4,
                                ).withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.tag_rounded,
                                color: Color(0xFF06B6D4),
                                size: 16,
                              ),
                            ),
                            title: Text(
                              '#${h['tag']}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF06B6D4),
                              ),
                            ),
                            subtitle: Text(
                              h['count']!,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            onTap: () => _insertHashtag(h['tag']!),
                          );
                        }),
                    ],
                  ),
                ),
              ],

              // TextField Input Area
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                child: TextField(
                  controller: _textController,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 13, height: 1.4),
                  decoration: const InputDecoration(
                    hintText:
                        'Ketik pesan... gunakan @ untuk mention atau # untuk hashtag',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),

              // Bottom Action Bar inside Card
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                child: Row(
                  children: [
                    // Quick trigger shortcuts
                    ActionChip(
                      avatar: const Icon(
                        Icons.alternate_email_rounded,
                        size: 14,
                        color: Color(0xFF6366F1),
                      ),
                      label: const Text(
                        'Mention',
                        style: TextStyle(fontSize: 10.5),
                      ),
                      backgroundColor: const Color(
                        0xFF6366F1,
                      ).withValues(alpha: 0.08),
                      side: BorderSide.none,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        final pos = _textController.selection.baseOffset;
                        final current = _textController.text;
                        final newPos = pos >= 0 ? pos : current.length;
                        _textController.text =
                            '${current.substring(0, newPos)}@${current.substring(newPos)}';
                        _textController.selection = TextSelection.collapsed(
                          offset: newPos + 1,
                        );
                      },
                    ),
                    const SizedBox(width: 6),
                    ActionChip(
                      avatar: const Icon(
                        Icons.tag_rounded,
                        size: 14,
                        color: Color(0xFF06B6D4),
                      ),
                      label: const Text(
                        'Hashtag',
                        style: TextStyle(fontSize: 10.5),
                      ),
                      backgroundColor: const Color(
                        0xFF06B6D4,
                      ).withValues(alpha: 0.08),
                      side: BorderSide.none,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        final pos = _textController.selection.baseOffset;
                        final current = _textController.text;
                        final newPos = pos >= 0 ? pos : current.length;
                        _textController.text =
                            '${current.substring(0, newPos)}#${current.substring(newPos)}';
                        _textController.selection = TextSelection.collapsed(
                          offset: newPos + 1,
                        );
                      },
                    ),
                    const Spacer(),

                    // Send Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        visualDensity: VisualDensity.compact,
                        elevation: 0,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Row(
                              children: [
                                Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Pesan dengan mention & tagar terkirim!',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: Color(0xFF10B981),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const Text(
                        'Kirim',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ---------------- 2. RICH TEXT LIVE PREVIEW CARD ----------------
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.visibility_rounded,
                    size: 15,
                    color: Color(0xFF6366F1),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Live Parsed RichText Preview:',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return RichText(
                    text: TextSpan(
                      children: _buildFormattedTextSpans(_textController.text),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
