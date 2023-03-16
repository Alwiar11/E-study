import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../shared/constant.dart';

class MemberContainer extends StatelessWidget {
  final String classId;
  const MemberContainer({
    required this.classId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('class')
          .doc(classId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.get('participantsName').length,
              itemBuilder: (context, index) {
                return CardMember(
                    name: snapshot.data!.get('participantsName')[index]);
              });
        }
        return SizedBox();
      },
    );
  }
}

class CardMember extends StatelessWidget {
  final String name;
  const CardMember({
    required this.name,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 45,
              width: 45,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: secondaryColor),
            ),
            Row(
              children: [Text(name)],
            )
          ],
        ),
        Divider(
          thickness: 1,
          color: Color.fromARGB(255, 100, 100, 100),
        )
      ],
    );
  }
}
