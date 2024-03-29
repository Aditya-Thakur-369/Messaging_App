// ignore_for_file: unnecessary_string_interpolations, prefer_typing_uninitialized_variables

import 'package:chat_app/app/utils/components/showimage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleMessage extends StatelessWidget {
  final type;
  final currentTime;
  final String message;
  final bool isMe;
  SingleMessage(
      {required this.message,
      required this.isMe,
      required this.currentTime,
      required this.type});
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = currentTime.toDate();
    String formattedTime = DateFormat('h:mm a').format(dateTime);

    return Column(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                type == 'text'
                    ? Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(
                            top: 10, bottom: 2, left: 10, right: 10),
                        constraints: const BoxConstraints(maxWidth: 200),
                        decoration: BoxDecoration(
                            color: isMe
                                // ? Colors.blue.withOpacity(0.7)
                                ? Colors.black
                                : Colors.blue.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          message,
                          style: GoogleFonts.poppins(
                              fontSize: 16, color: Colors.white),
                        ))
                    : Container(
                        margin: const EdgeInsets.only(right: 20, top: 10),
                        child: type == "link"
                            ? Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(
                                    top: 10, bottom: 2, left: 10, right: 10),
                                constraints:
                                    const BoxConstraints(maxWidth: 260),
                                decoration: BoxDecoration(
                                    color: isMe
                                        // ? Colors.blue.withOpacity(0.7)
                                        ? Colors.black
                                        : Colors.blue.withOpacity(0.7),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30))),
                                child: GestureDetector(
                                  onTap: () async {
                                    await launchUrl(Uri.parse('$message'));
                                  },
                                  child: Text(
                                    message,
                                    style: GoogleFonts.poppins(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ShowImage(
                                                    message: message,
                                                    imageUrl: message),
                                              ));
                                        },
                                        child: Hero(
                                          tag: message,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.42,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.30,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(30)),
                                                image: DecorationImage(
                                                    image:
                                                        NetworkImage(message),
                                                    fit: BoxFit.cover)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                      ),
                Padding(
                  padding: const EdgeInsets.only(right: 17, left: 17, top: 1),
                  child: Text(
                    formattedTime,
                    style:
                        GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                  ),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
