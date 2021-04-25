import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:knn_citra_digital/Utils/text_form_fiels.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetelanPage extends StatefulWidget {
  @override
  _SetelanPageState createState() => _SetelanPageState();
}

class _SetelanPageState extends State<SetelanPage> {
  final _formKey = GlobalKey<FormState>();
  Color primaryColor = Color(0xFFa28eae);
  @override
  void initState() {
    super.initState();
  }

  void setPref(k) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('k', int.parse(k));
    FocusScope.of(context).unfocus();
    kC.clear();
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      animType: AnimType.SCALE,
      dialogType: DialogType.SUCCES,
      title: 'SUCCES',
      desc: 'SET nilai K berhasil',
      btnOkOnPress: () {},
    )..show();
  }

  TextEditingController kC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SETELAN'),
          backgroundColor: primaryColor,
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                child: textFormField(kC, 'SET nilai K', TextInputType.number),
              ),
              SizedBox(
                height: 20,
              ),
              SecondaryButtton(
                  title: 'SIMPAN',
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      setPref(kC.text);
                    }
                  })
            ],
          ),
        ));
  }
}
