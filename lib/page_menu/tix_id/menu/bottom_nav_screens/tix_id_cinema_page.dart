import 'package:flutter/material.dart';

class TixIdCinemaPage extends StatelessWidget {
  final String cityName;
  const TixIdCinemaPage({super.key, required this.cityName});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<String>> cityCinemas = {
      "AMBON": ["AMBON CITY CENTER XXI", "STUDIO AMBON"],
      "BALI": [
        "BEACHWALK XXI",
        "GALERIA XXI",
        "LEVEL 21 XXI",
        "TRANS STUDIO BALI XXI",
        "LIPPO MALL KUTA CINEPOLIS",
        "PARK 23 XXI",
        "DENPASAR CINEPLEX",
      ],
      "BALIKPAPAN": [
        "E-WALK XXI",
        "PENTACITY XXI",
        "STUDIO XXI BALIKPAPAN",
        "LIVING PLAZA CGV",
      ],
      "BANDUNG": [
        "CIWALK XXI",
        "TSM XXI BANDUNG",
        "BEC CGV",
        "PARIS VAN JAVA CGV",
        "EMPIRE XXI BANDUNG",
        "BRAGA XXI",
        "BTC XXI",
        "FESTIVAL CITYLINK XXI",
        "MIM CGV",
        "KINGS SHOPPING CENTER CGV",
      ],
      "BANJARBARU": ["Q MALL XXI BANJARBARU", "CINEPOLIS Q MALL"],
      "BANJARMASIN": ["DUTAMALL XXI", "STUDIO XXI BANJARMASIN"],
      "BATAM": [
        "MEGA MALL XXI",
        "BCS XXI",
        "PANBIL MALL XXI",
        "STUDIO XXI BATAM",
        "GRAND BATAM CGV",
      ],
      "BAUBAU": ["LIPPO PLAZA BUTON CINEPOLIS"],
      "BEKASI": [
        "MEGA BEKASI XXI",
        "SUMMARECON MAL BEKASI XXI",
        "METROPOLITAN XXI",
        "GRAND GALAXY PARK CGV",
        "BEKASI CYBER PARK CGV",
        "CIPUTRA CIBUBUR XXI",
        "PLAZA CIBUBUR XXI",
      ],
      "BENGKULU": ["BENGKULU INDAH MALL XXI", "MEGA MALL BENGKULU XXI"],
      "BINJAI": ["BINJAI SUPERMALL XXI"],
      "BLITAR": ["BLITAR SQUARE CGV"],
      "BOGOR": [
        "BOTANI SQUARE XXI",
        "BOGOR TRADE MALL XXI",
        "CIBINONG CITY MALL XXI",
        "AEON MALL SENTUL CITY XXI",
        "TRANSMART BOGOR XXI",
        "VIVO SENTUL CGV",
      ],
      "BONDOWOSO": ["CITYMALL BONDOWOSO CGV"],
      "BONTANG": ["PLAZA TAMAN BONTANG XXI"],
      "CIANJUR": ["CITIMALL CIANJUR XXI"],
      "CIKARANG": [
        "CHADSTONE XXI",
        "LIPPO CIKARANG XXI",
        "SENTRA GROSIR CIKARANG XXI",
        "LIVING PLAZA JABABEKA CGV",
      ],
      "CILEGON": [
        "CILEGON CENTER MALL XXI",
        "RAMAYANA CILEGON XXI",
        "TRANSMART CILEGON CGV",
      ],
      "CIREBON": [
        "CSB XXI",
        "GRAGE MALL XXI",
        "GRAGE CITY MALL CGV",
        "TRANSINDO CGV",
      ],
      "DENPASAR": ["LEVEL 21 XXI", "GALERIA XXI", "PLAZA RENON CINEPOLIS"],
      "DEPOK": [
        "MARGO CITY XXI",
        "PESONA SQUARE XXI",
        "CINERE BELLEVUE XXI",
        "DEPOK MALL XXI",
        "GREEN PRAMUKA SQUARE CGV",
      ],
      "GARUT": ["ANNARTO MALL XXI"],
      "GORONTALO": ["GORONTALO MALL XXI"],
      "GRESIK": ["GRESSMALL XXI", "ICON MALL CGV"],
      "JAKARTA": [
        "PLAZA SENAYAN XXI",
        "GRAND INDONESIA CGV",
        "PONDOK INDAH 1 XXI",
        "GANDARIA CITY XXI",
        "KELAPA GADING IMAX",
        "KOTA KASABLANKA XXI",
        "LOTTE SHOPPING AVENUE XXI",
        "ST. MORITZ XXI",
        "CENTRAL PARK CGV",
        "PACIFIC PLACE CGV",
        "KUNINGAN CITY XXI",
      ],
      "JAMBI": [
        "JAMBI TOWN SQUARE XXI",
        "WTC BATANGHARI XXI",
        "LIPPO PLAZA JAMBI CINEPOLIS",
      ],
      "JAYAPURA": ["JAYAPURA XXI"],
      "JEMBER": [
        "TRANSFASHION JEMBER XXI",
        "LIPPO PLAZA JEMBER CINEPOLIS",
        "ROXY SQUARE CGV",
      ],
      "JOGJA": [
        "AMBARRUKMO XXI",
        "AMBARRUKMO PREMIERE",
        "EMPIRE PREMIERE",
        "EMPIRE XXI",
        "JOGJA CITY PREMIERE",
        "JOGJA CITY XXI",
        "JWALK MALL CGV",
        "LIPPO PLAZA JOGJA CINEPOLIS",
        "SLEMAN CITY HALL XXI",
      ],
      "YOGYAKARTA": [
        "AMBARRUKMO XXI",
        "AMBARRUKMO PREMIERE",
        "EMPIRE PREMIERE",
        "EMPIRE XXI",
        "JOGJA CITY PREMIERE",
        "JOGJA CITY XXI",
        "JWALK MALL CGV",
        "LIPPO PLAZA JOGJA CINEPOLIS",
        "SLEMAN CITY HALL XXI",
      ],
      "KEDIRI": [
        "KEDIRI TOWN SQUARE XXI",
        "GOLDEN THEATER KEDIRI",
        "KEDIRI MALL CGV",
      ],
      "KENDARI": ["LIPPO PLAZA KENDARI CINEPOLIS", "THE PARK KENDARI XXI"],
      "KETAPANG": ["CITIMALL KETAPANG XXI"],
      "KISARAN": ["IRIAN SUPERMARKET KISARAN CGV"],
      "KUDUS": ["KUDUS EXTENSION MALL XXI"],
      "KUPANG": ["LIPPO PLAZA KUPANG CINEPOLIS", "TRANSFASHION KUPANG XXI"],
      "LAMPUNG": [
        "BOEMI KEDATON XXI",
        "MAL KARTINI XXI",
        "LAMPUNG CITY MALL CGV",
        "CENTRAL PLAZA XXI",
      ],
      "LOMBOK": ["LOMBOK EPICENTRUM MALL XXI", "TRANSFASHION LOMBOK XXI"],
      "MADIUN": [
        "SUNCITY MADIUN XXI",
        "PLAZA LAWU CGV",
        "TIMBUL JAYA PLAZA XXI",
      ],
      "MAGELANG": ["ARMADA TOWN SQUARE XXI", "PLATINUM CINEPLEX ARTOS"],
      "MAKASSAR": [
        "PANAKKUKANG XXI",
        "TSM XXI MAKASSAR",
        "M'TOS XXI",
        "NIPAH PREMIERE",
        "NIPAH XXI",
        "MARI XXI",
        "STUDIO XXI MAKASSAR",
        "PHINISI POINT CINEPOLIS",
      ],
      "MALANG": [
        "MALANG TOWN SQUARE 21",
        "MOG XXI",
        "MOVIMAX DINODYO",
        "CGV CYBER MALL",
        "ARAYA XXI",
        "DIENG 21",
        "MANDALA 21",
        "LIPPO PLAZA BATU CINEPOLIS",
      ],
      "MANADO": [
        "MANADO TOWN SQUARE XXI",
        "MEGA MALL MANADO XXI",
        "MANTOS 3 PREMIERE",
      ],
      "MATARAM": ["MATARAM MALL XXI", "EPICENTRUM XXI"],
      "MEDAN": [
        "CENTRE POINT XXI",
        "SUN PLAZA XXI",
        "DELIPARK XXI",
        "RINGROAD CITY WALKS XXI",
        "HERMES XXI",
        "THAMRIN XXI",
        "MANHATTAN XXI",
        "FOCAL POINT CGV",
        "LIPPO PLAZA MEDAN CINEPOLIS",
      ],
      "MOJOKERTO": ["SUNRISE MALL CGV"],
      "PADANG": ["PLAZA ANDALAS XXI", "TRANSMART PADANG XXI", "RAYA THEATER"],
      "PALANGKARAYA": ["PALMA PREMIERE", "METOS XXI"],
      "PALEMBANG": [
        "PIM XXI",
        "PALEMBANG SQUARE XXI",
        "OPI MALL XXI",
        "INTERNASIONAL 21",
        "PIM PREMIERE",
        "SOCIAL MARKET CGV",
        "TRANSMART PALEMBANG CGV",
      ],
      "PALU": ["GRAND MALL PALU XXI"],
      "PANGKALPINANG": ["TRANSFASHION PANGKALPINANG XXI", "BES CINEMA"],
      "PAREPARE": ["PAREPARE BEACH CITY XXI"],
      "PEKALONGAN": ["TRANSMART PEKALONGAN XXI"],
      "PEKANBARU": [
        "CIPUTRA SERAYA XXI",
        "SKA XXI",
        "SUKARAMAI TRADE CENTER XXI",
        "TRANSMART PEKANBARU CGV",
      ],
      "PEMATANGSIANTAR": [
        "SIANTAR CITY SQUARE XXI",
        "CINEPOLIS SIANTAR CITY SQUARE",
      ],
      "PONTIANAK": ["AYANI XXI", "TRANSFASHION PONTIANAK XXI"],
      "PRABUMULIH": ["CITIMALL PRABUMULIH CINEPOLIS"],
      "PROBOLINGGO": ["CGV WIJAYA KUSUMA"],
      "PURWOKERTO": ["RITA SUPERMALL CGV", "RAJAWALI CINEMA"],
      "PURWAKARTA": ["SADANG TERMINAL SQUARE CGV"],
      "SALATIGA": ["TAMAN SARI XXI"],
      "SAMARINDA": [
        "BIG MALL XXI",
        "SAMARINDA SQUARE XXI",
        "SCS XXI",
        "PLAZA MULIA CGV",
      ],
      "SEMARANG": [
        "PARAGON XXI",
        "CITRA XXI",
        "DP MALL XXI",
        "TENTREM MALL XXI",
        "JAVA SUPERMALL CINEPOLIS",
        "TRANSMART MAJAPAHIT XXI",
        "CENTRAL CITY XXI",
      ],
      "SERANG": ["MALL OF SERANG XXI", "TRANSMART SERANG CGV"],
      "SIDOARJO": [
        "SIDOARJO TOWN SQUARE XXI",
        "TRANSMART SIDOARJO XXI",
        "LIPPO PLAZA SIDOARJO CINEPOLIS",
      ],
      "SINGKAWANG": ["SINGKAWANG GRAND MALL XXI"],
      "SOLO": [
        "SOLO PARAGON XXI",
        "SOLO SQUARE XXI",
        "THE PARK XXI",
        "GRAND MALL 21",
        "TRANSFASHION SOLO CGV",
      ],
      "SORONG": ["XXI SORONG"],
      "SUKABUMI": ["MOVIPLEX SUKABUMI"],
      "SURABAYA": [
        "TUNJUNGAN 1 XXI",
        "TUNJUNGAN 3 XXI",
        "PAKUWON MALL CGV",
        "GALAXY MALL XXI",
        "CIPUTRA WORLD XXI",
        "LENMARC XXI",
        "ROYAL 21",
        "DELTA 21",
        "MARVELL CITY CGV",
        "BG JUNCTION CGV",
      ],
      "TANGERANG": [
        "TANGERANG CITY XXI",
        "BALE KOTA XXI",
        "SUPERMAL KARAWACI XXI",
        "SUMMARECON MALL SERPONG XXI",
        "LIVING WORLD XXI",
        "LOTTE MART BINTARO XXI",
        "AEON MALL BSD CITY XXI",
        "TERASKOTA CGV",
        "ECOPLAZA CITRARAYA CGV",
      ],
      "TANJUNGPINANG": ["TCC XXI"],
      "TASIKMALAYA": ["TASIKMALAYA XXI", "TRANSMART TASIKMALAYA CGV"],
      "TEGAL": ["TEGAL PACIFIC MALL CGV", "GAJAHMADA CINEMA"],
      "TERNATE": ["XXI JATILAND MALL"],
    };

    final List<String> cinemas = cityCinemas[cityName] ?? [];

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Banner Section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Icon
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A2C50),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Windows
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildWindow(),
                            _buildWindow(),
                            _buildWindow(),
                          ],
                        ),
                        // Gold Stripe
                        Container(
                          width: 12,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xFFC5A059),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Positioned(
                    top: -6,
                    left: -6,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.star_border,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tandai bioskop favoritmu!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF1A2C50),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Bioskop favoritmu akan berada paling atas pada daftar ini dan pada jadwal film.",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF1A2C50)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 0,
                        ),
                        minimumSize: const Size(0, 32),
                      ),
                      child: const Text(
                        "MENGERTI",
                        style: TextStyle(
                          color: Color(0xFF1A2C50),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Cinema List match exact style in image: star icon left, text bold, arrow right
        ...cinemas.map((name) => _buildCinemaItem(name)),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildWindow() {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      width: 4,
      height: 4,
      decoration: const BoxDecoration(
        color: Colors.white70,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildCinemaItem(String name) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: ListTile(
        leading: const Icon(Icons.star_border, color: Colors.grey),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A2C50),
            fontSize: 13,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        dense: true,
        onTap: () {},
      ),
    );
  }
}
