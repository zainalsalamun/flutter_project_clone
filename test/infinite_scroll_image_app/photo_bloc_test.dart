import 'package:flutter_test/flutter_test.dart';
import 'package:project_clone/page_menu/infinite_scroll_image_app/bloc/photo_bloc.dart';
import 'package:project_clone/page_menu/infinite_scroll_image_app/bloc/photo_event.dart';
import 'package:project_clone/page_menu/infinite_scroll_image_app/bloc/photo_state.dart';
import 'package:project_clone/page_menu/infinite_scroll_image_app/models/photo_model.dart';
import 'package:project_clone/page_menu/infinite_scroll_image_app/repository/photo_repository.dart';

class MockPhotoRepository extends PhotoRepository {
  final List<PhotoModel> mockPhotos;

  MockPhotoRepository({required this.mockPhotos});

  @override
  Future<List<PhotoModel>> getPhotos({
    String query = '',
    int page = 1,
    int limit = 20,
  }) async {
    if (page == 1) {
      return mockPhotos.take(limit).toList();
    } else if (page == 2) {
      return [
        PhotoModel(
          id: 'page2_1',
          title: 'Page 2 Photo',
          author: 'Author 2',
          url: 'https://example.com/2.jpg',
          thumbnailUrl: 'https://example.com/thumb2.jpg',
          width: 800,
          height: 600,
          source: 'Mock',
        ),
      ];
    }
    return [];
  }
}

void main() {
  group('PhotoBloc Tests', () {
    late PhotoBloc photoBloc;
    final testPhotos = List.generate(
      20,
      (i) => PhotoModel(
        id: 'photo_$i',
        title: 'Title $i',
        author: 'Author $i',
        url: 'https://example.com/$i.jpg',
        thumbnailUrl: 'https://example.com/thumb_$i.jpg',
        width: 1000,
        height: 800,
        source: 'Picsum Photos',
      ),
    );

    setUp(() {
      photoBloc = PhotoBloc(
        repository: MockPhotoRepository(mockPhotos: testPhotos),
      );
    });

    tearDown(() {
      photoBloc.close();
    });

    test('Initial state is correct', () {
      expect(photoBloc.state.status, PhotoStatus.initial);
      expect(photoBloc.state.photos, isEmpty);
      expect(photoBloc.state.page, 1);
      expect(photoBloc.state.hasReachedMax, false);
    });

    test('FetchPhotos loads initial 20 items', () async {
      photoBloc.add(const FetchPhotos());

      await expectLater(
        photoBloc.stream,
        emitsInOrder([
          predicate<PhotoState>((s) => s.status == PhotoStatus.loading),
          predicate<PhotoState>((s) =>
              s.status == PhotoStatus.success &&
              s.photos.length == 20 &&
              s.page == 1 &&
              !s.hasReachedMax),
        ]),
      );
    });

    test('FetchMorePhotos appends new items and increments page', () async {
      photoBloc.add(const FetchPhotos());
      await photoBloc.stream.firstWhere((s) => s.status == PhotoStatus.success);

      photoBloc.add(const FetchMorePhotos());

      await expectLater(
        photoBloc.stream,
        emitsInOrder([
          predicate<PhotoState>((s) => s.status == PhotoStatus.loadingMore),
          predicate<PhotoState>((s) =>
              s.status == PhotoStatus.success &&
              s.photos.length == 21 &&
              s.page == 2 &&
              s.hasReachedMax), // because page 2 returned < 20 items
        ]),
      );
    });

    test('ToggleFavoritePhoto toggles favorite flag', () async {
      photoBloc.add(const FetchPhotos());
      await photoBloc.stream.firstWhere((s) => s.status == PhotoStatus.success);

      photoBloc.add(const ToggleFavoritePhoto('photo_0'));

      await expectLater(
        photoBloc.stream,
        emits(
          predicate<PhotoState>((s) =>
              s.photos.firstWhere((p) => p.id == 'photo_0').isFavorite == true),
        ),
      );
    });
  });
}
