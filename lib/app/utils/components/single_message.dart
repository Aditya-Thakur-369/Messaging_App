// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleMessage extends StatelessWidget {
  final String message;
  final bool isMe;
  final String type;
  const SingleMessage({
    Key? key,
    required this.message,
    required this.type,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        type == "text"
            ? Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                constraints: const BoxConstraints(maxWidth: 200),
                decoration: BoxDecoration(
                    color: isMe ? Colors.black : Colors.grey,
                    borderRadius: const BorderRadius.all(Radius.circular(12))),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              )
            : type == "link"
                ? Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    constraints: const BoxConstraints(maxWidth: 200),
                    decoration: BoxDecoration(
                        color: isMe ? Colors.black : Colors.grey,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                    child: GestureDetector(
                      onTap: () async {
                        await launchUrl(Uri.parse('$message'));
                      },
                      child: Text(
                        message,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(right: 20, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.42,
                              height: MediaQuery.of(context).size.height * 0.30,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(18),
                                    topLeft: Radius.circular(18),
                                    bottomLeft: Radius.circular(18),
                                  ),
                                  image: DecorationImage(
                                      image: NetworkImage(message),
                                      fit: BoxFit.fill)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
      ],
    );
  }
}
