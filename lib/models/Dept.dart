//**Model of Object**

class Dept {
  String friend;
  String fId;
  DateTime date;
  double money;
  String reason;
  String status;

  Dept(
    this.friend,
    this.fId,
    this.date,
    this.money,
    this.reason,
    this.status,
  );

  Map<String, dynamic> toJson() => {
        'friend': friend,
        'fId': fId,
        'date': date,
        'money': money,
        'reason': reason,
        'status': status,
      };
}
