import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_finances/views/entrys_view.dart';
import 'package:my_finances/views/lower_card.dart';
import 'package:my_finances/widgets/provider_widget.dart';

class HomeView extends StatefulWidget {

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  Widget build(BuildContext context) {
    double sum = null;

    Stream<QuerySnapshot> getUsersEntryStreamSnapshots(
        BuildContext context) async* {
      final uid = await Provider.of(context).auth.getCurrentUID();
      yield* FirebaseFirestore.instance
          .collection('userData')
          .doc(uid)
          .collection("entrys")
          .orderBy('date', descending: true)
          .snapshots();
    }
    
    print(getUsersEntryStreamSnapshots(context).forEach((element) {print(element);}));

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Container(
            color: Colors.transparent,
            child: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: CustomScrollView(
                physics: ClampingScrollPhysics(),
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
                            sum == null ? "loading..." :"$sum €",
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
              ),
            )));
  }
}
