import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estudy/screens/chat/contact/add_contact.dart';
import 'package:estudy/screens/chat/roomchat/roomchat.dart';
import 'package:estudy/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  String? uid;

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

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
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
          'Kontak',
          style:
              TextStyle(color: Colors.black, fontFamily: 'Acme', fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  height: 50,
                  width: Constant(context).width * 0.9,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(158, 221, 221, 221).withOpacity(1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      hintStyle: TextStyle(fontSize: 17),
                      // hintText: title,
                      hintText: "Cari Kontak",
                      border: InputBorder.none,
                      // prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                      contentPadding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 15,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AddContact()));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      size: 30,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Tambah Kontak',
                      style: TextStyle(
                        fontFamily: 'Acme',
                        letterSpacing: 1.2,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Daftar Kontak',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('contacts')
                      .where('isConfirm', isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          ...snapshot.data!.docs.map(
                            (e) {
                              return InkWell(
                                  onTap: () async {
                                    // DocumentReference<Map<String, dynamic>>
                                    //     docRef = await FirebaseFirestore
                                    //         .instance
                                    //         .collection("chats")
                                    //         .add({
                                    //   'createdAt': Timestamp.now(),
                                    //   'participants': FieldValue.arrayUnion(
                                    //       [uid, e.get('id')]),
                                    // });
                                    // Navigator.of(context)
                                    //     .pushReplacement(MaterialPageRoute(
                                    //         builder: (context) => RoomChat(
                                    //               chatRef: docRef,
                                    //               uid: e.id,
                                    //             )));
                                    showGeneralDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      barrierLabel: '',
                                      transitionDuration:
                                          Duration(milliseconds: 100),
                                      pageBuilder:
                                          (context, animation1, animation2) {
                                        dContext = context;
                                        return Container();
                                      },
                                      transitionBuilder: (BuildContext context,
                                          a1, a2, widget) {
                                        dContext = context;
                                        return Center(
                                            child: CircularProgressIndicator());
                                      },
                                    );
                                    FirebaseFirestore.instance
                                        .collection("chats")
                                        .where('participants',
                                            arrayContains: uid)
                                        .get()
                                        .then((doc) async {
                                      print(doc.docs.length);
                                      bool ada = false;

                                      for (var i = 0; i < doc.size; i++) {
                                        if (doc.docs[i]
                                            .data()['participants']
                                            .toString()
                                            .contains(e.get('id'))) {
                                          ada = true;

                                          Navigator.of(dContext).pop();

                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RoomChat(
                                                        chatRef: doc
                                                            .docs[i].reference,
                                                        uid: e.get('id'),
                                                        name: e.get('name'),
                                                      )));
                                          break;
                                        }
                                      }
                                      if (!ada) {
                                        showGeneralDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          barrierLabel: '',
                                          transitionDuration:
                                              Duration(milliseconds: 100),
                                          pageBuilder: (context, animation1,
                                              animation2) {
                                            dContext = context;
                                            return Container();
                                          },
                                          transitionBuilder:
                                              (BuildContext context, a1, a2,
                                                  widget) {
                                            dContext = context;
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          },
                                        );
                                        DocumentReference<Map<String, dynamic>>
                                            docRef = await FirebaseFirestore
                                                .instance
                                                .collection("chats")
                                                .add({
                                          'createdAt': Timestamp.now(),
                                          'participants': FieldValue.arrayUnion(
                                              [uid, e.get('id')]),
                                        });
                                        Navigator.of(dContext).pop();
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => RoomChat(
                                                      chatRef: docRef,
                                                      uid: e.get('id'),
                                                      name: e.get('name'),
                                                    )));
                                      }
                                    });
                                  },
                                  child: StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(e.id)
                                        .snapshots(),
                                    builder: (context, snapshots) {
                                      return ListContact(
                                          name: snapshots.data!.get('name'),
                                          profile:
                                              snapshots.data!.get('profile'));
                                    },
                                  ));
                            },
                          )
                        ],
                      );
                    }
                    return SizedBox();
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class ListContact extends StatelessWidget {
  final String name;
  final String profile;
  const ListContact({
    required this.name,
    required this.profile,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 5),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                image: profile != ''
                    ? DecorationImage(
                        image: NetworkImage(profile), fit: BoxFit.cover)
                    : DecorationImage(
                        image: AssetImage("assets/img/default.png"),
                        scale: 4,
                      ),
                color: Color.fromARGB(255, 255, 255, 255),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      fontFamily: 'Acme', letterSpacing: 1, fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )
          ],
        ),
        Divider(
          thickness: 1,
        )
      ],
    );
  }
}
