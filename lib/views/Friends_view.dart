import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_finances/models/Friend.dart';
import 'package:my_finances/widgets/add_friend.dart';
import 'package:my_finances/widgets/provider_widget.dart';

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
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AddFriend(
                          friend: new Friend(null, null),
                        ));
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
  Stream<QuerySnapshot> getUsersEntryStreamSnapshots(
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
    final _height = MediaQuery.of(context).size.height;
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
                      Icon(
                        Icons.person_outline_rounded,
                        size: _height * 0.04,
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
