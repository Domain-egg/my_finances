import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_finances/models/Friend.dart';
import 'package:my_finances/widgets/add_friend.dart';
import 'package:my_finances/widgets/provider_widget.dart';

/// This class creates a list of the added Friends
///
/// The list is made out of cards inside there is some relevant information.

//**Stateful Widget because things are changing**
class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AddFriend(
                          friend: new Friend(null, null, 0.00),
                        ));
              },
            )
          ],
        ),

        //**Builds List**
        Container(
          child: Expanded(
            child: StreamBuilder(
                stream: getUsersFriendStreamSnapshots(context),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text("Loading...");
                  return new ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index) =>
                          buildEntryCard(
                              context, snapshot.data.documents[index]));
                }),
          ),
        ),
      ],
    );
  }

  //**Gets Data specific for this User**
  Stream<QuerySnapshot> getUsersFriendStreamSnapshots(
      BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* FirebaseFirestore.instance
        .collection('userData')
        .doc(uid)
        .collection("friends")
        .snapshots();
  }

  //**build every individual Item**
  Widget buildEntryCard(BuildContext context, DocumentSnapshot document) {
    //**gets width and height of screen**
    final _width = MediaQuery.of(context).size.width;
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                        document['name'],
                        style: new TextStyle(fontSize: 15.0),
                      ),
                      Spacer(),
                      Text(
                        "${document['dept'] > 0 ? "+" : ""}  ${document['dept'].toStringAsFixed(2)} €",
                        style: new TextStyle(
                          fontSize: 15.0,
                          color:
                              document['dept'] >= 0 ? Colors.green : Colors.red,
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
                        document['uid'],
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
    );
  }
}
