import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_finances/models/Friend.dart';
import 'package:my_finances/widgets/provider_widget.dart';

class AddFriend extends StatelessWidget {
  static const double _padding = 20.0;
  final db = FirebaseFirestore.instance;
  final Friend friend;

  AddFriend({Key key, @required this.friend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //**Creating all TextControllers**
    TextEditingController _nameController = new TextEditingController();
    TextEditingController _UIDController = new TextEditingController();
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    //**Creates Dialog**
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_padding),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(_padding),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(_padding),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  )
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: _height * 0.025),
                //**Title Text**
                AutoSizeText(
                  "Add Friend",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(height: _height * 0.025),
                //**Name TextField**
                Container(
                  width: _width * 0.7,
                  height: _height * 0.05,
                  child: TextField(
                    controller: _nameController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "Name",
                      //hintMaxLines: 1,
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(50.0),
                        ),
                      ),
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: _height * 0.025),
                //**UID TextField**
                Container(
                  width: _width * 0.7,
                  height: _height * 0.05,
                  child: TextField(
                    controller: _UIDController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "UID",
                      //hintMaxLines: 1,
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(50.0),
                        ),
                      ),
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                //**MainButton Text**
                RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AutoSizeText(
                      "Add",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w100),
                    ),
                  ),
                  //**Send input to Firebase**
                  onPressed: () async {
                    friend.name = _nameController.text;
                    friend.uid = _UIDController.text;

                    if (friend.name != "" && friend.uid != "") {
                      final uid =
                          await Provider.of(context).auth.getCurrentUID();

                      //**Entry gets saved in Firebase**
                      await db
                          .collection("userData")
                          .doc(uid)
                          .collection("friends")
                          .add(friend.toJson());
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
