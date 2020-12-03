import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_finances/models/Entry.dart';
import 'package:my_finances/views/entry_new.dart';

class EntryView extends StatefulWidget {
  @override
  _EntryViewState createState() => _EntryViewState();
}

class _EntryViewState extends State<EntryView> {
  List<Entry> entryList = [
    Entry("Donuts", DateTime.now(), -20.00, "Mein Beck"),
    Entry("Lohn", DateTime.now(), 220.00, "Mein Beck"),
    Entry("Flug", DateTime.now(), -90.00, "Amsterdam"),
    Entry("Hotel", DateTime.now(), -130.00, "Amsterdam"),
    Entry("Phone", DateTime.now(), -20.00, "Kiosk"),
  ];

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
            child: new ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: entryList.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildEntryCard(context, index)),
          ),
        ),
      ],
    );
  }

  Widget buildEntryCard(BuildContext context, int index) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => {_entryEditModalBottomSheet(context)},
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
                          entryList[index].title,
                          style: new TextStyle(fontSize: 15.0),
                        ),
                        Spacer(),
                        Text(
                          "${entryList[index].money >= 0 ? "+" : ""}${entryList[index].money.toStringAsFixed(2)} €",
                          style: new TextStyle(
                            fontSize: 15.0,
                            color: entryList[index].money >= 0
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
                        entryList[index].reason,
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

  void _entryEditModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.60,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("edit Entry"),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.cancel_rounded,
                            color: Colors.red, size: 25),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
