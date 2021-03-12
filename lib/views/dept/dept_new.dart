import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_finances/models/Dept.dart';
import 'package:my_finances/widgets/provider_widget.dart';

//**Create new dept**

class NewDeptView extends StatefulWidget {
  @override
  final Dept dept;
  final String id;
  NewDeptView({Key key, @required this.dept, @required this.id})
      : super(key: key);
  _NewDeptViewState createState() => _NewDeptViewState();
}

class _NewDeptViewState extends State<NewDeptView> {
  //**create Firebase instance**
  final db = FirebaseFirestore.instance;

  //**Creating all TextControllers**
  TextEditingController _moneyController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();
  TextEditingController _reasonController = new TextEditingController();
  TextEditingController _statusController = new TextEditingController();

  DateTime _dateTime;
  int selectedRadio;
  double startMoney;
  String statusValue;
  String selectedFriend;

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
    statusValue = 'open';
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  setSelectedStatus(String val) {
    setState(() {
      statusValue = val;
    });
  }

  setSelectedFriend(String val) {
    setState(() {
      selectedFriend = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final Dept dept = widget.dept;
    final String id = widget.id;

    if (dept.friend != null) {
      setState(() {
        selectedFriend = dept.friend;
        print(selectedFriend);
      });
    }

    if (_moneyController.text == "") {
      if (dept.money == null) {
        _moneyController.text = "0.00";
      } else {
        startMoney = dept.money;
        if (dept.money < 0) {
          setSelectedRadio(0);
          _moneyController.text = (dept.money * -1).toString();
        } else {
          setSelectedRadio(1);
          _moneyController.text = dept.money.toString();
        }
      }
    }
    if (_dateController.text == "") {
      if (dept.date == null) {
        _dateController.text = DateFormat('dd.MM.yyyy').format(DateTime.now());
        _dateTime = DateTime.now();
      } else {
        _dateController.text = DateFormat('dd.MM.yyyy').format(dept.date);
        _dateTime = dept.date;
      }

      if (dept.status != null) {
        _statusController.text = dept.status;
      }

      if (dept.reason != null) {
        _reasonController.text = dept.reason;
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
                    "Friend",
                    style: TextStyle(color: Colors.grey),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: getUsersFriendStreamSnapshots(context),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return const Center(
                            child: const CupertinoActivityIndicator(),
                          );

                        return new Container(
                          padding: EdgeInsets.only(bottom: 16.0),
                          width: _width * 0.9,
                          child: new Row(
                            children: <Widget>[
                              new Expanded(
                                flex: 4,
                                child: new InputDecorator(
                                  decoration: const InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: "OpenSans",
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  isEmpty: selectedFriend == null,
                                  child: new DropdownButton(
                                    isExpanded: true,
                                    value: selectedFriend,
                                    isDense: true,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        selectedFriend = newValue;
                                        print(selectedFriend);
                                      });
                                    },
                                    items: snapshot.data.docs
                                        .map((DocumentSnapshot document) {
                                      return new DropdownMenuItem<String>(
                                          value: document.data()['name'],
                                          child: new Container(
                                            child: new Text(
                                                document.data()['name']),
                                          ));
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Text(
                      "You are the:",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          value: 0,
                          groupValue: selectedRadio,
                          onChanged: (val) {
                            setSelectedRadio(val);
                          },
                          title: const Text('debtor'),
                          activeColor: Colors.redAccent,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                            value: 1,
                            groupValue: selectedRadio,
                            onChanged: (val) {
                              setSelectedRadio(val);
                            },
                            activeColor: Colors.greenAccent,
                            title: const Text('creditor')),
                      )
                    ],
                  ),
                ],
              ),
            ),

            //**MoneyTextField**
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0),
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
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 30.0, left: 10.0, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Status",
                        style: TextStyle(color: Colors.grey),
                      ),
                      DropdownButton<String>(
                        value: statusValue,
                        onChanged: (String newValue) {
                          setSelectedStatus(newValue);
                        },
                        items: <String>['open', 'paid']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                ),
              ],
            ),

            //**statusTextField**

            //**reasonTextField**
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

            //**DateTextField**
            Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, top: 0.0, right: 30.0, bottom: 30.0),
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
                    //**InputData gets Converted in to dept**
                    dept.friend = selectedFriend;
                    dept.date = _dateTime;
                    dept.money = selectedRadio == 1
                        ? double.parse(_moneyController.text)
                        : double.parse(_moneyController.text) * -1;
                    dept.status = statusValue;
                    dept.reason = _reasonController.text;

                    //**gets UID to save for current User**
                    final uid = await Provider.of(context).auth.getCurrentUID();
                    Navigator.of(context).pop();
                    //**dept gets saved in Firebase**
                    if (id == null) {
                      await db
                          .collection("userData")
                          .doc(uid)
                          .collection("depts")
                          .add(dept.toJson());

                      //**for later Versions**//

                      /*

                      var snapshot = await db
                          .collection("userData")
                          .doc(uid)
                          .collection("sums")
                          .doc("sumdept")
                          .get();


                      double sum = 0;

                      if (snapshot.exists) {
                        sum = double.parse(snapshot['sumD'].toString());
                      }

                      await db
                          .collection("userData")
                          .doc(uid)
                          .collection("sums")
                          .doc("sumdept")
                          .set({
                        'sumD': dept.money + sum,
                      });
                      Navigator.of(context).pop();
                      */
                    } else {
                      await db
                          .collection("userData")
                          .doc(uid)
                          .collection("depts")
                          .doc(id)
                          .update(dept.toJson());
                      /*
                      var snapshot = await db
                          .collection("userData")
                          .doc(uid)
                          .collection("sums")
                          .doc("sumdept")
                          .get();

                      double sum = 0;

                      if (snapshot.exists) {
                        sum = double.parse(snapshot['sumE'].toString());
                      }

                      await db
                          .collection("userData")
                          .doc(uid)
                          .collection("sums")
                          .doc("sumdept")
                          .set({
                        'sumD': dept.money + sum - startMoney,
                      });*/
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

Stream<QuerySnapshot> getUsersFriendStreamSnapshots(
    BuildContext context) async* {
  final uid = await Provider.of(context).auth.getCurrentUID();
  yield* FirebaseFirestore.instance
      .collection('userData')
      .doc(uid)
      .collection("friends")
      .snapshots();
}
