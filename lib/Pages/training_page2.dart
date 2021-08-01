import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TrainingPage2 extends StatefulWidget {
  @override
  _TrainingPageState2 createState() => _TrainingPageState2();
}

class _TrainingPageState2 extends State<TrainingPage2> {
  Color primaryColor = Color(0xFFa28eae);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('DATA TRAINING JAMUR BERACUN'), Text('26')],
        ),
        backgroundColor: primaryColor,
      ),
      body: StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        itemCount: 26,
        itemBuilder: (BuildContext context, int index) {
          final i = index + 1;
          return Card(
            child:
                // Column(
                //   children: <Widget>[
                Image.asset('./lib/Assets/image/1/b$i.jpg'),
            // ),
            //     Text(
            //         (dataTraining_reborn[index]['state'] == 1)
            //             ? 'BERACUN'
            //             : 'TIDAK BERACUN',
            //         style: TextStyle(
            //             fontSize: 18,
            //             fontWeight: FontWeight.w500,
            //             wordSpacing: 1.5)),
            // ],
            // ),
          );
        },
        staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
    );
  }
}
