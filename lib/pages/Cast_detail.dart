import 'package:flutter/material.dart';
import 'package:movie/entity/MovieDetailModel.dart';
import 'package:movie/entity/TvDetailModel.dart';
import 'package:movie/pages/Tv_detail.dart';
// import 'package:movie/ui/color.dart';
import '../entity/CastDetailModel.dart';
import '../entity/MovieDetailModel.dart';
// import '../entity/TvDetailModel.dart';
import 'movie_detail.dart';
// import 'tv_detail.dart';
import 'package:provider/provider.dart';

class CastDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CastDetailModel cast = context.watch();
    final detail = cast.detail;
    final height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: new Scaffold(
        body: new NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                toolbarHeight: 60,
                expandedHeight: height / 2,
                floating: true,
                pinned: true,
                snap: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: EdgeInsets.only(bottom: 50),
                  title: Text(detail['name'] ?? 'no name'),
                  background: Stack(
                    children: [
                      Container(
                        width: double.infinity,
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
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Image.network(
                              'https://image.tmdb.org/t/p/w500${detail["profile_path"]}',
                              fit: BoxFit.cover),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter,
                                colors: [
                              Colors.grey.withOpacity(0),
                              Colors.grey.withOpacity(0),
                              Colors.grey.withOpacity(0),
                              Colors.grey.withOpacity(0),
                              Colors.black,
                            ])),
                      )
                    ],
                  ),
                ),
                bottom: TabBar(
                  labelColor: Colors.amber[400],
                  unselectedLabelColor: Colors.white,
                  indicatorColor: Colors.amber[400],
                  indicatorWeight: 5,
                  tabs: <Tab>[
                    new Tab(text: "MOVIE"),
                    new Tab(text: "TV"),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [_MovieGridList(cast.movie), _TvGridList(cast.tv)],
          ),
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home),
        //       label: Text('Home'),
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.settings),
        //       label: Text('Setting'),
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.search),
        //       label: Text('Search'),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}

class _MovieGridList extends StatelessWidget {
  _MovieGridList(this.movie);
  final List<dynamic> movie;

  @override
  Widget build(BuildContext context) {
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
      padding: EdgeInsets.all(0),
      child: GridView.builder(
        itemCount: movie.length - 1,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
        ),
        itemBuilder: (BuildContext context, int index) {
          print(index);
          return _panel(movie[index].posterPath, movie[index].id, context);
        },
      ),
    );
  }

  Widget _panel(String? path, int id, BuildContext context) {
    final img = path ?? "/qD45xHA35HdJDGOaA1AgDwiWEgO.jpg";
    final netwarkImage = "https://image.tmdb.org/t/p/w500" + img;
    final MovieDetailModel model = context.watch();
    return GestureDetector(
      onTap: () async {
        await model.update(id);
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(10.5),
          ),
          child: FadeInImage.assetNetwork(
            placeholder: 'images/logo_transparent.png',
            image: netwarkImage,
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

class _TvGridList extends StatelessWidget {
  _TvGridList(this.tv);
  final List<dynamic> tv;

  @override
  Widget build(BuildContext context) {
    print(tv.length);
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
      padding: EdgeInsets.all(0),
      child: GridView.builder(
          itemCount: tv.length - 1,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 3,
          ),
          itemBuilder: (BuildContext context, int index) {
            print(index);
            return _panel(tv[index].posterPath, tv[index].id, context);
          }),
    );
  }

  Widget _panel(String? path, int id, BuildContext context) {
    final img = path ?? "/qD45xHA35HdJDGOaA1AgDwiWEgO.jpg";
    final netwarkImage = "https://image.tmdb.org/t/p/w500" + img;
    final TvDetailModel model = context.watch();
    return GestureDetector(
      onTap: () async {
        await model.update(id);
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => TvDetailPage()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(10.5),
          ),
          child: FadeInImage.assetNetwork(
            placeholder: 'images/logo_transparent.png',
            image: netwarkImage,
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
