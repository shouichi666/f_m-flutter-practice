import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:movie/ui/color.dart';
import '../entity/SearchModel.dart';
// import '../entity/CastDetailModel.dart';
// import 'Cast_detail.dart';
import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../ui/tab.dart';

class SearchList extends StatelessWidget {
  Widget _item(String? ttl, int? id, String? imgPath) {
    final _ttl = ttl;
    final _id = id;
    final _imgPath = imgPath != null
        ? 'https://image.tmdb.org/t/p/w500$imgPath'
        : 'https://image.tmdb.org/t/p/w500/qD45xHA35HdJDGOaA1AgDwiWEgO.jpg';

    print(_ttl);
    print(_id);
    print(_imgPath);

    return ListTile(
      title: Text(_ttl ?? ''),
      // subtitle: Text(_ttl ?? ''),
      leading: FadeInImage.assetNetwork(
        placeholder: 'images/logo_transparent.png',
        image: _imgPath,
        fadeInCurve: Curves.ease,
        fadeInDuration: Duration(milliseconds: 100),
        fadeOutDuration: Duration(milliseconds: 100),
      ),
      onTap: () => {},
      trailing: Icon(Icons.more_vert),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SearchModel model = context.watch();
    return new Scaffold(
      body: new NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              title: Text(model.keyword),
              floating: true,
              pinned: true,
              snap: true,
              centerTitle: false,
            )
          ];
        },
        body: Container(
          child: ListView.builder(
            itemCount: model.getMulti.length,
            itemBuilder: (BuildContext context, int index) {
              final name = model.getMulti[index].name;
              final id = model.getMulti[index].id;
              final poster = model.getMulti[index].posterPath;
              return _item(name, id, poster);
            },
          ),
        ),
      ),
    );
  }
}
