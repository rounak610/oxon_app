import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oxon/models/dustbin_data.dart';
import 'package:oxon/models/toilet_data.dart';

class LocDataRepository {
  final CollectionReference toiletCollection =
      FirebaseFirestore.instance.collection('toilet_data');

  final CollectionReference dustbinCollection =
      FirebaseFirestore.instance.collection('dustbin_data');

  Stream<QuerySnapshot> getStreamToilet() {
    return toiletCollection.snapshots();
  }

  Future<DocumentReference> addToiletData(ToiletData toiletData) {
    return toiletCollection.add(toiletData.toJson());
  }

  void updateToiletData(ToiletData toiletData) async {
    await toiletCollection
        .doc(toiletData.referenceId)
        .update(toiletData.toJson());
  }

  Future<String> deleteToiletData(ToiletData toiletData) async {
    await toiletCollection.doc(toiletData.referenceId).delete();
    return "deleted";
  }

  Stream<QuerySnapshot> getStreamDustbin() {
    return dustbinCollection.snapshots();
  }

  Future<DocumentReference> addDustbinData(DustbinData dustbinData) {
    return dustbinCollection.add(dustbinData.toJson());
  }

  void updateDustbinData(DustbinData dustbinData) async {
    await dustbinCollection
        .doc(dustbinData.referenceId)
        .update(dustbinData.toJson());
  }

  Future<String> deleteDustbinData(DustbinData dustbinData) async {
    await dustbinCollection.doc(dustbinData.referenceId).delete();

    return "deleted";
  }
}
