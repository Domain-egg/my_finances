import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_finances/services/auth_service.dart';
import 'package:my_finances/views/first-view.dart';
import 'package:my_finances/views/page_viewer.dart';
import 'package:my_finances/views/sign_in_view.dart';
import 'package:my_finances/views/sign_up_view.dart';
import 'package:my_finances/widgets/provider_widget.dart';

/// This class runs the start of the app.
///
/// It checks if the user is already logged in
/// and shows the right page. It manages all the routes.

void main() async {
  //**sets StatusBar Color to transparent**
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  //**initializes Firebase**
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
        //**sets Theme**
        theme: ThemeData(
            backgroundColor: Colors.white,
            primarySwatch: Colors.pink,
            textTheme: Theme.of(context).textTheme.apply(
                  fontFamily: 'PoppinsBold',
                )),
        home: HomeController(),
        //**creates Routes**
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => ViewPages(),
          '/signUp': (BuildContext context) => SignUp(),
          '/signIn': (BuildContext context) => SignIn(),
          '/firstView': (BuildContext context) => FirstView(),
        },
      ),
    );
  }
}

//**checks if USer is Signed In and sends him to the correct page
class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder<User>(
      stream: auth.authStateChanges,
      builder: (context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          return signedIn ? ViewPages() : FirstView();
        }
        return CircularProgressIndicator();
      },
    );
  }
}
