import 'package:chat_app/app/controller/chat/bloc/chat_bloc.dart';
import 'package:chat_app/app/utils/components/usertile.dart';
import 'package:chat_app/app/view/chatPage/chatpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadUsersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is UsersLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UsersLoadedState) {
            return ListView(
              children: state.users.map<Widget>((userdata) {
                if (userdata["email"] != firebaseAuth.currentUser?.email) {
                  return UserTile(
                    onTap: () {
                      print(firebaseAuth.currentUser);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            reciverEmail: userdata["name"],
                            receiverID: userdata["name"],
                          ),
                        ),
                      );
                    },
                    image: userdata["image"],
                    text: userdata["name"],
                  );
                } else {
                  return Container();
                }
              }).toList(),
            );
          } else if (state is UsersErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
            return const Center(child: Text('Error'));
          } else {
            return const Center(child: Text('Unexpected state'));
          }
        },
      ),
    );
  }
}
