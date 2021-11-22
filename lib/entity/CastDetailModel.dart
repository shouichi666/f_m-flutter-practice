import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
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
        backdropPath: json['backdrop_path'] ?? '');
  }
}

class Tv {
  int? voteCount;
  int? id;
  bool? video;
  num? voteAverage;
  String name;
  String originalName;
  double? popularity;
  String? posterPath;
  String? originalLanguage;
  String? originalTitle;
  String backdropPath = "";
  String overview = "";
  String status = "";
  String firstAirDate = "";

  Tv({
    this.voteCount,
    this.id,
    this.video,
    this.voteAverage,
    this.name = "",
    this.originalName = "",
    this.popularity,
    this.posterPath,
    this.originalLanguage,
    this.originalTitle,
    this.backdropPath = "",
    this.overview = "",
    this.status = "",
    this.firstAirDate = "",
  });

  factory Tv.fromJson(Map<String, dynamic> json) {
    return Tv(
        voteCount: json['vote_count'],
        id: json['id'],
        video: json['video'],
        voteAverage: json['vote_average'],
        name: json['name'],
        originalName: json['original_name'],
        popularity: json['popularity'],
        posterPath: json['poster_path'],
        originalLanguage: json['original_language'],
        originalTitle: json['original_title'],
        overview: json['overview'],
        backdropPath: json['backdrop_path'] ?? '',
        status: json['status'] ?? '',
        firstAirDate: json['first_air_dat'] ?? '');
  }
}

class Cast {
  int? id;
  bool? adult;
  int? gender;
  String? name;
  String? originalName;
  String? profilePath;

  Cast({
    this.id,
    this.adult,
    this.gender,
    this.name,
    this.originalName,
    this.profilePath,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'],
      adult: json['adult'],
      gender: json['gender'],
      name: json['name'],
      originalName: json['original_name'],
      profilePath: json['profile_path'],
    );
  }
}

class CastApi {
  final key = dotenv.env['KEY'];

  ///instance
  static final CastApi _instance = CastApi._();

  //constracter
  CastApi._();

  //factory constracter
  factory CastApi() => _instance;

  Future<Map<String, dynamic>> getPersonDetail(int id) async {
    var searchUrl =
        'https://api.themoviedb.org/3/person/$id?api_key=$key&language=ja';

    final res = await http.get(Uri.parse(searchUrl));
    final Map<String, dynamic> map =
        new Map<String, dynamic>.from(json.decode(res.body));
    return map;
  }

  Future<List<Movie>> getPersonMovie(int id) async {
    var searchUrl =
        'https://api.themoviedb.org/3/person/$id/movie_credits?api_key=$key&language=ja';

    final res = await http.get(Uri.parse(searchUrl));
    // print(res.body);
    final List<dynamic> jsonDecode = json.decode(res.body)['cast'];
    final data = jsonDecode.map((json) => Movie.fromJson(json)).toList();
    return data;
  }

  Future<List<Tv>> getPersonTv(int id) async {
    var searchUrl =
        'https://api.themoviedb.org/3/person/$id/tv_credits?api_key=$key&language=ja';

    final res = await http.get(Uri.parse(searchUrl));
    if (res.statusCode == 200) {
      final List<dynamic> jsonDecode = json.decode(res.body)['cast'];
      final data = jsonDecode.map((json) => Tv.fromJson(json)).toList();
      print(data);
      return data;
    } else {
      final Map<String, dynamic> json = {
        'adult': false,
        'gender': 2,
        'id': 18702,
        'known_for_department': 'Acting',
        'name': 'Mark Dacascos',
        'original_name': 'Mark Dacascos',
        'popularity': 7.899,
        'profile_path': '/trOACuJz1KzhB51qe6asaxRuxrh.jpg',
        'character': 'Eric Draven',
        'credit_id': '52582b20760ee36aaa873014',
        'order': 0
      };

      final data = Tv.fromJson(json);

      return [data];
    }
  }
}

class CastDetailModel extends ChangeNotifier {
  ///list tv
  Map<String, dynamic> detail = {};
  List<Tv> tv = [];
  List<Movie> movie = [];

  bool _isFetching = false;
  bool get isFetching => _isFetching;

  // void

  /// アイテムリストの更新
  Future<void> update(id) async {
    // addId(id);
    detail = {};
    tv = [];
    movie = [];
    detail = await CastApi().getPersonDetail(id);
    movie = await CastApi().getPersonMovie(id);
    tv = await CastApi().getPersonTv(id);
    // print(isFetching);
    // print(smiler);
    _isFetching = true;
    notifyListeners();
  }
}
