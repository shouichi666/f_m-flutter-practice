import 'package:flutter/material.dart';
import '../entity/TvDetailModel.dart';
import 'package:provider/provider.dart';

class TvDetailPage extends StatelessWidget {
  TvDetailPage(this.id);
  final int id;
  @override
  Widget build(BuildContext context) {
    final TvDetailModel datas = context.watch();
    print(datas);
    datas.addId(id);
    if (datas.detail.length <= 0) {
      datas.update();
    }
    print(datas.detail);
    print(datas.getId);
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Container(
        child: Text(id.toString()),
      ),
    );
  }
}
// class TvDetailPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     print(context);
//     return ChangeNotifierProvider<TvDetailModel>(
//       create: (_) => TvDetailModel(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(""),
//         ),
//         body: Consumer<TvDetailModel>(
//           builder: (context, model, child) {
//             print(model);
//             return Container(
//               color: Colors.cyan,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
