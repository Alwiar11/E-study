import 'package:flutter/material.dart';

import '../../shared/constant.dart';

class TextFields extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final TextInputType type;

  const TextFields({
    required this.controller,
    required this.title,
    required this.type,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        height: 45,
        width: Constant(context).width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
          keyboardType: type,
          controller: controller,
          decoration: InputDecoration(
            hintStyle: TextStyle(fontSize: 17),
            // hintText: title,
            labelText: title,
            labelStyle: TextStyle(color: secondaryColor, fontSize: 16),
            border: InputBorder.none,
            // prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          ),
        ),
      ),
    );
  }
}
