import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estudy/home_page.dart';
import 'package:estudy/screens/home/home.dart';
import 'package:estudy/shared/button.dart';
import 'package:estudy/shared/textfield.dart';
import 'package:estudy/shared/textfield_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/constant.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dContext = context;
  }

  late BuildContext dContext;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
                height: Constant(context).height * 0.05,
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
              TextFieldPassword(
                controller: passwordController,
                title: 'Password',
                type: TextInputType.name,
              ),
              Container(
                margin: EdgeInsets.only(left: 30, top: 5, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Lupa Kata Sandi?',
                      style: TextStyle(
                          fontFamily: 'Acme',
                          fontSize: 14,
                          letterSpacing: 1,
                          color: Color(0xff247881)),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  try {
                    final credential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passwordController.text.toString());
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: false,
                      barrierLabel: '',
                      transitionDuration: Duration(milliseconds: 100),
                      pageBuilder: (context, animation1, animation2) {
                        dContext = context;
                        return Container();
                      },
                      transitionBuilder:
                          (BuildContext context, a1, a2, widget) {
                        dContext = context;
                        return Center(child: CircularProgressIndicator());
                      },
                    );
                    Navigator.of(dContext).pop;
                    String uid = FirebaseAuth.instance.currentUser!.uid;
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .get()
                        .then((doc) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('uid', uid);
                      prefs.setString('name', doc.get('name'));
                    });

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                        (route) => false);
                  } on FirebaseAuthException catch (e) {
                    print(e);
                    if (e.code == 'user-not-found') {
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
                              Text('User not found'),
                            ],
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      print('object');
                    } else if (e.code == 'wrong-password') {
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
                              Text('Password wrong'),
                            ],
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      print('Wrong password provided for that user.');
                      print('object');
                    } else if (emailController.text.isEmpty ||
                        passwordController.text.isEmpty) {
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
                  } catch (e) {
                    print(e);
                  }
                },
                child: Button(
                    height: 6,
                    width: Constant(context).width * 0.023,
                    color: Color(0xff247881),
                    textColor: Colors.white,
                    text: "Masuk"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
