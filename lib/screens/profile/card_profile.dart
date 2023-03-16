import 'package:flutter/material.dart';

import '../../shared/constant.dart';

class CardProfile extends StatelessWidget {
  final String title;
  final String desc;
  const CardProfile({
    Key? key,
    required this.title,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  margin: EdgeInsets.only(top: 15, bottom: 5),
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    title,
                    style: TextStyle(fontFamily: "Acme", fontSize: 18),
                  ))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                width: Constant(context).width * 0.9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: secondaryColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(desc,
                        style: TextStyle(
                            fontFamily: "Acme",
                            fontSize: 18,
                            letterSpacing: 1.2,
                            color: Colors.white)),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
