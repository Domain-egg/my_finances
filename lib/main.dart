import 'package:flutter/material.dart';
import 'home_widget.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
    statusBarBrightness: Brightness.dark,//status bar brigtness
    statusBarIconBrightness:Brightness.dark , //status barIcon Brightness
    systemNavigationBarIconBrightness: Brightness.light, //navigation bar icon
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {



    return MaterialApp(
      title: "MyFinances",
      theme: ThemeData(
          backgroundColor: Colors.white,
          primarySwatch: Colors.pink,
          textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'PoppinsBold',
              )
      ),
      home: Home(),
    );
  }
}

