import 'package:auto_size_text/auto_size_text.dart';
import 'package:characters/characters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_finances/models/Friend.dart';
import 'package:my_finances/models/User.dart';
import 'package:my_finances/widgets/provider_widget.dart';

/// This class creates a list of the added Friends
///
/// The list is made out of cards inside there is some relevant information.

//**Stateful Widget because things are changing**
class AllUsers extends StatefulWidget {
  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  String _searchTerm;

  @override
  void initState() {
    super.initState();
    _searchTerm = "";
  }

  setSearch(String val) {
    setState(() {
      _searchTerm = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchBarController =
        new TextEditingController();
    _searchBarController.text = _searchTerm;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.90,
            //**SearchBar**
            child: TextField(
              controller: _searchBarController,
              onSubmitted: (value) {
                setSearch(value);
              },
              autofocus: false,
              decoration: new InputDecoration(
                prefixIcon: Icon(Icons.search_rounded),
                contentPadding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.00,
                ),
                filled: true,
                fillColor: new Color.fromRGBO(255, 255, 255, 0.45),
                focusColor: Colors.black,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(50),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(50),
                ),
                hintText: 'Search',
              ),
            ),
          ),
        ),
        //**Builds List**
        Container(
          child: Expanded(
            child: StreamBuilder(
                stream: getUsersFriendStreamSnapshots(context, _searchTerm),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text("Loading...");
                  return new ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index) =>
                          buildUserCard(
                              context, snapshot.data.documents[index]));
                }),
          ),
        ),
      ],
    );
  }

  //**Gets Data specific for this User**
  Stream<QuerySnapshot> getUsersFriendStreamSnapshots(
      BuildContext context, String searchText) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* FirebaseFirestore.instance
        .collection('userData')
        .orderBy("username", descending: false)
        .startAt([searchText]).endAt([searchText + '\uf8ff']).snapshots();
  }

  //**build every individual Item**
  Widget buildUserCard(BuildContext context, DocumentSnapshot document) {
    return new Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          color: Color(0xFFF2F2F2),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(
                    6.0,
                  ),
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            document['username'],
                            style: new TextStyle(fontSize: 15.0),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                //width: _width * 0.87,
                                child: AutoSizeText(
                                  "${document['uid'].toString().characters.take(6).toString()}...",
                                  maxLines: 1,
                                  style: new TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      new FriendRequestButton(
                        fId: document["uid"],
                        fName: document["username"],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FriendRequestButton extends StatefulWidget {
  final String fId;
  final String fName;
  FriendRequestButton({
    Key key,
    @required this.fId, @required this.fName,
  }) : super(key: key);

  @override
  _FriendRequestButtonState createState() => _FriendRequestButtonState();
}

class _FriendRequestButtonState extends State<FriendRequestButton> {
  final _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: getUsersSendFriendReqStreamSnapshots(context, widget.fId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text("Loading...");
          return buildFriendReqButton(context, snapshot.data);
        });
  }

  Widget buildFriendReqButton(BuildContext context, DocumentSnapshot document) {
    if (!document.exists) {
      return FlatButton(
          color: Colors.lightBlueAccent,
          child: Text("Add Friend"),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          onPressed: () async {
            final uid = await Provider.of(context).auth.getCurrentUID();
            await _db
                .collection("userData")
                .doc(uid)
                .collection("friendReq")
                .doc(widget.fId)
                .set({"request_type": "sent"});

            await _db
                .collection("userData")
                .doc(widget.fId)
                .collection("friendReq")
                .doc(uid)
                .set({"request_type": "received"});
          });
    }
    try {
      final String _currentState =
          document.data()["request_type"].toString() == "sent"
              ? "Cancel Request"
              : "Accept";

      return new FlatButton(
          color: Colors.lightBlueAccent,
          child: Text(_currentState),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          onPressed: () async {
            if (_currentState == "Cancel Request") {
                final uid = await Provider.of(context).auth.getCurrentUID();
                await _db
                    .collection("userData")
                    .doc(uid)
                    .collection("friendReq")
                    .doc(widget.fId)
                    .delete();

                await _db
                    .collection("userData")
                    .doc(widget.fId)
                    .collection("friendReq")
                    .doc(uid)
                    .delete();
              }
            if (_currentState == "Accept") {
              final uid = await Provider.of(context).auth.getCurrentUID();
              Friend friend = new Friend(null, null, 0);
              friend.name = widget.fName;
              friend.uid = widget.fId;


                //**Entry gets saved in Firebase**
                await _db
                    .collection("userData")
                    .doc(uid)
                    .collection("friends")
                    .doc(widget.fId)
                    .set(friend.toJson());
              final auth = Provider.of(context).auth;
              UserModel user = await auth.getUserFromDB(uid: uid);
              friend.name = user.username;
              friend.uid = uid;

              await _db
                  .collection("userData")
                  .doc(widget.fId)
                  .collection("friends")
                  .doc(uid)
                  .set(friend.toJson());
            }
          });
    } catch (e) {
      return new FlatButton(
          color: Colors.lightBlueAccent,
          child: Text("Add Friend"),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          onPressed: () async {
            final uid = await Provider.of(context).auth.getCurrentUID();
            await _db
                .collection("userData")
                .doc(uid)
                .collection("friendReq")
                .doc(widget.fId)
                .set({"request_type": "sent"});

            await _db
                .collection("userData")
                .doc(widget.fId)
                .collection("friendReq")
                .doc(uid)
                .set({"request_type": "received"});
          });
    }
  }
}

Stream<DocumentSnapshot> getUsersSendFriendReqStreamSnapshots(
    BuildContext context, String fId) async* {
  final uid = await Provider.of(context).auth.getCurrentUID();
  yield* FirebaseFirestore.instance
      .collection('userData')
      .doc(uid)
      .collection("friendReq")
      .doc(fId)
      .snapshots();
}
