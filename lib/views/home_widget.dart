import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_finances/views/home_view.dart';
import 'package:my_finances/views/profile_view.dart';
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
    ProfileView(),
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
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
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
                  autofocus: false,
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
