// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class ChatShareEvent extends ChatEvent {
  final String currentId;
  final String friendId;
  final String message;
  ChatShareEvent({
    required this.currentId,
    required this.friendId,
    required this.message,
  });
}
