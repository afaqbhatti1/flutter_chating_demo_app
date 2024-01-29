// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'dart:developer';

import 'package:class_mates/main.dart';
import 'package:class_mates/models/chatroommodel.dart';
import 'package:class_mates/models/usersmodel.dart';
import 'package:class_mates/screens/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  final User chatUser;

  const ChatList({
    Key? key,
    required this.chatUser,
  }) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ChatUser chatuser = ChatUser();
  FirebaseFirestore database = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Stream<QuerySnapshot<Map<String, dynamic>>> stream;

  Future<ChatRoomModel?> getChatroomModel(ChatUser targetuser) async {
    ChatRoomModel chatRoom;

    QuerySnapshot chatroomsnapshot = await database
        .collection("Chatrooms")
        .where("participants.${widget.chatUser.uid}", isEqualTo: true)
        .where("participants.${targetuser.uid}", isEqualTo: true)
        .get();

    if (chatroomsnapshot.docs.isNotEmpty) {
      log("Chatroom already exists");
      var docdata = chatroomsnapshot.docs[0].data();
      ChatRoomModel existingchatroom = ChatRoomModel.fromJson(docdata as Map<String, dynamic>);

      chatRoom = existingchatroom;
    } else {
      ChatRoomModel newchatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastmessage: "",
        participants: {
          widget.chatUser.uid.toString(): true,
          targetuser.uid.toString(): true,
        },
        time: DateTime.now(),
      );

      await FirebaseFirestore.instance.collection("Chatrooms").doc(newchatroom.chatroomid).set(newchatroom.toJson());
      log("New Chatroom created");

      chatRoom = newchatroom;
    }
    return chatRoom;
  }

  @override
  void initState() {
    final user = _auth.currentUser;
    stream = FirebaseFirestore.instance.collection('Users').where("uid", isNotEqualTo: user!.uid).snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    return Center(
      child: StreamBuilder(
          stream: stream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // snapshot.data.docs[index];
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            QuerySnapshot datasnapshot = snapshot.data as QuerySnapshot;
            if (datasnapshot.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: datasnapshot.docs.length,
                padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 40),
                itemBuilder: (context, index) {
                  var document = datasnapshot.docs[index];
                  Map<String, dynamic> chatuser = datasnapshot.docs[index].data() as Map<String, dynamic>;

                  ChatUser addtochatUser = ChatUser.fromJson(chatuser);
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(document['profilepic']),
                      ),
                      title: Text(document['username']),
                      tileColor: Colors.white,
                      subtitle: Text((document['about'] == null) ? "" : document['about'].toString()),
                      trailing: const Icon(Icons.arrow_right),
                      onTap: () async {
                        ChatRoomModel? chatroommodel = await getChatroomModel(addtochatUser);
                        if (chatroommodel != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                targetuser: addtochatUser,
                                firebaseuser: user!,
                                chatroom: chatroommodel,
                                currentuser: user,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              );
            } else {
              return const Text("No Users found");
            }
          }),
    );
  }
}
