import '../models/photo_model.dart';
import '../services/photo_api_service.dart';

class PhotoRepository {
  final PhotoApiService _apiService;
  final Set<String> _favoriteIds = {};

  PhotoRepository({PhotoApiService? apiService})
      : _apiService = apiService ?? PhotoApiService();

  /// Mengambil foto dengan query dan page untuk infinite scroll
  Future<List<PhotoModel>> getPhotos({
    String query = '',
    int page = 1,
    int limit = 20,
  }) async {
    List<PhotoModel> photos;
    final trimmed = query.trim();

    if (trimmed.isEmpty || trimmed.toLowerCase() == 'curated') {
      photos = await _apiService.getCuratedPhotos(page: page, limit: limit);
    } else {
      photos = await _apiService.searchPhotos(
        query: trimmed,
        page: page,
        pageSize: limit,
      );
    }

    // Beri penanda status favorit lokal
    return photos.map((photo) {
      return photo.copyWith(
        isFavorite: _favoriteIds.contains(photo.id),
      );
    }).toList();
  }

  /// Toggle bookmark favorit
  bool toggleFavorite(String photoId) {
    if (_favoriteIds.contains(photoId)) {
      _favoriteIds.remove(photoId);
      return false;
    } else {
      _favoriteIds.add(photoId);
      return true;
    }
  }

  bool isFavorite(String photoId) => _favoriteIds.contains(photoId);

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);
}
