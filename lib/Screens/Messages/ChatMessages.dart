import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/messages.dart';
import 'package:personal_trainer/Screens/Messages/ChatPictureView.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';

class ChatMessages extends StatefulWidget {
  final String docID;
  ChatMessages({Key key, this.docID}) : super(key: key);

  @override
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  ///To select a picture
  File postImage;
  String profileImageView;
  StorageUploadTask _uploadTask;
  bool loadingImagetoSend = false;

  Future getImagefromGallery() async {
    PickedFile selectedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      postImage = File(selectedImage.path);
      print(postImage);
    });
  }

  Future getImagefromCamera() async {
    PickedFile selectedImage =
        await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      postImage = File(selectedImage.path);
    });
  }

  Future uploaMessage(BuildContext context) async {
    setState(() {
      loadingImagetoSend = true;
    });

    ////Upload to Clod Storage
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    String fileName =
        'Chat Photos/' + uid + '/' + DateTime.now().toString() + '.png';
    _uploadTask =
        FirebaseStorage.instance.ref().child(fileName).putFile(postImage);

    ///Save to Firestore
    var downloadUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();
    var imageUrl = downloadUrl.toString();
    DatabaseService().sendMessage(widget.docID, null, imageUrl);
    setState(() {
      _controller.clear();
      postImage = null;
      messageText = null;
      loadingImagetoSend = false;
    });
  }

  ///Message bubble if sender or receiver
  _buildMessage(Messages message, bool isMe, bool hasImage) {
    if (hasImage) {
      return Container(
          width: MediaQuery.of(context).size.width * 0.1,
          margin: isMe
              ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80)
              : EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[200] : Colors.blueGrey.shade900,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChatPictureView(image: message.image)));
            },
            child: Container(
              height: 150,
              width: 150,
              child: Image.network(message.image, fit: BoxFit.cover),
            ),
          ));
    } else if (message.type != null) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.1,
        margin: isMe
            ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80)
            : EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: isMe ? Colors.grey[200] : Colors.blueGrey.shade900,
          borderRadius: isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                  bottomLeft: Radius.circular(25.0))
              : BorderRadius.only(
                  topRight: Radius.circular(25.0),
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0)),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              //Customized Header
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      (message.type == 'Exercise')
                          ? Icon(Icons.fitness_center, color: isMe ? Colors.black : Colors.white, size: 20)
                          : Icon(Icons.calendar_today, color: isMe ? Colors.black : Colors.white, size: 20),
                      SizedBox(width: 15),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //Title
                            Container(
                                constraints: BoxConstraints(maxWidth: 150),
                                child: Text(
                                  message.headline,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isMe ? Colors.black : Colors.white),
                                )),
                            SizedBox(height: 5),
                            //SubTitle
                            Container(
                              constraints: BoxConstraints(maxWidth: 150),
                              child: Text(
                                message.subtitle,
                                style: GoogleFonts.montserrat(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w200,
                                      color: isMe ? Colors.black : Colors.white),
                              ),
                            )
                          ])
                    ]),
              ),
              (message.text != '' || message.text != null) ? SizedBox(height: 10) : SizedBox(),
              //Text Input
              (message.text != '' || message.text != null)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:<Widget>[
                    SizedBox(width: 35),
                    Container(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Text(
                        message.text,
                        style: GoogleFonts.montserrat(
                            color: isMe ? Colors.black : Colors.white, fontSize: 14),
                      ),
                    ),
                  ] 
                )
              : SizedBox(),
            ],
          ),
        ),
      );
    }
    return Container(
        width: MediaQuery.of(context).size.width * 0.1,
        margin: isMe
            ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80)
            : EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80),
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        decoration: BoxDecoration(
          color: isMe ? Colors.grey[200] : Colors.blueGrey.shade900,
          borderRadius: isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                  bottomLeft: Radius.circular(25.0))
              : BorderRadius.only(
                  topRight: Radius.circular(25.0),
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0)),
        ),
        child: Text(
          message.text,
          style: GoogleFonts.montserrat(
              color: isMe ? Colors.black : Colors.white, fontSize: 14),
        ));
  }

  ///For the message
  String messageText;
  var _controller = TextEditingController();

  ////////To load more messages when scrolling
  ScrollController _scrollController = ScrollController();
  List<Messages> messageList = [];

  _loadMoreMessages() async {
    print('_loadMoreMessages called');

    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection('Chat Rooms')
        .doc(widget.docID)
        .collection('Messages')
        .orderBy('Time', descending: true)
        .startAfter([messageList.last.time])
        .limit(10)
        .get(); //snapshots().map(_messagesListFromSnapshot);

    List<Messages> newList = qn.docs.map((doc) {
      return Messages(
        sender: doc.data()['Sender'] ?? '',
        text: doc.data()['Text'] ?? '',
        time: doc.data()['Time'].toDate(),
        docID: doc.id,
      );
    }).toList();

    setState(() {
      messageList.addAll(newList);
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        _loadMoreMessages();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _messages = Provider.of<List<Messages>>(context);
    final user = Provider.of<User>(context);

    messageList = _messages;

    if (_messages == null) {
      return Loading();
    } else if (postImage != null) {
      return WillPopScope(
        onWillPop: (){
           setState(() {
              postImage = null;
           });
           return null;
        },
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black,
            child: Stack(
              children: <Widget>[
                ///Loading
                loadingImagetoSend
                    ? Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: Center(child: Loading()))
                    : SizedBox(),

                ///Image
                Opacity(
                  opacity: loadingImagetoSend ? 0.2 : 1,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: double.infinity,
                      child: Image.file(postImage, fit: BoxFit.fitWidth),
                    ),
                  ),
                ),

                ///Buttons
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FloatingActionButton(
                              backgroundColor: Colors.redAccent[700],
                              child: Icon(Icons.close, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  postImage = null;
                                });
                              }),
                          SizedBox(width: 30),
                          FloatingActionButton(
                              backgroundColor: Theme.of(context).accentColor,
                              child: Icon(Icons.send, color: Colors.white),
                              onPressed: () {
                                uploaMessage(context);
                              }),
                        ]),
                  ),
                )
              ],
            )),
      );
    }

    return Column(children: <Widget>[
      ///Chat Messages Column
      Expanded(
        child: InkWell(
          onTap: () {
            //To dismiss keyboard
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
              color: Colors.white,
              child: ListView.builder(
                  itemCount: messageList.length,
                  physics: BouncingScrollPhysics(),
                  reverse: true,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    final message = messageList[index];
                    final bool isMe = message.sender == user.uid;
                    final bool hasImage = message.image != null;

                    return _buildMessage(message, isMe, hasImage);
                  })),
        ),
      ),

      ///Chat input row
      Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(12.0, 10, 12.0, 20.0),
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(color: Colors.grey, width: 0.8),
                boxShadow: <BoxShadow>[
                  new BoxShadow(
                    color: Colors.grey,
                    offset: new Offset(0.0, 3.0),
                    blurRadius: 5.0,
                  )
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ///Icons Button
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: InkWell(
                    onTap: () {
                      getImagefromCamera();
                    },
                    child: Container(
                        height: 40,
                        width: 35,
                        child: Center(
                            child: Icon(Icons.camera_alt,
                                color: Theme.of(context).canvasColor,
                                size: 20))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: InkWell(
                    onTap: () {
                      getImagefromGallery();
                    },
                    child: Container(
                        height: 40,
                        width: 35,
                        child: Icon(Icons.image,
                            color: Theme.of(context).canvasColor, size: 20)),
                  ),
                ),

                ///Input Text
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextField(
                    style: GoogleFonts.montserrat(fontSize: 14),
                    cursorColor: Theme.of(context).accentColor,
                    autofocus: false,
                    expands: false,
                    maxLines: null,
                    controller: _controller,
                    decoration: InputDecoration.collapsed(
                        hintText: "Mensaje...",
                        hintStyle:
                            TextStyle(color: Theme.of(context).canvasColor)),
                    onChanged: (value) {
                      setState(() => messageText = value);
                    },
                  ),
                ),

                Spacer(),

                ///Send Button
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: Icon(Icons.send,
                        color: Theme.of(context).accentColor, size: 20),
                    onPressed: () {
                      if (messageText != ""){
                          DatabaseService()
                              .sendMessage(widget.docID, messageText, null);
                          DatabaseService().updateChatDate(widget.docID);
                          setState(() {
                            _controller.clear();
                            messageText = null;
                        });
                      }
                    },
                  ),
                )
              ],
            )),
      ),
    ]);
  }
}
