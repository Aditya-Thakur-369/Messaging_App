import 'package:chat_app/app/controller/chat/bloc/chat_bloc.dart';
import 'package:chat_app/app/utils/components/bottomsheet.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class MessageTextField extends StatefulWidget {
  final String currentId;
  final String friendId;

  MessageTextField(this.currentId, this.friendId);

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  bool showEmojiPicker = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is BottomSheetSuccessState) {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) =>
                bottomSheet(context, widget.currentId, widget.friendId),
          );
        }
      },
      builder: (context, state) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsetsDirectional.only(
            bottom: 12,
            start: 8,
            end: 8,
          ),
          child: Expanded(
              child: Column(
            children: [
              TextFormField(
                controller: controller,
                onChanged: (text) {
                  setState(() {}); // Update UI when text changes
                },
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(
                    hintText: "Type Here... ",
                    hintStyle: GoogleFonts.poppins(
                        color: Colors.grey, fontWeight: FontWeight.w400),
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 14),
                    filled: true,
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton.filled(
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.transparent)),
                            onPressed: () {
                              setState(() {
                                showEmojiPicker = !showEmojiPicker;
                              });
                            },
                            icon: const Icon(Iconsax.emoji_happy,
                                color: Colors.grey)),
                        const SizedBox(
                          width: 6,
                        ),
                      ],
                    ),
                    suffixIcon: controller.text.isEmpty
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton.filled(
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.transparent)),
                                  onPressed: () {
                                    BlocProvider.of<ChatBloc>(context).add(
                                        CameraImagesSentEvent(
                                            currentId: widget.currentId,
                                            friendId: widget.friendId));
                                  },
                                  icon: const Icon(Iconsax.camera,
                                      color: Colors.grey)),
                              IconButton.filled(
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.transparent)),
                                  onPressed: () {
                                    BlocProvider.of<ChatBloc>(context).add(
                                        GalleryImagesSentEvent(
                                            currentId: widget.currentId,
                                            friendId: widget.friendId));
                                  },
                                  icon: state is ChatLoading
                                      ? SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator(
                                            color: Colors.grey,
                                          ),
                                        )
                                      : Icon(Iconsax.image,
                                          color: Colors.grey)),
                              IconButton.filled(
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.transparent)),
                                  onPressed: () {
                                    BlocProvider.of<ChatBloc>(context).add(
                                        LocationSentEvent(
                                            currentId: widget.currentId,
                                            friendId: widget.friendId));
                                  },
                                  icon: const Icon(Iconsax.location,
                                      color: Colors.grey)),
                              // IconButton(
                              //     onPressed: () {
                              //       BlocProvider.of<ChatBloc>(context)
                              //           .add(BottomSheetEvent());
                              //     },
                              //     icon: const Icon(Ionicons.attach)),
                            ],
                          )
                        : TextButton(
                            onPressed: () async {
                              String message = controller.text;
                              controller.clear();
                              setState(() {});
                              if (message.isNotEmpty) {
                                BlocProvider.of<ChatBloc>(context).add(
                                    ChatShareEvent(
                                        currentId: widget.currentId,
                                        friendId: widget.friendId,
                                        message: message));
                              }
                            },
                            child: Text(
                              "Send",
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: const Color(0xFF5B17FE),
                                  fontWeight: FontWeight.w600),
                            )),
                    border: InputBorder.none
                    // border: OutlineInputBorder(
                    // borderSide: const BorderSide(width: 0),
                    // gapPadding: 10,
                    // borderRadius: BorderRadius.circular(25))
                    ),
              ),
              showEmojiPicker
                  ? SizedBox(
                      height: 300,
                      child: EmojiPicker(
                        textEditingController: controller,
                      ),
                    )
                  : SizedBox.shrink()
            ],
          )),
        );
      },
    );
  }
}
