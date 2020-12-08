import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_finances/services/auth_service.dart';
import 'package:my_finances/views/sign_in_view.dart';
import 'package:my_finances/views/sign_up_view.dart';

//import 'package:provider/provider.dart';
import 'package:my_finances/views/home_widget.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_finances/views/first-view.dart';

import 'package:my_finances/widgets/provider_widget.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    // navigation bar color
    statusBarColor: Colors.transparent,
    // status bar color
    statusBarBrightness: Brightness.dark,
    //status bar brightness
    statusBarIconBrightness: Brightness.dark,
    //status barIcon Brightness
    systemNavigationBarIconBrightness: Brightness.light, //navigation bar icon
  ));
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(FirebaseAuth.instance),
      child: MaterialApp(
        title: "MyFinances",
        theme: ThemeData(
            backgroundColor: Colors.white,
            primarySwatch: Colors.pink,
            textTheme: Theme.of(context).textTheme.apply(
                  fontFamily: 'PoppinsBold',
                )),
        home: HomeController(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => Home(),
          '/signUp': (BuildContext context) => SignUp(),
          '/signIn': (BuildContext context) => SignIn(),
          '/firstView': (BuildContext context) => FirstView(),
        },
      ),
    );
  }
}


class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider
        .of(context)
        .auth;
    return StreamBuilder<User>(
      stream: auth.authStateChanges,
      builder: (context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          return signedIn ? Home() : FirstView();
        }
        return CircularProgressIndicator();
      },
    );
  }
}

