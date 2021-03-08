import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/Home/OneOnOneChat.dart';
import 'package:groupchat/Models/ConnectionModel.dart';
import 'package:groupchat/Models/User.dart';
import 'package:groupchat/Services/Connections.dart';
import 'package:groupchat/Services/LoginService.dart';
import 'package:groupchat/Widgets/progress.dart';
import 'package:groupchat/Widgets/toast.dart';
import 'package:groupchat/Widgets/alertBox.dart';

class SearchUsers extends StatefulWidget {
  @override
  SearchUsersState createState() => SearchUsersState();
}

class SearchUsersState extends State<SearchUsers> {
  Stream<QuerySnapshot> userResult;
  final TextEditingController _email = TextEditingController();

  handleSearch() {
    if (_email.value.text.length > 4) {
      setState(() {
        Connection _connection = Connection();
        userResult = _connection.searchUser(_email.value.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Icon(Icons.person, color: Colors.black),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: TextFormField(
              onFieldSubmitted: (value) {
                handleSearch();
              },
              autofocus: true,
              validator: (value) {
                if (value.length < 1) {
                  return "Enter Text";
                }
                return null;
              },
              controller: _email,
              maxLines: 1,
              decoration: InputDecoration(
                fillColor: Colors.cyan,
                border: OutlineInputBorder(),
                hintText: "Search by Email",
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              handleSearch();
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: userResult,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return new Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return Center(child: Text("Search using Email Id"));
          }
          if (snapshot.hasData) {
            if (snapshot.data.runtimeType == String) {
              toast(snapshot.data);
            } else {
              return ListView(
                children: [
                  ...snapshot.data.documents.map((connection) {
                    var temp = UserModel.fromDocument(connection);
                    return searchedUser(temp, context);
                  })
                ],
              );
            }
          }
          return circularProgress();
        },
      ),
    );
  }
}

Widget searchedUser(connection, context) {
  handleGetChatId() async {
    Connection _connection = new Connection();
    ConnectionModel model = await _connection.getMessageId(connection);
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => OneONOneChat(model: model)));
  }

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: ListTile(
          onTap: () {
            if (connection.email != Login.userdata.email) {
              showDialogStructure(
                  context, "Send Message", handleGetChatId, "Yes", () {
                Navigator.pop(context);
              }, "Cancel", "");
            }
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(connection.photoUrl),
            maxRadius: 25,
          ),
          title: Text(
            connection.name,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            connection.email,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      Divider(
        height: 4,
        thickness: 1,
      )
    ],
  );
}
