import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:estudy/home_page.dart';
import 'package:estudy/screens/home/home.dart';
import 'package:estudy/shared/button.dart';
import 'package:estudy/shared/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/constant.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  List<String> listGender = ["Laki Laki", "Perempuan"];
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController ttlController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  DateTime dateTime = DateTime.now();
  selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1990),
        lastDate: DateTime(2101));
    if (picked != null) {
      dateTime = picked;
      //assign the chosen date to the controller
      ttlController.text = DateFormat('EEE d MMM y').format(dateTime);
    }
  }

  final List<String> items = [
    'Laki Laki',
    'Perempuan',
  ];
  String? selectedValue;
  late BuildContext dContext;
  showLoading({required BuildContext context}) {
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
        return WillPopScope(
            onWillPop: () async => true,
            child: Center(child: CircularProgressIndicator()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: Constant(context).height * 0.01,
              ),
              Center(
                child: Image.asset(
                  'assets/img/1.png',
                  scale: 4,
                ),
              ),
              SizedBox(
                height: Constant(context).height * 0.009,
              ),
              TextFields(
                controller: emailController,
                title: 'Email',
                type: TextInputType.name,
              ),
              TextFields(
                controller: passwordController,
                title: 'Password',
                type: TextInputType.name,
              ),
              TextFields(
                controller: nameController,
                title: 'Nama Lengkap',
                type: TextInputType.name,
              ),
              TextFields(
                controller: ageController,
                title: 'Umur',
                type: TextInputType.number,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  height: 45,
                  width: Constant(context).width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextFormField(
                    readOnly: true,
                    onTap: selectDate,
                    controller: ttlController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 17),
                      labelText: 'Tanggal Lahir',
                      labelStyle:
                          TextStyle(color: secondaryColor, fontSize: 16),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  height: 45,
                  width: Constant(context).width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        hint: Text(
                          'Jenis Kelamin',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: items
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value as String;
                          });
                        },
                        buttonHeight: 40,
                        buttonWidth: 140,
                        itemHeight: 40,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  if (ageController.text.toString().isNotEmpty &&
                      emailController.text.toString().isNotEmpty &&
                      passwordController.text.toString().isNotEmpty &&
                      nameController.text.toString().isNotEmpty &&
                      ttlController.text.toString().isNotEmpty) {
                    try {
                      final credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: emailController.text.toString(),
                        password: passwordController.text.toString(),
                      );
                      showLoading(context: context);
                      String uid = FirebaseAuth.instance.currentUser!.uid;
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString(
                        'uid',
                        FirebaseAuth.instance.currentUser!.uid,
                      );
                      prefs.setString('name', nameController.text.toString());

                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .set({
                        'name': nameController.text.toString(),
                        'age': int.parse(ageController.text.trim()),
                        'ttl': ttlController.text.toString().trim(),
                        'gender': selectedValue.toString().trim(),
                        'email': emailController.text.toString().trim(),
                        'profile': ''
                      });
                      Navigator.pop(dContext);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (route) => false);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        final snackBar = SnackBar(
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                            content: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.info,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                Text('Minimal Password 6 character'),
                              ],
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        print('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        final snackBar = SnackBar(
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 1),
                            content: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.info,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                Text('The email already'),
                              ],
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        print('The account already exists for that email.');
                      }
                    } catch (e) {
                      print(e);
                    }
                  } else {
                    final snackBar = SnackBar(
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 1),
                        content: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.info,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                            Text('Tidak Boleh Kosong'),
                          ],
                        ));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(top: 15, bottom: 25),
                  child: Button(
                      height: 6,
                      width: Constant(context).width * 0.023,
                      color: Color(0xff247881),
                      textColor: Colors.white,
                      text: "Daftar"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
