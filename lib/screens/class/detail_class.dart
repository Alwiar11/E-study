import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estudy/screens/home/home.dart';
import 'package:estudy/shared/textfield.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailClass extends StatefulWidget {
  final String classId;
  final String className;
  final String owner;
  const DetailClass(
      {required this.classId,
      required this.className,
      required this.owner,
      super.key});

  @override
  State<DetailClass> createState() => _DetailClassState();
}

class _DetailClassState extends State<DetailClass> {
  TextEditingController nameController = TextEditingController();

  String? uid;

  @override
  void initState() {
    super.initState();
    getUid();
  }

  getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    await FirebaseFirestore.instance
        .collection("class")
        .doc(widget.classId)
        .get()
        .then((doc) {
      nameController = TextEditingController(text: doc.get('kelas'));
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    print(widget.owner);
    print(uid);
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          actions: [
            Container(
              margin: EdgeInsets.only(right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.owner == uid
                      ? InkWell(
                          onTap: () {
                            FirebaseFirestore.instance
                                .collection("class")
                                .doc(widget.classId)
                                .set({'kelas': nameController.text.toString()},
                                    SetOptions(merge: true));
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage(
                                          uid: uid,
                                        )));
                          },
                          child: Text(
                            "Simpan",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        )
                      : SizedBox()
                ],
              ),
            )
          ],
          elevation: 0,
          title: Text(
            'Kelas ' + widget.className,
            style: TextStyle(color: Colors.black),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
          ),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('class')
              .doc(widget.classId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                padding: EdgeInsets.only(left: 25, right: 25, top: 10),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    TextFieldss(
                      nameController: nameController,
                      owner: widget.owner,
                      uid: uid ?? '',
                    ),
                    Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Kode Kelas",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              widget.classId,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
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

class TextFieldss extends StatelessWidget {
  final TextEditingController nameController;
  final String owner;
  final String uid;
  const TextFieldss({
    required this.nameController,
    required this.owner,
    required this.uid,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      height: 60,
      color: Color.fromARGB(255, 188, 188, 188),
      child: TextField(
        readOnly: owner == uid ? false : true,
        controller: nameController,
        decoration: InputDecoration(
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            label: Text(
              'Nama Kelas',
              style: TextStyle(fontSize: 18),
            ),
            fillColor: Colors.amber,
            contentPadding: EdgeInsets.only(left: 10, top: 7),
            labelStyle: TextStyle(color: Colors.black)),
      ),
    );
  }
}
