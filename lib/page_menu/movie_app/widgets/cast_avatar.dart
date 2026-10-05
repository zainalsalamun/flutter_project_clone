import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/movie_model.dart';

class CastAvatar extends StatelessWidget {
  final Cast cast;

  const CastAvatar({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: cast.profilePath.isNotEmpty
                ? CachedNetworkImageProvider(
                    'https://image.tmdb.org/t/p/w200${cast.profilePath}',
                  )
                : null,
            child: cast.profilePath.isEmpty ? const Icon(Icons.person) : null,
          ),
          const SizedBox(height: 8),
          Text(
            cast.name,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Text(
            cast.character,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
