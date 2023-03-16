import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estudy/shared/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_string/random_string.dart';
import '../../shared/textfield.dart';

class CreateClass extends StatefulWidget {
  const CreateClass({super.key});

  @override
  State<CreateClass> createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  String? uid;
  String? name;
  TextEditingController nameController = TextEditingController();
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
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Buat Kelas',
          style:
              TextStyle(color: Colors.black, fontFamily: "Acme", fontSize: 24),
        ),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.close,
            size: 35,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: Constant(context).height * 0.1,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/6.png',
                scale: 2,
              ),
            ],
          ),
          SizedBox(
            height: Constant(context).height * 0.1,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Nama Kelas',
                      style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Acme'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  height: 45,
                  width: Constant(context).width * 0.9,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    color: Colors.white.withOpacity(1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    controller: nameController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 17),
                      // hintText: title,
                      border: InputBorder.none,
                      // prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                      contentPadding:
                          EdgeInsets.only(left: 20, right: 20, bottom: 7),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  FirebaseFirestore.instance
                      .collection('class')
                      .doc(randomNumeric(6))
                      .set({
                    'kelas': nameController.text.toString(),
                    'owner': uid,
                    'createdAt': Timestamp.now(),
                    'participants': FieldValue.arrayUnion(
                      [uid],
                    ),
                    'participantsName': FieldValue.arrayUnion(
                      [name],
                    ),
                  });
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: secondaryColor),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Simpan',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )
                    ],
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
