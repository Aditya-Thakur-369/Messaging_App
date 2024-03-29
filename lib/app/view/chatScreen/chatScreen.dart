// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/app/utils/components/message_textfield.dart';
import 'package:chat_app/app/utils/components/showimage.dart';
import 'package:chat_app/app/utils/components/single_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Ionicons.videocam_outline)),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Iconsax.call_calling,
                size: 22,
              )),
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
              child: Container(
                height: 40,
                width: 40,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget.friendImage,
                  placeholder: (conteext, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                  ),
                  height: 50,
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
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  "Online",
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
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
                                  boxShadow: [
                                    const BoxShadow(
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
                        bool isMe =
                            snapshot.data.docs[index]['senderId'] == user!.uid;
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
    );
  }
}
