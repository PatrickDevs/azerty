import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

//Ici on a utiliser le plugin "percent_indicator"
//pour creer un cercle et afficher le texte:PAS DE DEPENSE.
//Cette classe est appeler dans resultatConnection.dart : ligne 30 et 56

class CircularPasDeDepense extends StatefulWidget {
  @override
  _CircularPasDeDepenseState createState() => _CircularPasDeDepenseState();
}

class _CircularPasDeDepenseState extends State<CircularPasDeDepense> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: CircularPercentIndicator(
          radius: 135.0,
          lineWidth: 1.0,
          percent: 0.0,
          center: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(" Pas de dépense"),
                ),
                new Text(
                  "0%",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.grey,
          progressColor: Colors.blue,
        ),
      ),
    );
  }
}
