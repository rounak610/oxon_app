import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oxon/models/loc_data.dart';

class DustbinData extends LocData {
  int overflowingCount;

  DustbinData(
      {required locatedBy,
      required helpfulCount,
      required uId,
      required usersVoted,
      required subType,
      required type,
      required isDisplayed,
      required location,
      required notPresentCount,
      referenceId,
      required this.overflowingCount})
      : super(
            locatedBy: locatedBy,
            helpfulCount: helpfulCount,
            uId: uId,
            usersVoted: usersVoted,
            subType: subType,
            type: type,
            isDisplayed: isDisplayed,
            location: location,
            notPresentCount: notPresentCount,
            referenceId: referenceId);

  factory DustbinData.fromSnapshot(DocumentSnapshot snapshot) {
    final newDustbinData =
        DustbinData.fromJson(snapshot.data() as Map<String, dynamic>);
    newDustbinData.referenceId = snapshot.reference.id;
    return newDustbinData;
  }

  factory DustbinData.fromJson(Map<String, dynamic> json) =>
      _dustbinDataFromJson(json);

  Map<String, dynamic> toJson() => _dustbinDataToJson(this);
}

DustbinData _dustbinDataFromJson(Map<String, dynamic> json) {
  return DustbinData(
    locatedBy: json['located_by'],
    helpfulCount: json['helpful_count'],
    uId: json['u_id'],
    usersVoted: json['users_voted'],
    subType: json['sub_type'],
    type: json['type'],
    isDisplayed: json['is_displayed'],
    location: json['location'],
    notPresentCount: json['not_present_count'],
    overflowingCount: json['overflowing_count'],
    referenceId: json['reference_id'],
  );
}

Map<String, dynamic> _dustbinDataToJson(DustbinData instance) =>
    <String, dynamic>{
      'located_by': instance.locatedBy,
      'helpful_count': instance.helpfulCount,
      'u_id': instance.uId,
      'users_voted': instance.usersVoted,
      'sub_type': instance.subType,
      'type': instance.type,
      'is_displayed': instance.isDisplayed,
      'location': instance.location,
      'not_present_count': instance.notPresentCount,
      'overflowing_count': instance.overflowingCount,
      'reference_id': instance.referenceId,
    };
