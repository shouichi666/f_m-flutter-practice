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
  String? posterPath;
  String? originalLanguage;
  String? originalTitle;
  String backdropPath = "";
  String overview = "";
  String status = "";
  String firstAirDate = "";
  String profilePath = "";

  Item({
    this.voteCount,
    this.id,
    this.video,
    this.voteAverage,
    this.name = "",
    this.originalName = "",
    this.mediaType,
    this.posterPath,
    this.originalLanguage,
    this.originalTitle,
    this.backdropPath = "",
    this.overview = "",
    this.status = "",
    this.firstAirDate = "",
    this.profilePath = "",
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        voteCount: json['vote_count'] ?? 0,
        id: json['id'] ?? '',
        video: json['video'] ?? false,
        voteAverage: json['vote_average'] ?? 0,
        name: json['name'] ?? json['title'],
        originalName: json['original_name'] ?? 'movie',
        mediaType: json['media_type'] ?? '',
        posterPath: json['poster_path'] ?? '',
        originalLanguage: json['original_language'] ?? '',
        originalTitle: json['original_title'] ?? '',
        overview: json['overview'] ?? '',
        backdropPath: json['backdrop_path'] ?? '',
        status: json['status'] ?? '',
        firstAirDate: json['first_air_dat'] ?? '',
        profilePath: json['profile_path'] ?? '');
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

  Future<List<Item>> getMulti(String query, bool adult, int page) async {
    // print('-------------------');
    // print(page);
    var searchUrl =
        'https://api.themoviedb.org/3/search/multi?api_key=$key&language=ja&query=$query&page=$page&include_adult=$adult';

    print(searchUrl);
    final res = await http.get(Uri.parse(searchUrl));
    final List<dynamic> jsonDecode = json.decode(res.body)['results'];
    final data = jsonDecode.map((json) => Item.fromJson(json)).toList();

    print(data);
    return data;
  }

  Future<int> getTotalPage(String query, bool adult, int page) async {
    // print('-------------------');
    // print(page);
    var searchUrl =
        'https://api.themoviedb.org/3/search/multi?api_key=$key&language=ja&query=$query&page=$page&include_adult=$adult';

    final res = await http.get(Uri.parse(searchUrl));
    final int pages = json.decode(res.body)['total_pages'];

    print(pages);
    return pages;
  }
}

class SearchModel extends ChangeNotifier {
  ///list Item
  int _id = 1;
  int page = 1;
  int totalPage = 1;
  String keyword = '';
  bool adult = true;
  List<Item> getMulti = [];

  bool _isFetching = false;
  bool get isFetching => _isFetching;
  void addId(int id) => _id = id;
  int get getId => _id;
  String first = 'first';

  // void

  void toggleAdult() {
    if (adult == true) {
      adult = false;
    } else {
      adult = true;
    }

    notifyListeners();
  }

  void onChangeKeyword(String text) {
    keyword = text;
    notifyListeners();
  }

  void onDeleteKeyword() {
    keyword = '';
    getMulti = [];
    // print(keyword);
    notifyListeners();
  }

  Future<void> addPage(query, _page) async {
    // print(_page);
    final List ary = await SearchApi().getMulti(query, adult, _page);
    final List origin = getMulti;
    getMulti = [...origin, ...ary];
    notifyListeners();
  }

  Future<void> onSeach(query) async {
    if (query.length > 0) {
      getMulti = [];

      print(query);
      totalPage = await SearchApi().getTotalPage(query, adult, page);
      getMulti = await SearchApi().getMulti(query, adult, page);
      _isFetching = true;
      notifyListeners();
    }
  }

  Future<void> onTapSearch(query) async {
    if (query.length > 0) {
      getMulti = [];
      keyword = query;
      getMulti = await SearchApi().getMulti(query, adult, page);
      _isFetching = true;
      notifyListeners();
    }
  }
}
