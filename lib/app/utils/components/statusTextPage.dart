import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../controller/status/bloc/status_bloc.dart';

class StatusTextPage extends StatefulWidget {
  final image;
  final name;
  final id;
  StatusTextPage({required this.image, required this.name, required this.id});

  @override
  State<StatusTextPage> createState() => _StatusTextPageState();
}

class _StatusTextPageState extends State<StatusTextPage> {
  final String camera = 'camera';
  final String addStatus = 'addstatus';
  User? user = FirebaseAuth.instance.currentUser;
  Color color = Colors.white;
  final datacontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: AnimatedTextKit(animatedTexts: [
          TyperAnimatedText("Type",
              textStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500, color: Colors.black)),
          TyperAnimatedText("Your",
              textStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500, color: Colors.black)),
          TyperAnimatedText("Status",
              textStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500, color: Colors.black))
        ]),
        // Text(
        //   "Status",
        //   style: GoogleFonts.poppins(
        //     fontWeight: FontWeight.w500,
        //   ),
        // ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: () {
                BlocProvider.of<StatusBloc>(context).add(ColorPick());
              },
              icon: const Icon(
                Iconsax.colorfilter,
                size: 30,
              ),
            ),
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: FloatingActionButton(
              heroTag: camera,
              backgroundColor: Colors.black,
              shape: CircleBorder(),
              onPressed: () {},
              child: Center(
                child: Icon(Icons.camera),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 70,
            width: 70,
            child: FloatingActionButton(
              heroTag: addStatus,
              shape: const CircleBorder(),
              backgroundColor: Colors.black,
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('status')
                    .doc(user!.uid)
                    .set({
                  "uid": user!.uid,
                  'image': widget.image,
                  'name': widget.name,
                });
                FirebaseFirestore.instance
                    .collection('status')
                    .doc(user!.uid)
                    .collection('status')
                    .doc()
                    .set({
                  "Data": datacontroller.text,
                  'color': color.value,
                  'timestamp': DateTime.now().toUtc(),
                });
                Future.delayed(const Duration(seconds: 30), () {
                  FirebaseFirestore.instance
                      .collection('status')
                      .doc()
                      .collection('status')
                      .where('timestamp',
                          isLessThan: DateTime.now()
                              .subtract(const Duration(seconds: 30)))
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    querySnapshot.docs.forEach((doc) {
                      doc.reference.delete();
                    });
                  });
                });
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<StatusBloc, StatusState>(
        listener: (context, state) {
          if (state is ColorPickState) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    'Pick Your Color',
                    style: GoogleFonts.poppins(fontSize: 20),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildColorPicker(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("SELECT"),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
        builder: (context, state) {
          if (state is ColorPickerState) {
            color = state.color;
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              datacontroller.text.isEmpty
                  ? Image.asset("assets/images/undraw_status.png")
                  : const SizedBox.shrink(),
              // const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: datacontroller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type your status',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              datacontroller.text.isEmpty
                  ? Text("Tap here to write status ☝🏻",
                      style: GoogleFonts.poppins(
                          fontSize: 18, color: Colors.grey.withOpacity(0.8)))
                  : const SizedBox.shrink(),
              const Spacer(),
              // Padding(
              //   padding: const EdgeInsets.only(left: 4, right: 75, bottom: 16),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              // SizedBox(
              //   width: MediaQuery.sizeOf(context).width / 2 - 40,
              //   child: CupertinoButton(
              //       minSize: 50,
              //       color: Colors.black,
              //       borderRadius: BorderRadius.circular(30),
              //       child: SizedBox(
              //         width: 180,
              //         child: Center(
              //           child: Text("Image",
              //               style: GoogleFonts.poppins(
              //                 fontWeight: FontWeight.w600,
              //                 fontSize: 12,
              //               )),
              //         ),
              //       ),
              //       onPressed: () {}),
              // ),
              // SizedBox(
              //   width: MediaQuery.sizeOf(context).width / 2 - 40,
              //   child: CupertinoButton(
              //       minSize: 50,
              //       color: Colors.black,
              //       borderRadius: BorderRadius.circular(40),
              //       child: SizedBox(
              //         width: 180,
              //         child: Center(
              //           child: Text("Text",
              //               style: GoogleFonts.poppins(
              //                 fontWeight: FontWeight.w600,
              //                 fontSize: 14,
              //               )),
              //         ),
              //       ),
              //       onPressed: () {}),
              // ),
              //   SizedBox(
              //     width: MediaQuery.sizeOf(context).width / 2 - 40,
              //     child: OutlinedButton(
              //         style: const ButtonStyle(
              //             minimumSize:
              //                 MaterialStatePropertyAll(Size(180, 50)),
              //             shape: MaterialStatePropertyAll(
              //                 RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.all(
              //                         Radius.circular(30))))),
              //         child: SizedBox(
              //           width: 180,
              //           child: Center(
              //             child: Text("Image",
              //                 style: GoogleFonts.poppins(
              //                     fontWeight: FontWeight.w600,
              //                     fontSize: 14,
              //                     color: Colors.black)),
              //           ),
              //         ),
              //         onPressed: () {}),
              //   ),
              //   const SizedBox(
              //     width: 1,
              //   ),
              //   SizedBox(
              //     width: MediaQuery.sizeOf(context).width / 2 - 40,
              //     child: OutlinedButton(
              //         style: const ButtonStyle(
              //             minimumSize:
              //                 MaterialStatePropertyAll(Size(180, 50)),
              //             shape: MaterialStatePropertyAll(
              //                 RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.all(
              //                         Radius.circular(30))))),
              //         child: SizedBox(
              //           width: 180,
              //           child: Center(
              //             child: Text("Text",
              //                 style: GoogleFonts.poppins(
              //                     fontWeight: FontWeight.w600,
              //                     fontSize: 14,
              //                     color: Colors.black)),
              //           ),
              //         ),
              //         onPressed: () {}),
              //   ),
              // ],
              // ),
              // ),
            ],
          );
        },
      ),
    );
  }

  buildColorPicker() {
    return ColorPicker(
      pickerColor: color,
      onColorChanged: (Color colors) {
        setState(() {
          BlocProvider.of<StatusBloc>(context)
              .add(ColorPickerEvent(color: colors));
        });
      },
    );
  }
}
