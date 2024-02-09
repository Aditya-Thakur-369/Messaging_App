part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

class NavigatedSearchPageDoneState extends ChatState{}

class BottomSheetSuccessState extends ChatState{}