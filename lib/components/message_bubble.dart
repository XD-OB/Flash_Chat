import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String     sender;
  final String     text;
  final Timestamp  time;
  final bool       isMe;

  MessageBubble({this.sender, this.text, this.isMe, this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ?
          CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isMe ? 30 : 0),
              topRight: Radius.circular(isMe ? 0 : 30),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            color: isMe ?
              Colors.lightBlue[600] : Colors.grey[200],
            elevation: 6.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 20.0,
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: isMe ?
            MainAxisAlignment.end : MainAxisAlignment.start,
            children: <Widget>[
              Text(
                sender,
                style: TextStyle(
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                  fontSize: 13.0,
                ),
              ),
              Text(
                ' (${timeAgo.format(DateTime.parse(time.toDate().toString()))})',
                style: TextStyle(
                  color: Colors.green[800],
                  fontStyle: FontStyle.italic,
                  fontSize: 10.0,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}