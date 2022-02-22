import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oxon_app/models/driver_loc_data.dart';

class DriverLocRepository {
  final CollectionReference driverLocCollection = FirebaseFirestore.instance.collection('driver_loc_data');


  Stream<QuerySnapshot> getStreamDriverLoc() {
    return driverLocCollection.snapshots();
  }

  Future<DocumentReference> addDriverLocData(DriverLocData driverLocData) {
    return driverLocCollection.add(driverLocData.toJson());
  }

  void updateDriverLocData(DriverLocData driverLocData) async {
    await driverLocCollection
        .doc(driverLocData.referenceId)
        .update(driverLocData.toJson());
  }

  Future<String> deleteDriverLocData(DriverLocData driverLocData) async {
    await driverLocCollection.doc(driverLocData.referenceId).delete();
    return "deleted";
  }
}
