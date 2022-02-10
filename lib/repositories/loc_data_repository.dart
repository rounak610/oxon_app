import 'package:cloud_firestore/cloud_firestore.dart';

class LocDataRepository {
  final CollectionReference toiletsCollection =
      FirebaseFirestore.instance.collection('toilets_geopoint');

  final CollectionReference dustbinsCollection =
      FirebaseFirestore.instance.collection('dustbins_geopoint');

  Stream<QuerySnapshot> toiletsGetStream() {
    return toiletsCollection.snapshots();
  }

  Stream<QuerySnapshot> dustbinsGetStream() {
    return dustbinsCollection.snapshots();
  }

  Future<DocumentReference> addToilet(Map<String, dynamic> toilet) { // save this id
    return toiletsCollection.add(toilet);
  }

  // Future<DocumentReference> addPet(Pet pet) {
  //   return collection.add(pet.toJson());
  // }

}
