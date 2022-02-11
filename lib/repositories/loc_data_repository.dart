import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oxon_app/models/loc_data.dart';

class LocDataRepository {
  final CollectionReference collection = FirebaseFirestore
      .instance.collection('loc_data_test');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> addLocData(LocData locData) {
    return collection.add(locData.toJson());
  }

  void updateLocData(LocData locData) async {
    await collection.doc(locData.referenceId).update(locData.toJson());
  }

  void deleteLocData(LocData locData) async {
    await collection.doc(locData.referenceId).delete();
  }
}