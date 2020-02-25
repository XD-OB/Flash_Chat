import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/message_bubble.dart';

final         firestore = Firestore.instance;
FirebaseUser  loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final         _msgController = TextEditingController();
  final         _auth = FirebaseAuth.instance;
  String        textMsg;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void    getCurrentUser() async {
    final user = await _auth.currentUser();
    try {
      if (user != null) {
        loggedInUser = user;
      }
    } catch(e) {
      print (e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      onChanged: (value) => textMsg = value,
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _msgController.clear();
                      firestore.collection('messages').add({
                        'sender': loggedInUser.email,
                        'text': textMsg,
                        'time': DateTime.now(),
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('messages').orderBy('time').snapshots(),
      builder: (context, snapshot) {
        List<MessageBubble>    msgWidgets = [];

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blueAccent,
            ),
          );
        }
        var      messages = snapshot.data.documents.reversed;
        for (var message in messages) {
          msgWidgets.add(MessageBubble(
            text: message.data['text'],
            sender: message.data['sender'],
            time: message.data['time'],
            isMe: loggedInUser.email == message.data['sender'],
          ));
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.all(20.0),
            children: msgWidgets,
          ),
        );
      }
    );
  }
}