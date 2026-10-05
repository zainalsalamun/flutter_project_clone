import '../models/movie_model.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

class MovieRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  MovieRepository({
    required this.apiService,
    required this.localStorageService,
  });

  Future<List<Movie>> getPopularMovies({int page = 1}) => apiService.getPopularMovies(page: page);
  Future<List<Movie>> getTopRatedMovies({int page = 1}) => apiService.getTopRatedMovies(page: page);
  Future<List<Movie>> getUpcomingMovies({int page = 1}) => apiService.getUpcomingMovies(page: page);
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) => apiService.getNowPlayingMovies(page: page);
  
  Future<Movie> getMovieDetail(int id) => apiService.getMovieDetail(id);
  Future<List<Cast>> getMovieCredits(int id) => apiService.getMovieCredits(id);
  Future<List<Trailer>> getMovieVideos(int id) => apiService.getMovieVideos(id);
  Future<List<Movie>> getRecommendations(int id) => apiService.getRecommendations(id);
  
  Future<List<Movie>> searchMovie(String query, {int page = 1}) => apiService.searchMovie(query, page: page);

  // Local Storage Methods
  Future<void> saveWatchlist(Movie movie) => localStorageService.saveWatchlist(movie);
  Future<void> removeWatchlist(int id) => localStorageService.removeWatchlist(id);
  bool isWatchlisted(int id) => localStorageService.isWatchlisted(id);
  List<Movie> getWatchlist() => localStorageService.getWatchlist();
}
