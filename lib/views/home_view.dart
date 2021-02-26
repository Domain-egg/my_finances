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
 double _sum = 0;
  _HomeViewState() {
    sum().then((val) => setState(() {
      _sum = val;
    }));
  }



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
                          Text(
                            _sum == null ? "loading..." :"$_sum €",
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



Future<double> sum() async {
  final uid = FirebaseAuth.instance.currentUser.uid;
  final db = FirebaseFirestore.instance;
  var snapshot = await db
      .collection("userData")
      .doc(uid)
      .collection("entrys")
      .doc("sumEntry").get();

  if(snapshot.exists){
    return (await snapshot['sum']);
  }else{
    return (await 8686);
  }
}
}