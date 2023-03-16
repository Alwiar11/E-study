import 'dart:ui';

import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:estudy/home_page.dart';
import 'package:estudy/screens/class/class_container.dart';
import 'package:estudy/screens/class/detail_class.dart';
import 'package:estudy/screens/class/member_container.dart';
import 'package:estudy/shared/constant.dart';
import 'package:flutter/material.dart';

class Class extends StatefulWidget {
  final String nama;
  final String classId;
  final String owner;
  const Class(
      {required this.nama,
      required this.classId,
      required this.owner,
      super.key});

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      widget.classId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailClass(
                        classId: widget.classId,
                        className: widget.nama,
                        owner: widget.owner,
                      )));
            },
            child: Container(
              margin: EdgeInsets.only(right: 15),
              child: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
            ),
          )
        ],
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen()),
                (route) => false);
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Kelas " + widget.nama,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.white,
        width: Constant(context).width,
        height: Constant(context).height,
        child: ContainedTabBarView(
          tabBarProperties: TabBarProperties(indicatorColor: Colors.black),
          tabs: [
            Text(
              'Postingan',
              style: TextStyle(color: Colors.black),
            ),
            Text(
              'Anggota',
              style: TextStyle(color: Colors.black),
            ),
          ],
          views: [
            TaskContainer(
              owner: widget.owner,
              classId: widget.classId,
              nama: widget.nama,
            ),
            MemberContainer(
              classId: widget.classId,
            )
          ],
          onChange: (index) => print(index),
        ),
      ),
    );
  }
}
