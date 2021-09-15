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
  String title;
  double? popularity;
  String? posterPath;
  String? originalLanguage;
  String? originalTitle;
  String backdropPath = "";
  String overview = "";

  Movie({
    this.voteCount,
    this.id,
    this.video,
    this.voteAverage,
    this.title = "",
    this.popularity,
    this.posterPath,
    this.originalLanguage,
    this.originalTitle,
    this.backdropPath = "",
    this.overview = "",
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
        overview: json['overview'],
        backdropPath: json['backdrop_path']);
  }
}

class Tv {
  int? id;
  double? voteAverage;
  String? backgroundPath;
  String? posterPath;
  String? name;
  String? originalName;
  String? overView;

  Tv({
    this.id,
    this.voteAverage,
    this.backgroundPath,
    this.posterPath,
    this.name,
    this.originalName,
    this.overView,
  });

  factory Tv.fromJson(Map<String, dynamic> json) {
    return Tv(
      id: json['id'],
      voteAverage: json['vote_average'],
      backgroundPath: json['background_path'],
      posterPath: json['poster_path'],
      name: json['name'],
      originalName: json['original_name'],
      overView: json['over_view'],
    );
  }
}

class MovieApi {
  final key = dotenv.env['KEY'];

  /// インスタンス
  static final MovieApi _instance = MovieApi._();

  /// コンストラクタ
  MovieApi._();

  /// ファクトリコンストラクタ
  factory MovieApi() => _instance;

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

  Future<List<Movie>> getNowMovies() async {
    var searchUrl =
        'https://api.themoviedb.org/3/movie/now_playing?api_key=$key&language=ja&page=1';

    final response = await http.get(Uri.parse(searchUrl));
    final List<dynamic> extractedData = json.decode(response.body)['results'];
    return extractedData.map((data) => Movie.fromJson(data)).toList();
  }

  Future<List<Movie>> getTrendDayMovies() async {
    var searchUrl =
        'https://api.themoviedb.org/3/trending/all/week?api_key=$key&language=ja&page=1';

    final response = await http.get(Uri.parse(searchUrl));
    final List<dynamic> extractedData = json.decode(response.body)['results'];
    return extractedData.map((data) => Movie.fromJson(data)).toList();
  }

  Future<Map<String, dynamic>> getLastedMovies() async {
    var searchUrl = 'https://api.themoviedb.org/3/movie/latest?api_key=$key';

    final response = await http.get(Uri.parse(searchUrl));
    final Map<String, dynamic> map =
        new Map<String, dynamic>.from(json.decode(response.body));
    return map;
  }
}

class TvApi {
  final key = dotenv.env['key'];

  ///instance
  static final TvApi _instance = TvApi._();

  //constracter
  TvApi._();

  //factory constracter
  factory TvApi() => _instance;

  Future<List<Tv>> getTvTopLate() async {
    var searchUrl =
        'https://api.themoviedb.org/3/tv/top_rated?api_key=$key&language=ja&page=1';

    final res = await http.get(Uri.parse(searchUrl));
    final List<dynamic> hogeData = json.decode(res.body)['results'];
    return hogeData.map((data) => Tv.fromJson(data)).toList();
  }
}

class MovieModel extends ChangeNotifier {
  /// アイテムリスト movie
  List<Movie> topLate = []; //高評価
  List<Movie> popular = []; //人気作品
  List<Movie> upcoming = []; //公開予定
  List<Movie> now = []; //公開中
  List<Movie> trendDay = []; //
  Map<String, dynamic> lasted = {}; //
  int onTap = 0;

  ///list tv
  List<Tv> tvTopLate = [];

  bool _isFetching = false;
  bool get isFetching => _isFetching;

  /// アイテムリストの更新
  Future<void> update() async {
    // アイテムリストをAPIから取得する
    topLate = await MovieApi().getLateMovies();
    popular = await MovieApi().getPopularMovies();
    upcoming = await MovieApi().getUpcomingMovies();
    now = await MovieApi().getNowMovies();
    trendDay = await MovieApi().getNowMovies();
    lasted = await MovieApi().getLastedMovies();

    tvTopLate = await TvApi().getTvTopLate();//例外処理
    // 変更を通知する
    notifyListeners();
  }
}
