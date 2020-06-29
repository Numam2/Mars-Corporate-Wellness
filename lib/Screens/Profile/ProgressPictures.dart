import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Profile/ProgressPicDelete.dart';
import 'package:personal_trainer/Shared/Loading.dart';
import 'package:provider/provider.dart';

class ProgressPicturesPage extends StatefulWidget {

  @override
  _ProgressPicturesPageState createState() => _ProgressPicturesPageState();
}

class _ProgressPicturesPageState extends State<ProgressPicturesPage> {
  
  ///To select a picture
  File postImage;
  String profileImageView;
  StorageUploadTask _uploadTask;
  bool loadingImagetoSend = false;

  Future getImagefromGallery() async {
    File selectedImage =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      postImage = selectedImage;
      print(postImage);
    });
  }

  Future uploaPicture (BuildContext context) async {
    
    setState(() {
      loadingImagetoSend = true;     
    });

    ////Upload to Clod Storage
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      final String uid = user.uid.toString();

      String fileName = 'Profile Images/Progress Pictures/' + uid + DateTime.now().toString() + '.png';
      _uploadTask =
          FirebaseStorage.instance.ref().child(fileName).putFile(postImage);

      ///Save to Firestore
      var downloadUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();
      var imageUrl = downloadUrl.toString();
      DatabaseService().saveProgressPicture(imageUrl);

      setState(() {
        postImage = null;
        loadingImagetoSend = false;
      });    
  }


  @override
  Widget build(BuildContext context) {

    final _profile = Provider.of<ProgressPictureList>(context);

    if (_profile == null) {
      return Center(child: Loading());
    } else if (postImage != null){
      return Container(
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
                child: Center(child: Loading())
              )
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
                  children:<Widget>[

                    FloatingActionButton(
                      backgroundColor: Colors.redAccent[700],
                      child: Icon(
                        Icons.close,
                        color: Colors.white
                      ),
                      onPressed:(){
                        setState(() {
                          postImage = null;
                        });
                      }
                    ),
                    SizedBox(width:30),

                    FloatingActionButton(
                      backgroundColor: Theme.of(context).accentColor,
                      child: Icon(
                        Icons.save,
                        color: Colors.white
                      ),
                      onPressed: () {
                        uploaPicture(context);
                      }
                    ),
                    
                  ]
                ),
              ),
            )
        ],)
      );
    }

    return Scaffold(
      appBar: AppBar(        
        backgroundColor: Colors.white,          
        centerTitle: true,
        title: Text('Mi Progreso',
          style: Theme.of(context).textTheme.headline),
        leading:InkWell(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => getImagefromGallery(),
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: (_profile.progressPicturesList.length > 0 || _profile.progressPicturesList == null)
      ? ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: _profile.progressPicturesList.length,
          itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.symmetric(vertical:10.0),
              child: Container(
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    ///Header
                    Container(
                      height: 50,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal:20.0),
                      decoration: BoxDecoration(
                      color: Colors.white,
                      //border: Border.all(color: Colors.grey, width: 0.8),
                      boxShadow: <BoxShadow>[
                        new BoxShadow(
                          color: Colors.grey,
                          offset: new Offset(0.0, 3.0),
                          blurRadius: 5.0,
                        )
                      ]),
                      child: Row(
                        children: <Widget>[
                          Text(DateFormat.yMMMd().format(_profile.progressPicturesList[index].date).toString()),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.more_horiz, color: Colors.black),
                            onPressed: () {
                              return showDialog(
                                context: context,
                                  builder: (context) {
                                    return ProgressPicDelete(
                                      image:_profile.progressPicturesList[index].image,
                                      date: _profile.progressPicturesList[index].date,
                                    );
                                  });
                              },
                          )
                        ],
                      )
                    ),
                    ///Image
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(maxHeight: 400, minHeight: 150),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, width: 0.8),
                        boxShadow: <BoxShadow>[
                          new BoxShadow(
                            color: Colors.grey,
                            offset: new Offset(0.0, 3.0),
                            blurRadius: 5.0,
                          )
                      ]),
                      child: Image.network(_profile.progressPicturesList[index].image, fit: BoxFit.cover),
                    ),
                  ],
                )
              ),
            );
          }
        )
      : Center(
        child: Container(
          child: Icon(Icons.photo_size_select_actual, size: 100, color: Colors.grey[300]),
        ),
      )
    );
  }
}