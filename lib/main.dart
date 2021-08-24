import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart'; //provider
import 'ui/color.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'entity/topModel.dart';

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
  @override
  Widget build(BuildContext context) {
    final TopModel hoge = context.watch<TopModel>();
    var movieList = hoge.movies;
    // print(hoge.movies);
    // print(movieList[1].backdropPath);
    return Container(
      height: double.infinity,
      child: ListView.builder(
        itemCount: movieList.length,
        itemBuilder: (BuildContext context, int index) {
          if (movieList[index].posterPath != null) {
            print('!null');
            print(movieList[index].posterPath);
          } else {
            print('null');
            print(movieList[index].posterPath);
          }
          if (movieList.length != 0) {
            return Container(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Image.network(
                      "https://image.tmdb.org/t/p/w154${movieList[index].posterPath}",
                      errorBuilder: (c, o, s) {
                        return const Icon(
                          Icons.error,
                          color: Colors.red,
                        );
                      },
                    ),
                    // Image.network(
                    //   "${movieList[index].posterPath}",
                    //   errorBuilder: (c, o, s) {
                    //     return const Icon(
                    //       Icons.error,
                    //       color: Colors.red,
                    //     );
                    //   },
                    // ),
                    Text('${movieList[index].id}'),
                    Text('${movieList[index].video}'),
                    Text('${movieList[index].voteCount}'),
                    Text('${movieList[index].voteAverage}'),
                    Text('${movieList[index].popularity}'),
                    Text('${movieList[index].posterPath}'),
                    Text('${movieList[index].originalLanguage}'),
                    Text('${movieList[index].originalTitle}'),
                    Text('${movieList[index].backdropPath}'),
                    Text('$index'),
                    Padding(padding: EdgeInsets.all(40))
                  ],
                ),
              ),
            );
          } else {
            return Container(
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.asset('images/logo.png'),
              ),
            );
          }
        },
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
