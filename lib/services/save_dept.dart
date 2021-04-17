import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_finances/models/Dept.dart';

///class that saves all Data in the DB
///
///



class SaveDept {
  save(String uid, String id, Dept dept, double startMoney, String startStatus,
      context) async {
    final dbDept = FirebaseFirestore.instance
        .collection("userData")
        .doc(uid)
        .collection("depts");
    final dbSumD = FirebaseFirestore.instance
        .collection("userData")
        .doc(uid)
        .collection("sumsD")
        .doc("sumDepts");

    final dbSumFD = FirebaseFirestore.instance
        .collection("userData")
        .doc(uid)
        .collection("friends")
        .doc(dept.fId);

//**dept gets saved in Firebase**
    if (id == null) {
      await dbDept.add(dept.toJson());

      var snapshot = await dbSumD.get();

      if (dept.status == "open") {
        double sum = 0;

        if (snapshot.exists) {
          sum = double.parse(snapshot['sumD'].toString());
        }

        await dbSumD.update({
          'sumD': dept.money + sum,
        });

        var snapshotF = await dbSumFD.get();

        if (dept.status == "open") {
          double sumF = 0;

          if (snapshotF.exists) {
            sumF = double.parse(snapshotF['dept'].toString());
          }

          await dbSumFD.update({
            'dept': dept.money + sumF,
          });
        }
      } else {
        await dbDept.doc(id).update(dept.toJson());

        var snapshot = await dbSumD.get();

        double sum = 0;

        if (snapshot.exists) {
          sum = double.parse(snapshot['sumD'].toString());
        }

        await dbSumD.set({
          'sumD': dept.money + (sum - startMoney),
        });

        sum = dept.money + (sum - startMoney);

        if (startStatus != dept.status) {
          await dbSumD.set({
            'sumD': dept.status == "open" ? sum + dept.money : sum - dept.money,
          });
        }

        var snapshotF = await dbSumFD.get();

        double sumF = 0;

        if (snapshotF.exists) {
          sumF = double.parse(snapshotF['dept'].toString());
        }

        sumF = dept.money + (sumF - startMoney);

        if (startStatus != dept.status) {
          await dbSumFD.update({
            'dept': dept.status == "open" ? sumF + dept.money : sumF - dept.money,
          });
        }

      }
    }
  }
}
