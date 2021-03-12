//**Model of Object**

class Dept {
  String friend;
  DateTime date;
  double money;
  String reason;
  String status;

  Dept(
    this.friend,
    this.date,
    this.money,
    this.reason,
    this.status,
  );

  Map<String, dynamic> toJson() => {
        'friend': friend,
        'date': date,
        'money': money,
        'reason': reason,
        'status': status,
      };
}
