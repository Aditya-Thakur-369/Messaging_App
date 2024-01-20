import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = "chats";
const String MESSAGES_COLLECTION = "Messages";

class DataBaseServices {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  
}
