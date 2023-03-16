import 'package:flutter/material.dart';

import '../../shared/constant.dart';

class ClassContainer extends StatelessWidget {
  final String kelas;
  final String idClass;
  final String image;
  const ClassContainer({
    required this.kelas,
    required this.image,
    required this.idClass,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 10),
      margin: EdgeInsets.only(right: 25, left: 25, top: 10),
      height: 160,
      width: Constant(context).width,
      decoration: BoxDecoration(
          // image: DecorationImage(
          //     image: AssetImage('assets/img/5.png'), scale: 3),
          color: Color(0xff43919B),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Kelas " + kelas,
                style: TextStyle(
                    fontFamily: 'Acme',
                    letterSpacing: 1,
                    fontSize: 18,
                    color: Colors.white),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(right: 15),
                child: Image.asset(
                  image,
                  scale: 2.5,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
