import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estudy/screens/chat/contact/contact.dart';
import 'package:estudy/screens/chat/roomchat/roomchat.dart';
import 'package:estudy/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String? uid;
  late BuildContext dContext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUid();
    dContext = context;
  }

  getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');

    setState(() {});
  }

  String formattedDate(timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat(' hh:mm ').format(dateFromTimeStamp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Pesan',
          style: TextStyle(
              fontFamily: 'Acme',
              color: Colors.black,
              letterSpacing: 1.2,
              fontSize: 22),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Contact()));
            },
            child: Container(
                margin: EdgeInsets.only(right: 15),
                child: Icon(
                  Icons.person,
                  color: Colors.black,
                  size: 30,
                )),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: uid)
            .orderBy('lastChat', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: false,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, index) {
                  String friendId =
                      snapshot.data!.docs[index].get('participants')[0] == uid
                          ? snapshot.data!.docs[index].get('participants')[1]
                          : snapshot.data!.docs[index].get('participants')[0];

                  // return Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 25),
                  //   child: Column(
                  //     children: [
                  //       Center(
                  //         child: Container(
                  //           margin: EdgeInsets.only(top: 30),
                  //           height: 50,
                  //           width: Constant(context).width * 0.9,
                  //           decoration: BoxDecoration(
                  //             color: Color.fromARGB(158, 221, 221, 221)
                  //                 .withOpacity(1),
                  //             borderRadius: BorderRadius.circular(20),
                  //           ),
                  //           child: TextFormField(
                  //             keyboardType: TextInputType.name,
                  //             decoration: InputDecoration(
                  //               suffixIcon: Icon(
                  //                 Icons.search,
                  //                 color: Colors.grey,
                  //               ),
                  //               hintStyle: TextStyle(fontSize: 17),
                  //               // hintText: title,

                  //               border: InputBorder.none,
                  //               // prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                  //               contentPadding: EdgeInsets.only(
                  //                 left: 20,
                  //                 right: 20,
                  //                 top: 15,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         height: 25,
                  //       ),
                  //       ...snapshot.data!.docs.map((e) {
                  //         return InkWell(
                  //             onTap: () {
                  //               // Navigator.of(context).push(
                  //               //     MaterialPageRoute(builder: (context) => RoomChat()));
                  //             },
                  //             child: CardChat());
                  //       })
                  //     ],
                  //   ),
                  // );
                  return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(friendId)
                          .snapshots(),
                      builder: (context, friendData) {
                        if (!friendData.hasData) {
                          return SizedBox();
                        }
                        return StreamBuilder<
                                QuerySnapshot<Map<String, dynamic>>>(
                            stream: snapshot.data!.docs[index].reference
                                .collection('messages')
                                .orderBy('sendAt', descending: false)
                                .snapshots(),
                            builder: (_, chatData) {
                              if (chatData.hasData) {
                                if (chatData.data!.docs.length > 0) {
                                  return Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          showGeneralDialog(
                                            context: _,
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
                                              _;
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            },
                                          );
                                          FirebaseFirestore.instance
                                              .collection("chats")
                                              .where('participants',
                                                  arrayContains: uid)
                                              .get()
                                              .then((doc) {
                                            print(doc.docs.length);

                                            for (var i = 0; i < doc.size; i++) {
                                              if (doc.docs[i]
                                                  .data()['participants']
                                                  .toString()
                                                  .contains(friendId)) {
                                                Navigator.of(_).pop();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            RoomChat(
                                                              chatRef: doc
                                                                  .docs[i]
                                                                  .reference,
                                                              name: friendData
                                                                  .data!
                                                                  .get('name'),
                                                              uid: friendData
                                                                  .data!.id,
                                                            )));

                                                break;
                                              }
                                            }
                                          });
                                        },
                                        child: CardChat(
                                          name: friendData.data!.get('name'),
                                          lastChat: chatData.data!.docs.last
                                              .get('message'),
                                          date: formattedDate(chatData
                                              .data!.docs.last
                                              .get('sendAt')),
                                          profile:
                                              friendData.data!.get('profile'),
                                        ),
                                      )
                                    ],
                                  );
                                }
                              }
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [CircularProgressIndicator()],
                                ),
                              );
                            });
                      });
                });
            //
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator()],
            ),
          );
          ;
        },
      ),
    );
  }
}

class CardChat extends StatelessWidget {
  final String name;
  final String lastChat;
  final String date;
  final String profile;
  const CardChat({
    required this.name,
    required this.lastChat,
    required this.date,
    required this.profile,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: profile != ''
                        ? BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                            image: DecorationImage(
                                image: NetworkImage(profile),
                                fit: BoxFit.cover))
                        : BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                            image: DecorationImage(
                                image: AssetImage('assets/img/default.png'))),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(fontFamily: 'Acme', fontSize: 18),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          lastChat,
                          style: TextStyle(
                              fontFamily: 'Acme',
                              fontSize: 14,
                              color: Color.fromARGB(255, 147, 147, 147)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    date,
                    style: TextStyle(fontFamily: 'Acme', color: Colors.grey),
                  )
                ],
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Divider(
              height: 5,
              color: Colors.black,
              thickness: 1,
            ),
          )
        ],
      ),
    );
  }
}
