class Entry {
  String title;
  DateTime date;
  double money;
  String reason;

  Entry(
    this.title,
    this.date,
    this.money,
    this.reason,
  );

  Map<String, dynamic> toJson() => {
        'title': title,
        'date': date,
        'money': money,
        'reason': reason,
      };
}
