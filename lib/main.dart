import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart'; //provider
import 'ui/color.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'entity/topModel.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TopModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
    context.read<TopModel>().update();
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
                  tabs: <Tab>[
                    new Tab(text: "HOME"),
                    new Tab(text: "TopModel"),
                    new Tab(text: "TV"),
                  ],
                ),
              ),
            ];
          },
          body: Consumer<TopModel>(builder: (context, model, child) {
            return RefreshIndicator(
              onRefresh: () async => model.update(),
              child: new TabBarView(
                children: <Widget>[
                  TopPage(),
                  TopModelPage(),
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

class TopPage extends StatelessWidget {
  static const List<StaggeredTile> _tiles = [
    StaggeredTile.count(3, 4),
    StaggeredTile.count(3, 4),
    StaggeredTile.count(2, 3),
    StaggeredTile.count(2, 3),
    StaggeredTile.count(2, 3),
  ];
  @override
  Widget build(BuildContext context) {
    final TopModel hoge = context.watch<TopModel>();
    var movieList = hoge.movies;
    // print(hoge.movies);
    // print(movieList[1].backdropPath);
    return Container(
      color: Colors.black87,
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 6,
        mainAxisSpacing: 6.0,
        crossAxisSpacing: 6.0,
        itemCount: movieList.length,
        itemBuilder: (BuildContext context, int index) {
          return _Tile(movieList[index].posterPath);
        },
        staggeredTileBuilder: (int index) {
          int _tileIndex = index % _tiles.length;
          return _tiles[_tileIndex];
        },
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  _Tile(this.imgPath);

  final String? imgPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(19.5)),
        child: Image.network('https://image.tmdb.org/t/p/w154$imgPath',
            fit: BoxFit.fitWidth),
      ),
    );
  }
}

class TopModelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('MoviePage'),
    );
  }
}

class TvPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('TvPage'),
    );
  }
}


  // Image.network(
  //   "https://image.tmdb.org/t/p/w154${movieList[index].posterPath}",
  //   errorBuilder: (c, o, s) {
  //     return const Icon(
  //       Icons.error,
  //       color: Colors.red,
  //     );
  //   },
  // ),
  // Text('${movieList[index].id}'),
  // Text('${movieList[index].video}'),
  // Text('${movieList[index].voteCount}'),
  // Text('${movieList[index].voteAverage}'),
  // Text('${movieList[index].popularity}'),
  // Text('${movieList[index].posterPath}'),
  // Text('${movieList[index].originalLanguage}'),
  // Text('${movieList[index].originalTitle}'),
  // Text('${movieList[index].backdropPath}'),
  // Text('$index'),