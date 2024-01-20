import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ChatBloc() : super(ChatInitial()) {
    on<LoadUsersEvent>(loadUsersEvent);
  }

  FutureOr<void> loadUsersEvent(LoadUsersEvent event, Emitter<ChatState> emit)async {
    emit(UsersLoadingState());
    try {
        final QuerySnapshot<Map<String, dynamic>> snapshot =
            await firestore.collection("Users").get();

        final List<Map<String, dynamic>> users =
            snapshot.docs.map((doc) => doc.data()).toList();

        emit(UsersLoadedState(users)) ;
      } catch (e) {
        emit(UsersErrorState("Error loading users: $e"));
      }
    }
  }

