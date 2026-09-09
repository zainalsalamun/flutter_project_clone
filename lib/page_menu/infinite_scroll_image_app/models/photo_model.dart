import 'package:equatable/equatable.dart';

class PhotoModel extends Equatable {
  final String id;
  final String title;
  final String author;
  final String? authorUrl;
  final String url;
  final String thumbnailUrl;
  final int width;
  final int height;
  final List<String> tags;
  final String source;
  final String? license;
  final bool isFavorite;

  const PhotoModel({
    required this.id,
    required this.title,
    required this.author,
    this.authorUrl,
    required this.url,
    required this.thumbnailUrl,
    required this.width,
    required this.height,
    this.tags = const [],
    required this.source,
    this.license,
    this.isFavorite = false,
  });

  /// Factory untuk data dari Openverse Search API
  factory PhotoModel.fromOpenverse(Map<String, dynamic> json) {
    final rawTags = json['tags'] as List? ?? [];
    final tagNames = rawTags
        .map((t) => t is Map ? (t['name']?.toString() ?? '') : t.toString())
        .where((name) => name.isNotEmpty)
        .take(6)
        .toList();

    final id = json['id']?.toString() ?? UniqueKeyGen.next();
    final title = (json['title']?.toString() ?? '').trim();
    final author = (json['creator']?.toString() ?? 'Anonymous Photographer').trim();
    final url = json['url']?.toString() ?? '';
    final thumbnail = json['thumbnail']?.toString() ?? url;
    final width = (json['width'] is num) ? (json['width'] as num).toInt() : 800;
    final height = (json['height'] is num) ? (json['height'] as num).toInt() : 600;

    return PhotoModel(
      id: 'openverse_$id',
      title: title.isNotEmpty ? title : 'Untitled Photo',
      author: author.isNotEmpty ? author : 'Creative Commons Creator',
      authorUrl: json['creator_url']?.toString(),
      url: url,
      thumbnailUrl: thumbnail,
      width: width > 0 ? width : 800,
      height: height > 0 ? height : 600,
      tags: tagNames,
      source: 'Openverse',
      license: json['license']?.toString().toUpperCase(),
    );
  }

  /// Factory untuk data dari Picsum Photos (Unsplash Curated)
  factory PhotoModel.fromPicsum(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';
    final author = (json['author']?.toString() ?? 'Unknown Artist').trim();
    final rawWidth = (json['width'] is num) ? (json['width'] as num).toInt() : 800;
    final rawHeight = (json['height'] is num) ? (json['height'] as num).toInt() : 600;

    // Resized image URLs via Picsum CDN
    final thumbnail = 'https://picsum.photos/id/$id/600/700';
    final fullUrl = 'https://picsum.photos/id/$id/1400/1000';

    return PhotoModel(
      id: 'picsum_$id',
      title: 'Photo by $author',
      author: author,
      authorUrl: json['url']?.toString(),
      url: fullUrl,
      thumbnailUrl: thumbnail,
      width: rawWidth > 0 ? rawWidth : 800,
      height: rawHeight > 0 ? rawHeight : 600,
      tags: const ['Curated', 'Editorial', 'HD'],
      source: 'Picsum Photos',
      license: 'Free to use',
    );
  }

  PhotoModel copyWith({
    String? id,
    String? title,
    String? author,
    String? authorUrl,
    String? url,
    String? thumbnailUrl,
    int? width,
    int? height,
    List<String>? tags,
    String? source,
    String? license,
    bool? isFavorite,
  }) {
    return PhotoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      authorUrl: authorUrl ?? this.authorUrl,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      width: width ?? this.width,
      height: height ?? this.height,
      tags: tags ?? this.tags,
      source: source ?? this.source,
      license: license ?? this.license,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        author,
        authorUrl,
        url,
        thumbnailUrl,
        width,
        height,
        tags,
        source,
        license,
        isFavorite,
      ];
}

class UniqueKeyGen {
  static int _counter = 0;
  static String next() => 'item_${++_counter}';
}
