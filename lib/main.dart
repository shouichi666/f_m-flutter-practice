import 'ui/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'entity/MovieModel.dart';
import 'entity/MovieDetailModel.dart';
import 'entity/TvDetailModel.dart';
import 'pages/Movie_detail.dart';
import 'pages/Tv_detail.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MovieModel()),
        ChangeNotifierProvider(create: (context) => MovieDetailModel()),
        ChangeNotifierProvider(create: (context) => TvDetailModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<MovieModel>().update();

    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: primaryBlack,
      ),
      darkTheme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: new Scaffold(
        body: new NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                title: SizedBox(
                  width: 60,
                  child: Image.asset('images/logo_transparent.png'),
                ),
                floating: true,
                pinned: true,
                snap: true,
                centerTitle: true,
                bottom: new TabBar(
                  labelColor: Colors.amber[400],
                  unselectedLabelColor: Colors.white,
                  indicatorColor: Colors.amber[400],
                  tabs: <Tab>[
                    new Tab(text: "HOME"),
                    new Tab(text: "MOVIE"),
                    new Tab(text: "TV"),
                  ],
                ),
              ),
            ];
          },
          body: Consumer<MovieModel>(builder: (context, model, child) {
            return RefreshIndicator(
              onRefresh: () async => model.update(),
              child: new TabBarView(
                children: <Widget>[
                  TopPage(),
                  MoviePage(),
                  TvPage(),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class CarouselWithIndicator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CarouselWithIndicatorState();
  }
}

class CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    final MovieModel datas = context.watch<MovieModel>();
    final items = datas.trendDay;
    return Container(
      color: primaryBlack.shade900,
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              CarouselSlider(
                carouselController: _controller,
                options: CarouselOptions(
                    aspectRatio: 2.0,
                    enlargeCenterPage: false,
                    enableInfiniteScroll: true,
                    initialPage: 1,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 6),
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
                items: items.map((item) {
                  return Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: _Panel(
                            item.id,
                            item.backdropPath,
                            item.originalTitle.toString(),
                            item.posterPath,
                            item.popularity),
                      ),
                    ],
                  );
                }).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: items.asMap().entries.map(
                  (entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 4.0,
                        height: 4.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.white)
                              .withOpacity(_current == entry.key ? 0.9 : 0.4),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  _Tile(this.imgPath, this.id);

  final String? imgPath;
  final int? id;

  @override
  Widget build(BuildContext context) {
    final MovieDetailModel detail = context.watch();
    return Container(
      child: GestureDetector(
        onTap: () {
          detail.update(id ?? 0);
          Navigator.of(context) // NavigatorState を取得して
              .push(
            MaterialPageRoute(
              // 新しいRoute を _history に追加
              builder: (context) => MovieDetailPage(), // 追加した Route は詳細画面を構築する
            ), // push() の中ではアニメーションしながら詳細画面を表示する処理を実行
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(19.5),
          ),
          child: Image.network('https://image.tmdb.org/t/p/w500$imgPath',
              fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class _TileTv extends StatelessWidget {
  _TileTv(this.imgPath, this.id);

  final String? imgPath;
  final int? id;

  @override
  Widget build(BuildContext context) {
    final TvDetailModel detail = context.watch();
    return Container(
      child: GestureDetector(
        onTap: () {
          detail.update(id ?? 0);
          Navigator.of(context) // NavigatorState を取得して
              .push(
            MaterialPageRoute(
              // 新しいRoute を _history に追加
              builder: (context) => TvDetailPage(), // 追加した Route は詳細画面を構築する
            ), // push() の中ではアニメーションしながら詳細画面を表示する処理を実行
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(19.5),
          ),
          child: Image.network('https://image.tmdb.org/t/p/w500$imgPath',
              fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  _Panel(
      this.id, this.backImgPath, this.title, this.posterImgPath, this.review);
  final int? id;
  final String backImgPath;
  final String? posterImgPath;
  final String title;
  final double? review;

  @override
  Widget build(BuildContext context) {
    final MovieDetailModel datas = context.watch();
    return GestureDetector(
      onTap: () {
        datas.update(id ?? 0);
        Navigator.of(context) // NavigatorState を取得して
            .push(
          MaterialPageRoute(
            // 新しいRoute を _history に追加
            builder: (context) => MovieDetailPage(), // 追加した Route は詳細画面を構築する
          ), // push() の中ではアニメーションしながら詳細画面を表示する処理を実行
        );
      },
      child: Container(
        margin: EdgeInsets.all(2.0),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                Image.network('https://image.tmdb.org/t/p/w500$backImgPath',
                    fit: BoxFit.cover),
                Positioned(
                  bottom: 10.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10.0,
                  right: 0.0,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      review.toString(),
                      style: TextStyle(
                        color: Colors.lime,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 58.0,
                  left: 0.0,
                  right: 200.0,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          spreadRadius: 1.0,
                          blurRadius: 10.0,
                          offset: Offset(10, 10),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: 20,
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500$posterImgPath',
                        fit: BoxFit.contain,
                        width: 100,
                        height: 110,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class _LastedContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MovieModel datas = context.watch<MovieModel>();
    final lasted = datas.lasted;
    // print(lasted);
    var img = (lasted['poster_path'] == null ? 0 : lasted['poster_path']);
    var title = (lasted['title'] == null ? '' : lasted['title']);
    if (img != 0) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.all(20)),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "追加作品(MOVIE)",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: 300,
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500$img',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 0.0,
                          right: 0.0,
                          child: Text(
                            'No Image',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        Positioned(
                          top: 20.0,
                          right: 0.0,
                          child: Text(
                            lasted['adult'] == true ? 'アダルト' : '全年齢',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.all(20)),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "最新追加作品",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Image.asset(
                          "images/no.png",
                          width: double.infinity,
                        ),
                        Positioned(
                          top: 0.0,
                          right: 0.0,
                          child: Text(
                            'No Image',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        Positioned(
                          top: 20.0,
                          right: 0.0,
                          child: Text(
                            lasted['adult'] == true ? 'アダルト' : '全年齢',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}

class _TvLastedContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MovieModel datas = context.watch<MovieModel>();
    final lasted = datas.tvLasted;
    print(lasted);
    var img = (lasted['backdrop_path'] == null ? 0 : lasted['backdrop_path']);
    var title = (lasted['name'] == null ? '' : lasted['name']);
    if (img != 0) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.all(20)),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "追加作品(TV)",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: 300,
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500$img',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 0.0,
                          right: 0.0,
                          child: Text(
                            'No Image',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        Positioned(
                          top: 20.0,
                          right: 0.0,
                          child: Text(
                            lasted['adult'] == true ? 'アダルト' : '全年齢',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.all(20)),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "追加作品（TV）",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Image.asset(
                          "images/no.png",
                          width: double.infinity,
                        ),
                        Positioned(
                          top: 0.0,
                          right: 0.0,
                          child: Text(
                            'No Image',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        Positioned(
                          top: 20.0,
                          right: 0.0,
                          child: Text(
                            lasted['adult'] == true ? 'アダルト' : '全年齢',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}

class TopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryBlack.shade900,
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              CarouselWithIndicator(),
              _LastedContainer(),
              _TvLastedContainer(),
            ],
          ),
        ),
      ),
    );
  }
}

class MoviePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MovieModel datas = context.watch<MovieModel>();
    final upComigList = datas.upcoming;
    final popularList = datas.popular;
    final topList = datas.topLate;
    final now = datas.now;
    if (upComigList.length > 0 &&
        popularList.length > 0 &&
        topList.length > 0 &&
        now.length > 0) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.topLeft,
            end: FractionalOffset.bottomRight,
            colors: [
              Color(0xFF032617).withOpacity(0.9),
              Color(0xFF000000).withOpacity(1),
            ],
            stops: const [
              0.1,
              1.1,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.all(15)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.fromLTRB(15, 20, 0, 20)),
                  Text(
                    '近日公開  ${upComigList.length} 作品',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontSize: 17),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right_outlined,
                    size: 28,
                    color: Colors.white,
                  )
                ],
              ),
              CarouselSlider.builder(
                options: CarouselOptions(
                  aspectRatio: 3,
                  enableInfiniteScroll: true,
                  initialPage: 1,
                  autoPlay: false,
                  enlargeCenterPage: false,
                  viewportFraction: 0.5,
                ),
                itemCount: (upComigList.length / 4).round(),
                itemBuilder: (context, index, realIdx) {
                  final int first = index * 2;
                  final int second = first + 1;
                  return Row(
                    children: [first, second].map((idx) {
                      return Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          child: _Tile(
                              upComigList[idx].posterPath, upComigList[idx].id),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              Padding(padding: EdgeInsets.all(15)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.fromLTRB(15, 20, 0, 20)),
                  Text(
                    '人気作品  ${upComigList.length} 作品',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontSize: 17),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right_outlined,
                    size: 28,
                    color: Colors.white,
                  )
                ],
              ),
              CarouselSlider.builder(
                options: CarouselOptions(
                  aspectRatio: 3,
                  enableInfiniteScroll: true,
                  initialPage: 1,
                  autoPlay: false,
                  enlargeCenterPage: false,
                  viewportFraction: 0.5,
                ),
                itemCount: (popularList.length / 2).round(),
                itemBuilder: (context, index, realIdx) {
                  final int first = index * 2;
                  final int second = first + 1;
                  return Row(
                    children: [first, second].map((idx) {
                      return Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          child: _Tile(
                              popularList[idx].posterPath, popularList[idx].id),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              Padding(padding: EdgeInsets.all(15)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.fromLTRB(15, 20, 0, 20)),
                  Text(
                    '高評価  ${upComigList.length} 作品',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontSize: 17),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right_outlined,
                    size: 28,
                    color: Colors.white,
                  )
                ],
              ),
              CarouselSlider.builder(
                options: CarouselOptions(
                  aspectRatio: 3,
                  enableInfiniteScroll: true,
                  initialPage: 1,
                  autoPlay: false,
                  enlargeCenterPage: false,
                  viewportFraction: 0.5,
                ),
                itemCount: (topList.length / 2).round(),
                itemBuilder: (context, index, realIdx) {
                  final int first = index * 2;
                  final int second = first + 1;
                  return Row(
                    children: [first, second].map((idx) {
                      return Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          child:
                              _Tile(topList[idx].posterPath, topList[idx].id),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              Padding(padding: EdgeInsets.all(15)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.fromLTRB(15, 20, 0, 20)),
                  Text(
                    '劇場の映画  ${upComigList.length} 作品',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontSize: 17),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right_outlined,
                    size: 28,
                    color: Colors.white,
                  )
                ],
              ),
              CarouselSlider.builder(
                options: CarouselOptions(
                  aspectRatio: 3,
                  enableInfiniteScroll: true,
                  initialPage: 1,
                  autoPlay: false,
                  enlargeCenterPage: false,
                  viewportFraction: 0.5,
                ),
                itemCount: (now.length / 2).round(),
                itemBuilder: (context, index, realIdx) {
                  final int first = index * 2;
                  final int second = first + 1;
                  return Row(
                    children: [first, second].map((idx) {
                      return Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          child: _Tile(now[idx].posterPath, now[idx].id),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              Padding(padding: EdgeInsets.all(30)),
            ],
          ),
        ),
      );
    } else {
      return Loading();
    }
  }
}

class TvPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MovieModel datas = context.watch<MovieModel>();
    final toLate = datas.tvTopLate;
    final popular = datas.tvPopuler;
    final onAir = datas.tvOnTheAir;

    if (toLate.length > 0 && popular.length > 0 && onAir.length > 0) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.topLeft,
            end: FractionalOffset.bottomRight,
            colors: [
              Color(0xFF000524).withOpacity(0.9),
              Color(0xFF000000).withOpacity(1),
            ],
            stops: const [
              0.1,
              1.1,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(15)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.fromLTRB(15, 20, 0, 20)),
                  Text(
                    '高評価  ${toLate.length} 作品',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontSize: 17),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right_outlined,
                    size: 28,
                    color: Colors.white,
                  )
                ],
              ),
              CarouselSlider.builder(
                options: CarouselOptions(
                  aspectRatio: 3,
                  enableInfiniteScroll: true,
                  initialPage: 1,
                  autoPlay: false,
                  enlargeCenterPage: false,
                  viewportFraction: 0.5,
                ),
                itemCount: (toLate.length / 4).round(),
                itemBuilder: (context, index, realIdx) {
                  final int first = index * 2;
                  final int second = first + 1;
                  return Row(
                    children: [first, second].map((idx) {
                      return Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          child:
                              _TileTv(toLate[idx].posterPath, toLate[idx].id),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              Padding(padding: EdgeInsets.all(15)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.fromLTRB(15, 20, 0, 20)),
                  Text(
                    '人気  ${onAir.length} 作品',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontSize: 17),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right_outlined,
                    size: 28,
                    color: Colors.white,
                  )
                ],
              ),
              CarouselSlider.builder(
                options: CarouselOptions(
                  aspectRatio: 3,
                  enableInfiniteScroll: true,
                  initialPage: 1,
                  autoPlay: false,
                  enlargeCenterPage: false,
                  viewportFraction: 0.5,
                ),
                itemCount: (onAir.length / 4).round(),
                itemBuilder: (context, index, realIdx) {
                  final int first = index * 2;
                  final int second = first + 1;
                  return Row(
                    children: [first, second].map((idx) {
                      return Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          child: _TileTv(onAir[idx].posterPath, onAir[idx].id),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              Padding(padding: EdgeInsets.all(15)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.fromLTRB(15, 20, 0, 20)),
                  Text(
                    '放送中？  ${popular.length} 作品',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontSize: 17),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right_outlined,
                    size: 28,
                    color: Colors.white,
                  )
                ],
              ),
              CarouselSlider.builder(
                options: CarouselOptions(
                  aspectRatio: 3,
                  enableInfiniteScroll: true,
                  initialPage: 1,
                  autoPlay: false,
                  enlargeCenterPage: false,
                  viewportFraction: 0.5,
                ),
                itemCount: (popular.length / 4).round(),
                itemBuilder: (context, index, realIdx) {
                  final int first = index * 2;
                  final int second = first + 1;
                  return Row(
                    children: [first, second].map((idx) {
                      return Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          child:
                              _TileTv(popular[idx].posterPath, popular[idx].id),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              Padding(padding: EdgeInsets.all(15)),
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: Loading(),
      );
    }
  }
}

class Loading extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      child: Text('LOADING'),
    );
  }
}
