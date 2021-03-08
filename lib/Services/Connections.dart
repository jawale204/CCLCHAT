import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupchat/Models/ConnectionModel.dart';
import 'package:groupchat/Models/User.dart';
import 'package:groupchat/Services/LoginService.dart';

class Connection {
  final userRef = FirebaseFirestore.instance.collection('Users');
  final oneOnOneRef = FirebaseFirestore.instance.collection('OneONOneChat');
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot> searchUser(String email) {
    print(email);
    return userRef.where("email", isEqualTo: email).snapshots();
  }

  Stream<QuerySnapshot> getConnections() {
    return userRef.doc(Login.userdata.id).collection("Connections").snapshots();
  }

  Future<ConnectionModel> getMessageId(UserModel user) async {
    WriteBatch writebatch = _firestore.batch();
    QuerySnapshot checkIsFriend = await userRef
        .doc(Login.userdata.id)
        .collection("Connections")
        .where("email", isEqualTo: user.email)
        .get();
    if (checkIsFriend.size == 0) {
      String chatId = oneOnOneRef.doc().id;
      DocumentReference doc1 =
          userRef.doc(Login.userdata.id).collection("Connections").doc();
      writebatch.set(doc1, {
        "id": chatId,
        "email": user.email,
        "userId": user.id,
        "isGroup": false,
        "lastUpdated": DateTime.now(),
      });
      DocumentReference doc2 =
          userRef.doc(user.id).collection("Connections").doc();
      writebatch.set(doc2, {
        "id": chatId,
        "email": Login.userdata.email,
        "userId": Login.userdata.id,
        "isGroup": false,
        "lastUpdated": DateTime.now(),
      });
      writebatch.commit();
      QuerySnapshot checkIsFriend = await userRef
          .doc(Login.userdata.id)
          .collection("Connections")
          .where("email", isEqualTo: user.email)
          .get();
      var a = ConnectionModel.fromDocument(checkIsFriend.docs.first);
      return a;
    } else {
      var a = ConnectionModel.fromDocument(checkIsFriend.docs.first);
      return a;
    }
  }

  sendChat(ConnectionModel model, text) {
    oneOnOneRef.doc(model.id).collection("Chats").add({
      "data": text,
      "sendBy": Login.userdata.email,
      "date": DateTime.now().toIso8601String(),
      "sentTo": model.email
    });
  }

  Stream<QuerySnapshot> getChats(ConnectionModel model) {
    return oneOnOneRef
        .doc(model.id)
        .collection("Chats")
        .orderBy('date')
        .snapshots();
  }
}
