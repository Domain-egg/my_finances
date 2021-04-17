import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_finances/main.dart';
import 'package:my_finances/widgets/custom_warning.dart';
import 'package:my_finances/widgets/provider_widget.dart';
import 'package:page_transition/page_transition.dart';

/// This class creates a view for the user to log-in
///
/// It creates different text-field's and buttons to log-in
/// or to switch to the sign-up page

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with TickerProviderStateMixin {
  final _primaryColor = const Color(0xFFE336AE);

  AnimationController rippleController;
  AnimationController scaleController;

  Animation<double> rippleAnimation;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    rippleController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    scaleController = AnimationController(
        vsync: this, duration: Duration(seconds: 1))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: MyApp()));
        }
      });

    rippleAnimation =
        Tween<double>(begin: 10.0, end: 70.0).animate(rippleController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              rippleController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              rippleController.forward();
            }
          });

    scaleAnimation =
        Tween<double>(begin: 1.0, end: 30.0).animate(scaleController);

    rippleController.forward();
  }

  //**creates TextControllers**
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          width: _width,
          height: _height,
          child: SafeArea(
            child: SingleChildScrollView(
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
                    Container(
                      height: 100,
                      child: AnimatedBuilder(
                        animation: rippleAnimation,
                        builder: (context, child) => Container(
                          width: rippleAnimation.value,
                          height: rippleAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _primaryColor.withOpacity(.4)),
                            child: InkWell(
                              onTap: () async {
                                //**LogIn with Input**
                                try {
                                  final auth = Provider.of(context).auth;

                                  String login = await auth.signIn(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim());
                                  print("Signed In with ID $login");
                                  if (login == "Signed in") {
                                    scaleController.forward();
                                    //Navigator.push(context, PageTransition(type: PageTransitionType.fade,child: HomeView()));
                                    //Navigator.of(context).pushReplacementNamed('/home');
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CustomWarning(
                                              description: login,
                                            ));
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: AnimatedBuilder(
                                animation: scaleAnimation,
                                builder: (context, child) => Transform.scale(
                                  scale: scaleAnimation.value,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _primaryColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
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
        ),
      ),
    );
  }
}
