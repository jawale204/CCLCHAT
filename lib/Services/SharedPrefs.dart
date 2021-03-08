import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
 static isLoggedInSetTrue() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool saved=await pref.setBool("isLoggedIN", true);
    return saved;
  }

   static isLoggedInSetFalse() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool saved=await pref.setBool("isLoggedIN", false);
    return saved;
  }


 static isLoggedInCheck() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool data = pref.getBool('isLoggedIN');
    return data;
  }
}
