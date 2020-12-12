import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_finances/models/Entry.dart';
import 'package:my_finances/widgets/provider_widget.dart';

//**Create new Entry**

class NewEntryView extends StatelessWidget {
  final Entry entry;

  NewEntryView({Key key, @required this.entry}) : super(key: key);

  //**create Firebase instance**
  final db = FirebaseFirestore.instance;

  DateTime _dateTime;

  @override
  Widget build(BuildContext context) {
    //**Creating all TextControllers**
    TextEditingController _titleController = new TextEditingController();
    TextEditingController _moneyController = new TextEditingController();
    TextEditingController _dateController = new TextEditingController();
    TextEditingController _reasonController = new TextEditingController();

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
            //**NameTextField**
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

            //**MoneyTextField**
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

            //**DateTextField**
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

            //**ReasonTextField**
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
                //**Cancel Button**
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

                //**Save Button**
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
                    //**InputData gets Converted in to Entry**
                    entry.title = _titleController.text;
                    entry.date = _dateTime;
                    entry.money = double.parse(_moneyController.text);
                    entry.reason = _reasonController.text;

                    //**gets UID to save for current User**
                    final uid = await Provider.of(context).auth.getCurrentUID();

                    //**Entry gets saved in Firebase**
                    await db
                        .collection("userData")
                        .doc(uid)
                        .collection("entrys")
                        .add(entry.toJson());
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
