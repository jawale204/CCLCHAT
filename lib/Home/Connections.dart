import 'package:flutter/material.dart';
import 'package:groupchat/Home/OneOnOneChat.dart';
import 'package:groupchat/Home/SearchUsers.dart';
import 'package:groupchat/Models/ConnectionModel.dart';
import 'package:groupchat/Services/LoginService.dart';
import 'package:groupchat/Widgets/progress.dart';
import 'package:groupchat/Widgets/toast.dart';
import '../Services/Connections.dart';

class Connections extends StatefulWidget {
  @override
  _ConnectionsState createState() => _ConnectionsState();
}

class _ConnectionsState extends State<Connections> {
  Connection _connection = Connection();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CCLHAT"),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              popUpItems(() {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchUsers(
                      
                    ),
                  ),
                );
              }, Icons.search, "Search Users"),
             // popUpItems(() {}, Icons.group_add, "Create Group"),
              popUpItems(() {
                Login login = new Login();
                login.logout(context);
              }, Icons.logout, "Logout")
            ],
          ),
        ],
      ),
   
      body: StreamBuilder(
          stream: _connection.getConnections(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print("has eror");
              return new Text('Error: ${snapshot.error}');
            }
            if (snapshot.hasData) {
              if (snapshot.data.runtimeType == String) {
                toast(snapshot.data);
              } else {
                return ListView(
                  children: [
                    ...snapshot.data.documents.map((connection) {
                      var temp = ConnectionModel.fromDocument(connection);
                      return listtile(temp,context);
                    })
                  ],
                );
              }
            }
            return circularProgress();
          }),
    );
  }
}

Widget drawer() {
  return Drawer();
}

PopupMenuItem popUpItems(Function ontap, IconData icon, String title) {
  return PopupMenuItem(
    child: ListTile(
      contentPadding: EdgeInsets.all(0),
      onTap: ontap,
      leading: Icon(icon, color: Colors.cyan),
      title: Text(title),
    ),
  );
}

Widget listtile(connection,context) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: ListTile(
          onTap: (){
            Navigator.push(context,
        MaterialPageRoute(builder: (context) => OneONOneChat(model: connection)));
          },
          leading: CircleAvatar(
              maxRadius: 25,
              child:
                  connection.isGroup ? Icon(Icons.group) : Icon(Icons.person)),
          title: Text(
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
