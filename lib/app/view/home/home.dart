// ignore_for_file: must_be_immutable
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chat_app/app/controller/home/bloc/home_bloc.dart';
import 'package:chat_app/app/utils/agora/callpage.dart';
import 'package:chat_app/app/utils/constants/notification.dart';
import 'package:chat_app/app/view/callLog/calls.dart';
import 'package:chat_app/app/view/chat/chat.dart';
import 'package:chat_app/app/view/profile/profile.dart';
import 'package:chat_app/app/view/status/status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> screens = <Widget>[
    const Chats(),
    const Status(),
    const Profile(),
  ];
  User? user = FirebaseAuth.instance.currentUser;

  void updateFcmToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid)
        .update({'token': token});
  }

  @override
  void initState() {
    super.initState();
    updateFcmToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      String? body = message.notification!.body;
      String? title = message.notification!.title!.split('1a2b3c4d5e').first;
      String? channelName =
          message.notification!.title!.split('1a2b3c4d5e').last;
      if (notification != null && android != null) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 123,
              channelKey: "call_channel",
              color: Colors.white,
              title: title,
              body: body,
              category: NotificationCategory.Call,
              wakeUpScreen: true,
              autoDismissible: false,
              backgroundColor: Colors.orange,
            ),
            actionButtons: [
              NotificationActionButton(
                key: "ACCEPT",
                label: 'Accept Call',
                color: Colors.green,
                autoDismissible: true,
              ),
              NotificationActionButton(
                key: "REJECT",
                label: 'Reject Call',
                color: Colors.red,
                autoDismissible: true,
              ),
            ]);
      }

      @pragma("vm:entry-point")
      Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
        if (receivedAction.buttonKeyPressed == 'ACCEPT') {
          await [Permission.camera, Permission.microphone]
              .request()
              .then((value) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Call(channelName: channelName),
                ));
          });
        } else if (receivedAction.buttonKeyPressed == 'REJECT') {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Call from $body is rejected")));
        } else {
          print("Clicked on notification");
        }
      }

      AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionRecievedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayMethod,
      );
    });
  }

  HomeBloc homeBloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: homeBloc,
      builder: (context, state) {
        return Scaffold(
          body: screens.elementAt(state.tabIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Ionicons.chatbox_ellipses_outline),
                  label: 'chats'),
              BottomNavigationBarItem(
                  icon: Icon(Ionicons.book_outline), label: 'stories'),
              BottomNavigationBarItem(
                  icon: Icon(Ionicons.person_outline), label: 'profile')
            ],
            currentIndex: state.tabIndex,
            fixedColor: Colors.black,
            unselectedItemColor: const Color.fromARGB(255, 207, 205, 205),
            onTap: (value) {
              homeBloc.add(
                TabChangeEvent(tabIndex: value),
              );
            },
          ),
        );
      },
    );
  }
}
