import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_finances/home_view.dart';
import 'package:my_finances/pages.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeView(),
    DeptsPage(),
    EntrysPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        endDrawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('SimpleFinances'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
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
                  }),
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
                  }),
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
                  }),
            ],
          ),
        ),
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Spacer(),
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextField(
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width *
                          0.03, // HERE THE IMPORTANT PART
                    ),
                    icon: Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: new Color.fromRGBO(255, 255, 255, 0.45),
                    focusColor: Colors.black,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    hintText: 'Search',
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: _children[_currentIndex],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
