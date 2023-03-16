import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estudy/shared/constant.dart';
import 'package:flutter/material.dart';

import 'answer_detail.dart';

class AnswerRoom extends StatefulWidget {
  final String classId;
  final String taskId;
  const AnswerRoom({required this.classId, required this.taskId, super.key});

  @override
  State<AnswerRoom> createState() => _AnswerRoomState();
}

class _AnswerRoomState extends State<AnswerRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
        title: Text(
          'Jawaban',
          style: TextStyle(fontFamily: 'Acme', color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.only(left: 25, right: 25, top: 15),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            //   CardAnswer(),
            //   CardAnswer(),
            //   CardAnswer(),
            //   CardAnswer(),
            //   CardAnswer(),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('class')
                    .doc(widget.classId)
                    .collection('task')
                    .doc(widget.taskId)
                    .collection('answer')
                    .snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        ...snapshot.data!.docs.map((e) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AnswerDetail(
                                      classId: widget.classId,
                                      taskId: widget.taskId,
                                      answerId: e.id)));
                            },
                            child: CardAnswer(
                                name: e.get('senderName'),
                                uid: e.get('sender')),
                          );
                        })
                      ],
                    );
                  }
                  return SizedBox();
                })
          ]),
        ),
      ),
    );
  }
}

class CardAnswer extends StatelessWidget {
  final String name;
  final String uid;
  const CardAnswer({
    required this.name,
    required this.uid,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 10),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: secondaryColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(
                fontFamily: 'Acme', fontSize: 18, color: Colors.white),
          )
        ],
      ),
    );
  }
}
