import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_finances/views/dept/dept_view.dart';

import 'file:///C:/Users/alexd/Desktop/my_finances/lib/views/entry/entrys_view.dart';

class LowerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50), topLeft: Radius.circular(50)),
      ),
      color: Colors.white,
      child: Column(
        children: [
          //**DragIcon**
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.remove_rounded,
                size: 60.00,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                //**Creates two Tabs**
                child: DefaultTabController(
                    length: 2,
                    child: new Scaffold(
                      resizeToAvoidBottomInset: false,
                      appBar: new TabBar(
                        tabs: [
                          Text(
                            "Entrys",
                            style: new TextStyle(color: Colors.black),
                          ),
                          Text(
                            "Depts",
                            style: new TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      //**what is inside the Tabs**
                      body: TabBarView(
                        children: [
                          EntryView(),
                          DeptView(),
                        ],
                      ),
                    ))),
          ),
        ],
      ),
    );
  }
}
