import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:my_finances/models/Dept.dart';
import 'package:my_finances/services/GroupSeparator.dart';
import 'package:my_finances/views/dept/dept_info.dart';
import 'package:my_finances/views/dept/dept_new.dart';
import 'package:my_finances/widgets/provider_widget.dart';

/// This class makes new dept's.
///
/// It checks if the user wants to modify an existing dept or create a new one.
/// It creates a form-like page where the user can input his data,
/// then it sends the data to the database.

class FriendDepts extends StatefulWidget {
  @override
  final String fId;
  final String fName;
  FriendDepts({Key key, @required this.fId, @required this.fName})
      : super(key: key);
  _FriendDeptsState createState() => _FriendDeptsState();
}

class _FriendDeptsState extends State<FriendDepts> {

  @override
  Widget build(BuildContext context) {
    final newDept = new Dept(null, null, null, null, null, null);
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
            children: <Widget>[
              AutoSizeText(widget.fName,maxLines: 1, style: TextStyle(color: Colors.black, fontSize: 20),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewDeptView(
                                dept: newDept,
                                id: null,
                              )));
                    },
                  )
                ],
              ),

              //**Builds List**
              Container(
                child: Expanded(
                  child: new StreamBuilder(
                      stream: getUsersFriendsStreamSnapshots(context),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const Text("Loading...");
                        return GroupedListView<dynamic, DateTime>(
                          elements: snapshot.data.documents,
                          groupBy: (element) => DateTime.parse(DateFormat('yyyyMMdd')
                              .format(element['date'].toDate()) +
                              "T000000"),
                          groupSeparatorBuilder: (DateTime date) => GroupSeparator(
                            date: date,
                          ),
                          indexedItemBuilder: (BuildContext context, dynamic,
                              int index) =>
                              buildDeptCard(context, snapshot.data.documents[index]),
                          order: GroupedListOrder.DESC,
                        );
                      }),
                ),
              ),
            ],
      ),
          ),
        ),
    );
  }

  //**Gets Data specific for this User**
  Stream<QuerySnapshot> getUsersFriendsStreamSnapshots(
      BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* FirebaseFirestore.instance
        .collection('userData')
        .doc(uid)
        .collection("depts")
        .where("friend", isEqualTo: widget.fName)
        .snapshots();
  }

  //**build every individual Item**
  Widget buildDeptCard(BuildContext context, DocumentSnapshot document) {
    //**gets width and height of screen**
    final _width = MediaQuery.of(context).size.width;

    return new Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => {
            //**shows more Info onTap**
            showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(25.0)),
                ),
                context: context,
                builder: (BuildContext bc) {
                  return DeptInfo(
                    dept: document,
                  );
                })
          },
          child: ClipPath(
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))
                )
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  border: Border(
                      right: BorderSide(color: document.data()['status'] == "paid"
                          ? Colors.green
                          : Colors.red,
                          width: 10.0)
                  )
              ),

              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 2.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            document.data()['friend'].toString(),
                            style: new TextStyle(fontSize: 15.0),
                          ),
                          Spacer(),
                          Text(
                            "${document.data()['money'] > 0 ? "+" : ""}${document.data()['money'].toStringAsFixed(2)} €",
                            style: new TextStyle(
                              fontSize: 15.0,
                              color: document.data()['money'] > 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: _width * 0.7,
                          child: AutoSizeText(
                            document.data()['reason'],
                            maxLines: 1,
                            style: new TextStyle(
                              fontSize: 11.0,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
