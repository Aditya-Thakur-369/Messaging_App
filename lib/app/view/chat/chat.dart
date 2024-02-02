import 'package:chat_app/app/controller/auth/bloc/auth_bloc.dart';
import 'package:chat_app/app/model/user_model.dart';
import 'package:chat_app/app/view/search/Search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {

  UserModel? userModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedSuccessState) {
          userModel = state.userModel;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chats'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            BlocProvider.of<AuthBloc>(context).add(AuthenticatedCheckEvent());
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Search(userModel: userModel),
                ));
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}
