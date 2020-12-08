import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_finances/services/auth_service.dart';
import 'package:provider/provider.dart';

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
          AutoSizeText(
            FirebaseAuth.instance.currentUser.email,
            maxLines: 1,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          SizedBox(height: _height * 0.1),
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
              onPressed: () {
                context.read<AuthService>().signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}
