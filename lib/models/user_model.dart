import 'package:cloud_firestore/cloud_firestore.dart';

const uidS = 'uid';
const usernameS = 'username';
const emailS = 'email';

class User {
  final String uid;
  final String username;
  final String email;

  const User(
    this.uid,
    this.username,
    this.email,
  );

  static User fromSnap(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>;
    return User(data[uidS], data[usernameS], data[emailS]);
  }

  Map<String, dynamic> toJson() => {
        uidS: uid,
        usernameS: username,
        emailS: email,
      };
}
