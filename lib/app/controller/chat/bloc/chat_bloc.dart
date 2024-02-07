import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<ChatShareEvent>(chatShareEvent);
    on<NavigateToSearchPageEvent>(navigateToSearchPage);
  }

  FutureOr<void> chatShareEvent(
      ChatShareEvent event, Emitter<ChatState> emit) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(event.currentId)
        .collection('messages')
        .doc(event.friendId)
        .collection('chats')
        .add({
      "senderId": event.currentId,
      "receiverId": event.friendId,
      "message": event.message,
      "type": "text",
      "date": DateTime.now(),
    }).then((value) {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(event.currentId)
          .collection('messages')
          .doc(event.friendId)
          .set({'last_msg': event.message});
    });
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(event.friendId)
        .collection('messages')
        .doc(event.currentId)
        .collection('chats')
        .add({
      "senderId": event.currentId,
      "receiverId": event.friendId,
      "message": event.message,
      "type": "text",
      "date": DateTime.now(),
    }).then((value) {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(event.friendId)
          .collection('messages')
          .doc(event.currentId)
          .set({'last_msg': event.message});
    });
  }

  FutureOr<void> navigateToSearchPage(
      NavigateToSearchPageEvent event, Emitter<ChatState> emit) {
    emit(NavigatedSearchPageDoneState());
  }
}
