import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estudy/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifikasi extends StatefulWidget {
  const Notifikasi({super.key});

  @override
  State<Notifikasi> createState() => _NotifikasiState();
}

class _NotifikasiState extends State<Notifikasi> {
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
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Notifikasi',
          style: TextStyle(
              color: Colors.black, fontFamily: 'Acme', letterSpacing: 1),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: Constant(context).height * 0.05,
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .collection('contacts')
                .where('isConfirm', isEqualTo: false)
                .where('sender', isNotEqualTo: uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    ...snapshot.data!.docs.map((e) {
                      return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .where('email', isEqualTo: e.get('email'))
                              .snapshots(),
                          builder: (_, snapshots) {
                            if (snapshots.hasData) {
                              return Column(
                                children: [
                                  ...snapshots.data!.docs.map((user) {
                                    print(user.get('name'));

                                    return Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: CardRequest(
                                        name: user.get('name'),
                                        profile: user.get('profile'),
                                        contactId: e.id,
                                        uid: uid,
                                        userID: user.id,
                                      ),
                                    );
                                    return Text(user.id);
                                  })
                                ],
                              );
                            }
                            return Text('tidak ada data');
                          });
                    })
                  ],
                );
              }
              return Text('data');
            },
          ),
        ],
      ),
    );
  }
}

class CardRequest extends StatelessWidget {
  final String profile;
  final String name;
  final String contactId;
  final String? uid;
  final String userID;

  const CardRequest({
    required this.name,
    required this.profile,
    required this.contactId,
    required this.uid,
    required this.userID,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  profile != ''
                      ? Container(
                          margin: EdgeInsets.only(right: 10, top: 5),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              image: DecorationImage(
                                  image: NetworkImage(profile),
                                  fit: BoxFit.cover)),
                        )
                      : Container(
                          margin: EdgeInsets.only(right: 10, top: 5),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/img/default.png',
                                ),
                              )),
                        ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(uid)
                                    .collection('contacts')
                                    .doc(contactId)
                                    .update({'isConfirm': true});
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userID)
                                    .collection('contacts')
                                    .doc(uid)
                                    .update({'isConfirm': true});
                              },
                              child: Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.close,
                              color: Colors.red,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
          Divider(
            thickness: 2,
          )
        ],
      ),
    );
  }
}
