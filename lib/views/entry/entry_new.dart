import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_finances/models/Entry.dart';
import 'package:my_finances/widgets/provider_widget.dart';

/// This class makes new entry's.
///
/// It checks if the user wants to modify an existing entry or create a new one.
/// It creates a form-like page where the user can input his data,
/// then it sends the data to the database.

class NewEntryView extends StatefulWidget {
  @override
  final Entry entry;
  final String id;
  NewEntryView({Key key, @required this.entry, @required this.id})
      : super(key: key);
  _NewEntryViewState createState() => _NewEntryViewState();
}

class _NewEntryViewState extends State<NewEntryView> {
  //**create Firebase instance**
  final db = FirebaseFirestore.instance;

  //**Creating all TextControllers**
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _moneyController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();
  TextEditingController _reasonController = new TextEditingController();

  DateTime _dateTime;
  int selectedRadio;
  double startMoney;

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Entry entry = widget.entry;
    final String id = widget.id;

    if (entry.title != null) {
      _titleController.text = entry.title;
    }

    if (_moneyController.text == "") {
      if (entry.money == null) {
        _moneyController.text = "0.00";
      } else {
        startMoney = entry.money;
        if (entry.money < 0) {
          setSelectedRadio(0);
          _moneyController.text = (entry.money * -1).toString();
        } else {
          setSelectedRadio(1);
          _moneyController.text = entry.money.toString();
        }
      }
    }
    if (_dateController.text == "") {
      if (entry.date == null) {
        _dateController.text = DateFormat('dd.MM.yyyy').format(DateTime.now());
        _dateTime = DateTime.now();
      } else {
        _dateController.text = DateFormat('dd.MM.yyyy').format(entry.date);
        _dateTime = entry.date;
      }

      if (entry.reason != null) {
        _reasonController.text = entry.reason;
      }
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
                    maxLength: 30,
                  ),
                ],
              ),
            ),

            RadioListTile(
              value: 0,
              groupValue: selectedRadio,
              onChanged: (val) {
                setSelectedRadio(val);
              },
              title: const Text('spend'),
              activeColor: Colors.redAccent,
            ),
            RadioListTile(
                value: 1,
                groupValue: selectedRadio,
                onChanged: (val) {
                  setSelectedRadio(val);
                },
                activeColor: Colors.greenAccent,
                title: const Text('receipt')),

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
                    maxLength: 10,
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
                    maxLength: 40,
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
                    entry.money = selectedRadio == 1
                        ? double.parse(_moneyController.text)
                        : double.parse(_moneyController.text) * -1;
                    entry.reason = _reasonController.text;

                    //**gets UID to save for current User**
                    final uid = await Provider.of(context).auth.getCurrentUID();
                    Navigator.of(context).pop();
                    //**Entry gets saved in Firebase**
                    if (id == null) {
                      await db
                          .collection("userData")
                          .doc(uid)
                          .collection("entrys")
                          .add(entry.toJson());

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
                        'sumE': entry.money + sum,
                      });
                    } else {
                      await db
                          .collection("userData")
                          .doc(uid)
                          .collection("entrys")
                          .doc(id)
                          .update(entry.toJson());

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
                        'sumE': entry.money + sum - startMoney,
                      });
                    }
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
