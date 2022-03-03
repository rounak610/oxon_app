import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  static String? userName = null;
  static String? mobileNumber = null;
  static String? uId = null;
  static late User? user;

  Future<String> getUserData() async {
    user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      uId = user!.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get()
          .then((ds) {
        userName = ds.data()!['name'];
        mobileNumber = ds.data()!['mobile'];
      }).catchError((e) {
        userName = null;
        mobileNumber = null;
      });
    }
    return "done";
  }
}