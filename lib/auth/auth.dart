import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:tankyou/auth/login_or_register.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

final GoogleSignIn _googleSignIn = GoogleSignIn();

void logCurrentUser() {
  final logger = Logger();
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    logger.d('User ID: ${user.uid}');
    logger.d('Email: ${user.email}');
  } else {
    logger.d('No user is currently logged in.');
  }
}

bool checkIfUserSignedIn() {
  return _auth.currentUser != null;
}

Future<User?> registerWithEmailPassword(String email, String password) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    print(e);
    return null;
  }
}

Future<User?> loginWithEmailPassword(String email, String password) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    print(e);
    return null;
  }
}

Future<User?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    if (googleAuth.accessToken == null && googleAuth.idToken == null) {
      return null; 
    }

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    final User? user = userCredential.user;
    assert(!user!.isAnonymous);
    assert(await user?.getIdToken() != null);

    final User? currentUser = _auth.currentUser;
    assert(currentUser != null && currentUser.uid == user?.uid);

    return user;
  } catch (e) {
    print('Error signing in with Google: $e');
    return null;
  }
}

void signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginOrRegister()),
      );
}