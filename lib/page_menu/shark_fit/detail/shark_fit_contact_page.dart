import 'package:flutter/material.dart';

class SharkFitContactPage extends StatefulWidget {
  const SharkFitContactPage({super.key});

  @override
  State<SharkFitContactPage> createState() => _SharkFitContactPageState();
}

class _SharkFitContactPageState extends State<SharkFitContactPage> {
  // Mock data
  final List<Map<String, String>> _contacts = [
    {'name': 'Mom', 'number': '+1 234 567 890'},
    {'name': 'Dad', 'number': '+1 987 654 321'},
    {'name': 'Office', 'number': '+1 555 123 456'},
    {'name': 'Emergency', 'number': '911'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Favorite Contacts',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body:
          _contacts.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.contact_phone_outlined,
                      size: 64,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No contacts added",
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount: _contacts.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final contact = _contacts[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              contact['name']![0],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                contact['name']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                contact['number']!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _contacts.removeAt(index);
                            });
                          },
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red.shade400,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12)),
        ),
        child: ElevatedButton(
          onPressed: () {
            // Mock add action
            setState(() {
              _contacts.add({
                'name': 'New Contact',
                'number': '+1 000 000 000',
              });
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00C853),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Add Contact',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
