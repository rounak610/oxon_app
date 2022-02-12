import 'package:flutter/foundation.dart';

class UserProfile with ChangeNotifier {
  final String userID;
  final String dateOfBirth;
  final String city;
  final String email;
  final String gender;
  final String name;

  UserProfile({
    required this.userID,
    required this.city,
    required this.dateOfBirth,
    required this.email,
    required this.gender,
    required this.name,
  });

}
