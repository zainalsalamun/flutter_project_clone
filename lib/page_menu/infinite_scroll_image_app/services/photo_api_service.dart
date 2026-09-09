import 'package:dio/dio.dart';
import '../models/photo_model.dart';

class PhotoApiService {
  final Dio _dio;

  PhotoApiService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 12),
                receiveTimeout: const Duration(seconds: 12),
                headers: {
                  'Accept': 'application/json',
                },
              ),
            );

  /// Mengambil feed foto kurasi dari Picsum Photos (Unsplash Library)
  Future<List<PhotoModel>> getCuratedPhotos({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        'https://picsum.photos/v2/list',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200 && response.data is List) {
        final list = response.data as List;
        return list
            .map((item) => PhotoModel.fromPicsum(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Gagal memuat feed kurasi: ${e.message}');
    } catch (e) {
      throw Exception('Kesalahan memuat foto: $e');
    }
  }

  /// Mencari foto publik berdasarkan kata kunci melalui Openverse API
  Future<List<PhotoModel>> searchPhotos({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      return getCuratedPhotos(page: page, limit: pageSize);
    }

    try {
      final response = await _dio.get(
        'https://api.openverse.org/v1/images/',
        queryParameters: {
          'q': cleanQuery,
          'page': page,
          'page_size': pageSize,
        },
      );

      if (response.statusCode == 200 && response.data is Map) {
        final results = response.data['results'] as List? ?? [];
        return results
            .map((item) => PhotoModel.fromOpenverse(item as Map<String, dynamic>))
            // Filter URL gambar yang valid
            .where((photo) => photo.url.isNotEmpty && photo.thumbnailUrl.isNotEmpty)
            .toList();
      }
      return [];
    } on DioException catch (e) {
      // Jika Openverse rate-limit atau timeout, berikan fallback informatif
      throw Exception('Gagal mencari gambar "$cleanQuery": ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan pencarian: $e');
    }
  }
}
