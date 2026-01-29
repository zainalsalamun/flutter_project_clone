import 'package:flutter/material.dart';

class TixIdCitySelectorPage extends StatefulWidget {
  final String currentCity;

  const TixIdCitySelectorPage({super.key, required this.currentCity});

  @override
  State<TixIdCitySelectorPage> createState() => _TixIdCitySelectorPageState();
}

class _TixIdCitySelectorPageState extends State<TixIdCitySelectorPage> {
  final TextEditingController _searchController = TextEditingController();

  // Comprehensive list of cities to match the UI look
  final List<String> _allCities = [
    "AMBON",
    "BALI",
    "BALIKPAPAN",
    "BANDUNG",
    "BANJARBARU",
    "BANJARMASIN",
    "BATAM",
    "BAUBAU",
    "BEKASI",
    "BENGKULU",
    "BINJAI",
    "BLITAR",
    "BOGOR",
    "BONDOWOSO",
    "BONTANG",
    "CIANJUR",
    "CIKARANG",
    "CILEGON",
    "CIREBON",
    "DENPASAR",
    "DEPOK",
    "GARUT",
    "GORONTALO",
    "GRESIK",
    "JAKARTA",
    "JAMBI",
    "JAYAPURA",
    "JEMBER",
    "JOGJA",
    "YOGYAKARTA",
    "KEDIRI",
    "KENDARI",
    "KETAPANG",
    "KISARAN",
    "KUDUS",
    "KUPANG",
    "LAMPUNG",
    "LOMBOK",
    "MADIUN",
    "MAGELANG",
    "MAKASSAR",
    "MALANG",
    "MANADO",
    "MATARAM",
    "MEDAN",
    "MOJOKERTO",
    "PADANG",
    "PALANGKARAYA",
    "PALEMBANG",
    "PALU",
    "PANGKALPINANG",
    "PAREPARE",
    "PEKALONGAN",
    "PEKANBARU",
    "PEMATANGSIANTAR",
    "PONTIANAK",
    "PRABUMULIH",
    "PROBOLINGGO",
    "PURWOKERTO",
    "PURWAKARTA",
    "SALATIGA",
    "SAMARINDA",
    "SEMARANG",
    "SERANG",
    "SIDOARJO",
    "SINGKAWANG",
    "SOLO",
    "SORONG",
    "SUKABUMI",
    "SURABAYA",
    "TANGERANG",
    "TANJUNGPINANG",
    "TASIKMALAYA",
    "TEGAL",
    "TERNATE",
  ];

  List<String> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    _filteredCities = _allCities;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredCities =
          _allCities
              .where(
                (city) => city.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2C50),
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Masukkan Kata Kunci",
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      suffixIcon: Icon(
                        Icons.my_location,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  "Batal",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: _filteredCities.length,
        separatorBuilder:
            (context, index) => Divider(height: 1, color: Colors.grey[200]),
        itemBuilder: (context, index) {
          final city = _filteredCities[index];
          return ListTile(
            title: Text(
              city,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 0,
            ),
            onTap: () {
              Navigator.pop(context, city);
            },
          );
        },
      ),
    );
  }
}
