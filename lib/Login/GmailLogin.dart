import 'package:flutter/material.dart';
import 'package:groupchat/Home/Connections.dart';
import 'package:groupchat/Services/LoginService.dart';
import 'package:groupchat/Services/SharedPrefs.dart';
import 'package:groupchat/Widgets/alertBox.dart';
import 'package:groupchat/Widgets/button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:groupchat/Widgets/progress.dart';
import 'package:groupchat/Widgets/toast.dart';

class GmailLogin extends StatefulWidget {
  static String id="login";
  @override
  _GmailLoginState createState() => _GmailLoginState();
}

class _GmailLoginState extends State<GmailLogin> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool loading = true;
  String deviceToken;
  _getToken() async {
    deviceToken = await _firebaseMessaging.getToken();
    print(deviceToken);
  }

  @override
  initState() {
    super.initState();
    _getToken();
    _configureFirebaseMessaging();
    checkLocalLogin();
  }

  checkLocalLogin() async {
    var result = await LocalData.isLoggedInCheck();
    if (result == true) {
      handleLogin();
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  _configureFirebaseMessaging() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print(message);
    }, onLaunch: (Map<String, dynamic> message) async {
      print(message);
    }, onResume: (Map<String, dynamic> message) async {
      print(message);
    });
  }

  handleLogin() async {
    Login login = new Login();
    setState(() {
      loading = true;
    });
    bool signedin = await login.googleSignIn(deviceToken);
    if (signedin == true) {
      setState(() {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Connections()),
            (route) => false);
      });
    } else {
      toast("Network error");
      await showDialogStructure(
          context,
          "Network error",
          () {
            handleLogin();
            Navigator.pop(context);
          },
          "Retry",
          () {
            Navigator.pop(context);
            setState(() {
              loading = false;
            });
          },
          "Cancel",
          "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? circularProgress()
          : Center(
              child: CustButton(
                txt: "Login with Gmail",
                onpress: () {
                  handleLogin();
                },
              ),
            ),
    );
  }
}
