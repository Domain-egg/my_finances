import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_finances/widgets/custom_dialog.dart';

/// The class creates a Screen that you see when you open the App first time or after logout.
///
/// The screen contains a welcome massage and two options for the user,
/// to get started (create a new account) or log in

class FirstView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //**gets width and height of screen**
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        width: _width,
        height: _height,
        //**SafeArea makes a padding around the notch**
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: _height * 0.10),
                AutoSizeText(
                  "Hello",
                  style: TextStyle(fontSize: 44, color: Colors.white),
                ),
                SizedBox(height: _height * 0.10),
                AutoSizeText(
                  "Let's start managing your finances!",
                  style: TextStyle(fontSize: 40, color: Colors.white),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: _height * 0.15),
                RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Get Started",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w100),
                    ),
                  ),
                  onPressed: () {
                    //**shows custom Dialog**
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => CustomDialog(
                              title: 'Would you like to crate a account?',
                              description:
                                  'With an account, your data will be securely saved.',
                              primaryButtonText: 'Create My Account',
                              primaryButtonRoute: '/signUp',
                            ));
                  },
                ),
                SizedBox(height: _height * 0.05),
                //**LogIn Button**
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w100,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/signIn');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
