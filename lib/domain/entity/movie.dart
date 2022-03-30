import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';
JsonSerializable(fieldRename: FieldRename.snake )
class Movie {
  final String? posterPath;
  final bool adult;
  final String overview;

  final DateTime? releaseDate;
  final List<int> genre_ids;
  final int id;
  final String originalTitle;
  final String originalLanguage;
  final String title;
  final String? backdropPath;
  final double popularity;
  final int voteCount;
  final bool video;
  final double voteAverage;
  Movie({
    this.posterPath,
    required this.adult,
    required this.overview,
    this.releaseDate,
    required this.genre_ids,
    required this.id,
    required this.originalTitle,
    required this.originalLanguage,
    required this.title,
    this.backdropPath,
    required this.popularity,
    required this.voteCount,
    required this.video,
    required this.voteAverage,
  });
static DateTime? _releaseDateFromString(String)
  
}
