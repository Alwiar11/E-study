import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../shared/constant.dart';

class AddTask extends StatefulWidget {
  final String classId;
  const AddTask({required this.classId, super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime dateTime = DateTime.now();

  selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      dateTime = picked;
      //assign the chosen date to the controller
      dateController.text = DateFormat('EEE d MMM y').format(dateTime);
    }
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   titleController.dispose();
  //   descController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambahkan Tugas',
          style: TextStyle(
              color: Colors.black, fontFamily: 'Acme', letterSpacing: 1.2),
        ),
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
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 15, bottom: 5),
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            'Judul',
                            style: TextStyle(fontFamily: "Acme", fontSize: 18),
                          ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          width: Constant(context).width * 0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromARGB(255, 183, 183, 183)),
                          child: TextField(
                            controller: titleController,
                            maxLines: 2,
                            decoration:
                                InputDecoration(border: InputBorder.none),
                          ))
                    ],
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 15, bottom: 5),
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            'Deskripsi',
                            style: TextStyle(fontFamily: "Acme", fontSize: 18),
                          ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 150,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          width: Constant(context).width * 0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromARGB(255, 183, 183, 183)),
                          child: TextField(
                            controller: descController,
                            maxLines: 6,
                            decoration:
                                InputDecoration(border: InputBorder.none),
                          ))
                    ],
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 15, bottom: 5),
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            'Masa Tenggat',
                            style: TextStyle(fontFamily: "Acme", fontSize: 18),
                          ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          width: Constant(context).width * 0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromARGB(255, 183, 183, 183)),
                          child: TextField(
                            controller: dateController,
                            readOnly: true,
                            onTap: selectDate,
                            decoration:
                                InputDecoration(border: InputBorder.none),
                          ))
                    ],
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                FirebaseFirestore.instance
                    .collection('class')
                    .doc(widget.classId)
                    .collection('task')
                    .add({
                  'title': titleController.text.toString(),
                  'desc': descController.text.toString(),
                  'expired': Timestamp.fromDate(dateTime),
                  'createdAt': Timestamp.now()
                });
                Navigator.of(context).pop();
              },
              child: Container(
                margin: EdgeInsets.only(top: 20),
                width: 150,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: primaryColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tambah',
                      style: TextStyle(
                          fontFamily: 'Acme',
                          fontSize: 18,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
