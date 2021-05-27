import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:knn_citra_digital/DbProviders/list_training.dart';

class TrainingPage extends StatefulWidget {
  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  Color primaryColor = Color(0xFFa28eae);
  @override
  void initState() {
    super.initState();
    dataShuffle = shuffle(dataTraining);
  }

  List dataShuffle = [];

  List shuffle(List items) {
    var random = Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.cover,
    );
  }

  void onGoBack(dynamic value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('DATA TRAINING '),
            Text(dataShuffle.length.toString())
          ],
        ),
        backgroundColor: primaryColor,
      ),
      body: StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        itemCount: dataShuffle.length,
        itemBuilder: (BuildContext context, int index) => Card(
          child: Column(
            children: <Widget>[
              Image.memory(
                base64Decode(dataShuffle[index]['base64']),
                fit: BoxFit.cover,
              ),
              Text(
                  (dataShuffle[index]['state'] == 1)
                      ? 'BERACUN'
                      : 'TIDAK BERACUN',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      wordSpacing: 1.5)),
            ],
          ),
        ),
        staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
    );
  }
}
