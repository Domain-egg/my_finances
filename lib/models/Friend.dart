//**Model of Object**

class Friend {
  String name;
  String uid;

  Friend(
    this.name,
    this.uid,
  );

  Map<String, dynamic> toJson() => {
        'name': name,
        'uid': uid,
      };
}
