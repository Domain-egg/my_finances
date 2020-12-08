import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  final _primaryColor = const Color(0xFFE336AE);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    TextEditingController _emailController = new TextEditingController();
    TextEditingController _passwordController = new TextEditingController();

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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: _height * 0.10),
                Image(
                  image: AssetImage("assets/images/user.png"),
                  height: _height * 0.25,
                ),
                SizedBox(height: _height * 0.05),
                Container(
                  width: _width * 0.8,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintMaxLines: 1,
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(50.0),
                        ),
                      ),
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: _height * 0.025),
                Container(
                  width: _width * 0.8,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _passwordController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintMaxLines: 1,
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(50.0),
                        ),
                      ),
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: _height * 0.025),
                Container(
                  width: _width * 0.8,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _passwordController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintMaxLines: 1,
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(50.0),
                        ),
                      ),
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: _height * 0.025),
                ButtonTheme(
                  minWidth: _width * 0.4,
                  child: RaisedButton(
                    color: _primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        "Sign up",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        maxLines: 1,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
                SizedBox(height: _height * 0.0125),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: AutoSizeText(
                    "Already an account?",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade300,
                        decoration: TextDecoration.underline),
                    maxLines: 1,
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
