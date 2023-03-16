import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estudy/screens/profile/edit/edit_profile.dart';
import 'package:estudy/screens/profile/profile.dart';
import 'package:estudy/shared/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/login.dart';
import 'sign_out_function.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String? uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUid();
  }

  getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          Container(
              width: Constant(context).width,
              height: Constant(context).height * 0.4,
              color: Colors.white,
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            height: Constant(context).height * 0.28,
                            width: Constant(context).width * 0.4,
                            decoration: BoxDecoration(
                              image: snapshot.data!.get("profile") != ""
                                  ? DecorationImage(
                                      image: NetworkImage(
                                          snapshot.data!.get("profile")),
                                      fit: BoxFit.cover)
                                  : DecorationImage(
                                      image:
                                          AssetImage("assets/img/default.png"),
                                      scale: 4.5,
                                    ),
                              border:
                                  Border.all(width: 10, color: secondaryColor),
                              color: Color.fromARGB(255, 255, 255, 255),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              snapshot.data!.get('name'),
                              style:
                                  TextStyle(fontFamily: "Acme", fontSize: 20),
                            )
                          ],
                        )
                      ],
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        strokeWidth: 5,
                        color: secondaryColor,
                      )
                    ],
                  );
                },
              )),
          SizedBox(
            height: 5,
          ),
          Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Profile()));
                },
                child: CardAccount(
                  title: 'Profile Saya',
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => EditProfile()));
                },
                child: CardAccount(
                  title: 'Edit Profile',
                ),
              ),
              InkWell(
                onTap: () async {
                  // SignOut(context).signout();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            title: Text(
                              'Peringatan!',
                              style: TextStyle(color: Colors.amber),
                            ),
                            content: Text("Apakah Anda Yakin?"),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text(
                                  'Kembali',
                                  style: TextStyle(color: secondaryColor),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  SignOut(context).signout();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => Login()),
                                      (route) => false);
                                },
                                child: const Text('OK',
                                    style: TextStyle(color: secondaryColor)),
                              ),
                            ],
                          ));
                },
                child: CardAccount(
                  title: 'Keluar',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CardAccount extends StatelessWidget {
  final String title;
  const CardAccount({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            width: Constant(context).width * 0.9,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: secondaryColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    style: TextStyle(
                        fontFamily: "Acme", fontSize: 18, color: Colors.white)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
