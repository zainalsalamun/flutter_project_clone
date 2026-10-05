import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/movie_bloc.dart';
import '../bloc/movie_event.dart';
import '../bloc/movie_state.dart';
import '../widgets/cast_avatar.dart';
import '../widgets/movie_card.dart';

class DetailPage extends StatefulWidget {
  final int movieId;

  const DetailPage({super.key, required this.movieId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(FetchMovieDetail(widget.movieId));
  }

  void _launchTrailer(String key) async {
    final url = Uri.parse('https://www.youtube.com/watch?v=$key');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch trailer')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state.detailStatus == MovieStatus.loading || state.currentMovie == null) {
            return const Center(child: CircularProgressIndicator(color: Colors.red));
          } else if (state.detailStatus == MovieStatus.failure) {
            return Center(
              child: Text(
                'Error: ${state.errorMessage}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final movie = state.currentMovie!;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.black,
                expandedHeight: 300,
                pinned: true,
                actions: [
                  IconButton(
                    icon: Icon(
                      state.isWatchlisted ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      context.read<MovieBloc>().add(ToggleWatchlist(movie.id));
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'poster_${movie.id}',
                    child: CachedNetworkImage(
                      imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            movie.voteAverage.toStringAsFixed(1),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Runtime: ${movie.runtime} min',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Overview',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      if (state.movieVideos.isNotEmpty)
                        ElevatedButton.icon(
                          onPressed: () => _launchTrailer(state.movieVideos.first.key),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Official Trailer'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      const SizedBox(height: 16),
                      const Text(
                        'Cast',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.movieCredits.length,
                          itemBuilder: (context, index) {
                            return CastAvatar(cast: state.movieCredits[index]);
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Recommendations',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.movieRecommendations.length,
                          itemBuilder: (context, index) {
                            return MovieCard(movie: state.movieRecommendations[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
