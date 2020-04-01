import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_trainer/Screens/Home/Inicio_Navigate.dart';
import 'package:wave_slider/wave_slider.dart';

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
     'Age': birthday,
     'Weight': weight,
     'Height': height,
     'Experience': experience,
     'Preference': preference,
     'Goal': goal,
    });
  }

class _OnboardingState extends State<Onboarding> {
   final controller = PageController(initialPage:0);
   final int totalPages = 5;
  
   int currentpage = 0;
   List trainingExperience = ["I never workout", "I try to be active sometimes", "I have some experience", "I exercise all the time"];
   List objective = ["Lose Weight", "Gain Muscle", "Be Active", "Prepare for my Sport"];
   List trainingPreference = ["Bodyweight", "Running", "With gym machines", "With all gym material"];

  ///User Data to save
  String sex = '';
  String currentAge;
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
  List<String> ages = [for(var i=15; i<90; i+=1) i.toString()];
   
  onChangedAge(val){
    setState(() {
      currentAge = val;
      print(currentAge);
    });
  }
  ///SecondPage/FourthPage
  int selectedButton;
  int selectedButtonObj;
  ///ThirdPage
  Color preferenceColor1 = Colors.grey;
  Color preferenceColor2 = Colors.grey;
  Color preferenceColor3 = Colors.grey;
  Color preferenceColor4 = Colors.grey;
  ///End button
  String nextButton = 'NEXT';

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

 /////// Create a function to navigate into further details for every document printed
  goHome(context){
    Navigator.push(context, MaterialPageRoute(builder: (context) => InicioNew()));
    
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
                              Padding(
                                padding: const EdgeInsets.fromLTRB(30, 0, 30, 8),
                                child: Text(
                                  "Hi there!",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize:30),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(30, 8, 30, 40),
                                child: Text(
                                  "Tell us a bit about yourself to complete your profile information",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize:16),
                                  textAlign: TextAlign.left,
                                ),
                              ),                                
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
                                        Material(
                                          child: InkWell(
                                            onTap: (){
                                              setState(() {
                                                sex = "Male";
                                                sexColor1 = Colors.redAccent[700];
                                                sexText1 = Colors.white;
                                                sexColor2 = Colors.white;
                                                sexText2 = Colors.black;
                                                maleBorderColor = Colors.redAccent[700];
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
                                              child: Center(child: Text("Male", style: TextStyle(fontSize: 14, color: sexText1))),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 30),
                                        ///Female
                                        Material(
                                          child: InkWell(
                                            onTap: (){
                                              setState(() {
                                                sex = "Female";
                                                sexColor1 = Colors.white;
                                                sexText1 = Colors.black;
                                                sexColor2 = Colors.redAccent[700];
                                                sexText2 = Colors.white;
                                                maleBorderColor = Colors.black;
                                                femaleBorderColor = Colors.redAccent[700];
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
                                              child: Center(child: Text("Female", style: TextStyle(fontSize: 14, color: sexText2))),
                                            ),
                                          ),
                                        ),
                                      ],
                                      ),
                                  ),

                                  SizedBox(height: 30),

                                  ///Birthday
                                  Column(
                                    children:<Widget>[
                                      Container(
                                        child: Text(
                                          "Select your age", style: TextStyle(fontSize: 11),
                                        ),
                                      ),
                                    SizedBox(height:5),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                      width: 250,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25.0),
                                          border: Border.all(color:Colors.grey, width: 0.8)
                                        ),
                                      child: DropdownButtonFormField(
                                        decoration: InputDecoration.collapsed(hintText: null),
                                        value: currentAge ?? '30',
                                        items: ages.map((age){
                                          return DropdownMenuItem(
                                            value: age,
                                            child: Text('$age',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                                          );
                                          }).toList(),
                                          onChanged: (val){
                                            setState(() => currentAge = val);
                                            print(currentAge);
                                          },
                                        ),
                                      ),
                                    ]
                                  ),
                                  
                                  SizedBox(height: 100),

                                ]
                              ),
                            ], 
                          ),
                        ),
                      //Second Screen
                      Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.white,
                          child:                               
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children:<Widget>[

                                  //Weight            
                                  Text(
                                    'Weight (Kg)',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Container(
                                    height: 60,
                                    width: 300,
                                    child: WaveSlider(
                                      color: Colors.black,
                                      displayTrackball: true,
                                      onChanged: (double dragUpdate) {
                                        setState(() {
                                          weight = ((dragUpdate * 100)+40).toStringAsFixed(1); // dragUpdate is a fractional value between 0 and 1
                                        });
                                      },
                                    ),
                                  ),
                                  Text(
                                    '$weight',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),

                                  SizedBox(height:50),
                                  //Weight            
                                  Text(
                                    'Height (Cm)',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Container(
                                    height: 60,
                                    width: 300,
                                    child: WaveSlider(
                                      color: Colors.black,
                                      displayTrackball: true,
                                      onChanged: (double dragUpdate) {
                                        setState(() {
                                          height = ((dragUpdate * 80)+140).toStringAsFixed(1); // dragUpdate is a fractional value between 0 and 1
                                        });
                                      },
                                    ),
                                  ),
                                  Text(
                                    '$height',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),

                                  SizedBox(height:100),

                                ]
                              ),
                        ),
                      ///Third Screen
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
                                padding: const EdgeInsets.fromLTRB(20, 50, 20, 40),
                                child: Text(  
                                  "What is your training experience?",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize:20),
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
                                            color: Colors.redAccent[700],
                                            //border: Border.all(color: Colors.black, width: 1),
                                            borderRadius: BorderRadius.circular(15),                                            
                                          ),
                                          child: Center(
                                            child: Text(trainingExperience[index],
                                              style: TextStyle(fontSize: 14, color: Colors.white)
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
                                            color: Colors.black,
                                            border: Border.all(color: Colors.black, width: 1),
                                            borderRadius: BorderRadius.circular(15),                                            
                                          ),
                                          child: Center(
                                            child: Text(trainingExperience[index],
                                              style: TextStyle(fontSize: 14, color: Colors.white),
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
                      ///Fourth Screen
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
                                  "How do you prefer to exercise?",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize:20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                // color: Colors.green,
                                //height: 300,
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
                                          Material(
                                            child: InkWell(
                                              onTap: (){
                                                setState(() {
                                                  preferenceColor1 = Colors.transparent;
                                                  preferenceColor2 = Colors.grey;
                                                  preferenceColor3 = Colors.grey;
                                                  preferenceColor4 = Colors.grey;
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
                                                        child: Text("Bodyweight", textAlign: TextAlign.center, style: TextStyle(fontSize:11)),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ),
                                            ),
                                          ),

                                          SizedBox(width: 15),
                                          ///Machines
                                          Material(
                                            child: InkWell(
                                              onTap: (){
                                                setState(() {
                                                  preferenceColor1 = Colors.grey;
                                                  preferenceColor2 = Colors.transparent;
                                                  preferenceColor3 = Colors.grey;
                                                  preferenceColor4 = Colors.grey;
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
                                                        child: Text("Gym machines", textAlign: TextAlign.center, style: TextStyle(fontSize:11)),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          ///Running
                                          Material(
                                            child: InkWell(
                                              onTap: (){
                                                setState(() {
                                                  preferenceColor1 = Colors.grey;
                                                  preferenceColor2 = Colors.grey;
                                                  preferenceColor3 = Colors.transparent;
                                                  preferenceColor4 = Colors.grey;
                                                  preference = "Running";
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
                                                        child: Text("Running", textAlign: TextAlign.center, style: TextStyle(fontSize:11)),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          ///Gym material
                                          Material(
                                            child: InkWell(
                                              onTap: (){
                                                setState(() {
                                                  preferenceColor1 = Colors.grey;
                                                  preferenceColor2 = Colors.grey;
                                                  preferenceColor3 = Colors.grey;
                                                  preferenceColor4 = Colors.transparent;
                                                  preference = "Gym";
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
                                                        child: Text("Gym weights", textAlign: TextAlign.center, style: TextStyle(fontSize:11)),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ),
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
                      ///Fifth Screen
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
                                padding: const EdgeInsets.fromLTRB(10, 50, 20, 40),
                                child: Text(
                                  "What do you want to achieve?",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize:20),
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
                                            color: Colors.redAccent[700],
                                            borderRadius: BorderRadius.circular(15),                                            
                                          ),
                                          child: Center(
                                            child: Text(objective[index],
                                              style: TextStyle(fontSize: 14, color: Colors.white),
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
                                            color: Colors.black,
                                            border: Border.all(color: Colors.black, width: 1),
                                            borderRadius: BorderRadius.circular(15),                                            
                                          ),
                                          child: Center(
                                            child: Text(objective[index],
                                              style: TextStyle(fontSize: 14, color: Colors.white),
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
                    Container(
                      width:200,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          ),
                        color: Colors.redAccent[700],
                              padding: EdgeInsets.all(0),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                onPressed: ()async{
                                  if(currentpage<3){
                                        controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
                                        print(currentpage);
                                      }else if(currentpage==3){                                        
                                        controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
                                        setState(() {
                                          nextButton = 'FINISH';
                                        });
                                      }else{
                                        await updateUserData(sex, currentAge, weight, height, experience, preference, goal);
                                        goHome(context);                                      
                                      }
                                    }, 
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children:<Widget> [
                                        Text(
                                          nextButton,
                                          style: TextStyle(color: Colors.white, fontSize: 14),
                                        ),
                            ]
                         )
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

