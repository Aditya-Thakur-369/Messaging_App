// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors, unnecessary_string_interpolations, unnecessary_brace_in_string_interps
// ignore_for_file: unrelated_type_equality_checks, camel_case_types
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'package:chat_app/app/controller/profile/bloc/profile_bloc.dart';
import 'package:chat_app/app/view/login/login.dart';
import 'package:chat_app/app/view/profileupdate/profileupdate.dart';
import 'package:palette_generator/palette_generator.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
  }

  String? imageUrl;
  String? name;
  String? id;

  PaletteGenerator? paletteGenerator;

  void generatecolor(String imageUrl) async {
    if (imageUrl != null) {
      try {
        ImageProvider img = NetworkImage(imageUrl!);
        paletteGenerator = await PaletteGenerator.fromImageProvider(img);
        setState(() {});
      } catch (e) {
        print("No Image Found");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Color.fromRGBO(64, 105, 225, 1);
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is LogoutDoneState) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ));
        } else if (state is NavigationDoneToProfileUpdatePageState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProfileUpdate(imageUrl: imageUrl!, name: name!, id: id!),
              ));
        }
      },
      builder: (context, state) {
        BlocProvider.of<ProfileBloc>(context).add(FetchingUserDataEvent());
        if (state is UserDataFectchedDone) {
          name = state.name;
          imageUrl = state.imageUrl;
          id = state.id;

          generatecolor(imageUrl!);

          return Scaffold(
            // appBar: AppBar(
            //   actions: [
            //     IconButton(
            //       onPressed: () {
            // BlocProvider.of<ProfileBloc>(context)
            //     .add(NavigateToprofileUpdatePageEvent());
            //       },
            //       icon: const Icon(Icons.edit),
            //     ),
            //   ],
            // ),
            body: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.3 + 60,
                      width: MediaQuery.sizeOf(context).width,
                      child: Opacity(
                        opacity: 0.3,
                        child: Image.asset(
                          "assets/images/chat_background.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // CircleAvatar(
                    //   backgroundColor: color,
                    //   radius: 75,
                    //   child: CircleAvatar(
                    //     radius: 70,
                    //     backgroundImage: NetworkImage(imageUrl!),
                    //   ),
                    // ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Profile",
                            style: GoogleFonts.poppins(
                                fontSize: 32, fontWeight: FontWeight.w600),
                          ),
                          IconButton.filled(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.transparent)),
                              onPressed: () {
                                BlocProvider.of<ProfileBloc>(context)
                                    .add(NavigateToprofileUpdatePageEvent());
                              },
                              icon: Icon(Iconsax.edit_2, color: Colors.black))
                        ],
                      ),
                    ),

                    Positioned(
                      top: 100,
                      left: 130,
                      child: Column(
                        children: [
                          Container(
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: paletteGenerator != null
                                          ? paletteGenerator!.vibrantColor !=
                                                  null
                                              ? paletteGenerator!
                                                  .vibrantColor!.color
                                              : Colors.black
                                          : Colors.black,
                                      blurRadius: 80,
                                      spreadRadius: 2,
                                      blurStyle: BlurStyle.outer)
                                ],
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.teal.withOpacity(0.5),
                                      Colors.purple.withOpacity(0.5),
                                    ])),
                            clipBehavior: Clip.antiAlias,
                            child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: imageUrl != null
                                    ? CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(imageUrl!),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(28.0),
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                        ),
                                      )),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '$name',
                                style: GoogleFonts.poppins(
                                    fontSize: 22, fontWeight: FontWeight.w600),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Verified ",
                                    style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green),
                                  ),
                                  Icon(
                                    Iconsax.tick_circle,
                                    size: 14,
                                    color: Colors.green,
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 5,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text("Account Overview",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 20),
                      ProfileMenuWidget(
                        title: 'Upload Image',
                        onpress: () {
                          BlocProvider.of<ProfileBloc>(context)
                              .add(NavigateToprofileUpdatePageEvent());
                        },
                        icon: Iconsax.document_upload,
                        color: Colors.green,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ProfileMenuWidget(
                        title: 'Delete Account',
                        onpress: () {},
                        icon: Iconsax.profile_delete,
                        color: Colors.purple,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ProfileMenuWidget(
                        title: 'Logout',
                        onpress: () {
                          BlocProvider.of<ProfileBloc>(context)
                              .add(LouOutEvent());
                        },
                        icon: Iconsax.logout_1,
                        color: Colors.lightBlueAccent,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ProfileMenuWidget(
                        title: 'Invite Friend',
                        onpress: () {},
                        // icon: Ionicons.share_outline,
                        icon: Iconsax.share,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: "Your personal messagge are ",
                    style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  ),
                  TextSpan(
                    text: "end-to-end-encrypted",
                    style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.blue),
                  ),
                ])),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          );
        }
        return Scaffold();
      },
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onpress;
  final Color color;

  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onpress,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onpress,
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
        ),
        child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                icon,
                color: color,
              ),
            )),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
      ),
      trailing: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100), color: Colors.grey[100]),
        child: const Icon(Iconsax.arrow_right_3),
      ),
    );
  }
}
