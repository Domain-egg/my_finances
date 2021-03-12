//**Model of Object**

class Friend {
  String name;
  String uid;
  double dept;

  Friend(
    this.name,
    this.uid,
    this.dept,
  );

  Map<String, dynamic> toJson() => {
        'name': name,
        'uid': uid,
        'dept': dept,
      };
}
