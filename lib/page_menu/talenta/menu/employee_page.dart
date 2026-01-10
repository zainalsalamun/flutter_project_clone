import 'package:flutter/material.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Dummy Data for "Who's Off Today"
  final List<_Employee> offEmployees = [
    _Employee(name: 'Sufi Novia', role: 'Staff', imageUrl: ''),
    _Employee(name: 'Shifa Amelia', role: 'Staff', imageUrl: ''),
    _Employee(name: 'Sundari', role: 'Staff', imageUrl: ''),
    _Employee(name: 'Deza Sabilla', role: 'Staff', imageUrl: ''),
    _Employee(name: 'Hardian', role: 'Staff', imageUrl: ''),
  ];

  // Dummy Data for Employee List
  final List<_Employee> allEmployees = [
    _Employee(
      name: 'Budi Santoso',
      role: 'Senior Frontend Engineer',
      imageUrl: '',
    ),
    _Employee(name: 'Siti Aminah', role: 'Product Manager', imageUrl: ''),
    _Employee(name: 'Rahmat Hidayat', role: 'UI/UX Designer', imageUrl: ''),
    _Employee(name: 'Dewi Lestari', role: 'Quality Assurance', imageUrl: ''),
    _Employee(name: 'Eko Prasetyo', role: 'Backend Developer', imageUrl: ''),
    _Employee(name: 'Fajar Nugraha', role: 'DevOps Engineer', imageUrl: ''),
    _Employee(name: 'Gita Pertiwi', role: 'HR Specialist', imageUrl: ''),
    _Employee(name: 'Hendra Wijaya', role: 'Mobile Developer', imageUrl: ''),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_Employee> get filteredEmployees {
    if (_searchQuery.isEmpty) {
      return allEmployees;
    }
    return allEmployees
        .where((e) => e.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  RichText(
                    text: TextSpan(
                      text: 'Employees ',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      children: [
                        TextSpan(
                          text: '${allEmployees.length + 550}',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.hub_outlined,
                    color: Colors.grey[600],
                  ), // Org chart icon alias
                  const SizedBox(width: 16),
                  Icon(Icons.filter_list, color: Colors.grey[600]),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search employee',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Who's Off Today Section
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: Text(
                        "Who's Off Today",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: offEmployees.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final emp = offEmployees[index];
                          return Column(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.grey[200],
                                child: Text(
                                  emp.initials,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 70,
                                child: Text(
                                  emp.firstName,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
                    const SizedBox(height: 8),

                    // Employee List
                    ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredEmployees.length,
                      separatorBuilder:
                          (_, __) => const Padding(
                            padding: EdgeInsets.only(left: 64),
                            child: Divider(),
                          ),
                      itemBuilder: (context, index) {
                        final emp = filteredEmployees[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: Colors
                                    .primaries[index % Colors.primaries.length]
                                    .withOpacity(0.2),
                                backgroundImage:
                                    emp.imageUrl.isNotEmpty
                                        ? NetworkImage(emp.imageUrl)
                                        : null,
                                child:
                                    emp.imageUrl.isEmpty
                                        ? Text(
                                          emp.initials,
                                          style: TextStyle(
                                            color:
                                                Colors.primaries[index %
                                                    Colors.primaries.length],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                        : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      emp.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      emp.role,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Action Buttons
                              Row(
                                children: [
                                  _ActionButton(
                                    icon: Icons.phone_outlined,
                                    onTap: () {},
                                  ),
                                  const SizedBox(width: 12),
                                  _ActionButton(
                                    icon: Icons.email_outlined,
                                    onTap: () {},
                                  ),
                                  const SizedBox(width: 12),
                                  _ActionButton(
                                    icon: Icons.chat_bubble_outline,
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 24, color: const Color(0xFF616161)),
      ),
    );
  }
}

class _Employee {
  final String name;
  final String role;
  final String imageUrl;

  _Employee({required this.name, required this.role, required this.imageUrl});

  String get initials {
    if (name.isEmpty) return '';
    final parts = name.split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  String get firstName {
    if (name.isEmpty) return '';
    return name.split(' ')[0];
  }
}
