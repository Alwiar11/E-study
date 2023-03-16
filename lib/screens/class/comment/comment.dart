import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/constant.dart';
import '../../task/task_room.dart';

class CommentRoom extends StatefulWidget {
  final String classId;
  final String taskId;
  final String owner;
  final String title;
  final String task;
  const CommentRoom(
      {required this.classId,
      required this.owner,
      required this.taskId,
      required this.title,
      required this.task,
      super.key});

  @override
  State<CommentRoom> createState() => _CommentRoomState();
}

class _CommentRoomState extends State<CommentRoom> {
  String? uid;
  String? name;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUid();
  }

  getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    name = prefs.getString('name');
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  String formattedDate(Timestamp timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat(' EEE d MMM y H:m').format(dateFromTimeStamp);
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Kelas " + widget.title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          width: Constant(context).width * 0.7,
                          child: Text(
                            widget.task,
                            style: TextStyle(
                                fontFamily: 'Acme',
                                fontSize: 20,
                                letterSpacing: 1.2),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => TaskRoom(
                                    owner: widget.owner,
                                    classId: widget.classId,
                                    taskId: widget.taskId,
                                  )));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 35,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromARGB(255, 0, 160, 16)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Lihat Tugas',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Divider(
              thickness: 1,
              height: 1,
              color: Colors.black,
            ),
            SizedBox(
              height: Constant(context).height * 0.01,
            ),
            Container(
              padding: EdgeInsets.only(left: 25, right: 25, bottom: 50),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Komentar Kelas',
                        style: TextStyle(
                            fontFamily: "Acme",
                            fontSize: 16,
                            color: Color.fromARGB(255, 90, 90, 90)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Constant(context).height * 0.03,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('class')
                          .doc(widget.classId)
                          .collection('comments')
                          .orderBy('sendAt', descending: true)
                          .snapshots(),
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              ...snapshot.data!.docs.map((e) {
                                return CardComment(
                                  comment: e.get('comment'),
                                  name: e.get('senderName'),
                                  date: formattedDate(e.get('sendAt')),
                                  sender: e.get('sender'),
                                  uid: uid ?? '',
                                );
                              })
                            ],
                          );
                        }
                        return CircularProgressIndicator();
                      })
                ],
              ),
            )
          ],
        ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(border: Border.all(width: 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: Constant(context).width * 0.7,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,
                    hintText: "Masukkan Komentar",
                    fillColor: Colors.amber,
                    contentPadding: EdgeInsets.only(
                      left: 10,
                    ),
                    labelStyle: TextStyle(color: Colors.black)),
              ),
            ),
            InkWell(
              onTap: () {
                FirebaseFirestore.instance
                    .collection('class')
                    .doc(widget.classId)
                    .collection('comments')
                    .add({
                  'sendAt': Timestamp.now(),
                  'senderName': name,
                  'sender': uid,
                  'comment': controller.text.toString()
                });
                controller.clear();
              },
              child: Container(
                margin: EdgeInsets.only(right: 15),
                child: Icon(Icons.send),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CardComment extends StatelessWidget {
  final String comment;
  final String name;
  final String date;
  final String uid;
  final String sender;
  const CardComment({
    required this.comment,
    required this.date,
    required this.name,
    required this.uid,
    required this.sender,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      width: Constant(context).width * 0.9,
      decoration: sender != uid
          ? BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(15))
          : BoxDecoration(
              color: primaryColor,
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          sender != uid
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        right: 10,
                      ),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.amber),
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'Acme',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    )
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'Acme',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 10,
                      ),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.amber),
                    ),
                  ],
                ),
          SizedBox(
            height: Constant(context).height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: Constant(context).width * 0.8,
                  child: Text(
                    comment,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 110, 110, 110)),
                  ))
            ],
          ),
          SizedBox(
            height: Constant(context).height * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(date),
              SizedBox(
                width: Constant(context).width * 0.04,
              ),
            ],
          )
        ],
      ),
    );
  }
}
