import 'package:equatable/equatable.dart';

abstract class PhotoEvent extends Equatable {
  const PhotoEvent();

  @override
  List<Object?> get props => [];
}

/// Event pemuatan awal foto
class FetchPhotos extends PhotoEvent {
  final String query;

  const FetchPhotos({this.query = ''});

  @override
  List<Object?> get props => [query];
}

/// Event saat scroll mendekati ujung bawah (Infinite Scroll)
class FetchMorePhotos extends PhotoEvent {
  const FetchMorePhotos();
}

/// Event pencarian kata kunci atau filter kategori
class SearchPhotos extends PhotoEvent {
  final String query;

  const SearchPhotos(this.query);

  @override
  List<Object?> get props => [query];
}

/// Event pull-to-refresh
class RefreshPhotos extends PhotoEvent {
  const RefreshPhotos();
}

/// Event bookmark/like foto
class ToggleFavoritePhoto extends PhotoEvent {
  final String photoId;

  const ToggleFavoritePhoto(this.photoId);

  @override
  List<Object?> get props => [photoId];
}
