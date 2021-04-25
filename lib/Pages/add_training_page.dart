import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knn_citra_digital/DbProviders/training_db_provider.dart';
import 'package:knn_citra_digital/Models/training_model.dart';
import 'package:palette_generator/palette_generator.dart';

class AddTrainingPage extends StatefulWidget {
  @override
  _AddTrainingPageState createState() => _AddTrainingPageState();
}

class _AddTrainingPageState extends State<AddTrainingPage> {
  TrainingDbProvider trainingDbProvider = TrainingDbProvider();

  //Color
  Color primaryColor = Color(0xFFa28eae);
  int r, g, b;
  String base64;
  bool isSwitched = false;
  Future<PaletteGenerator> _updatePaletteGenerator(image) async {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      Image.memory(image).image,
    );
    final face = paletteGenerator.dominantColor.color;
    setState(() {
      r = face.red;
      g = face.green;
      b = face.blue;
    });
    return paletteGenerator;
  }

  final snackBar = SnackBar(content: Text('MASUKAN GAMBAR'));

  addTraining() async {
    if (decoded != null) {
      await trainingDbProvider.addTraining(TrainingModel(
        state: (isSwitched) ? 1 : 0,
        r: r,
        g: g,
        b: b,
        base64: base64,
      ));
      AwesomeDialog(
        dismissOnTouchOutside: false,
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.SUCCES,
        title: 'SUCCES',
        desc: 'Tambah Data berhasil',
        btnOkOnPress: () {
          setState(() {
            decoded = null;
            isSwitched = false;
          });
        },
      )..show();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  File imageFile;
  Uint8List decoded;
  pickImage(source) async {
    PickedFile pickedFile = await ImagePicker().getImage(
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
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (croppedImage != null) {
      imageFile = croppedImage;
      List<int> imageBytes = croppedImage.readAsBytesSync();
      String imageB64 = base64Encode(imageBytes);
      decoded = base64Decode(imageB64);
      _updatePaletteGenerator(decoded);
      setState(() {
        base64 = imageB64;
      });
    } else {
      decoded = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TAMBAH DATA TRAINING'),
        backgroundColor: primaryColor,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 15),
        child: Center(
          child: Column(
            children: [
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
                          decoded,
                          fit: BoxFit.cover,
                        ))
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.of(context).size.width - 30,
                        height: MediaQuery.of(context).size.width - 30,
                        child: Icon(
                          Icons.add_a_photo_rounded,
                          size: 100,
                          color: Colors.grey[400],
                        ),
                      ),
              ),
              Row(
                children: [
                  Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                        });
                      },
                      activeTrackColor: primaryColor.withOpacity(0.2),
                      activeColor: Colors.purple[600]),
                  Text((isSwitched) ? 'BERACUN' : 'TIDAK BERACUN',
                      style: TextStyle(fontSize: 20)),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SecondaryButtton(
                  title: 'SIMPAN',
                  onPressed: () {
                    addTraining();
                  })
            ],
          ),
        ),
      ),
    );
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
