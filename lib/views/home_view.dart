import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_finances/views/lower_card.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
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
                          UserSum(),
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

class UserSum extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser.uid;
    Stream documentStream = FirebaseFirestore.instance
        .collection("userData")
        .doc(uid)
        .collection("sums")
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: documentStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return new Text(
            "0.00 €",
            style: new TextStyle(
              color: Colors.white,
              fontSize: 40,
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading...");
        }

        return new Column(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            String _sumE = document.data()['sumE'].toStringAsFixed(2);
            //String _sumD = document.data()['sumD'].toStringAsFixed(2);

            return Column(
              children: [
                new Text(
                  "$_sumE €",
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),

                //**for later versions***//

                /*new Text(
                  "$_sumD €",
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),*/
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
