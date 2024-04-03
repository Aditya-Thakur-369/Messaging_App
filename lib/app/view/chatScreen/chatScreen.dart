// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/app/controller/chat/bloc/chat_bloc.dart';
import 'package:chat_app/app/utils/components/message_textfield.dart';
import 'package:chat_app/app/utils/components/showimage.dart';
import 'package:chat_app/app/utils/components/single_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import '../../utils/services/sentpushnotification.dart';

class ChatScreen extends StatefulWidget {
  final String friendId;
  final String friendName;
  final String friendImage;

  const ChatScreen({
    Key? key,
    required this.friendId,
    required this.friendName,
    required this.friendImage,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is VideoCallWorkingState) {
          sendPushNotification(state.token, state.name);
        } else if (state is ChattedUserDeletedState) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () {
                  BlocProvider.of<ChatBloc>(context).add(
                      VideoCallButtonClickedEvent(friendId: widget.friendId));
                },
                // icon: const Icon(Ionicons.videocam_outline)),
                icon: const Icon(
                  Iconsax.video4,
                  color: Colors.grey,
                  size: 30,
                )),
            IconButton(
                onPressed: () {
                  BlocProvider.of<ChatBloc>(context).add(
                      VideoCallButtonClickedEvent(friendId: widget.friendId));
                },
                // icon: const Icon(Ionicons.videocam_outline)),
                icon: const Icon(
                  Iconsax.call,
                  color: Colors.grey,
                  size: 28,
                )),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Conversation'),
                        content: const Text(
                            'Are you sure you want to delete this conversation?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteConversation();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Ionicons.trash_bin_outline),
                    title: Text('Delete'),
                  ),
                ),
              ],
            )
          ],
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  print(widget.friendImage);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowImage(
                            message: widget.friendImage,
                            imageUrl: widget.friendImage),
                      ));
                },
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 60,
                          width: 60,
                          clipBehavior: Clip.antiAlias,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: widget.friendImage != null
                              ? CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: widget.friendImage,
                                  placeholder: (conteext, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                    Icons.error,
                                  ),
                                  height: 50,
                                )
                              : const Center(
                                  child: Icon(Iconsax.profile),
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 1,
                        child: Container(
                          height: 14,
                          width: 14,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              height: 12,
                              width: 12,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.green),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.friendName,
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Online",
                    style: GoogleFonts.poppins(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  )
                ],
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(user!.uid)
                      .collection('messages')
                      .doc(widget.friendId)
                      .collection('chats')
                      .orderBy('date', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.length < 1) {
                        return Center(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 140,
                                width: 140,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 80,
                                          spreadRadius: 2,
                                          blurStyle: BlurStyle.outer)
                                    ],
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.teal.withOpacity(0.5),
                                          Colors.purple.withOpacity(0.5),
                                        ])),
                                clipBehavior: Clip.antiAlias,
                                child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(widget.friendImage!),
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: "Say hii to  ",
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text: widget.friendName,
                                    style: GoogleFonts.poppins(
                                        fontSize: 32,
                                        color: Colors.blue.withOpacity(0.4),
                                        fontWeight: FontWeight.w600)),
                              ])),
                              const SizedBox(
                                height: 10,
                              ),
                              Text("Start Chatting to know more about him 😊 ",
                                  style: GoogleFonts.poppins())
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          bool isMe = snapshot.data.docs[index]['senderId'] ==
                              user!.uid;
                          final data = snapshot.data.docs[index];
                          return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) async {
                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(user?.uid)
                                  .collection('messages')
                                  .doc(widget.friendId)
                                  .collection('chats')
                                  .doc(data.id)
                                  .delete();
                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(widget.friendId)
                                  .collection('messages')
                                  .doc(user?.uid)
                                  .collection('chats')
                                  .doc(data.id)
                                  .delete();
                            },
                            child: SingleMessage(
                                currentTime: snapshot.data.docs[index]['date'],
                                type: snapshot.data.docs[index]['type'],
                                message: snapshot.data.docs[index]['message'],
                                isMe: isMe),
                          );
                        },
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),
            MessageTextField(user!.uid, widget.friendId)
          ],
        ),
      ),
    );
  }

  void deleteConversation() async {
    try {
      // Get a reference to the collection
      CollectionReference<Map<String, dynamic>> collectionReference =
          FirebaseFirestore.instance
              .collection('Users')
              .doc(user!.uid)
              .collection('messages')
              .doc(widget.friendId)
              .collection('chats');

      // Fetch the documents within the collection
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collectionReference.get();

      // Delete each document one by one
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        await doc.reference.delete();
      }
      print('Documents deleted successfully.');
    } catch (e) {
      print('Error deleting documents: $e');
    }
  }
}
