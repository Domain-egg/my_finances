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
  int _currentIndex = 1;
  final List<Widget> _children = [
    DeptsPage(),
    HomeView(),
    EntrysPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
              body: _children[_currentIndex],
              /*bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        selectedItemColor: Colors.purple,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.account_balance_rounded),
            // ignore: deprecated_member_use
            title: new Text("Schulden"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.home_rounded),
            // ignore: deprecated_member_use
            title: new Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.euro_rounded),
            // ignore: deprecated_member_use
            title: new Text("Einträge"),
          ),
        ],
      ),*/


    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
