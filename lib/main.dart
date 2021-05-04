import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knn_citra_digital/Pages/main_page.dart';
import 'package:package_info/package_info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return FutureBuilder(
      // Replace the 3 second delay with your initialization code:
      future: Future.delayed(Duration(seconds: 3)),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(debugShowCheckedModeBanner: false, home: Splash());
        } else {
          // Loading is done, return the app:
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: MainHomePage()),
          );
        }
      },
    );
  }
}

// ignore: must_be_immutable
class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String version = '';
  getInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    // String buildNumber = packageInfo.buildNumber;
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3,
                child: Image(
                    fit: BoxFit.cover,
                    image: AssetImage('lib/Assets/image/ic_launcher.png')),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'KLASIFIKASI',
                style: TextStyle(fontSize: 38.6, fontWeight: FontWeight.bold),
              ),
              Text(
                'JAMUR',
                style: TextStyle(fontSize: 66.6, fontWeight: FontWeight.bold),
              ),
              Text(
                'K-NEAREST NEIGHBORS',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 25,
              )
            ],
          )),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'versi ' + version + ' android',
                        style: TextStyle(fontSize: 14),
                      )),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
