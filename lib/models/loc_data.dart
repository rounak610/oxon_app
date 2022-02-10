import 'package:cloud_firestore/cloud_firestore.dart';

class LocData {
  int downvote;
  bool is_displayed;
  GeoPoint location;
  String name;
  String type;
  String sub_type;
  String u_id;
  int upvote;

  String? referenceId;

  LocData(
      {required this.downvote,
      required this.is_displayed,
      required this.location,
      required this.name,
      required this.type,
      required this.sub_type,
      required this.u_id,
      required this.upvote,
      this.referenceId});

  factory LocData.fromSnapshot(DocumentSnapshot snapshot) {
    final newLocData = LocData.fromJson(snapshot.data() as Map<String, dynamic>);
    newLocData.referenceId = snapshot.reference.id;
    return newLocData;
  }

  factory LocData.fromJson(Map<String, dynamic> json) => _locDataFromJson(json);

  Map<String, dynamic> toJson() => _locDataToJson(this);
}


LocData _locDataFromJson(Map<String, dynamic> json) {
  return LocData(
    downvote: json['downvote'],
    is_displayed: json['is_displayed'],
    location: json['location'],
    name: json['name'],
    type: json['type'],
    sub_type: json['sub_type'],
    u_id: json['u_id'],
    upvote: json['upvote'],
    referenceId: json['reference_id']
  );
}


Map<String, dynamic> _locDataToJson(LocData instance) => <String, dynamic>{
      'downvote': instance.downvote,
      'is_displayed': instance.is_displayed,
      'location': instance.location,
      'name': instance.name,
      'type': instance.type,
      'sub_type': instance.sub_type,
      'u_id': instance.u_id,
      'upvote': instance.upvote,
      'reference_id': instance.referenceId
    };
