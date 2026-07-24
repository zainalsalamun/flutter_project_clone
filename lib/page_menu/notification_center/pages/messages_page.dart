import 'package:flutter/material.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      {'name': 'Alice Smith', 'msg': 'Hey, are we still on for tomorrow?', 'time': '10:30 AM', 'unread': 2},
      {'name': 'Bob Johnson', 'msg': 'I just sent the documents.', 'time': 'Yesterday', 'unread': 0},
      {'name': 'Charlie Brown', 'msg': 'Thanks for the help!', 'time': 'Yesterday', 'unread': 0},
      {'name': 'Diana Ross', 'msg': 'Can you call me back?', 'time': 'Monday', 'unread': 1},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Messages', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: ListView.separated(
        itemCount: messages.length,
        separatorBuilder: (context, index) => const Divider(height: 1, indent: 70),
        itemBuilder: (context, index) {
          final chat = messages[index];
          final unread = chat['unread'] as int;
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blueAccent,
              child: Text(
                (chat['name'] as String)[0],
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(chat['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              chat['msg'] as String,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: unread > 0 ? Colors.black87 : Colors.grey,
                fontWeight: unread > 0 ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chat['time'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: unread > 0 ? Colors.blue : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                if (unread > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      unread.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  )
                else
                  const SizedBox(height: 24, width: 24),
              ],
            ),
            onTap: () {},
          );
        },
      ),
    );
  }
}
