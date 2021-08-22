import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

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
        backdropPath: json['backdrop_path']);
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

  // List<Movie> _computeMovies(dynamic body) =>
  //     List<Movie>.from(body.map((movie) => Movie.fromJson(movie)));

  Future<List<Movie>> get() async {
    var searchUrl =
        'https://api.themoviedb.org/3/movie/top_rated?api_key=$key&language=ja';

    final response = await http.get(Uri.parse(searchUrl));
    print("=====================================-");
    print(response);
    final List<dynamic> extractedData = json.decode(response.body)['results'];
    return extractedData.map((data) => Movie.fromJson(data)).toList();
  }
}

class MovieModel extends ChangeNotifier {
  /// アイテムリスト
  List<Movie> movies = [];

  /// アイテムリストの更新
  Future<void> update() async {
    // アイテムリストをAPIから取得する
    movies = await Api().get();
    print(movies);
    // 変更を通知する
    notifyListeners();
  }
}
