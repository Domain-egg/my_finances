import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_finances/models/Entry.dart';
import 'package:my_finances/views/entry_info.dart';
import 'package:my_finances/views/entry_new.dart';
import 'package:my_finances/widgets/provider_widget.dart';

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
                        builder: (context) => NewEntryView(entry: newEntry)));
              },
            )
          ],
        ),
        Container(
          child: Expanded(
            child: StreamBuilder(
                stream: getUsersTripStreamSnapshots(context),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text("Loading...");
                  return new ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index) =>
                          buildEntryCard(
                              context, snapshot.data.documents[index]));
                }
            ),
          ),
        ),
      ],
    );
  }

  Stream<QuerySnapshot> getUsersTripStreamSnapshots(
      BuildContext context) async* {
    final uid = await Provider
        .of(context)
        .auth
        .getCurrentUID();
    yield* FirebaseFirestore.instance.collection('userData')
        .doc(uid)
        .collection("entrys")
        .snapshots();
  }


  Widget buildEntryCard(BuildContext context, DocumentSnapshot document) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () =>
          {
            showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0)),
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
                          "${document['money'] >= 0
                              ? "+"
                              : ""}${document['money'].toStringAsFixed(2)} €",
                          style: new TextStyle(
                            fontSize: 15.0,
                            color: document['money'] >= 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        document['reason'],
                        style: new TextStyle(
                          fontSize: 11.0,
                          color: Colors.grey[700],
                        ),
                      ),
                      Spacer(),
                    ],
                  ),

                  //Text(DateFormat('dd/MM/yyyy').format(entryList[index].date).toString()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
