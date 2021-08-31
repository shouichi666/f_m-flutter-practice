import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';

class Movie {
  int? voteCount;
  int? id;
  bool? video;
  num? voteAverage;
  String? title;
  double? popularity;
  String? posterPath;
  String? originalLanguage;
  String? originalTitle;
  String? backdropPath;

  Movie({
    this.voteCount,
    this.id,
    this.video,
    this.voteAverage,
    this.title,
    this.popularity,
    this.posterPath,
    this.originalLanguage,
    this.originalTitle,
    this.backdropPath,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        voteCount: json['vote_count'],
        id: json['id'],
        video: json['video'],
        voteAverage: json['vote_average'],
        title: json['title'],
        popularity: json['popularity'],
        posterPath: json['poster_path'],
        originalLanguage: json['original_language'],
        originalTitle: json['original_title'],
        backdropPath:
            'https://image.tmdb.org/t/p/w154${json['backdrop_path']}');
  }
}

class Api {
  final key = dotenv.env['KEY'];

  /// インスタンス
  static final Api _instance = Api._();

  /// コンストラクタ
  Api._();

  /// ファクトリコンストラクタ
  factory Api() => _instance;

  Future<List<Movie>> getLateMovies() async {
    var searchUrl =
        'https://api.themoviedb.org/3/movie/top_rated?api_key=$key&language=ja';

    final response = await http.get(Uri.parse(searchUrl));
    final List<dynamic> extractedData = json.decode(response.body)['results'];
    return extractedData.map((data) => Movie.fromJson(data)).toList();
  }

  Future<List<Movie>> getPopularMovies() async {
    var searchUrl =
        'https://api.themoviedb.org/3/movie/popular?api_key=$key&language=ja&page=1';

    final response = await http.get(Uri.parse(searchUrl));
    final List<dynamic> extractedData = json.decode(response.body)['results'];
    return extractedData.map((data) => Movie.fromJson(data)).toList();
  }

  Future<List<Movie>> getUpcomingMovies() async {
    var searchUrl =
        'https://api.themoviedb.org/3/movie/upcoming?api_key=$key&language=ja&page=1';

    final response = await http.get(Uri.parse(searchUrl));
    final List<dynamic> extractedData = json.decode(response.body)['results'];
    return extractedData.map((data) => Movie.fromJson(data)).toList();
  }
}

class TopModel extends ChangeNotifier {
  /// アイテムリスト
  List<Movie> topLate = []; //高評価
  List<Movie> popular = []; //人気作品
  List<Movie> upcoming = []; //公開予定

  bool _isFetching = false;
  bool get isFetching => _isFetching;

  /// アイテムリストの更新
  Future<void> update() async {
    // print(movies);
    // アイテムリストをAPIから取得する
    topLate = await Api().getLateMovies();
    popular = await Api().getPopularMovies();
    upcoming = await Api().getUpcomingMovies();
    // 変更を通知する
    notifyListeners();
  }
}
