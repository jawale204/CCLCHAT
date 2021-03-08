import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String data;
  final String sentBy;
  final String date;

  ChatModel({this.data,  this.sentBy, this.date});

  factory ChatModel.fromDocument(DocumentSnapshot doc) {
    return ChatModel(
      data: doc['data'],
      sentBy: doc['sendBy'],
      date: doc['date']
    );
  }
}
