import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// {
//   "backdrop_path":"/se2jymoLDghIrLewQismwfmWG.jpg",
//   "created_by":[],
//   "episode_run_time":[60],
//   "first_air_date":"2005-06-08",
//   "genres":[],
//   "homepage":"",
//   "id":11,
//   "in_production":false,
//   "languages":["en"],
//   "last_air_date":"2005-08-24",
//   "last_episode_to_air":{
//     "air_date":"2005-08-24",
//     "episode_number":10,
//     "id":1130622,
//     "name":"",
//     "overview":"",
//     "production_code":"",
//     "season_number":1,
//     "still_path":null,
//     "vote_average":0.0,
//     "vote_count":0
//   },
//   "name":"Strictly Sex with Dr. Drew",
//   "next_episode_to_air":null,
//   "networks":[
//     {
//       "name":"Discovery Health Channel",
//       "id":10,
//       "logo_path":"/yiBepnHS6gdzlT6ZIehYnNl0nEG.png",
//       "origin_country":"US"
//     }
//   ],
//   "number_of_episodes":10,
//   "number_of_seasons":1,
//   "origin_country":["US"],
//   "original_language":"en",
//   "original_name":"Strictly Sex with Dr. Drew",
//   "overview":"","popularity":1.092,
//   "poster_path":"/3hFpUg6Ty25Vs5XgbnNz1Xcirb5.jpg",
//   "production_companies":[],
//   "production_countries":[],
//   "seasons":[
//     {
//       "air_date":"2005-06-08",
//       "episode_count":10,
//       "id":2328145,
//       "name":"Season 1",
//       "overview":"",
//       "poster_path":null,
//       "season_number":1
//       }
//   ],"spoken_languages":[
//     {
//       "english_name":"English",
//       "iso_639_1":"en",
//       "name":"English"
//       }
//   ],
//   "status":"Ended",
//   "tagline":"",
//   "type":"Scripted",
//   "vote_average":0.0,
//   "vote_count":0
// }

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

class TvApi {
  final key = dotenv.env['KEY'];

  ///instance
  static final TvApi _instance = TvApi._();

  //constracter
  TvApi._();

  //factory constracter
  factory TvApi() => _instance;

  Future<Map<String, dynamic>> getMovieDetail(int id) async {
    var searchUrl =
        'https://api.themoviedb.org/3/tv/$id?api_key=$key&language=ja';

    final res = await http.get(Uri.parse(searchUrl));
    final Map<String, dynamic> map =
        new Map<String, dynamic>.from(json.decode(res.body));
    return map;
  }

  Future<List<Tv>> getSmilerTv(int id) async {
    var searchUrl =
        'https://api.themoviedb.org/3/tv/$id/similar?api_key=$key&language=ja';

    final res = await http.get(Uri.parse(searchUrl));
    final List<dynamic> jsonDecode = json.decode(res.body)['results'];
    final data = jsonDecode.map((json) => Tv.fromJson(json)).toList();
    return data;
  }

  Future<List<Cast>> getCastTv(int id) async {
    var searchUrl =
        'https://api.themoviedb.org/3/tv/$id/credits?api_key=$key&language=ja';

    final res = await http.get(Uri.parse(searchUrl));
    print('res _________________________');
    print(res.statusCode == 200);
    // final List<dynamic> jsonDecode = json.decode(res.body)['cast'];
    // final data = jsonDecode.map((json) => Cast.fromJson(json)).toList();
    // print(jsonDecode);
    // return data;

    if (res.statusCode == 200) {
      final List<dynamic> jsonDecode = json.decode(res.body)['cast'];
      final data = jsonDecode.map((json) => Cast.fromJson(json)).toList();
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

      final data = Cast.fromJson(json);

      return [data];
    }
  }
}

class TvDetailModel extends ChangeNotifier {
  ///list tv
  int _id = 1;
  Map<String, dynamic> detail = {};
  List<Tv> smiler = [];
  List<Cast> cast = [];
  bool adult = false;

  bool _isFetching = false;
  bool get isFetching => _isFetching;
  void addId(int id) => _id = id;
  int get getId => _id;
  String first = 'first';

  // void

  /// アイテムリストの更新
  Future<void> update(id) async {
    // addId(id);
    detail = {};
    smiler = [];
    cast = [];
    detail = await TvApi().getMovieDetail(id);
    smiler = await TvApi().getSmilerTv(id);
    cast = await TvApi().getCastTv(id);
    // print(isFetching);
    // print(smiler);
    print(cast);
    _isFetching = true;
    notifyListeners();
  }
}

// {
//   "adult":false,
//   "backdrop_path":"/iTgM25ftE7YtFgZwUZupVp8A61S.jpg",
//   "belongs_to_collection":null,
//   "budget":18000000,
//   "genres":[
//     {"id":9648,"name":"謎"},
//     {"id":53,"name":"スリラー"},
//     {"id":27,"name":"ホラー"}
//   ],
//   "homepage":"https://www.old.movie/",
//   "id":631843,
//   "imdb_id":"tt10954652",
//   "original_language":"en",
//   "original_title":"Old",
//   "overview":"「シックス・センス」「スプリット」のM・ナイト・シャマラン監督が、異常なスピードで時間が流れ、急速に年老いていくという不可解な現象に見舞われた一家の恐怖とサバイバルを描いたスリラー。人里離れた美しいビーチに、バカンスを過ごすためやってきた複数の家族。それぞれが楽しいひと時を過ごしていたが、そのうちのひとりの母親が、姿が見えなくなった息子を探しはじめた。ビーチにいるほかの家族にも、息子の行方を尋ねる母親。そんな彼女の前に、「僕はここにいるよ」と息子が姿を現す。しかし、6歳の少年だった息子は、少し目を離したすきに青年へと急成長していた。やがて彼らは、それぞれが急速に年老いていくことに気づく。ビーチにいた人々はすぐにその場を離れようとするが、なぜか意識を失ってしまうなど脱出することができず……。主人公一家の父親役をガエル・ガルシア・ベルナルが演じ、「ファントム・スレッド」のビッキー・クリーブス、「ジョジョ・ラビット」のトーマシン・マッケンジー、「ジュマンジ」シリーズのアレックス・ウルフらが共演する。",
//   "popularity":1853.229,
//   "poster_path":"/6VC8rOnA3eVzbEXMdLaTYuYwlby.jpg",
//   "production_companies":[
//     {"id":33,"logo_path":"/8lvHyhjr8oUKOOy2dKXoALWKdp0.png","name":"Universal Pictures","origin_country":"US"},
//     {"id":12236,"logo_path":"/uV6QBPdn3MjQzAFdgEel6od7geg.png","name":"Blinding Edge Pictures","origin_country":"US"},
//     {"id":10338,"logo_path":"/el2ap6lvjcEDdbyJoB3oKiYgXu9.png","name":"Perfect World Pictures","origin_country":"CN"}
//   ],
//   "production_countries":[
//     {"iso_3166_1":"US","name":"United States of America"}
//   ],
//   "release_date":"2021-07-21",
//   "revenue":89500000,
//   "runtime":108,
//   "spoken_languages":[
//     {"english_name":"English","iso_639_1":"en","name":"English"}
//   ],
//   "status":"Released",
//   "tagline":"",
//   "title":"オールド",
//   "video":false,
//   "vote_average":6.8,
//   "vote_count":862
// }

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
