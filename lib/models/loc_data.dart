import 'package:cloud_firestore/cloud_firestore.dart';

class LocData {
  String locatedBy;
  int helpfulCount;
  String uId;
  List<dynamic> usersVoted;
  String subType;
  String type;
  bool isDisplayed;
  GeoPoint location;
  int notPresentCount;

  String? referenceId;

  LocData({
    required this.locatedBy,
    required this.helpfulCount,
    required this.uId,
    required this.usersVoted,
    required this.subType,
    required this.type,
    required this.isDisplayed,
    required this.location,
    required this.notPresentCount,
    this.referenceId,
  });
}