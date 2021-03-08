import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/Models/Chat.dart';
import 'package:groupchat/Models/ConnectionModel.dart';
import 'package:groupchat/Services/Connections.dart';
import 'package:groupchat/Services/LoginService.dart';
import 'package:groupchat/Widgets/progress.dart';

class OneONOneChat extends StatefulWidget {
  final ConnectionModel model;
  OneONOneChat({this.model});
  @override
  _OneONOneChatState createState() => _OneONOneChatState();
}

class _OneONOneChatState extends State<OneONOneChat> {
  TextEditingController messcontroller = TextEditingController();
  final key = GlobalKey<FormState>();
  Connection connect = new Connection();
  sendText() {
    connect.sendChat(widget.model, messcontroller.value.text);
    messcontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        widget.model.email,
        style: TextStyle(color: Colors.white),
        overflow: TextOverflow.ellipsis,
      )),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(model: widget.model),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Type your message here...',
                      focusColor: Colors.brown,
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                    controller: messcontroller,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: FlatButton(
                      color: Colors.cyan,
                      onPressed: () {
                        if (messcontroller.value.text.isNotEmpty) {
                          sendText();
                        }
                      },
                      child: Text(
                        'Send',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatefulWidget {
  final ConnectionModel model;
  MessageStream({this.model});
  @override
  _MessageStreamState createState() => _MessageStreamState();
}

class _MessageStreamState extends State<MessageStream> {
  Connection connect = new Connection();
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
        stream: connect.getChats(widget.model),
        builder: (BuildContext context, AsyncSnapshot<dynamic> a) {
          if (a.hasData) {
            return ListView(
              shrinkWrap: true,
              children: [
                ...a.data.documents.reversed.map((chat) {
                  ChatModel singleText = ChatModel.fromDocument(chat);
                  return MessageBubble(model: singleText);
                })
              ],
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              reverse: true,
            );
          } else {
            return circularProgress();
          }
        },
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final ChatModel model;
  MessageBubble({this.model});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: model.sentBy == Login.userdata.email
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            model.sentBy,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: model.sentBy == Login.userdata.email
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: model.sentBy == Login.userdata.email
                ? Colors.lightBlueAccent
                : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                model.data,
                style: TextStyle(
                  color: model.sentBy == Login.userdata.email
                      ? Colors.white
                      : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
