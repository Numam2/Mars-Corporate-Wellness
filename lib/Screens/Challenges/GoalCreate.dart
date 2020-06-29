import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Firebase_Services/database.dart';
import 'package:personal_trainer/Screens/Home/Inicio_Navigate.dart';

class GoalCreate extends StatefulWidget {

  final String goalType;
  GoalCreate({this.goalType});

  @override
  _GoalCreateState createState() => _GoalCreateState();
}

class _GoalCreateState extends State<GoalCreate> {
  String goalDescription;
  String target;
  String current;
  double targetValue;
  double currentValue;
  String unit;
  List milestoneList = [];
  List newMilestoneList = [];
  DateTime dateTo = DateTime.now().add(Duration(days: 30));

  final FocusNode _descFocus = FocusNode();  
  final FocusNode _amountFocus = FocusNode();  
  final FocusNode _targetFocus = FocusNode();
  final FocusNode _milestone1 = FocusNode();
  final FocusNode _milestone2 = FocusNode();
  final FocusNode _milestone3 = FocusNode();
  final FocusNode _milestone4 = FocusNode();
  final FocusNode _milestone5 = FocusNode();

  String milestone1;
  String milestone2;
  String milestone3;
  String milestone4;
  String milestone5;

  int milestones = 1;

  Color dateText1month = Colors.black;
  Color dateColor1month = Colors.white;
  Color borderColor1month = Colors.black;

  Color dateText3month = Colors.black;
  Color dateColor3month = Colors.white;
  Color borderColor3month = Colors.black;

  Color dateText6month = Colors.black;
  Color dateColor6month = Colors.white;
  Color borderColor6month = Colors.black;

  bool showErrorText = false;
  String errorText;

  @override
  Widget build(BuildContext context) {
    print(widget.goalType);
    if(widget.goalType == 'Weight'){
      
      return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: ()=> Navigator.push(context, MaterialPageRoute(
                  builder: (context) => InicioNew())),
            child: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black,
            ),
          ),
          title: Text(
            "Establece una meta",
              style: Theme.of(context).textTheme.headline,
            ),
          centerTitle: true,
        ),
        body:
            //Form
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        ///Image
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:<Widget>[
                            Container(
                              height: 75,
                              width: 75,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.fromBorderSide(BorderSide(color:Colors.grey, width: 0.5)),                          
                              ),
                              child: Icon(
                                (widget.goalType == 'Weight') ? Icons.trending_down : Icons.today,
                                size: 40,
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          ]
                        ),
                        SizedBox(height: 15),

                        ///Goal Description
                        Padding(
                          padding: EdgeInsets.only(top:15),
                          child: Text(
                            "¿Cuál es tu nueva meta?",
                            style: Theme.of(context).textTheme.subtitle
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(                       
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                              borderRadius: BorderRadius.circular(25.0),
                              border: Border.all(color: Colors.grey, width: 0.8)),
                          child: TextFormField(
                            focusNode: _descFocus,
                            textInputAction: TextInputAction.next,
                            style: Theme.of(context).textTheme.body1,
                            inputFormatters: [LengthLimitingTextInputFormatter(30)],
                            validator: (val) =>
                                val.isEmpty ? "No olvides agregar la descripción" : null,
                            cursorColor: Theme.of(context).accentColor,
                            decoration: InputDecoration.collapsed(
                              hintText:
                                (widget.goalType == 'Weight')
                                ? "Ej: Perder 5 Kg de grasa, Ganar músculo..."
                                : "Ej: Correr un maratón, mejorar mi postura...",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                            onFieldSubmitted: (term){
                              _descFocus.unfocus();
                              FocusScope.of(context).requestFocus(_amountFocus);
                            },
                            onChanged: (val) {
                              setState(() => goalDescription = val);
                            },
                          ),
                        ),
                        SizedBox(height: 30),

                        ///Goal Target
                        Text(
                          "Actual",
                          style: Theme.of(context).textTheme.subtitle),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:<Widget>[
                            ///Number
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height:70,
                                  width: 80,
                                  constraints: BoxConstraints(maxWidth: 300),                           
                                  child: Center(
                                    child: TextFormField(
                                      focusNode: _amountFocus,
                                      textInputAction: TextInputAction.next,
                                      validator: (val) =>
                                          val.contains(',') ? "Usa punto" : null,
                                      autovalidate: true,
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black, fontSize: 20),
                                      textAlign: TextAlign.center,
                                      //inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                      keyboardType: TextInputType.number,
                                      cursorColor: Theme.of(context).accentColor,
                                      decoration: InputDecoration(
                                        hintText: "70.5",
                                        hintStyle: GoogleFonts.montserrat(color: Colors.grey[350]),
                                        focusedBorder: UnderlineInputBorder(  
                                          borderSide: BorderSide(color: Theme.of(context).accentColor)
                                        ),
                                        errorStyle: TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      onFieldSubmitted: (term){
                                        _amountFocus.unfocus();
                                        FocusScope.of(context).requestFocus(_targetFocus);
                                      },
                                      onChanged: (val) {
                                        setState(() => current = val);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width:10),
                            ///Unit
                            Text(
                              'Kg',
                              style: Theme.of(context).textTheme.display2
                            )
                          ]
                        ),
                        SizedBox(height: 20),

                        ///Goal Target
                        Text(
                          "Objetivo",
                          style: Theme.of(context).textTheme.subtitle),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:<Widget>[
                            ///Number
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height:70,
                                  width: 80,
                                  constraints: BoxConstraints(maxWidth: 300),                           
                                  child: Center(
                                    child: TextFormField(
                                      focusNode: _targetFocus,
                                      validator: (val) =>
                                          val.contains(',') ? "Usa punto" : null,
                                      autovalidate: true,
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black, fontSize: 20),
                                      textAlign: TextAlign.center,
                                      //inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                      keyboardType: TextInputType.number,
                                      cursorColor: Theme.of(context).accentColor,
                                      decoration: InputDecoration(
                                        hintText: "65",
                                        hintStyle: GoogleFonts.montserrat(color: Colors.grey[350]),
                                        focusedBorder: UnderlineInputBorder(  
                                          borderSide: BorderSide(color: Theme.of(context).accentColor)
                                        ),
                                        errorStyle: TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      onFieldSubmitted: (term){
                                        _amountFocus.unfocus();
                                      },
                                      onChanged: (val) {
                                        setState(() => target = val);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width:10),
                            ///Unit
                            Text(
                              'Kg',
                              style: Theme.of(context).textTheme.display2
                            )
                          ]
                        ),
                        SizedBox(height: 20),

                        ///Goal Deadline
                        Text(
                          "Duración",
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                        SizedBox(height: 20),
                        ///Deadline Options
                        Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ///1 Month
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    dateTo =
                                        DateTime.now().add(Duration(days: 30));                                      
                                    dateColor1month = Theme.of(context).accentColor;
                                    dateText1month = Colors.white;
                                    dateColor3month = Colors.white;
                                    dateText3month = Colors.black;
                                    dateColor6month = Colors.white;
                                    dateText6month = Colors.black;
                                    borderColor1month = Theme.of(context).accentColor;
                                    borderColor3month = Colors.black;
                                    borderColor6month = Colors.black;
                                  });
                                },
                                splashColor: Colors.black.withOpacity(0.5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width *0.25,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: dateColor1month,
                                    border: Border.all(
                                        color: borderColor1month, width: 0.7),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Center(
                                      child: Text("1 mes",
                                          style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              color: dateText1month))),
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width *0.05),

                              ///3 month
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    dateTo =
                                        DateTime.now().add(Duration(days: 180));
                                    dateColor1month = Colors.white;
                                    dateText1month = Colors.black;
                                    dateColor3month = Theme.of(context).accentColor;
                                    dateText3month = Colors.white;
                                    dateColor6month = Colors.white;
                                    dateText6month = Colors.black;
                                    borderColor1month = Colors.black;
                                    borderColor3month = Theme.of(context).accentColor;
                                    borderColor6month = Colors.black;
                                  });
                                },
                                splashColor: Colors.black.withOpacity(0.5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width *0.25,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: dateColor3month,
                                    border: Border.all(
                                        color: borderColor3month, width: 0.7),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Center(
                                      child: Text("3 meses",
                                          style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              color: dateText3month))),
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width *0.05),

                              ///6 month
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    dateTo =
                                        DateTime.now().add(Duration(days: 90));
                                    dateColor1month = Colors.white;
                                    dateText1month = Colors.black;
                                    dateColor3month = Colors.white;
                                    dateText3month = Colors.black;
                                    dateColor6month = Theme.of(context).accentColor;
                                    dateText6month =  Colors.white;
                                    borderColor1month = Colors.black;
                                    borderColor3month = Colors.black;
                                    borderColor6month = Theme.of(context).accentColor;
                                  });
                                },
                                splashColor: Colors.black.withOpacity(0.5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width *0.25,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: dateColor6month,
                                    border: Border.all(
                                        color: borderColor6month, width: 0.7),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Center(
                                      child: Text("6 meses",
                                          style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              color: dateText6month))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 35),
                        
                        ///Button
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 35.0,
                            child: RaisedButton(
                              onPressed: () {
                                
                                if(goalDescription == null){
                                  setState(() {
                                    errorText = 'No olvides agregar una descripción';
                                    showErrorText = true;
                                  });
                                } else if (target.contains(",") || current.contains(",")){
                                  setState(() {
                                    errorText = 'Usa punto (.) para los decimales';
                                    showErrorText = true;
                                  });
                                } else if (target == null) {
                                  setState(() {
                                    errorText = 'Debes completar el número objetivo y la medida';
                                    showErrorText = true;
                                  });
                                } else {

                                    targetValue = double.tryParse(target);
                                    currentValue = double.tryParse(current);                                  

                                  if(targetValue == null || currentValue == null){
                                    setState(() {
                                      errorText = 'Asegúrate de agregar un número válido';
                                      showErrorText = true;
                                    });
                                  } else {
                                    DatabaseService().createGoal(
                                      goalDescription,
                                      currentValue,
                                      currentValue, 
                                      targetValue, 
                                      unit, dateTo, 
                                      widget.goalType,
                                      [],
                                    );
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => InicioNew()));
                                  }
                                
                                }
                                
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [Theme.of(context).accentColor, Theme.of(context).primaryColor],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                ),
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: 200.0, minHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "GUARDAR META",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12, fontWeight: FontWeight.w500 ,color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        showErrorText 
                        ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            errorText,
                            style: GoogleFonts.montserrat(
                              color: Colors.redAccent[700],
                              fontSize: 11,
                              fontWeight: FontWeight.w300,
                            )
                          )
                        )
                        : SizedBox(height: 10),
                        SizedBox(height: 20),

                      ],
                    ),
                  )),
            ),
      );

    }

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: ()=> Navigator.push(context, MaterialPageRoute(
                builder: (context) => InicioNew())),
          child: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Establece una meta",
            style: Theme.of(context).textTheme.headline,
          ),
        centerTitle: true,
      ),
      body:
          //Form
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      ///Image
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:<Widget>[
                          Container(
                            height: 75,
                            width: 75,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.fromBorderSide(BorderSide(color:Colors.grey, width: 0.5)),                          
                            ),
                            child: Icon(
                              Icons.today,
                              size: 40,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        ]
                      ),
                      SizedBox(height: 30),
                      
                      ///Goal Description
                      Text(
                        "¿Cuál es tu nueva meta?",
                        style: Theme.of(context).textTheme.subtitle
                      ),
                      SizedBox(height: 15),
                      Container(                       
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                            borderRadius: BorderRadius.circular(25.0),
                            border: Border.all(color: Colors.grey, width: 0.8)),
                        child: TextFormField(
                          focusNode: _descFocus,
                          textInputAction: TextInputAction.next,
                          style: Theme.of(context).textTheme.body1,
                          inputFormatters: [LengthLimitingTextInputFormatter(30)],
                          validator: (val) =>
                              val.isEmpty ? "No olvides agregar la descripción" : null,
                          cursorColor: Theme.of(context).accentColor,
                          decoration: InputDecoration.collapsed(
                            hintText:
                              (widget.goalType == 'Weight')
                               ? "Ej: Perder 5 Kg de grasa, Ganar músculo..."
                               : "Ej: Correr un maratón, mejorar mi postura...",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ),
                          onFieldSubmitted: (term){
                            _descFocus.unfocus();
                            FocusScope.of(context).requestFocus(_milestone1);
                          },
                          onChanged: (val) {
                            setState(() => goalDescription = val);
                          },
                        ),
                      ),
                      SizedBox(height: 30),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ///Milestone 1
                          Text(
                            "Objetivo 1",
                            style: Theme.of(context).textTheme.subtitle
                          ),
                          SizedBox(height: 15),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                                borderRadius: BorderRadius.circular(25.0),
                                border: Border.all(color: Colors.grey, width: 0.8)),
                            child: TextFormField(
                              focusNode: _milestone1,
                              style: Theme.of(context).textTheme.body1,
                              inputFormatters: [LengthLimitingTextInputFormatter(30)],
                              cursorColor: Theme.of(context).accentColor,
                              decoration: InputDecoration.collapsed(
                                hintText: "Describe el objetivo",
                                hintStyle: TextStyle(color: Colors.grey[400]),
                              ),
                              onChanged: (val) {
                                setState(() => milestone1 = val);
                              },
                            ),
                          ),
                          SizedBox(height: 30),

                          ///Milestone 2
                          (milestones >= 2) 
                          ? Text(
                              "Objetivo 2",
                              style: Theme.of(context).textTheme.subtitle
                            )
                          : SizedBox(),                          
                          SizedBox(height: (milestones >= 2) ? 15 : 0),
                          (milestones >= 2)
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                  borderRadius: BorderRadius.circular(25.0),
                                  border: Border.all(color: Colors.grey, width: 0.8)),
                              child: TextFormField(
                                focusNode: _milestone2,
                                style: Theme.of(context).textTheme.body1,
                                inputFormatters: [LengthLimitingTextInputFormatter(30)],
                                cursorColor: Theme.of(context).accentColor,
                                decoration: InputDecoration.collapsed(
                                  hintText: "Describe el objetivo",
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                                onChanged: (val) {
                                  setState(() => milestone2 = val);
                                },
                              ),
                            )
                          : SizedBox(),
                          SizedBox(height: (milestones >= 2) ? 30 : 0),

                          ///Milestone 3
                          (milestones >= 3) 
                          ? Text(
                              "Objetivo 3",
                              style: Theme.of(context).textTheme.subtitle
                            )
                          : SizedBox(),                          
                          SizedBox(height: (milestones >= 3) ? 15 : 0),
                          (milestones >= 3)
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                  borderRadius: BorderRadius.circular(25.0),
                                  border: Border.all(color: Colors.grey, width: 0.8)),
                              child: TextFormField(
                                focusNode: _milestone3,
                                style: Theme.of(context).textTheme.body1,
                                inputFormatters: [LengthLimitingTextInputFormatter(30)],
                                cursorColor: Theme.of(context).accentColor,
                                decoration: InputDecoration.collapsed(
                                  hintText: "Describe el objetivo",
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                                onChanged: (val) {
                                  setState(() => milestone3 = val);
                                },
                              ),
                            )
                          : SizedBox(),
                          SizedBox(height: (milestones >= 3) ? 30 : 0),

                          ///Milestone 4
                          (milestones >= 4) 
                          ? Text(
                              "Objetivo 4",
                              style: Theme.of(context).textTheme.subtitle
                            )
                          : SizedBox(),                          
                          SizedBox(height: (milestones >= 4) ? 15 : 0),
                          (milestones >= 4)
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                  borderRadius: BorderRadius.circular(25.0),
                                  border: Border.all(color: Colors.grey, width: 0.8)),
                              child: TextFormField(
                                focusNode: _milestone4,
                                style: Theme.of(context).textTheme.body1,
                                inputFormatters: [LengthLimitingTextInputFormatter(30)],
                                cursorColor: Theme.of(context).accentColor,
                                decoration: InputDecoration.collapsed(
                                  hintText: "Describe el objetivo",
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                                onChanged: (val) {
                                  setState(() => milestone4 = val);
                                },
                              ),
                            )
                          : SizedBox(),
                          SizedBox(height: (milestones >= 4) ? 30 : 0),

                          ///Milestone 5
                          (milestones >= 5) 
                          ? Text(
                              "Objetivo 5",
                              style: Theme.of(context).textTheme.subtitle
                            )
                          : SizedBox(),                          
                          SizedBox(height: (milestones >= 5) ? 15 : 0),
                          (milestones >= 5)
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                  borderRadius: BorderRadius.circular(25.0),
                                  border: Border.all(color: Colors.grey, width: 0.8)),
                              child: TextFormField(
                                focusNode: _milestone5,
                                style: Theme.of(context).textTheme.body1,
                                inputFormatters: [LengthLimitingTextInputFormatter(30)],
                                cursorColor: Theme.of(context).accentColor,
                                decoration: InputDecoration.collapsed(
                                  hintText: "Describe el objetivo",
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                                onChanged: (val) {
                                  setState(() => milestone5 = val);
                                },
                              ),
                            )
                          : SizedBox(),
                          SizedBox(height: (milestones >= 5) ? 30 : 0),

                        ],
                      ),

                      ///Add Milestone Button
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:<Widget>[
                            IconButton(
                              icon: Icon(Icons.add_circle_outline, color: Colors.black, size: 30),
                              onPressed: (){
                                setState(() {
                                  milestones = milestones + 1;
                                });                  
                              }
                            ),
                            Text(
                              'Agregar Milestone',
                              style: Theme.of(context).textTheme.body1,
                            )
                          ]
                        ),
                      ),

                      SizedBox(height: 20),

                      ///Goal Deadline
                      Text(
                        "Duración",
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      SizedBox(height: 20),
                      ///Deadline Options
                      Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ///1 Month
                            InkWell(
                              onTap: () {
                                setState(() {
                                  dateTo =
                                      DateTime.now().add(Duration(days: 30));                                      
                                  dateColor1month = Theme.of(context).accentColor;
                                  dateText1month = Colors.white;
                                  dateColor3month = Colors.white;
                                  dateText3month = Colors.black;
                                  dateColor6month = Colors.white;
                                  dateText6month = Colors.black;
                                  borderColor1month = Theme.of(context).accentColor;
                                  borderColor3month = Colors.black;
                                  borderColor6month = Colors.black;
                                });
                              },
                              splashColor: Colors.black.withOpacity(0.5),
                              child: Container(
                                width: MediaQuery.of(context).size.width *0.25,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: dateColor1month,
                                  border: Border.all(
                                      color: borderColor1month, width: 0.7),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                    child: Text("1 mes",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 12,
                                            color: dateText1month))),
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width *0.05),

                            ///3 month
                            InkWell(
                              onTap: () {
                                setState(() {
                                  dateTo =
                                      DateTime.now().add(Duration(days: 180));
                                  dateColor1month = Colors.white;
                                  dateText1month = Colors.black;
                                  dateColor3month = Theme.of(context).accentColor;
                                  dateText3month = Colors.white;
                                  dateColor6month = Colors.white;
                                  dateText6month = Colors.black;
                                  borderColor1month = Colors.black;
                                  borderColor3month = Theme.of(context).accentColor;
                                  borderColor6month = Colors.black;
                                });
                              },
                              splashColor: Colors.black.withOpacity(0.5),
                              child: Container(
                                width: MediaQuery.of(context).size.width *0.25,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: dateColor3month,
                                  border: Border.all(
                                      color: borderColor3month, width: 0.7),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                    child: Text("3 meses",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 12,
                                            color: dateText3month))),
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width *0.05),

                            ///6 month
                            InkWell(
                              onTap: () {
                                setState(() {
                                  dateTo =
                                      DateTime.now().add(Duration(days: 90));
                                  dateColor1month = Colors.white;
                                  dateText1month = Colors.black;
                                  dateColor3month = Colors.white;
                                  dateText3month = Colors.black;
                                  dateColor6month = Theme.of(context).accentColor;
                                  dateText6month =  Colors.white;
                                  borderColor1month = Colors.black;
                                  borderColor3month = Colors.black;
                                  borderColor6month = Theme.of(context).accentColor;
                                });
                              },
                              splashColor: Colors.black.withOpacity(0.5),
                              child: Container(
                                width: MediaQuery.of(context).size.width *0.25,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: dateColor6month,
                                  border: Border.all(
                                      color: borderColor6month, width: 0.7),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                    child: Text("6 meses",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 12,
                                            color: dateText6month))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 35),
                      
                      ///Button
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 35.0,
                          child: RaisedButton(
                            onPressed: () {
                              
                              milestoneList = [];

                              if(milestone1 != "" && milestone1 != null){
                                milestoneList.add(milestone1);
                              }
                              if(milestone2 != "" && milestone2 != null){
                                milestoneList.add(milestone2);
                              }
                              if(milestone3 != "" && milestone3 != null){
                                milestoneList.add(milestone3);
                              }
                              if(milestone4 != "" && milestone4 != null){
                                milestoneList.add(milestone4);
                              }
                              if(milestone5 != "" && milestone5 != null){
                                milestoneList.add(milestone5);
                              }

                              milestoneList.forEach((milestone){
                                newMilestoneList.add(
                                  {
                                    'Milestone': milestone,
                                    'Complete': false,
                                  }
                                );
                              });
         
                              print(newMilestoneList);                   
                              
                              if(goalDescription == null){
                                setState(() {
                                  errorText = 'No olvides agregar una descripción';
                                  showErrorText = true;
                                });
                              } else if(milestone1 == "" || milestone1 == null) {
                                setState(() {
                                  errorText = 'Agrega por lo menos un milestone';
                                  showErrorText = true;
                                });
                              } else {
                                
                                DatabaseService().createGoal(
                                  goalDescription, 
                                  0,
                                  0, 
                                  milestones, 
                                  unit, 
                                  dateTo, 
                                  widget.goalType,
                                  newMilestoneList,
                                );

                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => InicioNew()));                                                                                           
                              
                              }
                              
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            padding: EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [Theme.of(context).accentColor, Theme.of(context).primaryColor],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                              ),
                              child: Container(
                                constraints: BoxConstraints(maxWidth: 200.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "GUARDAR META",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12, fontWeight: FontWeight.w500 ,color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      showErrorText 
                      ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          errorText,
                          style: GoogleFonts.montserrat(
                            color: Colors.redAccent[700],
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                          )
                        )
                      )
                      : SizedBox(height: 10),
                      SizedBox(height: 20),

                    ],
                  ),
                )),
          ),
    );
  }
}
