import 'package:flutter/material.dart';
import 'package:knn_citra_digital/Pages/training_page.dart';
import 'package:knn_citra_digital/Pages/training_page2.dart';

class MainTraining extends StatelessWidget {
  const MainTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Color(0xFFa28eae);
    return Scaffold(
        appBar: AppBar(
          title: Text('DATA TRAINING JAMUR BERACUN'),
          backgroundColor: primaryColor,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xFFa28eae))),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TrainingPage()));
                    },
                    child: Text('JAMUR KONSUMSI')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xFFa28eae))),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TrainingPage2()));
                    },
                    child: Text(' JAMUR BERACUN ')),
              ],
            )
          ],
        ));
  }
}
