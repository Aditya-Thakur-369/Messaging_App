part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

class UsersLoadingState extends ChatState {}

class UsersLoadedState extends ChatState {
  final List<Map<String, dynamic>> users;

  UsersLoadedState(this.users);
}

class UsersErrorState extends ChatState {
  final String errorMessage;

  UsersErrorState(this.errorMessage);
}

