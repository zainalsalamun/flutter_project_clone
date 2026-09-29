import 'package:flutter/material.dart';

class CatalogSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const CatalogSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: 'Cari contoh widget (nama, tag, fitur)...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13.5),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF6366F1),
            size: 22,
          ),
          suffixIcon:
              controller.text.isNotEmpty
                  ? IconButton(
                    icon: const Icon(
                      Icons.clear_rounded,
                      size: 18,
                      color: Colors.grey,
                    ),
                    onPressed: onClear,
                  )
                  : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
