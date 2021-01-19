import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_finances/widgets/custom_warning.dart';
import 'package:my_finances/widgets/provider_widget.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _primaryColor = const Color(0xFFE336AE);

  //**creates TextControllers**
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                  //**Email TextField**
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
                  //**Password TextField**
                  child: TextField(
                    obscureText: true,
                    controller: _passwordController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "Password",
                      //hintMaxLines: 1,
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
                //**Login Button**
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
                        "Login",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        maxLines: 1,
                      ),
                    ),
                    onPressed: () async {
                      //**LogIn with Input**
                      try {
                        final auth = Provider.of(context).auth;

                        String login = await auth.signIn(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim());
                        print("Signed In with ID $login");
                        if (login == "Signed in") {
                          Navigator.of(context).pushReplacementNamed('/home');
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => CustomWarning(
                                    description: login,
                                  ));
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ),
                SizedBox(height: _height * 0.0125),
                //**Create Account Button**
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: AutoSizeText(
                    "Create Account",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade300,
                        decoration: TextDecoration.underline),
                    maxLines: 1,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/signUp');
                  },
                ),
                //**Forgot Password Button**
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: AutoSizeText(
                    "Forgot Password?",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade300,
                        decoration: TextDecoration.underline),
                    maxLines: 1,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
