// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import '/models/user_model.dart' as model;
import '/utils/routes.dart';
import '/utils/utils.dart';

const String someErrorS = 'Some error occured...';
const String enterAllS = 'Please enter all the fields...';

const String usersS = 'users';

class AuthM {
  static final _auth = FirebaseAuth.instance;
  // static final _firestore = FirebaseFirestore.instance;

  static Future signInWithGoogle(BuildContext context) async {
    print('starting');
    String res = await _signInWithGoogle();
    print('done');
    showSnackBar(res, context);
    if (res == successS) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.home, (route) => false);
    } else {
      print('idk');
    }
  }

  static Future<String> _signInWithGoogle() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      await _auth.signInWithPopup(googleProvider);
      return successS;
    } catch (e) {
      return '$someErrorS: $e';
    }
  }

  static Future<String> loginUser(String email, String pass) async {
    try {
      if (email.isEmpty || pass.isEmpty) {
        return enterAllS;
      }
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      return successS;
    } catch (e) {
      return '$someErrorS: $e';
    }
  }

  static Future<String> registerUser(String email, String pass) async {
    try {
      if (email.isEmpty || pass.isEmpty) {
        return enterAllS;
      }
      // UserCredential cred =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      // model.User user = model.User(cred.user!.uid, name, email);
      // await _firestore
      //     .collection(usersS)
      //     .doc(cred.user!.uid)
      //     .set(user.toJson());
      return successS;
    } catch (e) {
      return '$someErrorS: $e';
    }
  }

  static Future<String> signOut() async {
    try {
      await _auth.signOut();
      return successS;
    } catch (e) {
      return '$someErrorS: $e';
    }
  }

  // static Future<model.User> getCurrentUser() async {
  //   try {
  //     final snapshot = await _firestore.collection(S.users).doc(_uid).get();
  //     return model.User.fromSnap(snapshot);
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  // static Future<String> getUsername() async {
  //   try {
  //     var snap = await _firestore.collection(S.users).doc(_uid).get();
  //     return model.User.fromSnap(snap).username;
  //   } catch (e) {
  //     return '$e';
  //   }
  // }
}
