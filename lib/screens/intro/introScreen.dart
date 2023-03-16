import 'package:estudy/screens/opsi/opsi.dart';
import 'package:flutter/material.dart';

import '../../shared/button.dart';
import '../../shared/constant.dart';
import 'intro.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int _currentPage = 0;
  _onChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    PageController _controller = PageController();

    List<Widget> _pages = [
      Intro(
        image: Image.asset(
          "assets/img/1.png",
          scale: 3,
        ),
        title: "SELAMAT DATANG \nDI E-STUDY",
        desc: "Belajar Jadi Lebih Nyaman dan Seru",
        margin: 0,
      ),
      Intro(
        image: Image.asset(
          "assets/img/2.png",
          scale: 3,
        ),
        title: "BANGKIT & SEMANGAT!",
        desc: "Prestasi Tidak Bisa Diraih Tanpa \nSemangat",
        margin: 0,
      ),
      Intro(
        image: Image.asset(
          "assets/img/3.png",
          scale: 3,
        ),
        title: "BELAJAR LEBIH GIAT!",
        desc:
            "Jangan Berpikir Hidup Akan Mudah,\n Jika Belajar saja Masih Susah",
        margin: 40,
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: _onChanged,
            itemBuilder: (context, int index) {
              return _pages[index];
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(_pages.length, (int index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: Constant(context).height * 0.015,
                    width: (index == _currentPage)
                        ? Constant(context).width * 0.07
                        : Constant(context).width * 0.03,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: (index == _currentPage)
                            ? Color(0xff247881)
                            : primaryColor.withOpacity(0.5)),
                  );
                }),
              ),
              SizedBox(
                height: Constant(context).height * 0.06,
              ),
              Row(
                mainAxisAlignment: _currentPage == (_pages.length - 1)
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceEvenly,
                children: [
                  (_currentPage == (_pages.length - 1)
                      ? const SizedBox()
                      : InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Opsi()),
                            );
                          },
                          child: Button(
                              height: Constant(context).height / 100,
                              width: Constant(context).width / 100,
                              color: Color(0xffB9D2D2),
                              textColor: Color(0xff247881),
                              text: "Lewati"))),
                  InkWell(
                    onTap: () {
                      _controller.nextPage(
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOutQuint);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: Constant(context).height * 0.08,
                      alignment: Alignment.center,
                      width: Constant(context).width * 0.38,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: (_currentPage == (_pages.length - 1)
                          ? InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Opsi()),
                                );
                              },
                              child: Button(
                                  height: Constant(context).height / 100,
                                  width: Constant(context).height / 100,
                                  color: Color(0xff247881),
                                  textColor: Colors.white,
                                  text: "Masuk"),
                            )
                          : Button(
                              height: Constant(context).height / 100,
                              width: Constant(context).width / 100,
                              color: Color(0xff247881),
                              textColor: Colors.white,
                              text: "Selanjutnya")),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Constant(context).height * 0.06,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
