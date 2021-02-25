import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:personal_trainer/Screens/Home/Inicio_Navigate.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

//////// Create a future that saves Firestore data for User Profile
Future updateUserData(
    sex, birthday, weight, height, experience, preference, goal) async {
  final User user = FirebaseAuth.instance.currentUser;
  final String uid = user.uid.toString();
  return await FirebaseFirestore.instance
      .collection('User Profile')
      .doc(uid)
      .update({
    'Sex': sex,
    'Birthday': birthday,
    'Weight': weight,
    'Height': height,
    'Experience': experience,
    'Preferences': preference,
    'Goals': goal,
  });
}

class _OnboardingState extends State<Onboarding> {
  final controller = PageController(initialPage: 0);
  final int totalPages = 4;

  int currentpage = 0;
  List trainingExperience = [
    "Prácticamente nulo",
    "Hago algo 1-2 veces por semana",
    "Bastante alto, como 3-5 por semana",
    "Fitness es mi segundo nombre"
  ];
  List objective = [
    "Perder peso",
    "Ganar músculo",
    "Mantenerme saludable",
    "Aliviar estrés",
    "Salir de la rutina"
  ];
  List trainingPreference = [];
  List sexList = ['Masculino', 'Femenino', 'Otro'];

  ///User Data to save
  String sex = '';
  DateTime birthday = DateTime.parse("1994-01-01 12:00:00");
  double _weightValue = 0.0;
  double _heightValue = 0.0;
  String height = '140';
  String weight = '40';
  int experience = 0;
  String preference = '';

  /////////Questionaire variables//////

  ///SecondPage/FourthPage
  int selectedButton;
  int selectedButtonObj;

  List goalsList = [];

  ///End button
  String nextButton = 'SIGUIENTE';

  Widget _buildPageIndicator(bool isCurrentPage) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 375),
      margin: EdgeInsets.symmetric(horizontal: 2),
      height: isCurrentPage ? 10 : 6,
      width: isCurrentPage ? 10 : 6,
      decoration: BoxDecoration(
          color: isCurrentPage ? Colors.grey[700] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: Stack(children: <Widget>[
          PageView(
            controller: controller,
            onPageChanged: (int page) {
              currentpage = page;
              setState(() {});
            },
            children: <Widget>[
              ///First Screen
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ///Greetings Text
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "¡Confirmamos tu usuario!",
                        style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "Completa tus datos para personalizar tu experiencia",
                        style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 35),

                    ///Datos
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ///Male/Female
                          Container(
                              width: double.infinity,
                              height: 40,
                              color: Colors.white,
                              child: Align(
                                alignment: Alignment.center,
                                child: ListView.builder(
                                    itemCount: sexList.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (context, i) {
                                      return Padding(
                                        padding: (i == 0)
                                            ? EdgeInsets.only(left: 0)
                                            : EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          height: 35.0,
                                          width: 100,
                                          child: RaisedButton(
                                            onPressed: () async {
                                              setState(() {
                                                sex = sexList[i];
                                              });
                                            },
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            padding: EdgeInsets.all(0.0),
                                            child: Ink(
                                              decoration: BoxDecoration(
                                                color: (sex == sexList[i])
                                                    ? Theme.of(context)
                                                        .accentColor
                                                    : Colors.white,
                                                border: Border.all(
                                                    color: (sex == sexList[i])
                                                        ? Theme.of(context)
                                                            .accentColor
                                                        : Colors.black,
                                                    width: 0.7),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  sexList[i],
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: (sex == sexList[i])
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              )),
                          SizedBox(height: 25),

                          ///Birthday
                          Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 0.7)),
                            child: FlatButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.white,
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25.0)),
                                    ),
                                    builder: (context) {
                                      return Wrap(children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(25),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Fecha de nacimiento',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(height: 30),
                                                Container(
                                                  height: 100,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      child:
                                                          CupertinoDatePicker(
                                                              mode:
                                                                  CupertinoDatePickerMode
                                                                      .date,
                                                              initialDateTime:
                                                                  DateTime.parse(
                                                                      "1990-01-01"),
                                                              onDateTimeChanged:
                                                                  (date) {
                                                                setState(() {
                                                                  birthday =
                                                                      date;
                                                                });
                                                              })),
                                                ),
                                                SizedBox(height: 30),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    height: 35.0,
                                                    child: RaisedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25)),
                                                      padding:
                                                          EdgeInsets.all(0.0),
                                                      child: Ink(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(25),
                                                        ),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            nextButton,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ]);
                                    });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 15.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Fecha de nacimiento:",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Spacer(),
                                      Text(
                                        "${DateFormat.yMMMd().format(birthday)}",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 14),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          //Weight
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: Row(children: <Widget>[
                              Text(
                                'Peso (Kg)',
                                style: GoogleFonts.montserrat(fontSize: 12),
                              ),
                              SizedBox(width: 15),
                              Text(
                                '$weight',
                                style: GoogleFonts.montserrat(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ]),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
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
                                overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 28.0),
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
                                max: 100,
                                //divisions: 10,
                                value: _weightValue,
                                label: _weightValue.toStringAsFixed(0),
                                onChanged: (value) {
                                  setState(() {
                                    _weightValue = value;
                                    weight = ((_weightValue) + 40)
                                        .toStringAsFixed(0);
                                  });
                                },
                              ),
                            ),
                          ),

                          SizedBox(height: 20),
                          //Height
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: Row(children: <Widget>[
                              Text(
                                'Altura (Cm)',
                                style: GoogleFonts.montserrat(fontSize: 12),
                              ),
                              SizedBox(width: 15),
                              Text(
                                '$height',
                                style: GoogleFonts.montserrat(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ]),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
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
                                overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 28.0),
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
                                max: 100,
                                //divisions: 10,
                                value: _heightValue,
                                label: _heightValue.toStringAsFixed(0),
                                onChanged: (value) {
                                  setState(() {
                                    _heightValue = value;
                                    height = ((_heightValue) + 120)
                                        .toStringAsFixed(0);
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 80),
                        ]),
                  ],
                ),
              ),
              //Second Screen
              Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.only(left: 25, right: 25, top: 30),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
                      child: Text(
                        "¿Cuál es tu nivel actual de actividad física?",
                        style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      //color: Colors.red,
                      height: 300,
                      width: double.infinity,
                      child: ListView.builder(
                          itemCount: trainingExperience.length,
                          itemBuilder: (context, index) {
                            if (index == selectedButton) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: InkWell(
                                    child: Container(
                                  height: 50,
                                  width: 250,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                    //border: Border.all(color: Colors.black, width: 1),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Center(
                                      child: Text(trainingExperience[index],
                                          style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                              color: Colors.white))),
                                )),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  height: 50.0,
                                  width: 250,
                                  child: RaisedButton(
                                    onPressed: () async {
                                      setState(() {
                                        selectedButton = index;
                                        experience = index;
                                      });
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color:
                                                Theme.of(context).canvasColor,
                                            width: 0.7),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          trainingExperience[index],
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Theme.of(context)
                                                  .canvasColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }),
                    ),
                    SizedBox(height: 100)
                  ],
                ),
              ),
              ///Third Screen
              Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.only(left: 25, right: 25, top: 30),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 40, 20, 30),
                      child: Text(
                        "Selecciona hasta 3 objetivos que te gustaría lograr",
                        style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      //color: Colors.red,
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: objective.length,
                        itemBuilder: (context, index) {
                          if (goalsList.contains(objective[index])) {
                            return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  height: 50.0,
                                  width: 250,
                                  child: RaisedButton(
                                    onPressed: () async {
                                      setState(() {
                                        goalsList.remove(objective[index]);
                                        print(goalsList);
                                      });
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).accentColor,
                                        border: Border.all(
                                            color:
                                                Theme.of(context).accentColor,
                                            width: 0.7),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          objective[index],
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ));
                          } else {
                            return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  height: 50.0,
                                  width: 250,
                                  child: RaisedButton(
                                    onPressed: () async {
                                      if (goalsList.length < 3) {
                                        setState(() {
                                          goalsList.insert(
                                              goalsList.length, objective[index]);
                                          print(goalsList);
                                        });
                                    }
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color:
                                                Theme.of(context).canvasColor,
                                            width: 0.7),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          objective[index],
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Theme.of(context)
                                                  .canvasColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );                             
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
              ///Fourth Screen
              Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 40),
                      child: Text(
                        "¿Qué actividades prefieres hacer para lograr tus objetivos?",
                        style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ///Bodyweight
                                InkWell(
                                  onTap: () {
                                    if (trainingPreference
                                        .contains("Bodyweight")) {
                                      setState(() {
                                        trainingPreference.remove("Bodyweight");
                                      });
                                    } else {
                                      setState(() {
                                        trainingPreference.insert(
                                            trainingPreference.length,
                                            "Bodyweight");
                                      });
                                    }
                                  },
                                  child: Container(
                                      height: MediaQuery.of(context).size.width * 0.3,
                                      width: MediaQuery.of(context).size.width * 0.37,
                                      decoration: BoxDecoration(
                                          color: (trainingPreference
                                                  .contains("Bodyweight"))
                                              ? Colors.transparent
                                              : Theme.of(context).disabledColor,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: MediaQuery.of(context).size.width * 0.25,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(12),
                                                    topLeft:
                                                        Radius.circular(12)),
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'Images/TrainPreference/Home.jpg'),
                                                    fit: BoxFit.cover,
                                                    colorFilter: ColorFilter.mode(
                                                        (trainingPreference
                                                                .contains(
                                                                    "Bodyweight"))
                                                            ? Colors.transparent
                                                            : Theme.of(context)
                                                                .disabledColor,
                                                        BlendMode.hue))),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(12),
                                                  bottomLeft:
                                                      Radius.circular(12)),
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 0.1),
                                            ),
                                            height: MediaQuery.of(context).size.width * 0.05,
                                            width: double.infinity,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0),
                                              child: Text("Entrenar en casa",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 11)),
                                            ),
                                          )
                                        ],
                                      )),
                                ),

                                SizedBox(width: 15),

                                ///Machines
                                InkWell(                                  
                                  onTap: () {
                                    if (trainingPreference
                                        .contains("Gym")) {
                                      setState(() {
                                        trainingPreference.remove("Gym");
                                      });
                                    } else {
                                      setState(() {
                                        trainingPreference.insert(
                                            trainingPreference.length,
                                            "Gym");
                                      });
                                    }
                                  },
                                  splashColor: Colors.black.withOpacity(0.5),
                                  child: Container(
                                      height: MediaQuery.of(context).size.width * 0.3,
                                      width: MediaQuery.of(context).size.width * 0.37,
                                      decoration: BoxDecoration(
                                          color: (trainingPreference
                                                  .contains("Gym"))
                                              ? Colors.transparent
                                              : Theme.of(context).disabledColor,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: MediaQuery.of(context).size.width * 0.25,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(12),
                                                    topLeft:
                                                        Radius.circular(12)),
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'Images/TrainPreference/Gym.jpg'),
                                                    fit: BoxFit.cover,
                                                    colorFilter: ColorFilter.mode(
                                                        (trainingPreference
                                                                .contains(
                                                                    "Gym"))
                                                            ? Colors.transparent
                                                            : Theme.of(context)
                                                                .disabledColor,
                                                        BlendMode.hue))),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(12),
                                                  bottomLeft:
                                                      Radius.circular(12)),
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 0.1),
                                            ),
                                            height: MediaQuery.of(context).size.width * 0.05,
                                            width: double.infinity,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0),
                                              child: Text("Gimnasio",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 11)),
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ///Running
                                InkWell(
                                  onTap: () {
                                    if (trainingPreference.contains("Stretching")) {
                                      setState(() {
                                        trainingPreference.remove("Stretching");
                                      });
                                    } else {
                                      setState(() {
                                        trainingPreference.insert(
                                            trainingPreference.length,
                                            "Stretching");
                                      });
                                    }
                                  },
                                  splashColor: Colors.black.withOpacity(0.5),
                                  child: Container(
                                      height: 120,
                                      width: 150,
                                      decoration: BoxDecoration(
                                          color: (trainingPreference
                                                  .contains("Stretching"))
                                              ? Colors.transparent
                                              : Theme.of(context).disabledColor,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: 100,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(12),
                                                    topLeft:
                                                        Radius.circular(12)),
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'Images/TrainPreference/Stretching.jpg'),
                                                    fit: BoxFit.cover,
                                                    colorFilter: ColorFilter.mode(
                                                        (trainingPreference
                                                                .contains(
                                                                    "Stretching"))
                                                            ? Colors.transparent
                                                            : Theme.of(context)
                                                                .disabledColor,
                                                        BlendMode.hue))),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(12),
                                                  bottomLeft:
                                                      Radius.circular(12)),
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 0.1),
                                            ),
                                            height: 20,
                                            width: double.infinity,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0),
                                              child: Text("Stretching",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 11)),
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                                SizedBox(width: 15),

                                ///Gym material
                                InkWell(
                                  onTap: () {
                                    if (trainingPreference.contains("Yoga")) {
                                      setState(() {
                                        trainingPreference.remove("Yoga");
                                      });
                                    } else {
                                      setState(() {
                                        trainingPreference.insert(
                                            trainingPreference.length, "Yoga");
                                      });
                                    }
                                  },
                                  splashColor: Colors.black.withOpacity(0.5),
                                  child: Container(
                                      height: 120,
                                      width: 150,
                                      decoration: BoxDecoration(
                                          color: (trainingPreference
                                                  .contains("Yoga"))
                                              ? Colors.transparent
                                              : Theme.of(context).disabledColor,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: 100,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(12),
                                                    topLeft:
                                                        Radius.circular(12)),
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'Images/TrainPreference/Yoga.jpg'),
                                                    fit: BoxFit.cover,
                                                    colorFilter: ColorFilter.mode(
                                                        (trainingPreference
                                                                .contains(
                                                                    "Yoga"))
                                                            ? Colors.transparent
                                                            : Theme.of(context)
                                                                .disabledColor,
                                                        BlendMode.hue))),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(12),
                                                  bottomLeft:
                                                      Radius.circular(12)),
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 0.1),
                                            ),
                                            height: 20,
                                            width: double.infinity,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0),
                                              child: Text("Yoga",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 11)),
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          )
        ]),
      ),
      bottomSheet: Container(
          color: Colors.white,
          height: 100,
          width: double.infinity,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(children: <Widget>[
            ///NEXT Button
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 35.0,
                child: RaisedButton(
                  onPressed: () async {
                    if (currentpage < 2) {
                      controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease);
                      print(currentpage);
                    } else if (currentpage == 2) {
                      controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease);
                      setState(() {
                        nextButton = 'LISTO!';
                      });
                    } else {
                      await updateUserData(sex, birthday, weight, height,
                          experience, trainingPreference, goalsList);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => InicioNew()));
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
                      alignment: Alignment.center,
                      child: Text(
                        nextButton,
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
            ),
            SizedBox(height: 25),

            ///Pages navigator Dots
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  for (int i = 0; i < totalPages; i++)
                    i == currentpage
                        ? _buildPageIndicator(true)
                        : _buildPageIndicator(false),
                ],
              ),
            ),
          ])),
    );
  }
}
