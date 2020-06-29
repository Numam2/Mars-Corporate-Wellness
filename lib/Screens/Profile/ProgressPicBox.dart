import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_trainer/Models/userProfile.dart';
import 'package:personal_trainer/Screens/Profile/ProgressPictures.dart';
import 'package:provider/provider.dart';

class ProgressPicBox extends StatelessWidget {  
  
  @override
  Widget build(BuildContext context) {

    final _profile = Provider.of<ProgressPictureList>(context);    

    if (_profile == null){

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            ///Title
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              Text('Mis Fotos de Progreso', style: Theme.of(context).textTheme.title),
              Spacer(),
              IconButton(
                onPressed:  () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProgressPicturesPage()));
              },
                icon: Icon(Icons.add, color: Theme.of(context).primaryColor, size: 30)
              ),
            ]),
            SizedBox(height:15),
            Container(
              height: 150,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(8))
                      ),
                    ),
                  );
                }
              ),
            ),
          ] 
        ),
      );

    } else if (_profile.progressPicturesList.length == 0){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            ///Title
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              Text('Mis Fotos de Progreso', style: Theme.of(context).textTheme.title),
              Spacer(),
              IconButton(
                onPressed:  () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProgressPicturesPage()));
              },
                icon: Icon(Icons.add, color: Theme.of(context).primaryColor, size: 30)
              ),
            ]),
            SizedBox(height:15),
            Container(
              height: 150,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.all(Radius.circular(8))
                      ),
                      child: Center(
                        child: Icon(
                          Icons.photo_size_select_actual, size: 50, color: Colors.grey[300],
                        )
                      )
                    ),
                  );
                }
              ),
            ),
          ] 
        ),
      );
    }

    final int lastImage = _profile.progressPicturesList.length -1;
    final int secondLastImage = _profile.progressPicturesList.length -2;
    
    return Column(
      children: <Widget>[
          ///Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              Text('Mis Fotos de Progreso', style: Theme.of(context).textTheme.title),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProgressPicturesPage()));
                },
                child: Text(
                  'Ver más',
                  style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).primaryColor),
                ),
              ),
            ]),
          ),
          SizedBox(height:15),
          ///Pictures
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children:<Widget>[
                ///Last Image
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    image: DecorationImage(
                      image: NetworkImage(_profile.progressPicturesList[lastImage].image),
                      fit: BoxFit.cover,
                    )
                  ),
                ),
                SizedBox(width:15),
                ///Second to last Image
                (secondLastImage < 0)
                ? SizedBox()
                : Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    image: DecorationImage(
                      image: NetworkImage(_profile.progressPicturesList[secondLastImage].image),
                      fit: BoxFit.cover,
                    )
                  ),
                ),
              ] 
            ),
          )
          
      ],
    );
  }
}