import 'package:class_mates/models/usersmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  final User chatUser;
  const UsersScreen({super.key, required this.chatUser});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final ChatUser chatuser = ChatUser();
  FirebaseFirestore database = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Stream<QuerySnapshot<Map<String, dynamic>>> stream;

  // Future<ChatRoomModel?> getChatroomModel(ChatUser targetuser) async {
  //   ChatRoomModel chatRoom;

  //   QuerySnapshot chatroomsnapshot = await database
  //       .collection("Chatrooms")
  //       .where("participants.${widget.chatUser.uid}", isEqualTo: true)
  //       .where("participants.${targetuser.uid}", isEqualTo: true)
  //       .get();

  //   if (chatroomsnapshot.docs.isNotEmpty) {
  //     log("Chatroom already exists");
  //     var docdata = chatroomsnapshot.docs[0].data();
  //     ChatRoomModel existingchatroom = ChatRoomModel.fromJson(docdata as Map<String, dynamic>);

  //     chatRoom = existingchatroom;
  //   } else {
  //     ChatRoomModel newchatroom = ChatRoomModel(
  //       chatroomid: uuid.v1(),
  //       lastmessage: "",
  //       participants: {
  //         widget.chatUser.uid.toString(): true,
  //         targetuser.uid.toString(): true,
  //       },
  //       time: DateTime.now(),
  //     );

  //     await FirebaseFirestore.instance.collection("Chatrooms").doc(newchatroom.chatroomid).set(newchatroom.toJson());
  //     log("New Chatroom created");

  //     chatRoom = newchatroom;
  //   }
  //   return chatRoom;
  // }

  @override
  void initState() {
    final user = _auth.currentUser;
    stream = FirebaseFirestore.instance.collection('Users').where("uid", isNotEqualTo: user!.uid).snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2865DC),
        toolbarHeight: 130,
        title: const Text('All Students List'),
      ),
      body: Center(
        child: StreamBuilder(
          stream: stream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final users = snapshot.data?.docs ?? [];
            QuerySnapshot datasnapshot = snapshot.data as QuerySnapshot;

            if (datasnapshot.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: datasnapshot.docs.length,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                itemBuilder: (context, index) {
                  var document = datasnapshot.docs[index];
                  Map<String, dynamic> chatuser = datasnapshot.docs[index].data() as Map<String, dynamic>;

                  ChatUser addtochatUser = ChatUser.fromJson(chatuser);

                  return Container(
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              const TextSpan(
                                text: 'Name: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: document['username'].toString() ?? 'No name',
                                style: const TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              const TextSpan(
                                text: 'Email: ',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                              ),
                              TextSpan(
                                text: document['email'].toString() ?? 'No email',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              const TextSpan(
                                text: 'Phone No.: ',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                              ),
                              TextSpan(
                                text: document['phone'].toString() ?? 'No phone no.',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              const TextSpan(
                                text: 'Teacher Name: ',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                              ),
                              TextSpan(
                                text: document['teacherName'].toString() ?? 'No teacher name',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              const TextSpan(
                                text: 'Favourite Books: ',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                              ),
                              TextSpan(
                                text: document['favBooks'].toString() ?? 'No favBooks',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              const TextSpan(
                                text: 'Other Books: ',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                              ),
                              TextSpan(
                                text: document['otherBooks'].toString() ?? 'No otherBooks',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),

                        // Add more fields as needed
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Text("No Students found");
            }
          },
        ),
      ),
    );
  }
}
