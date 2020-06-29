import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class Onboarding extends StatefulWidget {

  @override
  _OnboardingState createState() => _OnboardingState();
}

 //////// Create a future that saves Firestore data for User Profile
  Future updateUserData (sex, birthday, weight, height, experience, preference, goal) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return await Firestore.instance.collection('User Profile').document(uid).updateData({
     'Sex': sex,
     'Birthday': birthday,
     'Weight': weight,
     'Height': height,
     'Experience': experience,
     'Preference': preference,
     'Goal': goal,
    });
  }

class _OnboardingState extends State<Onboarding> {
   final controller = PageController(initialPage:0);
   final int totalPages = 4;
  
   int currentpage = 0;
   List trainingExperience = ["Nunca he hecho ejercicio", "Tengo poca experiencia", "Puedo entrenar solo", "Tengo mucho conocimiento"];
   List objective = ["Perder peso", "Ganar músculo", "Mantenerme saludable", "Aliviar estrés"];
   List trainingPreference = ["Peso Corporal", "Cardio", "Yoga", "Gimnasio"];

  ///User Data to save
  String sex = '';
  DateTime birthday = DateTime.parse("1994-01-01 12:00:00");
  double _weightValue = 0.0;
  double _heightValue = 0.0;
  String height = '140';
  String weight = '40';
  String experience = '';
  String preference = '';
  String goal = '';

  /////////Questionaire variables//////
  ///FirstPage
  Color sexColor1 = Colors.white;
  Color sexColor2 = Colors.white;
  Color sexText1 = Colors.black;
  Color sexText2 = Colors.black;
  Color maleBorderColor = Colors.black;
  Color femaleBorderColor = Colors.black;
  Color buttonColor = Colors.black;
  Color buttonText = Colors.white;
  
  ///SecondPage/FourthPage
  int selectedButton;
  int selectedButtonObj;
  ///ThirdPage
  Color preferenceColor1 = Colors.grey;
  Color preferenceColor2 = Colors.grey;
  Color preferenceColor3 = Colors.grey;
  Color preferenceColor4 = Colors.grey;
  ///End button
  String nextButton = 'SIGUIENTE';

   Widget _buildPageIndicator (bool isCurrentPage){
     return AnimatedContainer(
       duration: Duration(milliseconds: 375),
       margin: EdgeInsets.symmetric(horizontal:2),
       height: isCurrentPage ? 10:6,
       width: isCurrentPage ? 10:6,
       decoration: BoxDecoration(color: isCurrentPage ? Colors.grey[700] : Colors.grey[300],
       borderRadius: BorderRadius.circular(12)
       ),
    );
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Container(
              child: Stack(
                children: <Widget>[

                  PageView(
                    controller: controller,
                    onPageChanged: (int page){
                      currentpage = page;
                      setState(() {                        
                      });
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
                            children:<Widget>[
                              ///Greetings Text
                              SizedBox(height:20),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  "Hola!",
                                  style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.w500, fontSize:30),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              SizedBox(height:8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  "Dinos un poco sobre ti para completar la información de tu perfil",
                                  style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.w500, fontSize:16),
                                  textAlign: TextAlign.left,
                                ),
                              ),                                
                              SizedBox(height:20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:<Widget>[
                                ///Male/Female                                
                                  Container(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        ///Male
                                        InkWell(
                                          onTap: (){
                                            setState(() {
                                              sex = "Male";
                                              sexColor1 = Theme.of(context).accentColor;
                                              sexText1 = Colors.white;
                                              sexColor2 = Colors.white;
                                              sexText2 = Colors.black;
                                              maleBorderColor = Theme.of(context).accentColor;
                                              femaleBorderColor = Colors.black;
                                            });
                                            print(sex);
                                          },
                                          splashColor: Colors.black.withOpacity(0.5),
                                          child: Container(
                                            width: 100,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: sexColor1,
                                              border: Border.all(color: maleBorderColor, width: 0.7),
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            child: Center(child: Text("Masculino", style: GoogleFonts.montserrat(fontSize: 12, color: sexText1))),
                                          ),
                                        ),
                                        SizedBox(width: 30),
                                        ///Female
                                        InkWell(
                                          onTap: (){
                                            setState(() {
                                              sex = "Female";
                                              sexColor1 = Colors.white;
                                              sexText1 = Colors.black;
                                              sexColor2 = Theme.of(context).accentColor;
                                              sexText2 = Colors.white;
                                              maleBorderColor = Colors.black;
                                              femaleBorderColor = Theme.of(context).accentColor;
                                            });
                                            print(sex);
                                          },
                                          splashColor: Colors.black.withOpacity(0.5),
                                          child: Container(
                                            width: 100,
                                            height: 30,                                      
                                            decoration: BoxDecoration(
                                              color: sexColor2,
                                              border: Border.all(color: femaleBorderColor, width: 0.7),
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            child: Center(child: Text("Femenino", style: GoogleFonts.montserrat(fontSize: 12, color: sexText2))),
                                          ),
                                        ),
                                      ],
                                      ),
                                  ),

                                  SizedBox(height: 25),

                                  ///Birthday
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children:<Widget>[
                                        Text(
                                          "Fecha de nacimiento: ", style: GoogleFonts.montserrat(fontSize: 12),
                                        ),
                                      ] 
                                    ),
                                  ),
                                  SizedBox(width:20),                                  
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                                    child: InkWell(
                                      child: Container(
                                        height: 100,
                                        width: MediaQuery.of(context).size.width*0.8,
                                        child: Container(
                                          width: MediaQuery.of(context).size.width*0.8,
                                          child: CupertinoDatePicker(
                                            mode: CupertinoDatePickerMode.date,
                                            initialDateTime: DateTime.parse("1990-01-01"),
                                            onDateTimeChanged: (date){
                                              birthday = date;
                                            }
                                          )
                                          ),
                                      ),
                                    ),
                                  ),
                                  
                                  SizedBox(height: 25),

                                  //Weight            
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                    child: Row(
                                      children:<Widget>[
                                        Text(
                                          'Peso (Kg)',
                                          style: GoogleFonts.montserrat(fontSize: 12),
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          '$weight',
                                          style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.bold),
                                        ),
                                      ] 
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        activeTrackColor: Theme.of(context).accentColor,
                                        inactiveTrackColor: Colors.grey[200],
                                        trackShape: RoundedRectSliderTrackShape(),
                                        trackHeight: 4.0,
                                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                                        thumbColor: Theme.of(context).accentColor,
                                        //overlayColor: Colors.grey[50],
                                        overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                                        tickMarkShape: RoundSliderTickMarkShape(),
                                        activeTickMarkColor: Theme.of(context).accentColor,
                                        inactiveTickMarkColor: Theme.of(context).disabledColor,
                                        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                                        valueIndicatorColor: Theme.of(context).accentColor,
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
                                            weight = ((_weightValue)+40).toStringAsFixed(0);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  
                                  
                                  SizedBox(height:20),
                                  //Height
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                    child: Row(
                                      children:<Widget>[
                                        Text(
                                          'Altura (Cm)',
                                          style: GoogleFonts.montserrat(fontSize: 12),
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          '$height',
                                          style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.bold),
                                        ),
                                      ] 
                                    ),
                                  ),     
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        activeTrackColor: Theme.of(context).accentColor,
                                        inactiveTrackColor:  Colors.grey[200],
                                        trackShape: RoundedRectSliderTrackShape(),
                                        trackHeight: 4.0,
                                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                                        thumbColor: Theme.of(context).accentColor,
                                        //overlayColor: Colors.grey[50],
                                        overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                                        tickMarkShape: RoundSliderTickMarkShape(),
                                        activeTickMarkColor: Theme.of(context).accentColor,
                                        inactiveTickMarkColor: Theme.of(context).disabledColor,
                                        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                                        valueIndicatorColor: Theme.of(context).accentColor,
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
                                            height = ((_heightValue)+120).toStringAsFixed(0);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height:80),

                                ]
                              ),
                            ], 
                          ),
                        ),
                      //Second Screen                      
                      Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding: EdgeInsets.only(left:25,right:25, top:30),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
                                child: Text(  
                                  "¿Cuál es tu experiencia con la actividad física?",
                                  style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.w500, fontSize:20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                //color: Colors.red,
                                height: 300,
                                width: double.infinity,
                                child: ListView.builder(
                                  itemCount: trainingExperience.length,
                                  itemBuilder: (context, index){
                                    if (index == selectedButton){
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
                                              style: GoogleFonts.montserrat(fontSize: 14, color: Colors.white)
                                            )
                                          ),
                                        )
                                      ),
                                    );
                                    } else {
                                    return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: InkWell(
                                        onTap: (){
                                          setState(() {
                                            selectedButton = index;
                                            experience = trainingExperience[index];
                                            print(experience);
                                          });
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 250,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                                            borderRadius: BorderRadius.circular(25),                                            
                                          ),
                                          child: Center(
                                            child: Text(trainingExperience[index],
                                              style: TextStyle(fontSize: 14, color: Theme.of(context).canvasColor),
                                            )
                                          ),
                                        )
                                      ),
                                    );}
                                  }
                                ),
                              ),
                              SizedBox(height:100)
                              ], 
                            ),
                          ),
                      ///Third Screen
                      Container(
                          //padding: EdgeInsets.all(8.0),
                          width: double.infinity,
                          height: double.infinity,
                          padding: EdgeInsets.only(left:20,right:20,top:30),
                          color: Colors.white,
                          child: 
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 50, 20, 40),
                                child: Text(
                                  "¿Cómo prefieres entrenar?",
                                  style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.w500, fontSize:20),
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
                                              onTap: (){
                                                setState(() {
                                                  preferenceColor1 = Colors.transparent;
                                                  preferenceColor2 = Theme.of(context).disabledColor;
                                                  preferenceColor3 = Theme.of(context).disabledColor;
                                                  preferenceColor4 = Theme.of(context).disabledColor;
                                                  preference = "Bodyweight";
                                                });
                                                print(preference);
                                              },
                                              splashColor: Colors.black.withOpacity(0.5),
                                              child: Container(
                                                height: 120,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                  color: preferenceColor1,
                                                  borderRadius: BorderRadius.circular(12)
                                                ),
                                                child:Column(
                                                  children: <Widget>[
                                                    Container(
                                                      height: 100,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.only(topRight: Radius.circular(12), topLeft: Radius.circular(12)),
                                                      image: DecorationImage(
                                                        image: AssetImage('Images/TrainPreference/Home.jpg'),
                                                        fit: BoxFit.cover,
                                                        colorFilter: ColorFilter.mode(preferenceColor1, BlendMode.hue)
                                                        )
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(12), bottomLeft: Radius.circular(12)),
                                                        border: Border.all(color: Colors.black, width: 0.1),
                                                        ),
                                                      height: 20,
                                                      width: double.infinity,                                                    
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top:2.0),
                                                        child: Text("Peso Corporal", textAlign: TextAlign.center, style: GoogleFonts.montserrat(fontSize:11)),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ),
                                            ),                                      

                                          SizedBox(width: 15),
                                          ///Machines
                                          InkWell(
                                            onTap: (){
                                              setState(() {
                                                preferenceColor1 = Theme.of(context).disabledColor;
                                                preferenceColor2 = Colors.transparent;
                                                preferenceColor3 = Theme.of(context).disabledColor;
                                                preferenceColor4 = Theme.of(context).disabledColor;
                                                preference = "Machines";
                                              });
                                               print(preference);
                                            },
                                            splashColor: Colors.black.withOpacity(0.5),
                                            child: Container(
                                              height: 120,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color: preferenceColor2,
                                                borderRadius: BorderRadius.circular(12)
                                              ),
                                              child:Column(
                                                children: <Widget>[
                                                  Container(
                                                    height: 100,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(topRight: Radius.circular(12), topLeft: Radius.circular(12)),
                                                    image: DecorationImage(
                                                      image: AssetImage('Images/TrainPreference/Machine.jpg'),
                                                      fit: BoxFit.cover,
                                                      colorFilter: ColorFilter.mode(preferenceColor2, BlendMode.hue)
                                                      )
                                                    ), 
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(12), bottomLeft: Radius.circular(12)),
                                                      border: Border.all(color: Colors.black, width: 0.1),
                                                      ),
                                                    height: 20,
                                                    width: double.infinity,                                                    
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top:2.0),
                                                      child: Text("Gimnasio", textAlign: TextAlign.center, style: GoogleFonts.montserrat(fontSize:11)),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          ///Running
                                          InkWell(
                                            onTap: (){
                                              setState(() {
                                                preferenceColor1 = Theme.of(context).disabledColor;
                                                preferenceColor2 = Theme.of(context).disabledColor;
                                                preferenceColor3 = Colors.transparent;
                                                preferenceColor4 = Theme.of(context).disabledColor;
                                                preference = "Cardio";
                                              });
                                               print(preference);
                                            },
                                            splashColor: Colors.black.withOpacity(0.5),
                                            child: Container(
                                              height: 120,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color: preferenceColor3,
                                                borderRadius: BorderRadius.circular(12)
                                              ),
                                              child:Column(
                                                children: <Widget>[
                                                  Container(
                                                    height: 100,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(topRight: Radius.circular(12), topLeft: Radius.circular(12)),
                                                    image: DecorationImage(
                                                      image: AssetImage('Images/TrainPreference/Running.jpg'),
                                                      fit: BoxFit.cover,
                                                      colorFilter: ColorFilter.mode(preferenceColor3, BlendMode.hue)
                                                      )
                                                    ), 
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(12), bottomLeft: Radius.circular(12)),
                                                      border: Border.all(color: Colors.black, width: 0.1),
                                                      ),
                                                    height: 20,
                                                    width: double.infinity,                                                    
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top:2.0),
                                                      child: Text("Cardio", textAlign: TextAlign.center, style: GoogleFonts.montserrat(fontSize:11)),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          ///Gym material
                                          InkWell(
                                            onTap: (){
                                              setState(() {
                                                preferenceColor1 = Theme.of(context).disabledColor;
                                                preferenceColor2 = Theme.of(context).disabledColor;
                                                preferenceColor3 = Theme.of(context).disabledColor;
                                                preferenceColor4 = Colors.transparent;
                                                preference = "Yoga";
                                              });
                                               print(preference);
                                            },
                                            splashColor: Colors.black.withOpacity(0.5),
                                            child: Container(
                                              height: 120,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color: preferenceColor4,
                                                borderRadius: BorderRadius.circular(12)
                                              ),
                                              child:Column(
                                                children: <Widget>[
                                                  Container(
                                                    height: 100,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(topRight: Radius.circular(12), topLeft: Radius.circular(12)),
                                                    image: DecorationImage(
                                                      image: AssetImage('Images/TrainPreference/Gym.jpg'),
                                                      fit: BoxFit.cover,
                                                      colorFilter: ColorFilter.mode(preferenceColor4, BlendMode.hue)
                                                      )
                                                    ), 
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(12), bottomLeft: Radius.circular(12)),
                                                      border: Border.all(color: Colors.black, width: 0.1),
                                                      ),
                                                    height: 20,
                                                    width: double.infinity,                                                    
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top:2.0),
                                                      child: Text("Yoga", textAlign: TextAlign.center, style: GoogleFonts.montserrat(fontSize:11)),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ),
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
                      ///Fourth Screen
                      Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding: EdgeInsets.only(left:25,right:25,top:30),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 40, 20, 30),
                                child: Text(
                                  "¿Qué te gustaría lograr?",
                                  style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.w500, fontSize:20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                //color: Colors.red,
                                height: 300,
                                width: double.infinity,
                                child: ListView.builder(
                                  itemCount: objective.length,
                                  itemBuilder: (context, index){
                                    if (index == selectedButtonObj){
                                      return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: InkWell(
                                        child: Container(
                                          height: 50,
                                          width: 250,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).accentColor,
                                            borderRadius: BorderRadius.circular(25),                                            
                                          ),
                                          child: Center(
                                            child: Text(objective[index],
                                              style: GoogleFonts.montserrat(fontSize: 14, color: Colors.white),
                                            )
                                          ),
                                        )
                                      ),
                                    );
                                    } else {
                                    return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: InkWell(
                                        onTap: (){
                                          setState(() {
                                            selectedButtonObj = index;
                                            goal = objective[index];
                                            print(goal);
                                          });
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 250,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                                            borderRadius: BorderRadius.circular(25),                                            
                                          ),
                                          child: Center(
                                            child: Text(objective[index],
                                              style: TextStyle(fontSize: 14, color: Theme.of(context).canvasColor),
                                            )
                                          ),
                                        )
                                      ),
                                    );}
                                  },
                                ),
                              ),
                              SizedBox(height: 100),
                            ], 
                          ),
                        ),
                          
                    ],
                  )
                ]
              ),
          ),
          bottomSheet: 
            Container(
              color: Colors.white,              
              height: 100,
              width: double.infinity,
              padding: EdgeInsets.only(left:20, right:20),
                child: Column(
                  children:<Widget>[
                    ///NEXT Button
                    Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 35.0,
                            child: RaisedButton(
                              onPressed: ()async{
                                  if(currentpage<2){
                                        controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
                                        print(currentpage);
                                      }else if(currentpage==2){                                        
                                        controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
                                        setState(() {
                                          nextButton = 'LISTO!';
                                        });
                                      }else{
                                        await updateUserData(sex, birthday, weight, height, experience, preference, goal);                                
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
                    SizedBox(height:25),
                    ///Pages navigator Dots
                    Center(
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        for (int i=0; i<totalPages; i++) i == currentpage ? _buildPageIndicator(true): _buildPageIndicator(false),
                        ],
                      ),
                    ),                  

                  ]
                )
              ),
        );
  }
}

