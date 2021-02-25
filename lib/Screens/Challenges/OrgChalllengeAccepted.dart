import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrganizationChallengeAccepted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        height: 250,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Cerrar
              Container(
                alignment: Alignment(1.0, 0.0),
                child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                    iconSize: 20.0),
              ),
              SizedBox(
                height: 10,
              ),
              //Text
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 5),
                child: Text(
                  "¡Reto aceptado!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 5),
                child: Text(
                  "Completa el reto en la fecha establecida y estarás concursando por increíbles premios",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.grey[700],
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
          ])
        ),
      )
    );
  }
}