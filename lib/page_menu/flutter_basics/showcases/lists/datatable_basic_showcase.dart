import 'package:flutter/material.dart';

class DataTableBasicShowcase extends StatefulWidget {
  const DataTableBasicShowcase({super.key});

  @override
  State<DataTableBasicShowcase> createState() => _DataTableBasicShowcaseState();
}

class _DataTableBasicShowcaseState extends State<DataTableBasicShowcase> {
  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  final List<Map<String, dynamic>> _data = [
    {
      'name': 'Flutter SDK',
      'version': '3.24.0',
      'stars': 160000,
      'selected': false,
    },
    {'name': 'Dart Lang', 'version': '3.5.0', 'stars': 9500, 'selected': true},
    {'name': 'Provider', 'version': '6.1.2', 'stars': 4800, 'selected': false},
    {
      'name': 'Flutter BLoC',
      'version': '8.1.4',
      'stars': 12400,
      'selected': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              sortColumnIndex: _sortColumnIndex,
              sortAscending: _sortAscending,
              columns: [
                DataColumn(
                  label: const Text(
                    'Package / Tool',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                      _data.sort(
                        (a, b) =>
                            ascending
                                ? (a['name'] as String).compareTo(b['name'])
                                : (b['name'] as String).compareTo(a['name']),
                      );
                    });
                  },
                ),
                const DataColumn(
                  label: Text(
                    'Versi',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: const Text(
                    'GitHub Stars',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  numeric: true,
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                      _data.sort(
                        (a, b) =>
                            ascending
                                ? (a['stars'] as int).compareTo(b['stars'])
                                : (b['stars'] as int).compareTo(a['stars']),
                      );
                    });
                  },
                ),
              ],
              rows:
                  _data.map((item) {
                    return DataRow(
                      selected: item['selected'] as bool,
                      onSelectChanged: (val) {
                        setState(() {
                          item['selected'] = val ?? false;
                        });
                      },
                      cells: [
                        DataCell(
                          Text(
                            item['name'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item['version'] as String,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                        DataCell(Text('${item['stars']}')),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),

        const Text(
          'Fitur DataTable Bawaan Flutter:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 6),
        const Text(
          '• Mendukung sorting otomatis per kolom dengan tap header.\n• Mendukung multi-row selection dengan checkbox secara otomatis via `onSelectChanged`.',
          style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
        ),
      ],
    );
  }
}
