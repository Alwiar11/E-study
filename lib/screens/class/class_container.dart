import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estudy/screens/class/answer_room.dart';
import 'package:estudy/screens/home/home.dart';
import 'package:estudy/screens/task/add_task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/constant.dart';
import '../task/task_room.dart';
import 'comment/comment.dart';

class TaskContainer extends StatefulWidget {
  final String owner;
  final String classId;
  final String nama;
  const TaskContainer({
    required this.owner,
    required this.classId,
    required this.nama,
    Key? key,
  }) : super(key: key);

  @override
  State<TaskContainer> createState() => _TaskContainerState();
}

class _TaskContainerState extends State<TaskContainer> {
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

  String formattedDate(Timestamp timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat(' EEE d MMM y H:m').format(dateFromTimeStamp);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.owner);
    return Scaffold(
      floatingActionButton: widget.owner == uid
          ? FloatingActionButton(
              backgroundColor: primaryColor,
              child: Icon(
                Icons.add,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddTask(
                          classId: widget.classId,
                        )));
              },
            )
          : SizedBox(),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('class')
              .doc(widget.classId)
              .collection('task')
              .snapshots(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Column(
                  children: [
                    ...snapshot.data!.docs.map((e) => TaskCard(
                          title: e.get('title'),
                          expired: formattedDate(e.get('expired')),
                          date: formattedDate(e.get('createdAt')),
                          classId: widget.classId,
                          taskId: e.id,
                          owner: widget.owner,
                          nama: widget.nama,
                        ))
                  ],
                ),
              );
            }
            return SizedBox();
          }),
      // body: Center(
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       SizedBox(
      //         height: 20,
      //       ),
      //       TaskCard(
      //         title: 'Tugas Membuat Login',
      //         expired: '22 OKtober 2022, 09 : 00',
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

class TaskCard extends StatefulWidget {
  final String title;
  final String classId;
  final String taskId;
  final String expired;
  final String date;
  final String owner;
  final String nama;
  const TaskCard({
    required this.title,
    required this.classId,
    required this.taskId,
    required this.expired,
    required this.date,
    required this.nama,
    required this.owner,
    Key? key,
  }) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin: EdgeInsets.only(top: 20),
      width: Constant(context).width * 0.8,
      height: 130,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1.5, color: secondaryColor)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TaskRoom(
                          classId: widget.classId,
                          owner: widget.owner,
                          taskId: widget.taskId)));
                },
                child: Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 22,
                      overflow: TextOverflow.ellipsis,
                      fontFamily: "Acme",
                      letterSpacing: 1),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TaskRoom(
                      classId: widget.classId,
                      owner: widget.owner,
                      taskId: widget.taskId)));
            },
            child: Container(
              margin: EdgeInsets.only(top: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.date,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Acme",
                        color: Colors.grey,
                        letterSpacing: 1),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Divider(
                  thickness: 1,
                  color: secondaryColor,
                ),
              ),
            ],
          )),
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => CommentRoom(
                            classId: widget.classId,
                            taskId: widget.taskId,
                            owner: widget.owner,
                            title: widget.title,
                            task: widget.nama,
                          )));
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Text(
                    "Tambahkan Komentar",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Acme",
                        color: Colors.grey,
                        letterSpacing: 1),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
