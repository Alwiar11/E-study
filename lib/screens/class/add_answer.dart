import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estudy/shared/constant.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAnswer extends StatefulWidget {
  final String classId;
  final String taskId;
  final String title;
  const AddAnswer(
      {required this.classId,
      required this.title,
      required this.taskId,
      super.key});

  @override
  State<AddAnswer> createState() => _AddAnswerState();
}

class _AddAnswerState extends State<AddAnswer> {
  String? uid;
  String? name;
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
    name = prefs.getString('name');

    setState(() {});
  }

  String getFileName(File file) {
    return file.path.split('/').last;
  }

  File? file;
  File? file2;

  @override
  Widget build(BuildContext context) {
    String classId = widget.classId;
    String taskId = widget.taskId;
    String title = widget.title;
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
            'Kirim Jawaban',
            style: TextStyle(fontFamily: 'Acme', color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('class')
                      .doc(widget.classId)
                      .collection('task')
                      .doc(widget.taskId)
                      .collection('answer')
                      .where('sender', isEqualTo: uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                        child: ElevatedButton(
                            onPressed: () {
                              selectFile();
                              setState(() {
                                file;
                              });
                            },
                            child: Column(
                              children: [Text('Pilih Lampiran')],
                            )),
                      );
                    }
                    return SizedBox();
                  }),
              SizedBox(
                height: Constant(context).height * 0.1,
              ),
              file == null
                  ? Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Kosong',
                            style: TextStyle(
                                fontFamily: 'Acme',
                                letterSpacing: 1,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            getFileName(file!),
                            style: TextStyle(
                                fontFamily: 'Acme',
                                letterSpacing: 1,
                                fontSize: 18,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
              SizedBox(
                height: Constant(context).height * 0.1,
              ),
              InkWell(
                onTap: () {
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: false,
                    barrierLabel: '',
                    transitionDuration: Duration(milliseconds: 100),
                    pageBuilder: (context, animation1, animation2) {
                      dContext = context;
                      return Container();
                    },
                    transitionBuilder: (BuildContext context, a1, a2, widget) {
                      dContext = context;
                      return Center(child: CircularProgressIndicator());
                    },
                  );
                  if (file != null) {
                    FirebaseStorage.instance
                        .ref(
                            'class/$classId/$taskId/$uid/${getFileName(file!)}')
                        .putFile(File(file!.path))
                        .then((result) async {
                      String downloadUrl = await result.ref.getDownloadURL();

                      DocumentReference<Map<String, dynamic>> docRef =
                          await FirebaseFirestore.instance
                              .collection('class')
                              .doc(widget.classId)
                              .collection('task')
                              .doc(taskId)
                              .collection('answer')
                              .add({
                        'file': downloadUrl,
                        'sendAt': Timestamp.now(),
                        'sender': uid,
                        'senderName': name,
                        'fileName': getFileName(file!),
                      });
                      Navigator.of(dContext).pop();
                      Navigator.of(context).pop();
                    });
                  }
                },
                child: Container(
                  width: 250,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: secondaryColor),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Simpan',
                        style: TextStyle(
                            fontFamily: 'Acme',
                            letterSpacing: 1,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Constant(context).height * 0.1,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('class')
                      .doc(widget.classId)
                      .collection('task')
                      .doc(widget.taskId)
                      .collection('answer')
                      .where('sender', isEqualTo: uid)
                      .snapshots(),
                  builder: (context, snapshots) {
                    if (snapshots.hasData) {
                      return Column(
                        children: [
                          Text(
                            "Terkirim",
                            style: TextStyle(
                                fontFamily: 'Acme',
                                letterSpacing: 1,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: Constant(context).height * 0.02,
                          ),
                          ...snapshots.data!.docs.map(
                            (e) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 10),
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.8,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      e.get('fileName'),
                                      style: TextStyle(
                                          fontFamily: 'Acme',
                                          letterSpacing: 1,
                                          fontSize: 18,
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }
                    return SizedBox();
                  })
            ],
          ),
        ));
  }

  Future selectFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      file = File(result.files.single.path!);
      print(file);
      setState(() {
        file;
      });
    } else {}
  }
}
