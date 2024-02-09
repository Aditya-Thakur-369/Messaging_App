// ignore_for_file: must_be_immutable
import 'package:chat_app/app/controller/home/bloc/home_bloc.dart';
import 'package:chat_app/app/view/callLog/calls.dart';
import 'package:chat_app/app/view/chat/chat.dart';
import 'package:chat_app/app/view/profile/profile.dart';
import 'package:chat_app/app/view/status/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

class Home extends StatelessWidget {
  Home({super.key});

  List<Widget> screens = <Widget>[
    const Chats(),
    const CallLog(),
    const Status(),
    const Profile(),
  ];

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
                  icon: Icon(Ionicons.call_outline), label: 'calls'),
              BottomNavigationBarItem(
                  icon: Icon(Ionicons.book_outline), label: 'story'),
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
