// ignore_for_file: prefer_const_constructor, import_of_legacy_library_into_null_safe, use_build_context_synchronously
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mztrackertodo/functions/variabels.dart';
import 'EditProfile.dart';
import 'LoginPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool light = true;
  bool light2 = true;
  bool light3 = true;
  static final _googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          // leading: const Icon(
          //   Icons.chevron_left,
          //   color: Colors.black,
          //   size: 35,
          // ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () async {
                  await _googleSignIn.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: Icon(
                  Icons.logout,
                  color: blackclr,
                  size: 25,
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: StreamBuilder(
              stream: null,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.40,
                        ),
                        Center(
                          child: CircularProgressIndicator(
                            color: MainTextColor,
                          ),
                        )
                      ],
                    ),
                  );
                }
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AvatarGlow(
                          endRadius: 70,
                          glowColor: Colors.black,
                          duration: const Duration(seconds: 2),
                          child: Container(
                            margin: const EdgeInsets.all(15),
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                  image: NetworkImage(box.read("profile")),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Center(
                      child: Text(
                        "Saravanan",
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: blackclr),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 20),
                            height: MediaQuery.of(context).size.height * 0.09,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(61, 23, 24, 25)
                                      .withOpacity(0.3),
                                  spreadRadius: 0,
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // ignore: prefer_const_constructors
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, left: 8),
                                  // ignore: prefer_const_constructors
                                  child: Icon(
                                    Icons.crisis_alert_outlined,
                                    color:
                                        const Color.fromARGB(255, 2, 120, 255),
                                  ),
                                ),
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            "Complete Task",
                                            style: GoogleFonts.roboto(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: blackclr),
                                          )),
                                      // ignore: prefer_const_constructors
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "2.2k",
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: blackclr),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20),
                            height: MediaQuery.of(context).size.height * 0.09,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(61, 23, 24, 25)
                                      .withOpacity(0.3),
                                  spreadRadius: 0,
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 8, left: 8),
                                  child: Icon(
                                    Icons.join_inner_outlined,
                                    color: Color.fromARGB(255, 255, 42, 42),
                                  ),
                                ),
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text(
                                          "Pending Task",
                                          style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: blackclr),
                                        ),
                                      ),
                                      // ignore: prefer_const_constructors
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "2.2k",
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: blackclr),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.37,
                      width: MediaQuery.of(context).size.width * 0.85,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(61, 23, 24, 25)
                                .withOpacity(0.3),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 20),
                            child: Row(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                // ignore: prefer_const_constructors
                                Icon(
                                  Icons.notifications_active,
                                  // ignore: prefer_const_constructors
                                  color: Color.fromARGB(255, 255, 42, 42),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 05),
                                  child: Text(
                                    "Notification",
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: blackclr),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.height * 0.13,
                                ),
                                Switch(
                                  // This bool value toggles the switch.
                                  value: light,
                                  activeColor: MainTextColor,
                                  onChanged: (bool value) {
                                    // This is called when the user toggles the switch.
                                    setState(() {
                                      light = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 20),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.light_mode,
                                  color: Color.fromARGB(255, 255, 42, 42),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 05),
                                  child: Text(
                                    "Theme",
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: blackclr),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.height * 0.18,
                                ),
                                Switch(
                                  // This bool value toggles the switch.
                                  value: light2,
                                  activeColor: MainTextColor,
                                  onChanged: (bool value) {
                                    // This is called when the user toggles the switch.
                                    setState(() {
                                      light2 = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4, left: 20),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.fingerprint,
                                  color: Color.fromARGB(255, 255, 42, 42),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 05),
                                  child: Text(
                                    "Biometric unlock",
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: blackclr),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.height * 0.08,
                                ),
                                Switch(
                                  // This bool value toggles the switch.
                                  value: light3,
                                  activeColor: MainTextColor,
                                  onChanged: (bool value) {
                                    // This is called when the user toggles the switch.
                                    setState(() {
                                      light3 = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 20),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const EditProfile()),
                                );
                              },
                              child: Row(
                                children: [
                                  // ignore: prefer_const_constructors
                                  Icon(
                                    Icons.edit,
                                    color:
                                        const Color.fromARGB(255, 255, 42, 42),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 05),
                                    child: Text(
                                      "Edit Profile",
                                      style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: blackclr),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.height *
                                        0.17,
                                  ),
                                  // ignore: prefer_const_constructors
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    size: 35,
                                    color:
                                        const Color.fromARGB(255, 255, 42, 42),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 9, left: 20),
                            child: Row(
                              children: [
                                // ignore: prefer_const_constructors
                                Icon(
                                  Icons.share_outlined,
                                  color: const Color.fromARGB(255, 255, 42, 42),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 05),
                                  child: Text(
                                    "Share",
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: blackclr),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.height * 0.21,
                                ),
                                // ignore: prefer_const_constructors
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 40,
                                  color: const Color.fromARGB(255, 255, 42, 42),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "V.1.0",
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: blackclr),
                        )
                      ],
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }
}
