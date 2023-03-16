import 'package:estudy/screens/register/register.dart';
import 'package:estudy/shared/constant.dart';
import 'package:flutter/material.dart';

import '../login/login.dart';

class Opsi extends StatelessWidget {
  const Opsi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: Constant(context).height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/4.png',
                  scale: 3,
                )
              ],
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: ((context) => Login())));
                  },
                  child: Container(
                    width: Constant(context).width * 0.8,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Masuk',
                                style: TextStyle(
                                    fontFamily: 'Acme',
                                    fontSize: 18,
                                    color: Color(0xff247881),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.2),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => Register())));
                          },
                          child: Container(
                            width: Constant(context).width * 0.43,
                            height: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromARGB(255, 223, 222, 222),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Daftar",
                                  style: TextStyle(
                                      fontFamily: 'Acme',
                                      fontSize: 18,
                                      color: Color(0xff247881),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.2),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
            SizedBox(
              height: Constant(context).height * 0.1,
            )
          ],
        ),
      ),
    );
  }
}
