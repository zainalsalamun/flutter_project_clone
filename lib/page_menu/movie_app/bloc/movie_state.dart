import 'package:equatable/equatable.dart';
import '../models/movie_model.dart';

enum MovieStatus { initial, loading, success, failure }

class MovieState extends Equatable {
  // Home
  final MovieStatus homeStatus;
  final List<Movie> popularMovies;
  final List<Movie> nowPlayingMovies;
  final List<Movie> topRatedMovies;
  final List<Movie> upcomingMovies;

  // Search
  final MovieStatus searchStatus;
  final List<Movie> searchResults;

  // Detail
  final MovieStatus detailStatus;
  final Movie? currentMovie;
  final List<Cast> movieCredits;
  final List<Trailer> movieVideos;
  final List<Movie> movieRecommendations;
  final bool isWatchlisted;

  // Watchlist
  final MovieStatus watchlistStatus;
  final List<Movie> watchlist;

  final String errorMessage;

  const MovieState({
    this.homeStatus = MovieStatus.initial,
    this.popularMovies = const [],
    this.nowPlayingMovies = const [],
    this.topRatedMovies = const [],
    this.upcomingMovies = const [],
    this.searchStatus = MovieStatus.initial,
    this.searchResults = const [],
    this.detailStatus = MovieStatus.initial,
    this.currentMovie,
    this.movieCredits = const [],
    this.movieVideos = const [],
    this.movieRecommendations = const [],
    this.isWatchlisted = false,
    this.watchlistStatus = MovieStatus.initial,
    this.watchlist = const [],
    this.errorMessage = '',
  });

  MovieState copyWith({
    MovieStatus? homeStatus,
    List<Movie>? popularMovies,
    List<Movie>? nowPlayingMovies,
    List<Movie>? topRatedMovies,
    List<Movie>? upcomingMovies,
    MovieStatus? searchStatus,
    List<Movie>? searchResults,
    MovieStatus? detailStatus,
    Movie? currentMovie,
    List<Cast>? movieCredits,
    List<Trailer>? movieVideos,
    List<Movie>? movieRecommendations,
    bool? isWatchlisted,
    MovieStatus? watchlistStatus,
    List<Movie>? watchlist,
    String? errorMessage,
  }) {
    return MovieState(
      homeStatus: homeStatus ?? this.homeStatus,
      popularMovies: popularMovies ?? this.popularMovies,
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      upcomingMovies: upcomingMovies ?? this.upcomingMovies,
      searchStatus: searchStatus ?? this.searchStatus,
      searchResults: searchResults ?? this.searchResults,
      detailStatus: detailStatus ?? this.detailStatus,
      currentMovie: currentMovie ?? this.currentMovie,
      movieCredits: movieCredits ?? this.movieCredits,
      movieVideos: movieVideos ?? this.movieVideos,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      isWatchlisted: isWatchlisted ?? this.isWatchlisted,
      watchlistStatus: watchlistStatus ?? this.watchlistStatus,
      watchlist: watchlist ?? this.watchlist,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        homeStatus,
        popularMovies,
        nowPlayingMovies,
        topRatedMovies,
        upcomingMovies,
        searchStatus,
        searchResults,
        detailStatus,
        currentMovie,
        movieCredits,
        movieVideos,
        movieRecommendations,
        isWatchlisted,
        watchlistStatus,
        watchlist,
        errorMessage,
      ];
}
