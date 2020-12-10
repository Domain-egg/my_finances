import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_finances/models/Entry.dart';
import 'package:my_finances/widgets/provider_widget.dart';

class NewEntryView extends StatelessWidget {
  final Entry entry;

  NewEntryView({Key key, @required this.entry}) : super(key: key);

  final db = FirebaseFirestore.instance;

  DateTime _dateTime;

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = new TextEditingController();
    TextEditingController _moneyController = new TextEditingController();
    TextEditingController _dateController = new TextEditingController();
    TextEditingController _reasonController = new TextEditingController();
    //_titleController.text=entry.title;

    if (entry.money == null) {
      _moneyController.text = "0.00";
    }

    if (entry.date == null) {
      _dateController.text = DateFormat('dd.MM.yyyy').format(DateTime.now());
      _dateTime = DateTime.now();
    }

    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            //NameTextField,
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextField(
                    controller: _titleController,
                    autofocus: true,
                  ),
                ],
              ),
            ),
            //MoneyTextField
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Money",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.euro_rounded),
                    ),
                    controller: _moneyController,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            //DateTextField
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Date",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.calendar_today_rounded),
                    ),
                    readOnly: true,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate:
                        _dateTime == null ? DateTime.now() : _dateTime,
                        firstDate: DateTime(2001),
                        lastDate: DateTime(2100),
                      ).then((date) {
                        if (date != null) {
                          _dateTime = date;
                          _dateController.text =
                              DateFormat('dd.MM.yyyy').format(_dateTime);
                        }
                      });
                    },
                    controller: _dateController,
                  ),
                ],
              ),
            ),
            //
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Reason",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextField(
                    controller: _reasonController,
                    autofocus: true,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Cancel button
                RaisedButton(
                  color: Colors.redAccent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.cancel_outlined),
                      ),
                      Text("Cancel"),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                //Save Button
                RaisedButton(
                  color: Colors.lightBlueAccent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.save_rounded),
                      ),
                      Text("Save"),
                    ],
                  ),
                  onPressed: () async {
                    entry.title = _titleController.text;
                    entry.date = _dateTime;
                    entry.money = double.parse(_moneyController.text);
                    entry.reason = _reasonController.text;
                    final uid = await Provider
                        .of(context)
                        .auth
                        .getCurrentUID();
                    await db.collection("userData").doc(uid).collection(
                        "entrys").add(entry.toJson());
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
