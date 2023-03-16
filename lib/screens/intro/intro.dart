import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import '../../shared/constant.dart';

class Intro extends StatelessWidget {
  final Image image;
  final String title;
  final String desc;
  final double margin;

  const Intro({
    Key? key,
    required this.image,
    required this.margin,
    required this.title,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipPath(
          clipper: WaveClipperTwo(),
          child: Container(
            width: Constant(context).width,
            height: Constant(context).height * 0.5,
            color: primaryColor,
            child: Container(
                margin: EdgeInsets.only(bottom: margin), child: image),
          ),
        ),
        SizedBox(
          height: Constant(context).height * 0.01,
        ),
        Text(title,
            style: const TextStyle(
                fontFamily: 'Acme',
                fontSize: 28,
                letterSpacing: 2,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.center),
        SizedBox(
          height: Constant(context).height * 0.05,
        ),
        Text(
          desc,
          style: const TextStyle(
              fontFamily: 'Acme',
              letterSpacing: 1.5,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 91, 96, 101)),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: Constant(context).height * 0.1,
        ),
      ],
    );
  }
}
