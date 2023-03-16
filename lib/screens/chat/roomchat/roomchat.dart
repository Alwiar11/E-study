import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estudy/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RoomChat extends StatefulWidget {
  final DocumentReference<Map<String, dynamic>>? chatRef;
  final String uid;
  final String name;
  const RoomChat(
      {required this.chatRef,
      required this.uid,
      required this.name,
      super.key});

  @override
  State<RoomChat> createState() => _RoomChatState();
}

class _RoomChatState extends State<RoomChat> {
  TextEditingController messageController = TextEditingController();
  Future<DocumentReference<Map<String, dynamic>>>? chatId;
  String formattedDate(timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat(' hh:mm ').format(dateFromTimeStamp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        title: Text(
          widget.name,
          style: TextStyle(color: Colors.black, fontFamily: 'Acme'),
        ),
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: widget.chatRef
              ?.collection("messages")
              .orderBy('sendAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              return Container(
                margin: EdgeInsets.only(bottom: 70),
                child: ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.size,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.only(
                          left: 14, right: 14, top: 6, bottom: 6),
                      child: Align(
                        alignment: (snapshot.data!.docs[index]['receiverId'] ==
                                widget.uid
                            ? Alignment.topRight
                            : Alignment.topLeft),
                        child: snapshot.data!.docs[index]['type'] == 'text'
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: (snapshot.data!.docs[index]
                                              ['receiverId'] ==
                                          widget.uid
                                      ? secondaryColor
                                      : Color.fromARGB(255, 121, 121, 121)),
                                ),
                                padding: EdgeInsets.all(16),
                                child: Text.rich(TextSpan(
                                    text: snapshot.data!.docs[index]['message']
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '  ' +
                                              formattedDate(snapshot
                                                  .data!.docs[index]['sendAt']),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255)))
                                    ])))
                            : Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: (snapshot.data!.docs[index]
                                              ['receiverId'] ==
                                          widget.uid
                                      ? secondaryColor
                                      : Color.fromARGB(255, 255, 255, 255)),
                                ),
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Image.network(
                                      snapshot.data!.docs[index]['image'],
                                      height: 150,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                          formattedDate(snapshot
                                              .data!.docs[index]['sendAt']),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Color.fromARGB(
                                                  255, 255, 91, 91))),
                                    )
                                  ],
                                )),
                      ),
                    );
                  },
                ),
              );
            }
          }),
      bottomSheet: Container(
        width: double.infinity,
        height: 50,
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: Constant(context).width * 0.7,
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,
                    hintText: "Masukkan Pesan",
                    fillColor: Colors.amber,
                    contentPadding: EdgeInsets.only(
                      left: 10,
                    ),
                    labelStyle: TextStyle(color: Colors.black)),
              ),
            ),
            InkWell(
              onTap: () {
                if (messageController.text.isNotEmpty) {
                  chatId = widget.chatRef?.collection('messages').add({
                    'message': messageController.text,
                    'receiverId': widget.uid,
                    'sendAt': Timestamp.now(),
                    'receivername': widget.name,
                    'type': 'text'
                  });
                  messageController.clear();
                  widget.chatRef?.update({'lastChat': Timestamp.now()});
                }
                return null;
              },
              child: Container(
                margin: EdgeInsets.only(right: 15),
                child: Icon(Icons.send),
              ),
            )
          ],
        ),
      ),
    );
  }
}
