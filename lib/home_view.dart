import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_finances/lower_card.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Container(
            color: Colors.transparent,
            child: Column(
              children: [
                Spacer(),
                Center(
                  child: Text(
                    "500.00€",
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                ),
                Spacer(),
                LowerCard(),
              ],
            )));
  }
}
