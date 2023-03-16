import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estudy/screens/profile/card_profile.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';
import '../../shared/constant.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: Constant(context).width,
              height: Constant(context).height * 0.43,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: Constant(context).height * 0.03,
                  ),
                  Positioned(
                    left: 0,
                    top: MediaQuery.of(context).viewPadding.top,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                        )),
                  ),
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .snapshots(),
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
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
                                          image: AssetImage(
                                              "assets/img/default.png"),
                                          scale: 4.5,
                                        ),
                                  border: Border.all(
                                      width: 10, color: secondaryColor),
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Text(
                                snapshot.data!.get('name'),
                                style: TextStyle(
                                    fontFamily: "Acme",
                                    fontSize: 20,
                                    letterSpacing: 1.2),
                              ),
                              Text(
                                snapshot.data!.get('email'),
                                style: TextStyle(
                                    fontFamily: "Acme",
                                    fontSize: 14,
                                    color: Colors.grey,
                                    letterSpacing: 1.2),
                              ),
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
                      }),
                ],
              ),
            ),
            FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .get(),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    UserModel users = UserModel.fromData(snapshot.data!);
                    return Column(
                      children: [
                        CardProfile(
                          title: 'Nama Lengkap',
                          desc: users.name,
                        ),
                        CardProfile(
                          title: 'Umur',
                          desc: users.age.toString(),
                        ),
                        CardProfile(
                          title: 'Tanggal Lahir',
                          desc: users.ttl,
                        ),
                        CardProfile(
                          title: 'Jenis Kelamin',
                          desc: users.gender,
                        ),
                        SizedBox(
                          height: 20,
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
                }),
          ],
        ),
      ),
    );
  }
}
