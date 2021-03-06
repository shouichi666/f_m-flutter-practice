import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movie/ui/color.dart';
import '../entity/TvDetailModel.dart';
import '../entity/CastDetailModel.dart';
import 'Cast_detail.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../ui/tab.dart';

class TvDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TvDetailModel datas = context.watch();
    final detail = datas.detail;
    final img = detail['backdrop_path'] ?? 'qD45xHA35HdJDGOaA1AgDwiWEgO.jpg';
    if (datas.smiler.length > 0 && datas.cast.length > 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text(detail['name'] ?? 'loading'),
        ),
        body: Container(
          color: primaryBlack.shade900,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 200,
                      padding: EdgeInsets.only(left: 50),
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return RadialGradient(
                            center: Alignment.topLeft,
                            radius: 6.0,
                            colors: <Color>[
                              primaryBlack.shade900,
                              Colors.amber.shade100,
                            ],
                            tileMode: TileMode.mirror,
                          ).createShader(bounds);
                        },
                        child: FadeInImage.assetNetwork(
                          placeholder: 'images/logo_transparent.png',
                          image: 'https://image.tmdb.org/t/p/w500' + img,
                          fit: BoxFit.contain,
                          fadeInCurve: Curves.linear,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0.0,
                      left: 40.0,
                      width: 150,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500' +
                                detail['poster_path'],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      right: 0.0,
                      width: 150,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'IMDb ' + detail['vote_average'].toString(),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  detail['runtime'].toString() + ' minutes',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0.0,
                      right: 0.0,
                      width: 150,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          detail['popularity'].toString(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Text(
                    detail['name'] ?? 'title',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    detail['overview'] ?? 'Sorry Non Overview',
                    style: TextStyle(
                        color: Colors.blueGrey.shade100, fontSize: 12),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: TabUI(key: GlobalKey(), tabs: [
                    Center(
                      child: Text(
                        '??????',
                        style: TextStyle(color: Colors.blue.shade200),
                      ),
                    ),
                    Center(
                      child: Text(
                        '??????',
                        style: TextStyle(color: Colors.blue.shade200),
                      ),
                    ),
                  ], children: <Widget>[
                    Container(
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
                      child: Column(
                        children: [SmilerSlider(), CastSlider()],
                      ),
                    ),
                    Container(
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
                      child: DetailList(detail),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: primaryBlack.shade900,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "images/no.png",
                width: double.infinity,
              ),
              Text('LOADING'),
            ],
          ),
        ),
      );
    }
  }
}

class SmilerSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TvDetailModel datas = context.watch();
    final smiler = datas.smiler;
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 1, 8),
                child: Text(
                  '??????????????? ' + smiler.length.toString() + ' ??????',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          CarouselSlider.builder(
            itemCount: (smiler.length / 4).round() - 1,
            itemBuilder: (context, index, realIdx) {
              final int first = index * 4;
              final int second = first + 1;
              final int third = first + 2;
              final int fourth = first + 3;
              if (smiler.length > 0) {
                return Row(
                  children: [first, second, third, fourth].map((e) {
                    return Expanded(
                      flex: 4,
                      child: Container(
                        child: _Tile(
                          smiler[e].posterPath,
                          smiler[e].id,
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return Container(
                  child: Text('fvdosihjj'),
                );
              }
            },
            options: CarouselOptions(
              aspectRatio: 3,
              initialPage: 1,
              enableInfiniteScroll: false,
              autoPlay: false,
              viewportFraction: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class CastSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TvDetailModel datas = context.watch();
    final cast = datas.cast;

    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 1, 8),
                child: Text(
                  '?????????  ' + cast.length.toString() + ' ???',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          CarouselSlider.builder(
            itemCount: (cast.length / 4).round() - 1,
            itemBuilder: (context, index, realIdx) {
              final int first = index * 4;
              final int second = first + 1;
              final int third = first + 2;
              final int fourth = first + 3;
              if (cast.length > 1) {
                return Row(
                  children: [first, second, third, fourth].map((e) {
                    print(cast.length);
                    final n = e > cast.length - 1 ? 0 : e;

                    return Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 3),
                        child: _TileCast(
                          cast[n].profilePath,
                          cast[n].id,
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return Container(
                  child: Text('fvdosihjj'),
                );
              }
            },
            options: CarouselOptions(
              aspectRatio: 3,
              enableInfiniteScroll: false,
              autoPlay: false,
              viewportFraction: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailList extends StatelessWidget {
  final Map<String, dynamic> detail;
  DetailList(this.detail);

  // hoge() {
  //   if (detail['release_date'].length > 0 || detail['release_date'] != null) {
  //     final aryDate = detail['release_date'].split('');
  //     aryDate[4] = '???';
  //     aryDate[7] = '???';
  //     aryDate.add('???');
  //     return aryDate;
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          ListTail('????????????', '????????????', detail['genres']),
          ListTail('????????????', detail['first_air_date'], []),
          ListTail('????????????', detail['episode_run_time'][0].toString() + '???', []),
          ListTail('???????????????????????????', detail['original_title'] ?? 'non', []),
          ListTail('??????', detail['vote_average'].toString(), []),
          ListTail('?????????', detail['vote_count'].toString(), []),
          // ListTail('home page', detail['homepage'].toString(), []),
        ],
      ),
    );
  }
}

class ListTail extends StatelessWidget {
  final String heading;
  final String text;
  final List<dynamic> list;

  ListTail(this.heading, this.text, this.list);

  Future _launchURL(argUrl) async {
    var url = argUrl;
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (text.length != 0 && heading != 'home page' && list.length == 0) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.blue.shade100,
              width: 0.3,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 1, 8),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    heading,
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(2)),
              Container(
                width: double.infinity,
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.blue.shade200,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (list.length > 0) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.blue.shade100,
              width: 0.3,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 1, 8),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    heading,
                    style: TextStyle(color: Colors.white, fontSize: 13),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(2)),
              Container(
                width: double.infinity,
                child: Text(
                  'haretu ',
                  style: TextStyle(color: Colors.blue.shade200, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (heading == 'home page') {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.blue.shade100,
              width: 0.3,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 1, 8),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    heading,
                    style: TextStyle(color: Colors.white, fontSize: 13),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(2)),
              Container(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    _launchURL(text);
                  },
                  child: Text(
                    text,
                    style: TextStyle(color: Colors.blue.shade200, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}

class _Tile extends StatelessWidget {
  _Tile(
    this.imgPath,
    this.id,
  );

  final String? imgPath;
  final int? id;

  @override
  Widget build(BuildContext context) {
    final TvDetailModel datas = context.watch();
    final imgUrl = imgPath != null
        ? 'https://image.tmdb.org/t/p/w500$imgPath'
        : 'https://image.tmdb.org/t/p/w500//qD45xHA35HdJDGOaA1AgDwiWEgO.jpg';

    return Container(
      child: GestureDetector(
        onTap: () {
          datas.update(id ?? 0);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(19.5),
          ),
          child: FadeInImage.assetNetwork(
            placeholder: 'images/logo_transparent.png',
            image: imgUrl,
            fit: BoxFit.contain,
            fadeInCurve: Curves.linear,
          ),
        ),
      ),
    );
  }
}

class _TileCast extends StatelessWidget {
  _TileCast(
    this.imgPath,
    this.id,
  );

  final String? imgPath;
  final int? id;

  @override
  Widget build(BuildContext context) {
    final CastDetailModel datas = context.watch();
    final imgUrl = imgPath != null
        ? 'https://image.tmdb.org/t/p/w185/$imgPath'
        : 'https://image.tmdb.org/t/p/w500/qD45xHA35HdJDGOaA1AgDwiWEgO.jpg';

    return Container(
      child: GestureDetector(
        onTap: () async {
          await datas.update(id ?? 0);
          Navigator.of(context) // NavigatorState ???????????????
              .push(
            MaterialPageRoute(
              // ?????????Route ??? _history ?????????
              builder: (context) => CastDetailPage(), // ???????????? Route ??????????????????????????????
            ), // push() ???????????????????????????????????????????????????????????????????????????????????????
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(19.5),
          ),
          child: FadeInImage.assetNetwork(
            placeholder: 'images/logo_transparent.png',
            image: imgUrl,
            fit: BoxFit.contain,
            fadeInCurve: Curves.ease,
            fadeInDuration: Duration(milliseconds: 100),
            fadeOutDuration: Duration(milliseconds: 100),
          ),
        ),
      ),
    );
  }
}
