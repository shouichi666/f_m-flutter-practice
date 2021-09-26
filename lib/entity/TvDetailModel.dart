import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Tv {
  int? id;
  num? voteAverage;
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

class TvApi {
  final key = dotenv.env['KEY'];

  ///instance
  static final TvApi _instance = TvApi._();

  //constracter
  TvApi._();

  //factory constracter
  factory TvApi() => _instance;

  Future<Map<String, dynamic>> getTvDetail(int id) async {
    var searchUrl =
        'https://api.themoviedb.org/3/tv/$id?api_key=$key&language=ja&page=1';
    final res = await http.get(Uri.parse(searchUrl));
    final Map<String, dynamic> map =
        new Map<String, dynamic>.from(json.decode(res.body));
    return map;
  }
}

class TvDetailModel extends ChangeNotifier {
  ///list tv
  int _id = 0;
  Map<String, dynamic> detail = {};

  bool _isFetching = false;
  bool get isFetching => _isFetching;

  void addId(int id) => _id = id;
  int get getId => _id;

  /// アイテムリストの更新
  Future<void> update() async {
    detail = await TvApi().getTvDetail(_id);
    // 変更を通知する
    notifyListeners();
  }
}



// {
//   "backdrop_path":"/7Ls73KYosHXFYOmgUE6zSflRJpA.jpg",
//   "created_by":[
//     {
//       "id":70804,
//       "credit_id":"5253314119c29579400143d9",
//       "name":"Dan Schneider",
//       "gender":2,
//       "profile_path":"/kQ4L3PyRUjrAN5xfpbme9xrap16.jpg"
//     },
//     {
//       "id":1212112,
//       "credit_id":"5253314119c29579400143df",
//       "name":"Wil Calhoun",
//       "gender":2,
//       "profile_path":null
//     }
//   ],
//   "episode_run_time":[30],
//   "first_air_date":"2002-09-20",
//   "genres":[
//     {
//       "id":35,
//       "name":"コメディ"
//     }
//   ],
//   "homepage":"",
//   "id":33,
//   "in_production":false,
//   "languages":["en"],
//   "last_air_date":"2006-03-24",
//   "last_episode_to_air":{
//     "air_date":"2006-03-24",
//     "episode_number":18,
//     "id":632,"name":"",
//     "overview":"",
//     "production_code":"",
//     "season_number":4,
//     "still_path":"/x6ElwFOM1rqRFXXVaQIx9mf6zRJ.jpg",
//     "vote_average":0.0,
//     "vote_count":0
//   },
//   "name":"What I Like About You",
//   "next_episode_to_air":null,
//   "networks":[
//     {
//       "name":"The WB",
//       "id":21,
//       "logo_path":"/9GlDHjQj9c2dkfARCR3zlH87R66.png",
//       "origin_country":"US"
//     }
//   ],
//   "number_of_episodes":86,
//   "number_of_seasons":4,
//   "origin_country":["US"],
//   "original_language":"en",
//   "original_name":"What I Like About You","overview":"",
//   "popularity":22.297,
//   "poster_path":"/zSBXCHUwMR3uCCeheTCeb6lzpEI.jpg",
//   "production_companies":[
//     {
//       "id":1957,
//       "logo_path":"/3T19XSr6yqaLNK8uJWFImPgRax0.png"
//       "name":"Warner Bros. Television"
//       "origin_country":"US"
//     },
//     {
//       "id":2184,
//       "logo_path":null,
//       "name":"Tollin/Robbins Productions",
//       "origin_country":""
//     }
//   ],
//   "production_countries":[
//     {
//       "iso_3166_1":"US",
//       "name":"United States of America"
//     }
//   ],
//   "seasons":[
//     {
//       "air_date":"2002-09-20"
//       "episode_count":22
//       "id":19
//       "name":"シーズン1"
//       "overview":""
//       "poster_path":"/ApYMfiCvCNYaGSgwhqXdVxZMiIt.jpg"
//       "season_number":1
//     }
//     {
//       "air_date":"2003-09-11",
//       "episode_count":22,
//       "id":18,
//       "name":"シーズン2",
//       "overview":"",
//       "poster_path":"/e5sCTIyR2U0JltSYIriCrGpsWkj.jpg",
//       "season_number":2
//     },
//     {
//       "air_date":"2004-09-17",
//       "episode_count":24,
//       "id":20,
//       "name":"シーズン3",
//       "overview":"",
//       "poster_path":"/dA0FkOh483yofq9CQcIBY2fFygl.jpg",
//       "season_number":3
//     },
//     {
//       "air_date":"2005-09-16",
//       "episode_count":18,
//       "id":21,
//       "name":"シーズン4",
//       "overview":"",
//       "poster_path":"/f03dHtWJRVUyJoa6ULL775EX9kK.jpg",
//       "season_number":4
//     }],
//   "spoken_languages":[
//     {
//       "english_name":"English",
//       "iso_639_1":"en",
//       "name":"English"
//     }
//   ],
//   "status":"Ended",
//   "tagline":"",
//   "type":"Scripted",
//   "vote_average":5.9,
//   "vote_count":38
// }