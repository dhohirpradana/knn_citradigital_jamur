import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:knn_citra_digital/DbProviders/training_db_provider.dart';
import 'package:knn_citra_digital/Pages/add_training_page.dart';

class TrainingPage extends StatefulWidget {
  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  Color primaryColor = Color(0xFFa28eae);
  @override
  void initState() {
    super.initState();
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
    TrainingDbProvider trainingDb = TrainingDbProvider();
    return Scaffold(
      appBar: AppBar(
        title: Text('DATA TRAINING'),
        backgroundColor: primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddTrainingPage()))
              .then((onGoBack));
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.add),
      ),
      body: Container(
          margin: EdgeInsets.only(top: 10, bottom: 10),
          child: FutureBuilder(
              future: trainingDb.fetchTraining(),
              initialData: [],
              builder: (context, snapshot) {
                return (snapshot.hasData)
                    ? NotificationListener<OverscrollIndicatorNotification>(
                        // ignore: missing_return
                        onNotification: (notification) {
                          // disable scroll glow effect
                          notification.disallowGlow();
                        },
                        child: GridView.builder(
                            itemCount: snapshot.data.length,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20),
                            itemBuilder: (_, int index) {
                              final data = snapshot.data[index];
                              return Container(
                                  child: Column(children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  height:
                                      MediaQuery.of(context).size.width / 3.7,
                                  child: GestureDetector(
                                      onTap: () async {
                                        await showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                                    child: Stack(children: [
                                                  imageFromBase64String(
                                                      data.base64),
                                                  IconButton(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      onPressed: () {
                                                        AwesomeDialog(
                                                          dismissOnTouchOutside:
                                                              false,
                                                          context: context,
                                                          dialogType: DialogType
                                                              .WARNING,
                                                          animType: AnimType
                                                              .BOTTOMSLIDE,
                                                          title: 'HAPUS',
                                                          desc:
                                                              'Ada ingin menghapus data Training ini?',
                                                          btnCancelOnPress:
                                                              () {},
                                                          btnOkOnPress: () {
                                                            setState(() {
                                                              trainingDb
                                                                  .deleteTraining(
                                                                      data.id);
                                                            });
                                                            AwesomeDialog(
                                                              dismissOnTouchOutside:
                                                                  false,
                                                              context: context,
                                                              animType: AnimType
                                                                  .SCALE,
                                                              dialogType:
                                                                  DialogType
                                                                      .SUCCES,
                                                              title: 'SUCCES',
                                                              desc:
                                                                  'Hapus data berhasil',
                                                              btnOkOnPress: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            )..show();
                                                          },
                                                        )..show();
                                                      },
                                                      icon: Icon(
                                                          Icons.delete_forever,
                                                          size: 28,
                                                          color: Colors.red))
                                                ])));
                                      },
                                      child:
                                          imageFromBase64String(data.base64)),
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Text(
                                    (data.state == 1)
                                        ? 'BERACUN'
                                        : 'TIDAK BERACUN',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        wordSpacing: 1.5))
                              ]));
                            }))
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              })),
    );
  }
}
