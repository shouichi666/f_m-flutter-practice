import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:movie/ui/color.dart';
import '../entity/SearchModel.dart';
// import '../entity/CastDetailModel.dart';
// import 'Cast_detail.dart';
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
    final SearchModel model = Provider.of<SearchModel>(context, listen: false);

    super.initState();
    _nameController = TextEditingController(text: model.keyword);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SearchModel model = Provider.of<SearchModel>(context, listen: false);
    print(model.keyword);

    return new Scaffold(
      body: new NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              title: Text('Search'),
              floating: true,
              pinned: true,
              snap: true,
              centerTitle: false,
              bottom: AppBar(
                automaticallyImplyLeading: false,
                title: Container(
                  width: double.infinity,
                  height: 40,
                  color: Colors.white,
                  child: Center(
                    child: TextField(
                      controller: _nameController,
                      onChanged: (text) => model.onSeach(text),
                      decoration: InputDecoration(
                        hintText: 'Search for something',
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: TextButton(
                            onPressed: () {
                              model.onDeleteKeyword();
                              _nameController.clear();
                            },
                            child: Icon(Icons.close)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Container(child: Text('defdgnoi')),
      ),
    );
  }
}
