import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/movie_model.dart';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://api.themoviedb.org/3',
          queryParameters: {
            'api_key': dotenv.env['TMDB_API_KEY'] ?? 'YOUR_API_KEY_HERE',
          },
        ));

  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      final response = await _dio.get('/movie/popular', queryParameters: {'page': page});
      final results = response.data['results'] as List;
      return results.map((e) => Movie.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load popular movies: $e');
    }
  }

  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    try {
      final response = await _dio.get('/movie/top_rated', queryParameters: {'page': page});
      final results = response.data['results'] as List;
      return results.map((e) => Movie.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load top rated movies: $e');
    }
  }

  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    try {
      final response = await _dio.get('/movie/upcoming', queryParameters: {'page': page});
      final results = response.data['results'] as List;
      return results.map((e) => Movie.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load upcoming movies: $e');
    }
  }

  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    try {
      final response = await _dio.get('/movie/now_playing', queryParameters: {'page': page});
      final results = response.data['results'] as List;
      return results.map((e) => Movie.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load now playing movies: $e');
    }
  }

  Future<Movie> getMovieDetail(int id) async {
    try {
      final response = await _dio.get('/movie/$id');
      return Movie.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load movie detail: $e');
    }
  }

  Future<List<Cast>> getMovieCredits(int id) async {
    try {
      final response = await _dio.get('/movie/$id/credits');
      final cast = response.data['cast'] as List;
      return cast.map((e) => Cast.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load movie credits: $e');
    }
  }

  Future<List<Trailer>> getMovieVideos(int id) async {
    try {
      final response = await _dio.get('/movie/$id/videos');
      final results = response.data['results'] as List;
      return results.map((e) => Trailer.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load movie videos: $e');
    }
  }

  Future<List<Movie>> getRecommendations(int id) async {
    try {
      final response = await _dio.get('/movie/$id/recommendations');
      final results = response.data['results'] as List;
      return results.map((e) => Movie.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load recommendations: $e');
    }
  }

  Future<List<Movie>> searchMovie(String query, {int page = 1}) async {
    try {
      final response = await _dio.get('/search/movie', queryParameters: {
        'query': query,
        'page': page,
      });
      final results = response.data['results'] as List;
      return results.map((e) => Movie.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to search movie: $e');
    }
  }
}
