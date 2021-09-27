import 'package:flutter/material.dart';
import 'package:movie/ui/color.dart';
import '../entity/MovieDetailModel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../ui/tab.dart';

class TvDetailPage extends StatelessWidget {
  TvDetailPage(this.id);
  final int id;
  @override
  Widget build(BuildContext context) {
    final MovieDetailModel datas = context.watch();
    final detail = datas.detail;
    datas.addId(id);
    if (detail['id'] != id) {
      datas.update();
    }
    // datas.update();
    print(detail);
    if (datas.isFetching) {
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
                    detail['title'],
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
                    detail['overview'].length > 0
                        ? detail['overview']
                        : 'Sorry Non Overview',
                    style: TextStyle(
                        color: Colors.blueGrey.shade100, fontSize: 12),
                  ),
                ),
                // Text(id.toString(), style: TextStyle(color: Colors.white)),
                Padding(padding: EdgeInsets.all(10)),
                SizedBox(
                  width: double.infinity,
                  height: 700,
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
                        children: [
                          Row(
                            children: [
                              Text(
                                '関連コンテンツ',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
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
