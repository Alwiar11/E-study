import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estudy/screens/class/class.dart';
import 'package:estudy/screens/home/top_home.dart';
import 'package:estudy/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'container_class.dart';
import 'create_class.dart';
import 'notifikasi.dart';

class HomePage extends StatefulWidget {
  final String? uid;
  const HomePage({required this.uid, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List searchResult = [];

  void searchFromFirebase(String query) async {
    final result = await FirebaseFirestore.instance
        .collection('class')
        .where('kelas', isEqualTo: query)
        .get();

    setState(() {
      searchResult = result.docs.map((e) => e.data()).toList();
    });
  }

  String? uid;
  String? name;
  bool isSearch = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUid();
    dContext = context;
  }

  late BuildContext dContext;
  getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    name = prefs.getString('name');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    TextEditingController searchController = TextEditingController();
    print(uid);
    return Scaffold(
        floatingActionButton: SpeedDial(
          overlayColor: Colors.black,
          overlayOpacity: 0.6,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          activeBackgroundColor: Colors.black,
          activeForegroundColor: Colors.white,
          icon: Icons.add,
          activeIcon: Icons.close,
          spacing: 3,
          mini: false,
          childPadding: const EdgeInsets.all(5),
          spaceBetweenChildren: 4,
          childrenButtonSize: Size(60, 60),
          visible: true,
          direction: SpeedDialDirection.up,
          switchLabelPosition: false,
          children: [
            SpeedDialChild(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CreateClass()));
                },
                backgroundColor: primaryColor,
                label: 'Buat Kelas',
                child: Icon(
                  Icons.add_box_outlined,
                  size: 30,
                )),
            SpeedDialChild(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Container(
                            height: 150,
                            width: 350,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Masukkan Kode Kelas'),
                                  ],
                                ),
                                TextField(
                                  controller: controller,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'Batal',
                                          style: TextStyle(color: Colors.black),
                                        )),
                                    InkWell(
                                      onTap: () {
                                        FirebaseFirestore.instance
                                            .collection('class')
                                            .doc(controller.text.toString())
                                            .set({
                                          'participants':
                                              FieldValue.arrayUnion([uid]),
                                          'participantsName':
                                              FieldValue.arrayUnion([name])
                                        }, SetOptions(merge: true));
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        width: 70,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            color: secondaryColor,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Gabung',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
                backgroundColor: primaryColor,
                label: 'Gabung Kelas',
                child: Icon(
                  Icons.class_outlined,
                  size: 30,
                ))
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SafeArea(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      uid != null
                          ? StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                    children: [
                                      snapshot.data!.get('profile') == ''
                                          ? Container(
                                              width: 35,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.account_circle,
                                                color: Colors.black,
                                                size: 30,
                                              ),
                                            )
                                          : Container(
                                              width: 35,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          snapshot.data!
                                                              .get('profile')),
                                                      fit: BoxFit.cover)),
                                            )
                                    ],
                                  );
                                }
                                return CircularProgressIndicator(
                                  color: Colors.red,
                                );
                              })
                          : Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.account_circle,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                      Container(
                        height: 40,
                        width: Constant(context).width * 0.7,
                        decoration: BoxDecoration(
                          color:
                              Color.fromARGB(158, 221, 221, 221).withOpacity(1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextFormField(
                          onChanged: (query) {
                            searchFromFirebase(query);
                          },
                          keyboardType: TextInputType.name,
                          controller: searchController,
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.search),
                            hintStyle: TextStyle(fontSize: 17),
                            // hintText: title,
                            hintText: 'Cari di E-study',
                            border: InputBorder.none,
                            // prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .collection('contacts')
                            .where('isConfirm', isEqualTo: false)
                            .where('sender', isNotEqualTo: widget.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.docs.length > 0) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Notifikasi()));
                                },
                                child: Icon(
                                  Icons.notifications_active,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              );
                              return Text(
                                  snapshot.data!.docs.length.toString());
                            } else {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Notifikasi()));
                                },
                                child: Icon(
                                  Icons.notifications,
                                  size: 30,
                                ),
                              );
                              return Text(
                                  snapshot.data!.docs.length.toString());
                            }
                          }
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Notifikasi()));
                            },
                            child: Icon(
                              Icons.notifications,
                              size: 30,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              uid != null
                  ? StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('class')
                          .where("participants", arrayContains: uid)
                          .snapshots(),
                      builder: (_, snapshotss) {
                        if (snapshotss.hasData) {
                          return Column(
                            children: [
                              ...snapshotss.data!.docs.map((e) {
                                return InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => Class(
                                              nama: e.get('kelas') != null
                                                  ? e.get('kelas')
                                                  : CircularProgressIndicator(),
                                              classId: e.id,
                                              owner: e.get('owner'))));
                                    },
                                    child: uid != null
                                        ? ClassContainer(
                                            kelas: e.get('kelas'),
                                            image: 'assets/img/5.png',
                                            idClass: e.id)
                                        : CircularProgressIndicator());
                              })
                            ],
                          );
                        }
                        return SizedBox();
                      })
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    )
            ],
          ),
        ));
  }
}
