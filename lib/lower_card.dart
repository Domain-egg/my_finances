import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_finances/entrys_view.dart';

class LowerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    topLeft: Radius.circular(50)),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 45.0),
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width,
                    child: DefaultTabController(
                        length: 2,
                        child: new Scaffold(
                          appBar: new TabBar(
                            tabs: [
                              Text(
                                "Schulden",
                                style:
                                new TextStyle(color: Colors.black),
                              ),
                              Text(
                                "Einträge",
                                style:
                                new TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          body: TabBarView(
                            children: [
                              EntryView(),
                              EntryView(),
                            ],
                          ),
                        ))),
              ),
            );
  }
}
