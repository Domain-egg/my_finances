import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// This class creates separators for the lists.
///
/// It takes the dates of the individual elements of the list
/// and groups them in days.

class GroupSeparator extends StatelessWidget {
  final DateTime date;
  GroupSeparator({this.date});

  @override
  Widget build(BuildContext context) {
    final String stringDate = DateFormat('dd/MM/yyyy').format(date);
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 16, top: 8, bottom: 0),
        child: Text(
          DateTime.now().day == this.date.day &&
                  DateTime.now().month == this.date.month &&
                  DateTime.now().year == this.date.year
              ? "Today"
              : "$stringDate",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }
}
