// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: sort_child_properties_last, avoid_unnecessary_containers, unnecessary_overrides

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/app/utils/components/skelton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/app/controller/chat/bloc/chat_bloc.dart';
import 'package:chat_app/app/view/chatScreen/chatScreen.dart';
import 'package:chat_app/app/view/search/Search.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:timeago/timeago.dart' as timeago;

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> with WidgetsBindingObserver {
  User? user = FirebaseAuth.instance.currentUser;
  String? lastMessageTime;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    setStatus("Online");
  }

  void setStatus(String status) async {
    try {
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user!.uid)
            .update({'status': status});
      } else {
        print('User is null, unable to update status.');
      }
    } catch (e) {
      print('Error updating user status: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //online
      setStatus("Online");
    } else {
      //offline
      setStatus("Offline");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is NavigatedSearchPageDoneState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Search(),
              ));
        } else if (state is ChattedUserDeletedState) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        // appBar: AppBar(
        // backgroundColor: Color(0xFF5B17FE),
        // actions: [
        //   const SizedBox(
        //     width: 30,
        //   ),
        //   // Container(
        //   //   height: 40,
        //   //   width: 40,
        //   //   decoration: const BoxDecoration(
        //   //       color: Color(0xFF5B17FE), shape: BoxShape.circle),
        //   //   child: const Center(
        //   //     child: Icon(Iconsax.profile_circle, color: Colors.white),
        //   //   ),
        //   // ),
        //   // const Spacer(),
        //   Text(
        //     "Chats",
        //     style: GoogleFonts.poppins(
        //         fontSize: 22, fontWeight: FontWeight.w600),
        //   ),
        //   const Spacer(),
        //   IconButton(
        //       onPressed: () {},
        //       icon: const Icon(
        //         Iconsax.notification,
        //         color: Color(0xFF5B17FE),
        //       )),
        //   const SizedBox(
        //     width: 20,
        //   ),
        // ],
        // ),
        body: Column(
          children: [
            // SizedBox(
            // height: 50,
            // ),
            Container(
              height: 120,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                  boxShadow: [
                    const BoxShadow(
                      color: Color(0xFF5B17FE),
                      blurStyle: BlurStyle.outer,
                      blurRadius: 10,
                    )
                  ],
                  border: Border.all(color: const Color(0xFF5B17FE)),
                  color: const Color(0xFF5B17FE),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Row(
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  // Container(
                  //   height: 40,
                  //   width: 40,
                  //   decoration: const BoxDecoration(
                  //       color: Color(0xFF5B17FE), shape: BoxShape.circle),
                  //   child: const Center(
                  //     child: Icon(Iconsax.profile_circle, color: Colors.white),
                  //   ),
                  // ),
                  // const Spacer(),
                  Text(
                    "Chats",
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Iconsax.notification,
                        color: Colors.white,
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(user!.uid)
                    .collection("messages")
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length < 1) {
                      return Center(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SizedBox(
                          //   height: 400,
                          //   width: 340,
                          //   child: Image.asset("assets/images/chatapp.gif"),
                          // ),
                          FittedBox(
                            child: Text(
                              "Stay Connected with your friends 👋",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 8),
                            child: Text(
                                "Start your journey of connection. Build friendships,       share moments Stay connected with your friends. 🌟",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                )),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ));
                    }
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        var friendId = snapshot.data.docs[index].id;
                        var lastMsg = snapshot.data.docs[index]['last_msg'];
                        return FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('Users')
                              .doc(friendId)
                              .get(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              var friend = snapshot.data;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 06, vertical: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(.0),
                                        width: 0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: ListTile(
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Delete Chat'),
                                            content: const Text(
                                                'Are you sure you want to delete this Chat?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  BlocProvider.of<ChatBloc>(
                                                          context)
                                                      .add(
                                                          ChattedFriendDeleteEvent(
                                                              currentUid:
                                                                  user!.uid,
                                                              friendId:
                                                                  friendId));
                                                },
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    leading: SizedBox(
                                      height: 100,
                                      width: 80,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 0,
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              height: 100,
                                              width: 80,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle),
                                              child: friend['image'] != null
                                                  ? CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl: friend['image'],
                                                      placeholder: (conteext,
                                                              url) =>
                                                          const CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                        Icons.error,
                                                      ),
                                                      // height: 80,
                                                    )
                                                  : const Center(
                                                      child:
                                                          Icon(Iconsax.profile),
                                                    ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 2,
                                            right: 2,
                                            child: Container(
                                              height: 16,
                                              width: 16,
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Container(
                                                  height: 14,
                                                  width: 14,
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.green),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    title: Text(
                                      friend['name'],
                                      style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Container(
                                      child: Text(
                                        '$lastMsg',
                                        style: GoogleFonts.poppins(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    trailing: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc(user!.uid)
                                          .collection('messages')
                                          .doc(friendId)
                                          .collection('chats')
                                          .orderBy('date', descending: true)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final docs = snapshot.data!.docs;
                                          if (docs.isNotEmpty) {
                                            final lastMessageDoc = docs.first;
                                            final currentTime =
                                                lastMessageDoc['date'];
                                            lastMessageTime = timeago
                                                .format(currentTime.toDate());
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  lastMessageTime!,
                                                  style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.grey,
                                                      fontSize: 12),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  height: 23,
                                                  width: 23,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color:
                                                              Color(0xFF5B17FE),
                                                          shape:
                                                              BoxShape.circle),
                                                  child: Center(
                                                    child: Text(
                                                      "2",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          } else {
                                            return const SizedBox();
                                          }
                                        }
                                        return const SizedBox();
                                      },
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                                friendId: friend['uid'],
                                                friendName: friend['name'],
                                                friendImage: friend['image']),
                                          ));
                                    },
                                  ),
                                ),
                              );
                            }
                            return const SkeltonLoadingIndicator();
                          },
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
          ],
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF5B17FE)),
              color: const Color(0xFF5B17FE),
              borderRadius: const BorderRadius.all(Radius.circular(100))),
          height: 70,
          width: 70,
          child: FloatingActionButton(
            elevation: 2,
            onPressed: () {
              BlocProvider.of<ChatBloc>(context)
                  .add(NavigateToSearchPageEvent());
            },
            child: const Icon(
              Iconsax.add,
              size: 35,
            ),
            backgroundColor: const Color(0xFF5B17FE),
            shape: const CircleBorder(),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
