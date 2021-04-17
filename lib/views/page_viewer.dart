import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_finances/views/Friends_view.dart';
import 'package:my_finances/views/all_users_view.dart';
import 'package:my_finances/views/home_view.dart';
import 'package:my_finances/views/profile_view.dart';

/// This class creates a viewer of the different pages.
///
/// It shows the different views and makes a background
/// and other gui elements like the menu-drawer.

class ViewPages extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ViewPagesState();
  }
}

class _ViewPagesState extends State<ViewPages> {
  int _currentIndex = 0;

  //**List of Pages for Menu**
  final List<Widget> _children = [
    HomeView(),
    ProfileView(),
    Friends(),
    AllUsers()
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      //**Background**
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        //**Menu on top-right**
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              //**Header of menu**
              DrawerHeader(
                child: AutoSizeText(
                  'MyFinances',
                  maxLines: 1,
                  style: TextStyle(fontSize: 24),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              //**Menu Items**
              //**Home**
              ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.home_rounded),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Text('Home'),
                    ],
                  ),
                  onTap: () {
                    onTabTapped(0);
                    Navigator.pop(context);
                  }),
              //**Profile**
              ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.account_circle_rounded),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Text('Profile'),
                    ],
                  ),
                  onTap: () {
                    onTabTapped(1);
                    Navigator.pop(context);
                  }),
              //**Friends**
              ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.person_add_alt_1_rounded),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Text('Friends'),
                    ],
                  ),
                  onTap: () {
                    onTabTapped(2);
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.person_add_alt_1_rounded),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Text('AllUsers'),
                    ],
                  ),
                  onTap: () {
                    onTabTapped(3);
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: _children[_currentIndex],
      ),
    );
  }

  //**changes Page**
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}