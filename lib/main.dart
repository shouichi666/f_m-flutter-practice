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
    print(hoge.movies);
    return Container(
      height: double.infinity,
      child: ListView.builder(
        // itemCount: model.movies.length,
        itemCount: hoge.movies.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Image.network(
                    "${hoge.movies[index].posterPath}",
                    errorBuilder: (c, o, s) {
                      return const Icon(
                        Icons.error,
                        color: Colors.red,
                      );
                    },
                  ),
                  Text('${hoge.movies[index].id}'),
                  Text('${hoge.movies[index].video}'),
                  Text('${hoge.movies[index].voteCount}'),
                  Text('${hoge.movies[index].voteAverage}'),
                  Text('${hoge.movies[index].popularity}'),
                  Text('${hoge.movies[index].posterPath}'),
                  Text('${hoge.movies[index].originalLanguage}'),
                  Text('${hoge.movies[index].originalTitle}'),
                  Text('${hoge.movies[index].backdropPath}'),
                  Text('$index'),
                  Padding(padding: EdgeInsets.all(40))
                ],
              ),
            ),
          );
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
