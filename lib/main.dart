import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:lms/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import './ui/Login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    builder: (context, _) {
      final themeProvider = Provider.of<ThemeProvider>(context);
      return MaterialApp(
          themeMode: themeProvider.themeMode,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          debugShowCheckedModeBanner: false,
          title: 'LMS',
          home: Scaffold(
            body: Splash(),
          )
      );
    },
  );
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState(){
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: 3);
    return Timer(duration, route);
  }

  route(){
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(20),
              child: Image(
                image: AssetImage('assets/mitwpu.png'),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}

