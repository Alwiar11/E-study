import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estudy/screens/class/reader.dart';
import 'package:estudy/shared/constant.dart';
import 'package:flutter/material.dart';

class Book extends StatelessWidget {
  const Book({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Buku',
          style:
              TextStyle(color: Colors.black, fontFamily: 'Acme', fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  height: 50,
                  width: Constant(context).width * 0.9,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(158, 221, 221, 221).withOpacity(1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      hintStyle: TextStyle(fontSize: 17),
                      // hintText: title,
                      hintText: "Cari Buku",
                      border: InputBorder.none,
                      // prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                      contentPadding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 15,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('books')
                      .snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          ...snapshot.data!.docs.map((e) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        Reader(file: e.get('file'))));
                              },
                              child: CardBook(
                                fileName: e.get('fileName'),
                                file: e.get('file'),
                              ),
                            );
                          })
                        ],
                      );
                    }
                    return Text('Tidak Ada Buku');
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class CardBook extends StatelessWidget {
  final String file;
  final String fileName;
  const CardBook({
    required this.file,
    required this.fileName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15),
      margin: EdgeInsets.only(bottom: 5),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          border: Border.all(width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            fileName,
            style:
                TextStyle(fontFamily: 'Acme', letterSpacing: 1, fontSize: 16),
          )
        ],
      ),
    );
  }
}
