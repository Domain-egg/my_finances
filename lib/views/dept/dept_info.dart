import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_finances/models/Dept.dart';
import 'package:my_finances/views/dept/dept_new.dart';
import 'package:my_finances/widgets/provider_widget.dart';

/// This class is here so the User can see more information's about there dept.
///
/// The user can see more information's but can also change the data or delete it.

class DeptInfo extends StatelessWidget {
  final DocumentSnapshot dept;

  DeptInfo({Key key, @required this.dept}) : super(key: key);

  Widget build(BuildContext context) {
    //**gets width and height of screen**
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    final db = FirebaseFirestore.instance;

    Dept editDept = new Dept(
        dept.data()['friend'],
        dept.data()['fId'],
        dept.data()['date'].toDate(),
        dept.data()['money'],
        dept.data()['reason'],
        dept.data()['status']);

    //**returns a decorated container with the dept info**
    return new Container(
      height: MediaQuery.of(context).size.height * 0.60,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              )
            ]),
        width: _width,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.cancel_rounded, color: Colors.red, size: 25),
                  onPressed: () {
                    //**closes the popup**
                    Navigator.of(context).pop();
                    FocusManager.instance.primaryFocus.unfocus();
                  },
                ),
                Spacer(),
                Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, size: 25),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewDeptView(
                                          dept: editDept,
                                          id: dept.id,
                                        )));
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.share_rounded, size: 25),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_forever_rounded, size: 25),
                          onPressed: () async {
                            final uid =
                                await Provider.of(context).auth.getCurrentUID();


                            var snapshot = await db
                                .collection("userData")
                                .doc(uid)
                                .collection("sumsD")
                                .doc("sumDepts")
                                .get();

                            double sum = 0;

                            if (snapshot.exists) {
                              sum = double.parse(snapshot['sumD'].toString());
                            }

                            await db
                                .collection("userData")
                                .doc(uid)
                                .collection("sumsD")
                                .doc("sumDepts")
                                .set({
                              'sumD': sum - dept['money'] ,
                            });


                            await db
                                .collection("userData")
                                .doc(uid)
                                .collection("depts")
                                .doc(dept.id)
                                .delete();

                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: _width * 0.8,
              child: Row(
                children: [
                  //**Description**
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: _height * 0.03,
                      ),
                      AutoSizeText(
                        'Title:',
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: _height * 0.01,
                      ),
                      AutoSizeText(
                        "Money:",
                        style: new TextStyle(fontSize: 20),
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: _height * 0.01,
                      ),
                      AutoSizeText(
                        "Status:",
                        style: new TextStyle(fontSize: 20),
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: _height * 0.01,
                      ),
                      AutoSizeText(
                        "Date:",
                        maxLines: 1,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: _height * 0.01,
                      ),
                      AutoSizeText(
                        "Reason:",
                        maxLines: 1,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Spacer(),
                  //**Info**
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: _height * 0.03,
                      ),
                      AutoSizeText(
                        dept.data()['friend'],
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: _height * 0.01,
                      ),
                      AutoSizeText(
                        "${dept.data()['money'] >= 0 ? "+" : ""}${dept.data()['money'].toStringAsFixed(2)} €",
                        style: new TextStyle(
                            color: dept.data()['money'] >= 0
                                ? Colors.green
                                : Colors.red,
                            fontSize: 20),
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: _height * 0.01,
                      ),
                      AutoSizeText(
                        dept.data()['status'],
                        style: new TextStyle(fontSize: 20),
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: _height * 0.01,
                      ),
                      AutoSizeText(
                        DateFormat('dd.MM.yyyy')
                            .format(dept.data()['date'].toDate())
                            .toString(),
                        maxLines: 1,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: _height * 0.01,
                      ),
                      Container(
                          width: _width * 0.50,
                          child: AutoSizeText(
                            dept.data()['reason'],
                            maxLines: 3,
                            style: TextStyle(fontSize: 18),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
