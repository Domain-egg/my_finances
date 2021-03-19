import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_finances/widgets/custom_warning.dart';
import 'package:my_finances/widgets/provider_widget.dart';

/// This class creates a view for the user to sign-up
///
/// It creates different text-field's and buttons to sign-up
/// or to switch to the log-in page

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _primaryColor = const Color(0xFFE336AE);
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _repeatController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      //resizeToAvoidBottomInset: true,
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
          child: ListView(children: <Widget>[
            Padding(
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
                      obscureText: true,
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
                      obscureText: true,
                      controller: _repeatController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "Repeat",
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
                      onPressed: () async {
                        try {
                          //**Checks if E-Mail Address contains "@"**
                          if (!_emailController.text.contains("@")) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CustomWarning(
                                      description:
                                          'This is not a valid E-Mail address',
                                    ));
                            //**Checks if Password and RepeatPassword is the same **
                          } else if (_repeatController.text ==
                              _passwordController.text) {
                            //**Sign Up with InputData**
                            final auth = Provider.of(context).auth;

                            String signUp = await auth.signUp(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim());
                            print("$signUp");

                            if (signUp == "Signed up") {
                              Navigator.of(context)
                                  .pushReplacementNamed('/signIn');
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CustomWarning(
                                        description: signUp,
                                      ));
                            }
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CustomWarning(
                                      description:
                                          'Your password is not the same',
                                    ));
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
                  ),
                  SizedBox(height: _height * 0.0125),
                  //**Already an Account Button**
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
          ]),
        ),
      ),
    );
  }
}
