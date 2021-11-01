import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Item {
  int? voteCount;
  int? id;
  bool? video;
  num? voteAverage;
  String name;
  String originalName;
  String? mediaType;
  double? popularity;
  String? posterPath;
  String? originalLanguage;
  String? originalTitle;
  String backdropPath = "";
  String overview = "";
  String status = "";
  String firstAirDate = "";

  Item({
    this.voteCount,
    this.id,
    this.video,
    this.voteAverage,
    this.name = "",
    this.originalName = "",
    this.mediaType,
    this.popularity,
    this.posterPath,
    this.originalLanguage,
    this.originalTitle,
    this.backdropPath = "",
    this.overview = "",
    this.status = "",
    this.firstAirDate = "",
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        voteCount: json['vote_count'] ?? '',
        id: json['id'] ?? '',
        video: json['video'] ?? '',
        voteAverage: json['vote_average'] ?? '',
        name: json['name'] ?? '',
        originalName: json['original_name'] ?? '',
        mediaType: json['media_type'] ?? '',
        popularity: json['popularity'] ?? '',
        posterPath: json['poster_path'] ?? '',
        originalLanguage: json['original_language'] ?? '',
        originalTitle: json['original_title'] ?? '',
        overview: json['overview'] ?? '',
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
      id: json['id'] ?? '',
      adult: json['adult'] ?? '',
      gender: json['gender'],
      name: json['name'],
      originalName: json['original_name'],
      profilePath: json['profile_path'],
    );
  }
}

class SearchApi {
  final key = dotenv.env['KEY'];

  ///instance
  static final SearchApi _instance = SearchApi._();

  //constracter
  SearchApi._();

  //factory constracter
  factory SearchApi() => _instance;

  Future<List<Item>> getMulti(String query) async {
    var searchUrl =
        'https://api.themoviedb.org/3/search/multi?api_key=$key&language=ja&query=$query&page=1';

    final res = await http.get(Uri.parse(searchUrl));
    final List<dynamic> jsonDecode = json.decode(res.body)['results'];
    final data = jsonDecode.map((json) => Item.fromJson(json)).toList();
    return data;
  }
}

class SearchModel extends ChangeNotifier {
  ///list Item
  int _id = 1;
  String keyword = '';
  List<Item> getMulti = [];

  bool _isFetching = false;
  bool get isFetching => _isFetching;
  void addId(int id) => _id = id;
  int get getId => _id;
  String first = 'first';

  // void

  void onChangeKeyword(String text) {
    keyword = text;
    notifyListeners();
  }

  void onDeleteKeyword() {
    keyword = '';
    print(keyword);
    notifyListeners();
  }

  Future<void> onSeach(query) async {
    getMulti = [];
    getMulti = await SearchApi().getMulti(query);
    _isFetching = true;
    notifyListeners();
  }
}
