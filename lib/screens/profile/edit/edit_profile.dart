import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estudy/shared/constant.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/image_picker.dart';
import '../../class/detail_class.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController ttlController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  String? uid;
  File? newProfile;
  File? newProfileTemp;
  late BuildContext dContext;

  @override
  void initState() {
    super.initState();
    getUid();
  }

  getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = await prefs.getString('uid');
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((doc) {
      nameController = TextEditingController(text: doc.get('name'));
      ttlController = TextEditingController(text: doc.get('ttl'));
      genderController = TextEditingController(text: doc.get('gender'));
      ageController = TextEditingController(text: doc.get('age').toString());
    });
    setState(() {});
  }

  showLoading({required BuildContext context}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 100),
      pageBuilder: (context, animation1, animation2) {
        dContext = context;
        return Container();
      },
      transitionBuilder: (BuildContext context, a1, a2, widget) {
        dContext = context;
        return WillPopScope(
            onWillPop: () async => true,
            child: Center(child: CircularProgressIndicator()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(uid);
    return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Edit Profile',
            style: TextStyle(color: Colors.black, fontFamily: 'Acme'),
          ),
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
          ),
        ),
        body: uid != null
            ? StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        padding: EdgeInsets.only(top: 15),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              height: Constant(context).height * 0.28,
                              width: Constant(context).width * 0.4,
                              decoration: newProfile == null
                                  ? BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      image: snapshot.data!.get("profile") != ""
                                          ? DecorationImage(
                                              image: NetworkImage(snapshot.data!
                                                  .get("profile")),
                                              fit: BoxFit.cover)
                                          : DecorationImage(
                                              image: AssetImage(
                                                  "assets/img/default.png"),
                                              scale: 4.5),
                                      border: Border.all(
                                          width: 10, color: secondaryColor))
                                  : BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: FileImage(newProfile!),
                                          fit: BoxFit.cover)),
                            ),
                            InkWell(
                              onTap: () async {
                                newProfile = (await AppImagePicker(context)
                                    .getImageGallery());
                                showLoading(context: context);

                                if (newProfile != null) {
                                  newProfileTemp = await newProfile;
                                  await FirebaseStorage.instance
                                      .ref('users/$uid/pfp.png')
                                      .putFile(newProfile!)
                                      .then((result) async {
                                    // Navigator.of(_).pop();
                                    String downloadUrl =
                                        await result.ref.getDownloadURL();

                                    // Simpan downloadUrl di collection user
                                    // teapal colletiona soalna
                                    await FirebaseFirestore.instance
                                        .doc("users/$uid")
                                        .set({
                                      "profile": downloadUrl,
                                    }, SetOptions(merge: true)).then((value) {
                                      Navigator.pop(dContext);
                                    });
                                  });
                                }
                                setState(() {});
                              },
                              child: Container(
                                width: 140,
                                height: 45,
                                decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Ubah Foto Profile',
                                      style: TextStyle(
                                          fontFamily: 'Acme',
                                          fontSize: 16,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            CardEditProfile(
                              title: 'Nama Lengkap',
                              controller: nameController,
                            ),
                            CardEditProfile(
                              title: 'Umur',
                              controller: ageController,
                            ),
                            CardEditProfile(
                              title: 'Tanggal Lahir',
                              controller: ttlController,
                            ),
                            CardEditProfile(
                              title: 'Jenis Kelamin',
                              controller: genderController,
                            ),
                            InkWell(
                              onTap: () {
                                // showLoading(context: dContext);
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(uid)
                                    .set({
                                  'name': nameController.text.toString().trim(),
                                  'umur':
                                      int.parse(ageController.text.toString()),
                                  'ttl': ttlController.text.toString().trim(),
                                  'gender':
                                      genderController.text.toString().trim(),
                                }, SetOptions(merge: true));
                                // Navigator.of(dContext).pop();
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: 100,
                                height: 45,
                                decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Simpan',
                                      style: TextStyle(
                                          fontFamily: 'Acme',
                                          fontSize: 16,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  return CircularProgressIndicator();
                },
              )
            : CircularProgressIndicator());
  }
}

class CardEditProfile extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  const CardEditProfile({
    required this.controller,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(left: 25),
                  child: Text(
                    title,
                    style: TextStyle(fontFamily: 'Acme', fontSize: 16),
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Constant(context).width * 0.9,
                height: 45,
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: controller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
