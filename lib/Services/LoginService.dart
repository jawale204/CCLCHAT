import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:groupchat/Login/GmailLogin.dart';
import 'package:groupchat/Models/User.dart';
import 'package:groupchat/Services/SharedPrefs.dart';

final GoogleSignIn _googleSignIn = new GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;
final userRef = FirebaseFirestore.instance.collection('Users');

class Login {
  static UserModel userdata;
  static UserModel reset;
  User user;
  googleSignIn(deviceToken) async {
    GoogleSignInAuthentication googleSignInAuthentication;
    try {
      bool check = await LocalData.isLoggedInCheck();
      if (check == true) {
        GoogleSignInAccount googleSignInAccount =
            await _googleSignIn.signInSilently();
        googleSignInAuthentication = await googleSignInAccount.authentication;
      } else if (check == false || check == null) {
        GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
        googleSignInAuthentication = await googleSignInAccount.authentication;
      }
      AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      await _auth.signInWithCredential(credential);
      user = _auth.currentUser;
      await LocalData.isLoggedInSetTrue();
      DocumentSnapshot doc = await userRef.doc(user.uid).get();
      if (!doc.exists) {
        await userRef.doc(user.uid).set({
          'Uid': user.uid,
          'photoUrl': user.photoURL,
          'email': user.email,
          'displayName': user.displayName,
          'deviceToken': deviceToken
        });
        DocumentSnapshot docsnapshot = await userRef.doc(user.uid).get();
        userdata = UserModel.fromDocument(docsnapshot);
      } else {
        await userRef.doc(user.uid).update({"deviceToken": deviceToken});
        DocumentSnapshot docsnapshot = await userRef.doc(user.uid).get();
        userdata = UserModel.fromDocument(docsnapshot);
      }
      print(userdata.email);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<dynamic> logout(context) async {
    try {
      await userRef.doc(Login.userdata.id).update({"deviceToken": null});
      await _googleSignIn.signOut();
      await _auth.signOut();
      await LocalData.isLoggedInSetFalse();
      userdata = reset;
      Navigator.pushReplacementNamed(context, GmailLogin.id);
      return true;
    } catch (e) {
      print(e.code);
      return false;
    }
  }
}
