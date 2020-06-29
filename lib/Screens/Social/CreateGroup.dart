import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';

class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  String newGroupName;
  String groupDescription;
  File groupImage;
  StorageUploadTask _uploadTask;

  Future getImage() async {
    File selectedImage =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      groupImage = selectedImage;
      print(groupImage);
    });
  }

  Future uploadGroup(BuildContext context) async {
    String fileName = 'Group Images/' + newGroupName + '.png';
    _uploadTask =
        FirebaseStorage.instance.ref().child(fileName).putFile(groupImage);

    ///Save to Firestore
    var downloadUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();
    var imageUrl = downloadUrl.toString();
    print(imageUrl);
    DatabaseService().createGroup(newGroupName, imageUrl, groupDescription,
        setSearchParam(newGroupName.toLowerCase()));
    DatabaseService().addMyGroup(newGroupName);
    
    //Close
    Navigator.of(context).pop();
  }

  setSearchParam(String caseNumber) {
    List<String> caseSearchList = List();
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title:
            Text('Crea un Grupo', style: Theme.of(context).textTheme.headline),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ///Select Picture
              Container(
                height: 150,
                width: 150,
                child: Stack(children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[100],
                      child: ClipOval(
                        child: Container(
                            height: 120,
                            width: 120,
                            child: !(groupImage == null)
                                ? Image.file(groupImage, fit: BoxFit.cover)
                                : Icon(Icons.group,
                                    color: Colors.black, size: 40)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                          icon: Icon(Icons.camera_enhance,
                              color: Colors.black),
                          color: Colors.white,
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.only(top: 8),
                          iconSize: 30,
                          onPressed: getImage,
                      ),
                    ),
                  )
                ]),
              ),
              SizedBox(height: 30),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ///Group Name
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      "Nombre",
                      style: Theme.of(context).textTheme.body1,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(color: Colors.grey, width: 0.8)),
                    child: TextFormField(
                      style: Theme.of(context).textTheme.body1,
                      textAlign: TextAlign.start,
                      inputFormatters: [LengthLimitingTextInputFormatter(35)],
                      cursorColor: Theme.of(context).accentColor,
                      decoration: InputDecoration.collapsed(
                        hintText: "",
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                      ),
                      onChanged: (val) {
                        setState(() => newGroupName = val);
                      },
                    ),
                  ),
                  SizedBox(height: 30),

                  ///Group Description
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      "Descripción",
                      style: Theme.of(context).textTheme.body1,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 100,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(color: Colors.grey, width: 0.8)),
                    child: TextFormField(
                      style: Theme.of(context).textTheme.body1,
                      textAlign: TextAlign.start,
                      maxLines: null,
                      inputFormatters: [LengthLimitingTextInputFormatter(125)],
                      cursorColor: Theme.of(context).accentColor,
                      decoration: InputDecoration.collapsed(
                        hintText: "",
                        hintStyle:
                            TextStyle(color: Theme.of(context).canvasColor),
                      ),
                      onChanged: (val) {
                        setState(() => groupDescription = val);
                      },
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),

              ///Confirm Button
              Container(
                height: 35.0,
                child: RaisedButton(
                  onPressed: () {
                    if (newGroupName != null && groupDescription != null && groupImage != null){
                      uploadGroup(context);
                    }                                        
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).accentColor,
                          Theme.of(context).primaryColor
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: 200.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        "CREAR GRUPO",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
