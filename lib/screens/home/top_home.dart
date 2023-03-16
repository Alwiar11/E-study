import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estudy/screens/home/notifikasi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/constant.dart';

class TopHome extends StatefulWidget {
  final String? uid;
  final TextEditingController controller;

  const TopHome({
    required this.uid,
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<TopHome> createState() => _TopHomeState();
}

class _TopHomeState extends State<TopHome> {
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

    setState(() {
      uid = prefs.getString('uid');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          widget.uid != null
              ? StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.uid)
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
                                              snapshot.data!.get('profile')),
                                          fit: BoxFit.cover)),
                                )
                        ],
                      );
                    }
                    return CircularProgressIndicator(
                      color: Colors.red,
                    );
                  })
              : Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        color: Colors.green,
                      )
                    ],
                  ),
                ),
          Container(
            height: 40,
            width: Constant(context).width * 0.7,
            decoration: BoxDecoration(
              color: Color.fromARGB(158, 221, 221, 221).withOpacity(1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextFormField(
              keyboardType: TextInputType.name,
              controller: widget.controller,
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.search),
                hintStyle: TextStyle(fontSize: 17),
                // hintText: title,
                hintText: 'Cari di E-study',
                border: InputBorder.none,
                // prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.uid)
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
                }
              }
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Notifikasi()));
                },
                child: Icon(
                  Icons.notifications,
                  size: 30,
                ),
              );
            },
          ),
          // InkWell(
          //   onTap: () {
          //     Navigator.of(context)
          //         .push(MaterialPageRoute(builder: (context) => Notifikasi()));
          //   },
          //   child: Icon(
          //     Icons.notifications,
          //     size: 30,
          //   ),
          // )
        ],
      ),
    );
  }
}
