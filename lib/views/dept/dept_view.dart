import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:my_finances/models/Dept.dart';
import 'package:my_finances/services/GroupSeperator.dart';
import 'package:my_finances/views/dept/dept_info.dart';
import 'package:my_finances/views/dept/dept_new.dart';
import 'package:my_finances/widgets/provider_widget.dart';

//**Stateful Widget because things are changing**
class DeptView extends StatefulWidget {
  @override
  _DeptViewState createState() => _DeptViewState();
}

class _DeptViewState extends State<DeptView> {
  @override
  Widget build(BuildContext context) {
    final newDept = new Dept(null, null, null, null, null);
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
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
        .orderBy('date', descending: true)
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
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            color: Color(0xFFF2F2F2),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
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
                    children: <Widget>[
                      Container(
                        width: _width * 0.87,
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
    );
  }
}
