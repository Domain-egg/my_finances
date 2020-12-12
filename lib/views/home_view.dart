import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_finances/views/lower_card.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Container(
            color: Colors.transparent,
            child: CustomScrollView(
              slivers: <Widget>[
                //**Creates resizable header**
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  expandedHeight: 400,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(),
                        Text(
                          "500.00€",
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
                //**creates Items below header**
                SliverFixedExtentList(
                  itemExtent: 500,
                  delegate: SliverChildListDelegate([
                    LowerCard(),
                  ]),
                )
              ],
            )));
  }
}
