import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knn_citra_digital/DbProviders/list_training_v2.dart';
import 'package:knn_citra_digital/Utils/text_status.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getPref();
  }

  //Color
  Color primaryColor = Color(0xFFa28eae);

  GlobalKey _toolTipKey = GlobalKey();
  GlobalKey _toolTipKey1 = GlobalKey();

  void getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      k = preferences.getInt("k") ?? 25;
    });
  }

  int k = 5;
  List selisihList = [];
  int sum = 0;
  Color color = Colors.white;

  //Extract RGB data from image
  //Count Different Based On RGB Domination Color
  Future<PaletteGenerator> _updatePaletteGenerator(image) async {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      Image.memory(image).image,
    );
    final face = paletteGenerator.dominantColor!.color;
    double percent;
    selisihList.clear();
    for (int i = 0; i < dataTrainingReborn.length; i++) {
      final hsl = HSLColor.fromColor(face);
      final hsli = HSLColor.fromColor(Color.fromRGBO(
        dataTrainingReborn[i]['r'],
        dataTrainingReborn[i]['g'],
        dataTrainingReborn[i]['b'],
        1,
      ));

      final sr = ((hsli.hue - hsl.hue).abs()) / 360;
      final sg = ((hsli.saturation - hsl.saturation).abs());
      final sb = ((hsli.lightness - hsl.lightness).abs());
      percent = sqrt((sr * sr) + (sg * sg) + (sb * sb));
      selisihList.add({
        'state': dataTrainingReborn[i]['state'],
        'percent': percent,
        'r': dataTrainingReborn[i]['r'],
        'g': dataTrainingReborn[i]['g'],
        'b': dataTrainingReborn[i]['b']
      });

      //sort data selisih list
      selisihList.sort((a, b) {
        var apercent = a['percent'];
        var bpercent = b['percent'];
        return apercent.compareTo(bpercent);
      });
    }

    //SUM List Value
    sum = 0;
    for (var i = 0; i < k; i++) {
      sum = sum + selisihList[i]['state'] as int;
    }
    return paletteGenerator;
  }

  File? imageFile;
  Uint8List? decoded;
  pickImage(source) async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: source,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      cropImage(pickedFile.path);
    }
  }

  /// Crop Image
  cropImage(filePath) async {
    File? croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (croppedImage != null) {
      imageFile = croppedImage;
      List<int> imageBytes = croppedImage.readAsBytesSync();
      String imageB64 = base64Encode(imageBytes);
      setState(() {
        decoded = base64Decode(imageB64);
      });
    } else {
      decoded = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text('KLASIFIKASI JAMUR'),
              Column(
                children: [
                  Container(
                    height: 40,
                    child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage('lib/Assets/image/jamur.png')),
                  ),
                  SizedBox(
                    height: 15,
                  )
                ],
              ),
            ],
          ),
          backgroundColor: primaryColor,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: (decoded != null)
                      ? Container(
                          padding: EdgeInsets.only(bottom: 15),
                          height: MediaQuery.of(context).size.height / 2,
                          width: MediaQuery.of(context).size.width / 1.07,
                          child: Image.memory(
                            decoded!,
                            fit: BoxFit.cover,
                          ))
                      : Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)),
                          width: MediaQuery.of(context).size.width - 30,
                          height: MediaQuery.of(context).size.height / 1.3,
                          child: Icon(
                            Icons.add_a_photo_rounded,
                            size: 100,
                            color: Colors.grey[400],
                          ),
                        ),
                ),
                (decoded != null)
                    ? FutureBuilder<PaletteGenerator>(
                        future: _updatePaletteGenerator(decoded), // async work
                        builder: (BuildContext context,
                            AsyncSnapshot<PaletteGenerator> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Center(
                                  child: Column(
                                children: [
                                  SizedBox(
                                    child: CircularProgressIndicator(),
                                    width: 60,
                                    height: 60,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: Text('Menunggu hasil...'),
                                  ),
                                ],
                              ));
                            default:
                              if (snapshot.hasError)
                                return new Text('Error: ${snapshot.error}');
                              else {
                                var f = NumberFormat("##.####", "id_INA");
                                return Stack(
                                  children: [
                                    Column(children: [
                                      GestureDetector(
                                        onLongPress: () {
                                          final dynamic tooltip =
                                              _toolTipKey1.currentState;
                                          tooltip.ensureTooltipVisible();
                                        },
                                        child: Tooltip(
                                          key: _toolTipKey1,
                                          message: 'Status',
                                          child: Text(
                                            ((k - sum) > sum)
                                                ? 'TIDAK BERACUN'
                                                : 'BERACUN',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text('R: '),
                                            Text(snapshot
                                                .data!.dominantColor!.color.red
                                                .toString()),
                                            Text(' G: '),
                                            Text(snapshot.data!.dominantColor!
                                                .color.green
                                                .toString()),
                                            Text(' B: '),
                                            Text(snapshot
                                                .data!.dominantColor!.color.blue
                                                .toString()),
                                          ],
                                        ),
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Column(children: [
                                                  Text("K"),
                                                  for (var i = 0; i < k; i++)
                                                    Text(
                                                      (i + 1).toString(),
                                                    )
                                                ])),
                                            Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Column(children: [
                                                  Text("R"),
                                                  for (var i = 0; i < k; i++)
                                                    Text(f.format(
                                                        selisihList[i]['r']))
                                                ])),
                                            Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Column(children: [
                                                  Text("G"),
                                                  for (var i = 0; i < k; i++)
                                                    Text(f.format(
                                                        selisihList[i]['g']))
                                                ])),
                                            Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Column(children: [
                                                  Text("B"),
                                                  for (var i = 0; i < k; i++)
                                                    Text(f.format(
                                                        selisihList[i]['b']))
                                                ])),
                                            Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Column(children: [
                                                  Text("Jarak"),
                                                  for (var i = 0; i < k; i++)
                                                    Text(f.format(selisihList[i]
                                                        ['percent']))
                                                ])),
                                            Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Column(children: [
                                                  Text("Status"),
                                                  for (var i = 0; i < k; i++)
                                                    statusText(selisihList[i]
                                                        ['state']),
                                                ])),
                                          ]),
                                    ]),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: GestureDetector(
                                        onLongPress: () {
                                          final dynamic tooltip =
                                              _toolTipKey.currentState;
                                          tooltip.ensureTooltipVisible();
                                        },
                                        child: Tooltip(
                                          key: _toolTipKey,
                                          message: 'SUM State / K',
                                          child: Container(
                                              padding: EdgeInsets.all(5),
                                              margin: EdgeInsets.only(right: 5),
                                              decoration: BoxDecoration(
                                                  color: Colors.yellow[100],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Text((k - sum) < sum
                                                  ? sum.toString() +
                                                      '/' +
                                                      k.toString()
                                                  : (k - sum).toString() +
                                                      '/' +
                                                      k.toString())),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }
                          }
                        })
                    : Container(),
              ],
            ),
          ),
        ));
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Galeri'),
                      onTap: () {
                        pickImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Kamera'),
                    onTap: () {
                      pickImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
