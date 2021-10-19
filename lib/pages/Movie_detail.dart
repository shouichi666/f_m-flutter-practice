import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movie/ui/color.dart';
import '../entity/MovieDetailModel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../ui/tab.dart';

class MovieDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MovieDetailModel datas = context.watch();
    final detail = datas.detail;
    // datas.update();
    print('------- id -------');
    if (datas.isFetching && datas.cast.length > 0 && datas.smiler.length > 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text(detail['title'] ?? 'loading'),
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
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500' +
                              detail['backdrop_path'],
                          height: 200,
                          width: double.infinity,
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
                    detail['title'] ?? 'title',
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
                  height: 620,
                  child: TabUI(key: GlobalKey(), tabs: [
                    Center(
                      child: Text(
                        '関連',
                        style: TextStyle(color: Colors.blue.shade200),
                      ),
                    ),
                    Center(
                      child: Text(
                        '詳細',
                        style: TextStyle(color: Colors.blue.shade200),
                      ),
                    ),
                  ], children: <Widget>[
                    Container(
                      child: Column(
                        children: [SmilerSlider(), _CastTile()],
                      ),
                    ),
                    Container(
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
    final MovieDetailModel datas = context.watch();
    final smiler = datas.smiler;
    print(smiler.length);

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
                  '類似の作品',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          CarouselSlider.builder(
            itemCount: smiler.length, //今だけ
            itemBuilder: (context, index, realIdx) {
              final int first = index * 2;
              final int second = first + 1;
              if (smiler.length > 0) {
                return Row(
                  children: [first, second].map((e) {
                    return Expanded(
                      flex: 1,
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
              enableInfiniteScroll: true,
              initialPage: 1,
              autoPlay: false,
              viewportFraction: 0.5,
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
  //     aryDate[4] = '年';
  //     aryDate[7] = '月';
  //     aryDate.add('日');
  //     return aryDate;
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          ListTail('ジャンル', 'テテキスト', detail['genres']),
          ListTail('公開日', detail['release_date'], []),
          ListTail('上映時間', detail['runtime'].toString() + '分', []),
          ListTail('オリジナルタイトル', detail['original_title'], []),
          ListTail('評価', detail['vote_average'].toString(), []),
          ListTail('評価数', detail['vote_count'].toString(), []),
          ListTail('home page', detail['homepage'].toString(), []),
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
    final MovieDetailModel datas = context.watch();
    final imgUrl = imgPath != null
        ? 'https://image.tmdb.org/t/p/w500$imgPath'
        : 'https://image.tmdb.org/t/p/w500//qD45xHA35HdJDGOaA1AgDwiWEgO.jpg';

    return Container(
      child: GestureDetector(
        // onTap: () => datas.update(id ?? 0, 'updata'), 8
        onTap: () {
          datas.update(id ?? 0);
          Navigator.of(context) // NavigatorState を取得して
              .push(
            MaterialPageRoute(
              // 新しいRoute を _history に追加
              builder: (context) =>
                  MovieDetailPage(), // 追加した Route は詳細画面を構築する
            ), // push() の中ではアニメーションしながら詳細画面を表示する処理を実行
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(19.5),
          ),
          child: Image.network(imgUrl.toString(), fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class _CastTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 5.0,
      padding: EdgeInsets.all(10.0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Container(
          child: Text("One"),
          color: Colors.blue[50],
        ),
        Container(
          child: Text("Two"),
          color: Colors.red[50],
        ),
        // Container(
        //   child: Text("Three"),
        //   color: Colors.green[50],
        // ),
        // Container(
        //   child: Text("Four"),
        //   color: Colors.yellow[50],
        // ),
      ],
    );
  }
}
