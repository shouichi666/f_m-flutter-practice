import 'package:flutter/material.dart';
// import 'package:movie/pages/Search_list.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:movie/ui/color.dart';
import '../entity/SearchModel.dart';
import '../entity/TvDetailModel.dart';
import '../entity/CastDetailModel.dart';
import '../entity/MovieDetailModel.dart';
import 'Tv_detail.dart';
import 'Movie_detail.dart';
import 'Cast_detail.dart';
import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../ui/tab.dart';

class Search extends StatefulWidget {
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  late TextEditingController _nameController;

  @override
  void initState() {
    // final SearchModel model = Provider.of<SearchModel>(context, listen: true);
    super.initState();
    _nameController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    final SearchModel model = Provider.of<SearchModel>(context, listen: true);
    final list = model.getMulti;
    final _adult = model.adult;

    return new Scaffold(
      body: new NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              leading: TextButton(
                  onPressed: () {
                    model.onDeleteKeyword();
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              title: Container(
                padding: EdgeInsets.all(0),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text('Search')),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: SwitchListTile(
                          value: _adult,
                          activeColor: Colors.blue.shade100,
                          activeTrackColor: Colors.blue.shade400,
                          onChanged: (bool value) {
                            model.toggleAdult();
                          }),
                    ),
                  ],
                ),
              ),
              floating: true,
              pinned: true,
              snap: true,
              centerTitle: false,
              bottom: AppBar(
                automaticallyImplyLeading: false,
                title: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 40,
                      // color: Colors.black87,
                      child: Center(
                        child: TextField(
                          controller: _nameController,
                          onChanged: (text) => model.onSeach(text),
                          decoration: InputDecoration(
                            hintText: 'Search for something',
                            prefixIcon: Icon(Icons.search, color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white, width: 0.5)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1)),
                            suffixIcon: TextButton(
                                onPressed: () {
                                  model.onDeleteKeyword();
                                  _nameController.clear();
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Container(
          padding: EdgeInsets.all(0),
          child: ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: list.length > 1 ? list.length : 0,
            itemBuilder: (BuildContext content, int index) {
              final name = model.getMulti[index].name;
              final type = model.getMulti[index].mediaType;
              final id = model.getMulti[index].id;
              final poster = model.getMulti[index].posterPath;
              final person = model.getMulti[index].profilePath;

              // print(model.getMulti.length);

              // var now = 1;
              // print('------------------------------------');
              // print(model.getMulti.length - 1 == index);
              // print(model.getMulti.length - 1);

              if (model.getMulti.length - 1 == index) {
                var page = model.getMulti.length / 20 + 1;

                if (model.totalPage >= page) {
                  model.addPage(_nameController.text, page.toInt());
                  if (type == 'tv') {
                    return _itemTv(name, type, id, poster);
                  } else if (type == 'person') {
                    return _itemPerson(name, type, id, person);
                  } else {
                    return _itemMv(name, type, id, poster);
                  }
                } else {
                  if (type == 'tv') {
                    return _itemTv(name, type, id, poster);
                  } else if (type == 'person') {
                    return _itemPerson(name, type, id, person);
                  } else {
                    return _itemMv(name, type, id, poster);
                  }
                }
              } else {
                if (type == 'tv') {
                  return _itemTv(name, type, id, poster);
                } else if (type == 'person') {
                  return _itemPerson(name, type, id, person);
                } else {
                  return _itemMv(name, type, id, poster);
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _itemTv(String? ttl, String? type, int? id, String? imgPath) {
    final TvDetailModel tv = context.watch();
    final _ttl = ttl;
    // final _id = id;
    final _imgPath = imgPath != ''
        ? 'https://image.tmdb.org/t/p/w500$imgPath'
        : 'https://image.tmdb.org/t/p/w500/qD45xHA35HdJDGOaA1AgDwiWEgO.jpg';

    // print(_ttl);
    // print(_id);
    // print(_imgPath);

    return ListTile(
      title: Text(_ttl ?? ''),
      leading: FadeInImage.assetNetwork(
        placeholder: 'images/logo_transparent.png',
        image: _imgPath,
        fit: BoxFit.contain,
        fadeInCurve: Curves.ease,
        fadeInDuration: Duration(milliseconds: 100),
        fadeOutDuration: Duration(milliseconds: 100),
      ),
      onTap: () async {
        await tv.update(id ?? 0);
        await Navigator.of(context) // NavigatorState を取得して
            .push(
          MaterialPageRoute(
            // 新しいRoute を _history に追加
            builder: (context) => TvDetailPage(), // 追加した Route は詳細画面を構築する
          ), // push() の中ではアニメーションしながら詳細画面を表示する処理を実行=
        );
      },
      trailing: Icon(Icons.tv_sharp),
    );
  }

  Widget _itemMv(String? ttl, String? type, int? id, String? imgPath) {
    final MovieDetailModel movie = context.watch();

    final _ttl = ttl;
    // final _id = id;
    final _imgPath = imgPath != ''
        ? 'https://image.tmdb.org/t/p/w500$imgPath'
        : 'https://image.tmdb.org/t/p/w500/qD45xHA35HdJDGOaA1AgDwiWEgO.jpg';

    // print(_imgPath);

    return ListTile(
      title: Text(_ttl ?? ''),
      leading: FadeInImage.assetNetwork(
        placeholder: 'images/logo_transparent.png',
        image: _imgPath,
        fit: BoxFit.contain,
        fadeInCurve: Curves.ease,
        fadeInDuration: Duration(milliseconds: 100),
        fadeOutDuration: Duration(milliseconds: 100),
      ),
      onTap: () async {
        await movie.update(id ?? 0);
        await Navigator.of(context) // NavigatorState を取得して
            .push(
          MaterialPageRoute(
            // 新しいRoute を _history に追加
            builder: (context) => MovieDetailPage(), // 追加した Route は詳細画面を構築する
          ), // push() の中ではアニメーションしながら詳細画面を表示する処理を実行=
        );
      },
      trailing: Icon(Icons.movie),
    );
  }

  Widget _itemPerson(String? ttl, String? type, int? id, String? imgPath) {
    final CastDetailModel cast = context.watch();

    final _ttl = ttl;
    // final _id = id;
    final _imgPath = imgPath != ''
        ? 'https://image.tmdb.org/t/p/w500$imgPath'
        : 'https://image.tmdb.org/t/p/w500/qD45xHA35HdJDGOaA1AgDwiWEgO.jpg';

    // print(_imgPath);

    return ListTile(
      title: Text(_ttl ?? ''),
      leading: FadeInImage.assetNetwork(
        placeholder: 'images/logo_transparent.png',
        image: _imgPath,
        fit: BoxFit.contain,
        fadeInCurve: Curves.ease,
        fadeInDuration: Duration(milliseconds: 100),
        fadeOutDuration: Duration(milliseconds: 100),
      ),
      onTap: () async {
        await cast.update(id ?? 0);
        await Navigator.of(context) // NavigatorState を取得して
            .push(
          MaterialPageRoute(
            // 新しいRoute を _history に追加
            builder: (context1) => CastDetailPage(), // 追加した Route は詳細画面を構築する
          ), // push() の中ではアニメーションしながら詳細画面を表示する処理を実行=
        );
      },
      trailing: Icon(Icons.person),
    );
  }
}
