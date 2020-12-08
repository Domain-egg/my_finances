import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_finances/services/auth_service.dart';
import 'package:my_finances/views/sign_in_view.dart';
import 'package:my_finances/views/sign_up_view.dart';
import 'package:provider/provider.dart';
import 'views/home_widget.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_finances/views/first-view.dart';

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
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        StreamProvider(
            create: (context) => context.read<AuthService>().authStateChanges)
      ],
      child: MaterialApp(
        title: "MyFinances",
        theme: ThemeData(
            backgroundColor: Colors.white,
            primarySwatch: Colors.pink,
            textTheme: Theme.of(context).textTheme.apply(
                  fontFamily: 'PoppinsBold',
                )),
        home: AuthenticationWrapper(),
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

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return Home();
    }
    return SignIn();
  }
}
