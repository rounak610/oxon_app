import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oxon_app/models/loc_data.dart';

class LocDataRepository {
  final CollectionReference collection = FirebaseFirestore
      .instance.collection('loc_data');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> addLocData(LocData locData) {
    return collection.add(locData.toJson());
  }

  void updateLocData(LocData locData) async {
    await collection.doc(locData.referenceId).update(locData.toJson());
  }

  Future<String> deleteLocData(LocData locData) async {
    await collection.doc(locData.referenceId).delete();

    return "deleted";
  }
}