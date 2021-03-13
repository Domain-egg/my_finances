import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_finances/models/Entry.dart';
import 'package:my_finances/views/entry/entry_new.dart';
import 'package:my_finances/widgets/provider_widget.dart';

/// This class is here so the User can see more information's about there entry's.
///
/// The user can see more information's but can also change the data or delete it.

class EntryInfo extends StatelessWidget {
  final DocumentSnapshot entry;

  EntryInfo({Key key, @required this.entry}) : super(key: key);

  Widget build(BuildContext context) {
    //**gets width and height of screen**
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    final db = FirebaseFirestore.instance;

    Entry editEntry = new Entry(entry['title'], entry['date'].toDate(),
        entry['money'], entry['reason']);

    //**returns a decorated container with the entry info**
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
                                    builder: (context) => NewEntryView(
                                          entry: editEntry,
                                          id: entry.id,
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
                                .collection("sums")
                                .doc("sumEntry")
                                .get();

                            double sum = 0;

                            if (snapshot.exists) {
                              sum = double.parse(snapshot['sumE'].toString());
                            }

                            await db
                                .collection("userData")
                                .doc(uid)
                                .collection("sums")
                                .doc("sumEntry")
                                .set({
                              'sumE': sum - entry['money'],
                            });

                            await db
                                .collection("userData")
                                .doc(uid)
                                .collection("entrys")
                                .doc(entry.id)
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
                        entry['title'],
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: _height * 0.01,
                      ),
                      AutoSizeText(
                        "${entry['money'] >= 0 ? "+" : ""}${entry['money'].toStringAsFixed(2)} €",
                        style: new TextStyle(
                            color:
                                entry['money'] >= 0 ? Colors.green : Colors.red,
                            fontSize: 20),
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: _height * 0.01,
                      ),
                      AutoSizeText(
                        DateFormat('dd.MM.yyyy')
                            .format(entry['date'].toDate())
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
                            entry['reason'],
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
