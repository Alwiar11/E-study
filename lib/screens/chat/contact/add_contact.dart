import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estudy/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  TextEditingController controller = TextEditingController();
  String? uid;
  String? name;
  String? selectedValue;
  bool isSelectedValue = false;
  late BuildContext dContext;

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Tambah Kontak',
            style: TextStyle(
                color: Colors.black, fontFamily: "Acme", fontSize: 22),
          ),
          backgroundColor: primaryColor,
          automaticallyImplyLeading: false,
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
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(
                      height: Constant(context).height * 0.1,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/img/userAdd.png',
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
                                'Email',
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
                              controller: controller,
                              keyboardType: TextInputType.name,
                              // controller: controller,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 17),
                                // hintText: title,
                                border: InputBorder.none,
                                // prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                                contentPadding: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 7),
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
                                .collection('users')
                                .where('email',
                                    isEqualTo: controller.text.toString())
                                .get()
                                .then((value) {
                              value.docs.forEach((element) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(uid)
                                    .collection('contacts')
                                    .doc(element.id)
                                    .set({
                                  'id': element.id,
                                  'name': element.get('name'),
                                  'isConfirm': false,
                                  'email': element.get('email'),
                                  'sender': uid
                                }, SetOptions(merge: true));
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(uid)
                                    .get()
                                    .then((a) {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(element.id)
                                      .collection('contacts')
                                      .doc(uid)
                                      .set({
                                    'id': a.id,
                                    'name': a.get('name'),
                                    'isConfirm': false,
                                    'email': a.get('email'),
                                    'sender': uid
                                  }, SetOptions(merge: true));
                                  // Navigator.pop(dContext);
                                });
                              });
                            });

                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .get()
                                .then((value) {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(controller.text.toString())
                                  .collection('contacts')
                                  .add({
                                'id': value.id,
                                'name': value.get('name'),
                                'isConfirm': false
                              });
                            });
                            // Navigator.of(dContext).pop();
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: secondaryColor),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Tambahkan ',
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
            return Text('data');
          },
        ));
  }
}
