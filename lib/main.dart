import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart'; //provider
import 'ui/color.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'entity/api_request.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(MyApp());
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
    return ChangeNotifierProvider<MovieModel>(
      create: (_) => MovieModel(),
      child: DefaultTabController(
        length: 3,
        child: new Scaffold(
          body: new NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
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
                      new Tab(text: "MovieModel"),
                      new Tab(text: "TV"),
                    ],
                  ),
                ),
              ];
            },
            body: new TabBarView(
              children: <Widget>[
                TopPage(),
                MovieModelPage(),
                TvPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MovieModel>(
      builder: (context, model, child) {
        // print(model.movies[1].posterPath);
        print(model.update());

        return Container(
          height: double.infinity,
          child: ListView.builder(
            itemCount: model.movies.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Image.network(
                          'http://image.tmdb.org/t/p/w154${model.movies[index].posterPath}'),
                      Text('${model.movies[index].title}'),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class MovieModelPage extends StatelessWidget {
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
