import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/movie_repository.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository movieRepository;

  MovieBloc({required this.movieRepository}) : super(const MovieState()) {
    on<FetchHomeMovies>(_onFetchHomeMovies);
    on<SearchMovies>(_onSearchMovies);
    on<FetchMovieDetail>(_onFetchMovieDetail);
    on<ToggleWatchlist>(_onToggleWatchlist);
    on<LoadWatchlist>(_onLoadWatchlist);
  }

  Future<void> _onFetchHomeMovies(FetchHomeMovies event, Emitter<MovieState> emit) async {
    emit(state.copyWith(homeStatus: MovieStatus.loading));
    try {
      final popular = await movieRepository.getPopularMovies();
      final nowPlaying = await movieRepository.getNowPlayingMovies();
      final topRated = await movieRepository.getTopRatedMovies();
      final upcoming = await movieRepository.getUpcomingMovies();

      emit(state.copyWith(
        homeStatus: MovieStatus.success,
        popularMovies: popular,
        nowPlayingMovies: nowPlaying,
        topRatedMovies: topRated,
        upcomingMovies: upcoming,
      ));
    } catch (e) {
      emit(state.copyWith(homeStatus: MovieStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onSearchMovies(SearchMovies event, Emitter<MovieState> emit) async {
    emit(state.copyWith(searchStatus: MovieStatus.loading));
    try {
      final results = await movieRepository.searchMovie(event.query, page: event.page);
      emit(state.copyWith(searchStatus: MovieStatus.success, searchResults: results));
    } catch (e) {
      emit(state.copyWith(searchStatus: MovieStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onFetchMovieDetail(FetchMovieDetail event, Emitter<MovieState> emit) async {
    emit(state.copyWith(detailStatus: MovieStatus.loading));
    try {
      final movie = await movieRepository.getMovieDetail(event.id);
      final credits = await movieRepository.getMovieCredits(event.id);
      final videos = await movieRepository.getMovieVideos(event.id);
      final recommendations = await movieRepository.getRecommendations(event.id);
      final isWatchlisted = movieRepository.isWatchlisted(event.id);

      emit(state.copyWith(
        detailStatus: MovieStatus.success,
        currentMovie: movie,
        movieCredits: credits,
        movieVideos: videos,
        movieRecommendations: recommendations,
        isWatchlisted: isWatchlisted,
      ));
    } catch (e) {
      emit(state.copyWith(detailStatus: MovieStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onToggleWatchlist(ToggleWatchlist event, Emitter<MovieState> emit) async {
    if (state.currentMovie != null) {
      if (state.isWatchlisted) {
        await movieRepository.removeWatchlist(event.id);
        emit(state.copyWith(isWatchlisted: false));
      } else {
        await movieRepository.saveWatchlist(state.currentMovie!);
        emit(state.copyWith(isWatchlisted: true));
      }
      add(LoadWatchlist()); // Refresh watchlist
    }
  }

  Future<void> _onLoadWatchlist(LoadWatchlist event, Emitter<MovieState> emit) async {
    emit(state.copyWith(watchlistStatus: MovieStatus.loading));
    try {
      final watchlist = movieRepository.getWatchlist();
      emit(state.copyWith(watchlistStatus: MovieStatus.success, watchlist: watchlist));
    } catch (e) {
      emit(state.copyWith(watchlistStatus: MovieStatus.failure, errorMessage: e.toString()));
    }
  }
}
