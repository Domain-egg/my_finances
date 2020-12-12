import 'package:auto_size_text/auto_size_text.dart';
import 'package:clipboard/clipboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_finances/services/auth_service.dart';
import 'package:my_finances/widgets/provider_widget.dart';

//**Shows Info about User**
class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Container(
      width: _width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: _height * 0.05),
          Image(
            image: AssetImage("assets/images/user.png"),
            height: _height * 0.15,
          ),
          SizedBox(height: _height * 0.1),
          //**Shows email**
          AutoSizeText(
            FirebaseAuth.instance.currentUser.email,
            maxLines: 1,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          SizedBox(height: _height * 0.05),
          AutoSizeText(
            "UID:",
            maxLines: 1,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          SizedBox(height: _height * 0.025),
          //**Shows UID**
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                FirebaseAuth.instance.currentUser.uid,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: Icon(Icons.copy_rounded),
                color: Colors.white,
                onPressed: () {
                  //**Copy UID**
                  FlutterClipboard.copy(FirebaseAuth.instance.currentUser.uid)
                      .then((value) => print('copied'));
                },
              ),
            ],
          ),
          SizedBox(height: _height * 0.1),
          //**PasswordReset Button**
          ButtonTheme(
            minWidth: _width * 0.4,
            child: RaisedButton(
              color: Color(0xFFE336AE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                  "Reset Password",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  maxLines: 1,
                ),
              ),
              onPressed: () {},
            ),
          ),
          SizedBox(height: _height * 0.1),
          //**LogOut Button**
          ButtonTheme(
            minWidth: _width * 0.4,
            child: RaisedButton(
              color: Colors.red.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                  "Sign out",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  maxLines: 1,
                ),
              ),
              onPressed: () async {
                //**logs User out**
                try {
                  AuthService auth = Provider.of(context).auth;
                  await auth.signOut();
                  Navigator.of(context).pushReplacementNamed('/firstView');
                } catch (e) {
                  print(e);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
