import 'package:equatable/equatable.dart';
import '../models/photo_model.dart';

enum PhotoStatus { initial, loading, success, failure, loadingMore }

class PhotoState extends Equatable {
  final PhotoStatus status;
  final List<PhotoModel> photos;
  final bool hasReachedMax;
  final int page;
  final String query;
  final String activeCategory;
  final String? errorMessage;

  const PhotoState({
    this.status = PhotoStatus.initial,
    this.photos = const [],
    this.hasReachedMax = false,
    this.page = 1,
    this.query = '',
    this.activeCategory = 'Curated',
    this.errorMessage,
  });

  bool get isLoading => status == PhotoStatus.loading;
  bool get isLoadingMore => status == PhotoStatus.loadingMore;
  bool get isSuccess => status == PhotoStatus.success;
  bool get isFailure => status == PhotoStatus.failure;

  PhotoState copyWith({
    PhotoStatus? status,
    List<PhotoModel>? photos,
    bool? hasReachedMax,
    int? page,
    String? query,
    String? activeCategory,
    String? errorMessage,
  }) {
    return PhotoState(
      status: status ?? this.status,
      photos: photos ?? this.photos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      query: query ?? this.query,
      activeCategory: activeCategory ?? this.activeCategory,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        photos,
        hasReachedMax,
        page,
        query,
        activeCategory,
        errorMessage,
      ];
}
