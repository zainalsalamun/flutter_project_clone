import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class FetchHomeMovies extends MovieEvent {}

class SearchMovies extends MovieEvent {
  final String query;
  final int page;

  const SearchMovies(this.query, {this.page = 1});

  @override
  List<Object> get props => [query, page];
}

class FetchMovieDetail extends MovieEvent {
  final int id;

  const FetchMovieDetail(this.id);

  @override
  List<Object> get props => [id];
}

class ToggleWatchlist extends MovieEvent {
  final int id;

  const ToggleWatchlist(this.id);

  @override
  List<Object> get props => [id];
}

class LoadWatchlist extends MovieEvent {}
