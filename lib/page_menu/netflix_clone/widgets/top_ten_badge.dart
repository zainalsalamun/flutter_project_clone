import 'package:flutter/material.dart';

class TopTenRankNumber extends StatelessWidget {
  final int rank;

  const TopTenRankNumber({
    super.key,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final text = rank.toString();
    return SizedBox(
      width: rank == 10 ? 80 : 55,
      height: 140,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          // Outer drop shadow
          Text(
            text,
            style: TextStyle(
              fontSize: 105,
              fontWeight: FontWeight.w900,
              fontFamily: 'sans-serif',
              height: 0.9,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 10
                ..color = Colors.black,
            ),
          ),
          // Silver/Chrome outer stroke border
          Text(
            text,
            style: TextStyle(
              fontSize: 105,
              fontWeight: FontWeight.w900,
              fontFamily: 'sans-serif',
              height: 0.9,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 6
                ..color = const Color(0xFF595959),
            ),
          ),
          // Inner Dark Fill
          Text(
            text,
            style: const TextStyle(
              fontSize: 105,
              fontWeight: FontWeight.w900,
              fontFamily: 'sans-serif',
              height: 0.9,
              color: Color(0xFF141414),
            ),
          ),
        ],
      ),
    );
  }
}
