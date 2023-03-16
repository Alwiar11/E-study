import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estudy/screens/class/add_answer.dart';
import 'package:estudy/screens/class/answer_room.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/constant.dart';

class TaskRoom extends StatefulWidget {
  final String classId;
  final String taskId;
  final String owner;
  const TaskRoom(
      {required this.classId,
      required this.owner,
      required this.taskId,
      super.key});

  @override
  State<TaskRoom> createState() => _TaskRoomState();
}

class _TaskRoomState extends State<TaskRoom> {
  String formattedDate(Timestamp timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat(' EEE d MMM y ').format(dateFromTimeStamp);
  }

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
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: primaryColor,
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
            'Kelas PKK',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('class')
              .doc(widget.classId)
              .collection('task')
              .doc(widget.taskId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  width: Constant(context).width * 0.7,
                                  child: Text(
                                    snapshot.data!.get('title'),
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Masa Tenngat : ' +
                                  formattedDate(snapshot.data!.get('expired'))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      height: 1,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: Constant(context).height * 0.03,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              height: Constant(context).height * 0.45,
                              width: Constant(context).width * 0.75,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Text(snapshot.data!.get('desc'))],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          width: Constant(context).width * 0.75,
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: secondaryColor),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              uid != widget.owner
                                  ? InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => AddAnswer(
                                                      classId: widget.classId,
                                                      taskId: widget.taskId,
                                                      title: snapshot.data!
                                                          .get('title'),
                                                    )));
                                      },
                                      child: Text(
                                        'Kumpulkan Tugas',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontFamily: 'Acme',
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AnswerRoom(
                                                      classId: widget.classId,
                                                      taskId: widget.taskId,
                                                    )));
                                      },
                                      child: Text(
                                        'Lihat Jawaban',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontFamily: 'Acme',
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            }
            return SizedBox();
          },
        ));
  }
}
