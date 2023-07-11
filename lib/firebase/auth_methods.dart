import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/utils/routes.dart';
import '/utils/utils.dart';

const someErrorS = 'Some error occured';
const enterAllS = 'Please enter all the fields';
const verifyEmailS = 'Please verify your email';

const unknownS = 'unknown';
const userNotFoundS = 'user-not-found';
const wrongPassS = 'wrong-password';
const tooManyRequestsS = 'too-many-requests';
const popupClosedByUserS = 'popup-closed-by-user';
const emailAlreadyInUseS = 'email-already-in-use';

const userNotFoundMessage =
    'An unknown error occurred: FirebaseError: Firebase: There is no user record corresponding to this identifier. The user may have been deleted. (auth/user-not-found).';

class AuthM {
  static final _auth = FirebaseAuth.instance;

  static Future<String> verifyEmail(String email) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
      }
      return successS;
    } catch (e) {
      return '$someErrorS: $e';
    }
  }

  static Future<String> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return successS;
    } on FirebaseAuthException catch (e) {
      if (e.code == unknownS) {
        if (e.message == userNotFoundMessage) {
          return userNotFoundS;
        }
      }
      return e.code;
    } catch (e) {
      return '$someErrorS: $e';
    }
  }

  static Future signInWithGoogle(BuildContext context) async {
    String res = await _signInWithGoogle();
    if (res == successS) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.home, (route) => false);
    }
  }

  static Future<String> _signInWithGoogle() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      await _auth.signInWithPopup(googleProvider);
      return successS;
    } on FirebaseAuthException catch (e) {
      if (e.code == unknownS) {
        if (e.message ==
            'An unknown error occurred: FirebaseError: Firebase: The popup has been closed by the user before finalizing the operation. (auth/popup-closed-by-user).') {
          return popupClosedByUserS;
        }
      }
      return e.code;
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
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        return verifyEmailS;
      }
      return successS;
    } on FirebaseAuthException catch (e) {
      if (e.code == unknownS) {
        if (e.message == userNotFoundMessage) {
          return userNotFoundS;
        }
        if (e.message ==
            'An unknown error occurred: FirebaseError: Firebase: The password is invalid or the user does not have a password. (auth/wrong-password).') {
          return wrongPassS;
        }
        if (e.message ==
            'An unknown error occurred: FirebaseError: Firebase: Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later. (auth/too-many-requests).') {
          return tooManyRequestsS;
        }
      }
      return e.code;
    } catch (e) {
      return '$e';
    }
  }

  static Future<String> registerUser(String email, String pass) async {
    try {
      if (email.isEmpty || pass.isEmpty) {
        return enterAllS;
      }
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      return successS;
    } on FirebaseAuthException catch (e) {
      if (e.code == unknownS) {
        if (e.message ==
            'An unknown error occurred: FirebaseError: Firebase: The email address is already in use by another account. (auth/email-already-in-use).') {
          return emailAlreadyInUseS;
        }
      }
      return e.code;
    } catch (e) {
      return '$e';
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
}
