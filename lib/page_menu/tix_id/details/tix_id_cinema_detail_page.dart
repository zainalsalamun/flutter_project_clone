import 'package:flutter/material.dart';

class TixIdCinemaDetailPage extends StatefulWidget {
  final String cinemaName;

  const TixIdCinemaDetailPage({super.key, required this.cinemaName});

  @override
  State<TixIdCinemaDetailPage> createState() => _TixIdCinemaDetailPageState();
}

class _TixIdCinemaDetailPageState extends State<TixIdCinemaDetailPage> {
  int _selectedDateIndex = 0;
  String? _selectedTime;

  final List<String> dates = [
    "29 Jan\nHARI INI",
    "30 Jan\nJUM",
    "31 Jan\nSAB",
    "01 Feb\nMIN",
    "02 Feb\nSEN",
  ];

  final List<String> showtimes = ["12:00", "14:10", "16:20", "18:30", "20:40"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.cinemaName,
          style: const TextStyle(
            color: Color(0xFF1A2C50),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A2C50)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Map Placeholder
            Container(
              height: 120,
              width: double.infinity,
              color: Colors.grey[200],
              child: Stack(
                children: [
                  // Placeholder for map image
                  Image.network(
                    "https://imgs.search.brave.com/JjEyr6qgD_9AXrW-vOJEzZRUyFhZt03n9UDK1Obt1a4/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTE0/MDM0NTA3My92ZWN0/b3IvbWFwLWNpdHkt/dmVjdG9yLmpwZz9z/PTYxMng2MTImdz0w/Jms9MjAmYz0yMzBa/bFAtWEg5bVdpY25y/T2xHcmZ1c0x3Wk9z/ODltTzA2ZmphV1hv/X3NFPQ",
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                  Center(
                    child: Icon(
                      Icons.location_on,
                      size: 40,
                      color: const Color(0xFF1A2C50),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      color: Colors.white,
                      child: const Row(
                        children: [
                          Icon(Icons.apple, size: 12),
                          Text(
                            "Maps",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Legal",
                            style: TextStyle(fontSize: 8, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Info Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.star_border, color: Colors.grey),
                    label: const Text(
                      "FAVORIT",
                      style: TextStyle(
                        color: Color(0xFF1A2C50),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.grey,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "PLAZA AMBARRUKMO LT. 3, JL. ADI SUCIPTO",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.phone, color: Colors.grey, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "(0274)4331221",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(height: 8, color: Colors.grey[100]),

            // 3. Food Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Image.network(
                    "https://img.freepik.com/premium-vector/popcorn-soda-takeaway-cinema-icon-movie-symbol-fast-food-sign_124507-10651.jpg",
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Pesan makanan & minuman dari bioskop ini",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
            Container(height: 8, color: Colors.grey[100]),

            // 4. Date Selector
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(vertical: 12),
              margin: const EdgeInsets.only(left: 16),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: dates.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final bool isSelected = index == _selectedDateIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDateIndex = index;
                      });
                    },
                    child: Container(
                      width: 70,
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? const Color(0xFF1A2C50)
                                : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        dates[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[500],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),

            // 5. Movie List
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Poster
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      "https://picsum.photos/100/150?random=88",
                      width: 100,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "KAFIR GERBANG SUKMA",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF1A2C50),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Genre     Horror",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "Durasi    1 jam 48 menit",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "Sutradara Azhar Kinoi Lubis",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: const Text(
                            "D 17+",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 10,
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

            // Format & Price
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "2D",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "Rp40.000",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Showtimes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    showtimes.map((time) {
                      final bool isSelected = _selectedTime == time;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTime = time;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? const Color(0xFF1A2C50)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            time,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),

            const SizedBox(height: 20),
            Container(height: 8, color: Colors.grey[100]),
            // Add a mock section for another movie to make it feel scrollable
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Poster
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      "https://picsum.photos/100/150?random=99",
                      width: 100,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "PENGABDI SETAN 3",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF1A2C50),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Genre     Horror",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "Durasi    1 jam 55 menit",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: const Text(
                            "D 17+",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 10,
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
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _selectedTime != null ? () {} : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A2C50),
            disabledBackgroundColor: Colors.grey[300],
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chair,
                color: _selectedTime != null ? Colors.white : Colors.grey[500],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "BELI TIKET",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:
                      _selectedTime != null ? Colors.white : Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
