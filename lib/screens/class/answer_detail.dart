import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estudy/screens/class/reader.dart';

import 'package:estudy/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnswerDetail extends StatefulWidget {
  final String classId;
  final String taskId;
  final String answerId;
  const AnswerDetail(
      {required this.answerId,
      required this.classId,
      required this.taskId,
      super.key});

  @override
  State<AnswerDetail> createState() => _AnswerDetailState();
}

class _AnswerDetailState extends State<AnswerDetail> {
  String formattedDate(Timestamp timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat(' EEE d MMM y H:m').format(dateFromTimeStamp);
  }

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('class')
                .doc(widget.classId)
                .collection('task')
                .doc(widget.taskId)
                .collection('answer')
                .doc(widget.answerId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Reader(
                                    file: snapshot.data!.get('file'),
                                  )));
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: secondaryColor),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                snapshot.data!.get('fileName'),
                                style: TextStyle(
                                    fontFamily: 'Acme',
                                    letterSpacing: 1,
                                    fontSize: 18,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                      Text(formattedDate(snapshot.data!.get('sendAt')))
                    ],
                  ),
                );
              }
              return Text("kosong");
            },
          )
        ],
      ),
    );
  }
}
