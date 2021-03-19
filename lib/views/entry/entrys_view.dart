import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:my_finances/models/Entry.dart';
import 'package:my_finances/services/GroupSeparator.dart';
import 'package:my_finances/views/entry/entry_info.dart';
import 'package:my_finances/views/entry/entry_new.dart';
import 'package:my_finances/widgets/provider_widget.dart';

/// This class creates a list of all entry's.
///
/// The list is made out of cards that contain data from the database.
/// The data gets changed in realtime.

//**Stateful Widget because things are changing**
class EntryView extends StatefulWidget {
  @override
  _EntryViewState createState() => _EntryViewState();
}

class _EntryViewState extends State<EntryView> {
  @override
  Widget build(BuildContext context) {
    final newEntry = new Entry(null, null, null, null);
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
                        builder: (context) => NewEntryView(
                          entry: newEntry,
                          id: null,
                        )));
              },
            )
          ],
        ),

        //**Builds List**
        Container(
          child: Expanded(
            child: StreamBuilder(
                stream: getUsersEntryStreamSnapshots(context),
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
                        buildEntryCard(context, snapshot.data.documents[index]),
                    order: GroupedListOrder.DESC,
                  );
                }),
          ),
        ),
      ],
    );
  }

  //**Gets Data specific for this User**
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

  //**build every individual Item**
  Widget buildEntryCard(BuildContext context, DocumentSnapshot document) {
    //**gets width and height of screen**
    final _width = MediaQuery.of(context).size.width;

    return Container(
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
                  return EntryInfo(
                    entry: document,
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
                          document['title'],
                          style: new TextStyle(fontSize: 15.0),
                        ),
                        Spacer(),
                        Text(
                          "${document['money'] > 0 ? "+" : ""}${document['money'].toStringAsFixed(2)} €",
                          style: new TextStyle(
                            fontSize: 15.0,
                            color: document['money'] > 0
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
                          document['reason'],
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