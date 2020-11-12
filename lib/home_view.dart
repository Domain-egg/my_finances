import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_finances/lower_card.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Item 1'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: SafeArea(
              child: Row(
            children: <Widget>[
              Spacer(),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter a search term'),
                ),
              ),
              Spacer(),
            ],
          )),
          elevation: 0,
          backgroundColor: Colors.purple,
        ),
        body: Container(
            color: Colors.purple,
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
