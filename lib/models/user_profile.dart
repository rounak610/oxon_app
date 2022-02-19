import 'package:flutter/foundation.dart';

class UserProfile with ChangeNotifier {
  final String userID;
  final String dob;
  final String city;
  final String gender;
  final String name;
  final int mobile;
  final int credits;

  UserProfile({
    required this.userID,
    required this.city,
    required this.dob,
    required this.mobile,
    required this.gender,
    required this.name,
    required this.credits
  });

}
