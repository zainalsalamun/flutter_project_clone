import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/movie_bloc.dart';
import '../bloc/movie_event.dart';
import '../bloc/movie_state.dart';
import '../models/movie_model.dart';
import '../widgets/movie_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<MovieBloc>();
    if (bloc.state.homeStatus == MovieStatus.initial) {
      bloc.add(FetchHomeMovies());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state.homeStatus == MovieStatus.loading || state.homeStatus == MovieStatus.initial) {
            return const Center(child: CircularProgressIndicator(color: Colors.red));
          } else if (state.homeStatus == MovieStatus.failure) {
            return Center(
              child: Text(
                'Error: ${state.errorMessage}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              const SliverAppBar(
                backgroundColor: Colors.black,
                floating: true,
                pinned: true,
                title: Text(
                  'Movie App',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection('Now Playing', state.nowPlayingMovies),
                    _buildSection('Popular Movies', state.popularMovies),
                    _buildSection('Top Rated', state.topRatedMovies),
                    _buildSection('Upcoming', state.upcomingMovies),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Movie> movies) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 250,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return MovieCard(movie: movies[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
