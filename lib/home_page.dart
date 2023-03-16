import 'package:bottom_bar/bottom_bar.dart';
import 'package:estudy/screens/account/account.dart';
import 'package:estudy/screens/book/book.dart';
import 'package:estudy/screens/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home/home.dart';
import 'shared/constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? uid;
  String? name;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUid();
    dContext = context;
  }

  late BuildContext dContext;
  getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    name = prefs.getString('name');
    setState(() {});
  }

  int _currentPage = 0;
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          HomePage(
            uid: uid,
          ),
          Book(),
          Chat(),
          Account()
        ],
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
      ),
      bottomNavigationBar: BottomBar(
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        selectedIndex: _currentPage,
        onTap: (int index) {
          _pageController.jumpToPage(index);
          setState(() => _currentPage = index);
        },
        items: const <BottomBarItem>[
          BottomBarItem(
            icon: Icon(Icons.home),
            title: Text('Beranda'),
            activeColor: secondaryColor,
            activeIconColor: secondaryColor,
            activeTitleColor: secondaryColor,
          ),
          BottomBarItem(
            icon: Icon(Icons.menu_book_outlined),
            title: Text('Buku'),
            activeColor: secondaryColor,
            activeIconColor: secondaryColor,
            activeTitleColor: secondaryColor,
          ),
          BottomBarItem(
            icon: Icon(Icons.chat_sharp),
            title: Text('Pesan'),
            activeColor: secondaryColor,
            activeIconColor: secondaryColor,
            activeTitleColor: secondaryColor,
          ),
          BottomBarItem(
            icon: Icon(Icons.person_rounded),
            title: Text('Akun Saya'),
            activeColor: secondaryColor,
            activeIconColor: secondaryColor,
            activeTitleColor: secondaryColor,
          ),
        ],
      ),
    );
  }
}
