import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_finances/Entry.dart';

class EntryView extends StatelessWidget {
  final List<Entry> entryList = [
    Entry("Donuts", DateTime.now(), -20.00, "Mein Beck"),
    Entry("Bagels", DateTime.now(), 20.00, "Mein Beck"),
    Entry("Flug", DateTime.now(), -90.00, "Amsterdam"),
    Entry("Hotel", DateTime.now(), -130.00, "Amsterdam"),
    Entry("Drugs", DateTime.now(), -20.00, "Mein Dealer"),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new ListView.builder(
          itemCount: entryList.length,
          itemBuilder: (BuildContext context, int index) =>
              buildEntryCard(context, index)),
    );
  }

  Widget buildEntryCard(BuildContext context, int index) {
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
                      entryList[index].location,
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
    );
  }
}