import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/photo_repository.dart';
import 'photo_event.dart';
import 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final PhotoRepository _repository;
  static const int _pageSize = 20;

  PhotoBloc({required PhotoRepository repository})
      : _repository = repository,
        super(const PhotoState()) {
    on<FetchPhotos>(_onFetchPhotos);
    on<FetchMorePhotos>(_onFetchMorePhotos);
    on<SearchPhotos>(_onSearchPhotos);
    on<RefreshPhotos>(_onRefreshPhotos);
    on<ToggleFavoritePhoto>(_onToggleFavoritePhoto);
  }

  /// Pemuatan awal halaman pertama (page 1)
  Future<void> _onFetchPhotos(
    FetchPhotos event,
    Emitter<PhotoState> emit,
  ) async {
    emit(state.copyWith(
      status: PhotoStatus.loading,
      page: 1,
      hasReachedMax: false,
      query: event.query,
      errorMessage: null,
    ));

    try {
      final photos = await _repository.getPhotos(
        query: event.query,
        page: 1,
        limit: _pageSize,
      );

      emit(state.copyWith(
        status: PhotoStatus.success,
        photos: photos,
        page: 1,
        hasReachedMax: photos.length < _pageSize,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PhotoStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  /// Mengambil halaman berikutnya saat scroll mencapai batas (Infinite Scroll)
  Future<void> _onFetchMorePhotos(
    FetchMorePhotos event,
    Emitter<PhotoState> emit,
  ) async {
    // Guard: Jangan fetch lagi jika sudah mentok atau sedang loading
    if (state.hasReachedMax ||
        state.isLoadingMore ||
        state.isLoading ||
        state.photos.isEmpty) {
      return;
    }

    emit(state.copyWith(status: PhotoStatus.loadingMore));

    final nextPage = state.page + 1;

    try {
      final newPhotos = await _repository.getPhotos(
        query: state.query,
        page: nextPage,
        limit: _pageSize,
      );

      if (newPhotos.isEmpty) {
        emit(state.copyWith(
          status: PhotoStatus.success,
          hasReachedMax: true,
        ));
      } else {
        // Gabungkan list lama dengan list baru
        final updatedList = List.of(state.photos)..addAll(newPhotos);
        emit(state.copyWith(
          status: PhotoStatus.success,
          photos: updatedList,
          page: nextPage,
          hasReachedMax: newPhotos.length < _pageSize,
        ));
      }
    } catch (e) {
      // Jika load more gagal, jangan hapus data yang sudah ada, tetap di success tapi tampilkan pesan
      emit(state.copyWith(
        status: PhotoStatus.success,
        errorMessage: 'Gagal memuat foto tambahan: $e',
      ));
    }
  }

  /// Pencarian gambar baru (query atau filter chip)
  Future<void> _onSearchPhotos(
    SearchPhotos event,
    Emitter<PhotoState> emit,
  ) async {
    final query = event.query.trim();
    emit(state.copyWith(
      status: PhotoStatus.loading,
      page: 1,
      hasReachedMax: false,
      query: query,
      activeCategory: query.isEmpty ? 'Curated' : query,
      errorMessage: null,
    ));

    try {
      final photos = await _repository.getPhotos(
        query: query,
        page: 1,
        limit: _pageSize,
      );

      emit(state.copyWith(
        status: PhotoStatus.success,
        photos: photos,
        page: 1,
        hasReachedMax: photos.length < _pageSize,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PhotoStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  /// Pull-to-refresh
  Future<void> _onRefreshPhotos(
    RefreshPhotos event,
    Emitter<PhotoState> emit,
  ) async {
    try {
      final photos = await _repository.getPhotos(
        query: state.query,
        page: 1,
        limit: _pageSize,
      );

      emit(state.copyWith(
        status: PhotoStatus.success,
        photos: photos,
        page: 1,
        hasReachedMax: photos.length < _pageSize,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Gagal me-refresh galeri: $e',
      ));
    }
  }

  /// Bookmark favorit foto
  void _onToggleFavoritePhoto(
    ToggleFavoritePhoto event,
    Emitter<PhotoState> emit,
  ) {
    final isFav = _repository.toggleFavorite(event.photoId);

    final updatedPhotos = state.photos.map((p) {
      if (p.id == event.photoId) {
        return p.copyWith(isFavorite: isFav);
      }
      return p;
    }).toList();

    emit(state.copyWith(photos: updatedPhotos));
  }
}
