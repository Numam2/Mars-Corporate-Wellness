import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Models/userProfile.dart';

class EditProfile extends StatefulWidget {
  final UserProfile profile;
  EditProfile({Key key, this.profile}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File profileImage;
  String profileImageView;
  StorageUploadTask _uploadTask;

  Future getImage() async {
    PickedFile selectedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      profileImage = File(selectedImage.path);
      print(profileImage);
    });
  }

  Future uploadPic(BuildContext context) async {
    ////Upload to Clod Storage
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    String fileName = 'Profile Images/' + uid + '.png';
    _uploadTask =
        FirebaseStorage.instance.ref().child(fileName).putFile(profileImage);

    ///Save to Firestore
    var downloadUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();
    var imageUrl = downloadUrl.toString();
    DatabaseService().createUserImage(uid, imageUrl);
  }

  String name;
  String about;
  String sex;
  double weight;
  String newWeight;
  String preference;
  String goal;

  String male = 'Masculino';
  String female = 'Femenino';
  String maleE = 'Male';
  String femaleE = 'Female';

  Color sexColor1 = Colors.white;
  Color sexColor2 = Colors.white;
  Color sexText1 = Colors.black;
  Color sexText2 = Colors.black;
  Color maleBorderColor = Colors.black;
  Color femaleBorderColor = Colors.black;

  @override
  void initState() {
    super.initState();
    name = widget.profile.name;
    about = widget.profile.about;
    weight = double.tryParse(widget.profile.weight);
    newWeight = widget.profile.weight;
    sex = widget.profile.sex;
    preference = widget.profile.preference;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
        ),
        centerTitle: true,
        title:
            Text('Edit Profile', style: Theme.of(context).textTheme.headline),
        actions: <Widget>[
          InkWell(
              onTap: () {
                uploadPic(context);
                DatabaseService().editUserData(
                    name, about, sex, newWeight, preference, goal);
                Navigator.of(context).pop();
              },
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Text('Guardar',
                        style: GoogleFonts.montserrat(
                            color: Theme.of(context).primaryColor)),
                  )))
        ],
      ),
      body: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ///Select Picture
                  Column(children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[100],
                      child: ClipOval(
                        child: Container(
                            height: 100,
                            width: 100,
                            child: !(profileImage == null)
                                ? Image.file(profileImage,
                                    fit: BoxFit.cover)
                                : Image.network(widget.profile.profilePic,
                                    fit: BoxFit.cover)),
                      ),
                    ),
                    SizedBox(height:5),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text('Cambiar foto',
                          style: GoogleFonts.montserrat(
                              color: Theme.of(context).primaryColor)),
                      ),
                      onTap: getImage,
                    )
                  ]),
                  SizedBox(height: 20),

                  ///Sex
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ///Male
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              sex = "Masculino";
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                              color: (sex == male || sex == maleE)
                                  ? Theme.of(context).accentColor
                                  : Colors.white,
                              border: Border.all(
                                  color: (sex == male || sex == maleE)
                                      ? Theme.of(context).accentColor
                                      : Colors.black,
                                  width: 0.7),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                                child: Text(male,
                                    style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        color: (sex == male || sex == maleE)
                                            ? Colors.white
                                            : Colors.black))),
                          ),
                        ),
                        SizedBox(width: 30),

                        ///Female
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              sex = "Femenino";
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                              color: (sex == female || sex == femaleE)
                                  ? Theme.of(context).accentColor
                                  : Colors.white,
                              border: Border.all(
                                  color: (sex == female || sex == femaleE)
                                      ? Theme.of(context).accentColor
                                      : Colors.black,
                                  width: 0.7),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                                child: Text(female,
                                    style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        color: (sex == female || sex == femaleE)
                                            ? Colors.white
                                            : Colors.black))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

                  ///Name
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Nombre',
                            style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              border:
                                  Border.all(color: Colors.grey, width: 0.8)),
                          child: TextFormField(
                            initialValue: name,
                            style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.start,
                            cursorColor: Theme.of(context).accentColor,
                            decoration: InputDecoration.collapsed(
                              hintText: "",
                              hintStyle: TextStyle(color: Colors.grey.shade700),
                            ),
                            onChanged: (val) {
                              setState(() => name = val);
                            },
                          ),
                        ),
                      ]),
                  SizedBox(height: 20),

                  //About
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Sobre mi',
                            style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              border:
                                  Border.all(color: Colors.grey, width: 0.8)),
                          child: TextFormField(
                            initialValue: about,
                            style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.start,
                            cursorColor: Theme.of(context).accentColor,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(45)
                            ],
                            maxLines: null,
                            decoration: InputDecoration.collapsed(
                              hintText: (about == null || about == '')
                                  ? "Ocupaciónn, intereses.."
                                  : "",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            onChanged: (val) {
                              setState(() => about = val);
                            },
                          ),
                        ),
                      ]),
                  SizedBox(height: 30),

                  ///Weight
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Row(children: <Widget>[
                            Text(
                              'Peso',
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(width: 15),
                            Text(
                              '$newWeight Kg',
                              style: GoogleFonts.montserrat(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Theme.of(context).accentColor,
                              inactiveTrackColor: Colors.grey[200],
                              trackShape: RoundedRectSliderTrackShape(),
                              trackHeight: 4.0,
                              thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 12.0),
                              thumbColor: Theme.of(context).accentColor,
                              //overlayColor: Colors.grey[50],
                              overlayShape:
                                  RoundSliderOverlayShape(overlayRadius: 28.0),
                              tickMarkShape: RoundSliderTickMarkShape(),
                              activeTickMarkColor:
                                  Theme.of(context).accentColor,
                              inactiveTickMarkColor:
                                  Theme.of(context).disabledColor,
                              valueIndicatorShape:
                                  PaddleSliderValueIndicatorShape(),
                              valueIndicatorColor:
                                  Theme.of(context).accentColor,
                              valueIndicatorTextStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            child: Slider(
                              min: 0,
                              max: 140,
                              value: weight,
                              label: weight.toStringAsFixed(0),
                              onChanged: (value) {
                                setState(() {
                                  weight = value;
                                  newWeight = weight.toStringAsFixed(0);
                                });
                                print(newWeight);
                              },
                            ),
                          ),
                        ),
                      ]),
                  SizedBox(height: 20),

                  ///Goal

                  ///Preference
                ],
              ),
            ),
          )),
    );
  }
}
