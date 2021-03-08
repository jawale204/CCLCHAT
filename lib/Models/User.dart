import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String id;
  final String photoUrl;
  final String name;
  final String deviceToken;
  UserModel({this.id, this.email, this.photoUrl, this.name,this.deviceToken});

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      id: doc['Uid'],
      email: doc['email'],
      photoUrl: doc['photoUrl'],
      name: doc['displayName'],
      deviceToken: doc["deviceToken"]
    );
  }
}
