import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Home/Inicio_Navigate.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {
  final String groupName;
  final String type;
  final String headline;
  final String time;
  final IconData activityIcon;
  CreatePost(
      {this.groupName, this.type, this.headline, this.time, this.activityIcon});

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  var _controller = TextEditingController();
  String commentPost;

  File postImage;
  String profileImageView;
  StorageUploadTask _uploadTask;

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
      print(postImage);
    });
  }

  Future uploadPost(BuildContext context) async {
    if (postImage == null) {
      DatabaseService().createPost(widget.groupName, commentPost, '');
    } else {
      ////Upload to Clod Storage
      final User user = FirebaseAuth.instance.currentUser;
      final String uid = user.uid.toString();

      String fileName = 'Posts/' + uid + postImage.path + '.png';
      _uploadTask =
          FirebaseStorage.instance.ref().child(fileName).putFile(postImage);

      ///Save to Firestore
      var downloadUrl =
          await (await _uploadTask.onComplete).ref.getDownloadURL();
      var imageUrl = downloadUrl.toString();
      DatabaseService().createPost(widget.groupName, commentPost, imageUrl);
    }
  }

  Future uploadSharedPost(BuildContext context) async {
    if (postImage == null) {
      DatabaseService().createSharedPost(widget.groupName, commentPost, '', widget.type, widget.headline, widget.time);   
    } else {
      ////Upload to Clod Storage
      final User user = FirebaseAuth.instance.currentUser;
      final String uid = user.uid.toString();

      String fileName = 'Posts/' + uid + postImage.path + '.png';
      _uploadTask =
          FirebaseStorage.instance.ref().child(fileName).putFile(postImage);

      ///Save to Firestore
      var downloadUrl =
          await (await _uploadTask.onComplete).ref.getDownloadURL();
      var imageUrl = downloadUrl.toString();
      DatabaseService().createSharedPost(widget.groupName, commentPost, imageUrl, widget.type, widget.headline, widget.time); 
    }
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserProfile>(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
          title: Text('Compartir', style: Theme.of(context).textTheme.headline),
          actions: <Widget>[
            InkWell(
                onTap: () {
                  if((widget.type == null || widget.headline == null || widget.time == null)){
                    uploadPost(context);
                    DatabaseService().recordOrganizationStats(_user.organization, 'Feed Posts');
                    Navigator.of(context).pop();
                  } else {
                    uploadSharedPost(context);
                    DatabaseService().recordOrganizationStats(_user.organization, 'Feed Posts');
                    Navigator.push(context,
                     MaterialPageRoute(builder: (context) => InicioNew()));
                  }
                },
                child: Container(
                  height: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                    child: Text('Publicar',
                        style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor)),
                  ),
                )),
          ],
        ),
        body: Container(
            child: Column(
          children: <Widget>[
            ///Input section
            Expanded(
                child: SingleChildScrollView(
                    child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ///User name and picture
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        children: <Widget>[
                          ///Image
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey[100],
                            child: ClipOval(
                              child: Container(
                                  height: 50,
                                  width: 50,
                                  child: Image.network(_user.profilePic,
                                      fit: BoxFit.cover)),
                            ),
                          ),
                          SizedBox(width: 20),

                          ///Name and Group
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _user.name,
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 3),
                              (_user.about == null || _user.about == '')
                                  ? Text(
                                      'Compartir en ' + widget.groupName,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black),
                                    )
                                  : Text(
                                      _user.about,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black),
                                    )
                            ],
                          ),
                        ],
                      ),
                    ),

                    (widget.type == null ||
                            widget.headline == null ||
                            widget.time == null)
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    (widget.type == 'Exercise')
                                        ? Icon(Icons.fitness_center,
                                            color: Colors.black, size: 20)
                                        : Icon(Icons.calendar_today,
                                            color: Colors.black, size: 20),
                                    SizedBox(width: 15),
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.75),
                                              child: Text(
                                                widget.headline,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .display1,
                                              )),
                                          SizedBox(height: 5),
                                          Text(
                                            widget.time,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display2,
                                          ),
                                        ])
                                  ]),
                            ),
                          ),

                    ///Text Input
                    Container(
                      width: double.infinity,
                      child: TextField(
                        style: GoogleFonts.montserrat(
                            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                        cursorColor: Theme.of(context).accentColor,
                        autofocus: true,
                        expands: false,
                        maxLines: null,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1500)
                        ],
                        controller: _controller,
                        decoration: InputDecoration.collapsed(
                          hintText:
                              "Empieza una conversación en " + widget.groupName,
                          hintStyle: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w400)
                        ),
                        onChanged: (value) {
                          setState(() => commentPost = value);
                        },
                      ),
                    ),

                    (postImage == null)
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Column(children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.cancel),
                                  onPressed: () {
                                    setState(() {
                                      postImage = null;
                                    });
                                  }),
                              Container(
                                constraints: BoxConstraints(maxHeight: 400),
                                width: double.infinity,
                                child:
                                    Image.file(postImage, fit: BoxFit.fitWidth),
                              ),
                            ]),
                          )
                  ]),
            ))),

            ///Select Photos
            Container(
              height: 50,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    child: Icon(Icons.camera_alt),
                    onTap: () {
                      getImagefromCamera();
                    },
                  ),
                  SizedBox(width: 25),
                  InkWell(
                    child: Icon(Icons.photo_library),
                    onTap: () {
                      getImagefromGallery();
                    },
                  ),
                ],
              ),
            ),
          ],
        )));
  }
}
