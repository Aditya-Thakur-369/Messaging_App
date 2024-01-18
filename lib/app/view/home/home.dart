// ignore_for_file: must_be_immutable
import 'package:chat_app/app/controller/home/bloc/home_bloc.dart';
import 'package:chat_app/app/view/callLog/calls.dart';
import 'package:chat_app/app/view/chat/chat.dart';
import 'package:chat_app/app/view/profile/profile.dart';
import 'package:chat_app/app/view/status/status.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  Home({super.key});

  List<Widget> screens = <Widget>[
     Chats(),
    const CallLog(),
    const Status(),
    const Profile(),
  ];

  GlobalKey<CurvedNavigationBarState> curvednavigationkey = GlobalKey();

  HomeBloc homeBloc = HomeBloc();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: homeBloc,
      builder: (context, state) {
        return Scaffold(
          body: screens.elementAt(state.tabIndex),
          bottomNavigationBar: CurvedNavigationBar(
            items: const [
              Icon(EneftyIcons.message_2_bold),
              Icon(EneftyIcons.call_bold),
              Icon(EneftyIcons.story_bold),
              Icon(EneftyIcons.profile_bold),
            ],
            key: curvednavigationkey,
            index: state.tabIndex,
            height: 60,
            color: Colors.white,
            buttonBackgroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(83, 204, 203, 202),
            animationDuration: const Duration(milliseconds: 600),
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
