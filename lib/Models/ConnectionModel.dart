import 'package:cloud_firestore/cloud_firestore.dart';

class ConnectionModel {
  final String id;
  final String userId;
  final String email;
  final bool isGroup;
  final String lastUpdated;

  ConnectionModel({this.id,this.userId, this.email, this.isGroup, this.lastUpdated});

  factory ConnectionModel.fromDocument(DocumentSnapshot doc) {
    return ConnectionModel(
      id: doc['id'],
      email: doc['email'],
      userId:doc['userId'],
      isGroup: doc['isGroup'],
      lastUpdated: doc['lastUpdated'].toString()
    );
  }
}
