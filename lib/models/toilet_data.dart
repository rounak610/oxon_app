import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oxon/models/loc_data.dart';

class ToiletData extends LocData {
  int notCleanedCount;

  ToiletData(
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
      required this.notCleanedCount})
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

  factory ToiletData.fromSnapshot(DocumentSnapshot snapshot) {
    final newToiletData =
        ToiletData.fromJson(snapshot.data() as Map<String, dynamic>);
    newToiletData.referenceId = snapshot.reference.id;
    return newToiletData;
  }

  factory ToiletData.fromJson(Map<String, dynamic> json) =>
      _toiletDataFromJson(json);

  Map<String, dynamic> toJson() => _toiletDataToJson(this);
}

ToiletData _toiletDataFromJson(Map<String, dynamic> json) {
  return ToiletData(
    locatedBy: json['located_by'],
    helpfulCount: json['helpful_count'],
    uId: json['u_id'],
    usersVoted: json['users_voted'],
    subType: json['sub_type'],
    type: json['type'],
    isDisplayed: json['is_displayed'],
    location: json['location'],
    notPresentCount: json['not_present_count'],
    notCleanedCount: json['not_cleaned_count'],
    referenceId: json['reference_id'],
  );
}

Map<String, dynamic> _toiletDataToJson(ToiletData instance) =>
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
      'not_cleaned_count': instance.notCleanedCount,
      'reference_id': instance.referenceId,
    };
