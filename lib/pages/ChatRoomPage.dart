import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/ChatRoomModel.dart';
import '../models/MessageModel.dart';
import '../models/UserModel.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoomPage({Key? key, required this.targetUser, required this.chatroom, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  ChatRoomPageState createState() => ChatRoomPageState();
}

class ChatRoomPageState extends State<ChatRoomPage> {

  TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();

    if(msg != "") {
      // Send Message
      MessageModel newMessage = MessageModel(
        massageId: uuid.v1(),
        sender: widget.userModel.uid,
        createdOn: DateTime.now(),
        text: msg,
        seen: false
      );

      FirebaseFirestore.instance.collection("chatroom's").doc(widget.chatroom.chatRoomId).collection("messages").doc(newMessage.massageId).set(newMessage.toMap());

      widget.chatroom.lastMessage = msg;
      FirebaseFirestore.instance.collection("chatroom's").doc(widget.chatroom.chatRoomId).set(widget.chatroom.toMap());

      log("Message Sent!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [

            CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage: NetworkImage(widget.targetUser.profilePic.toString()),
            ),

            const SizedBox(width: 10,),

            Text(widget.targetUser.fullName.toString()),

          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [

            // This is where the chats will go
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10
                ),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("chatroom's").doc(widget.chatroom.chatRoomId).collection("messages").orderBy("createdOn", descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.active) {
                      if(snapshot.hasData) {
                        QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

                        return ListView.builder(
                          reverse: true,
                          itemCount: dataSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            MessageModel currentMessage = MessageModel.fromMap(dataSnapshot.docs[index].data() as Map<String, dynamic>);

                            return Row(
                              mainAxisAlignment: (currentMessage.sender == widget.userModel.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (currentMessage.sender == widget.userModel.uid) ? Colors.grey : Theme.of(context).colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    currentMessage.text.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  )
                                ),
                              ],
                            );
                          },
                        );
                      }
                      else if(snapshot.hasError) {
                        return const Center(
                          child: Text("An error occurred! Please check your internet connection."),
                        );
                      }
                      else {
                        return const Center(
                          child: Text("Say hi to your new friend"),
                        );
                      }
                    }
                    else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),

            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5
              ),
              child: Row(
                children: [

                  Flexible(
                    child: TextField(
                      controller: messageController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter message"
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      sendMessage();
                    },
                    icon: Icon(Icons.send, color: Theme.of(context).colorScheme.secondary,),
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