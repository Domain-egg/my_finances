import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EntryInfo extends StatelessWidget {
  final DocumentSnapshot entry;

  EntryInfo({Key key, @required this.entry}) : super(key: key);

  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

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
              //mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.cancel_rounded, color: Colors.red, size: 25),
                  onPressed: () {
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
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(entry['title']),
                Text(
                  "${entry['money'] >= 0 ? "+" : ""}${entry['money'].toStringAsFixed(2)} €",
                  style: new TextStyle(
                    color: entry['money'] >= 0 ? Colors.green : Colors.red,
                  ),
                ),
                Text(DateFormat('dd.MM.yyyy')
                    .format(entry['date'].toDate())
                    .toString()),
                Text(entry['reason']),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
