import 'package:chat_app/app/utils/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String reciverEmail;
  final String receiverID;

  ChatPage({
    Key? key,
    required this.reciverEmail,
    required this.receiverID,
  }) : super(key: key);

  final TextEditingController textEditingController = TextEditingController();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(reciverEmail),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: textEditingController,
                    hintText: 'Type your message...',
                    obscureText: false,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 223, 220, 220)),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
