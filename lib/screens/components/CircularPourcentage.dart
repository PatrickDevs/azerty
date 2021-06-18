import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Ce fichier calcule le pourcentage total des depenses effectuer
//qu'elle affiche ensuite dans un cercle(grace au plugin dart percent_indicator).
//Elle est exploiter par le fichier le resultatConnection.dart : ligne 111.
class CircularPourcentage extends StatefulWidget {
  final String toTalduJour;

  CircularPourcentage({this.toTalduJour});

  @override
  _CircularPourcentageState createState() => _CircularPourcentageState();
}

class _CircularPourcentageState extends State<CircularPourcentage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          SharedPreferences prefs = snapshot.data;
          //
          double depenseDuJour = double.tryParse("${widget.toTalduJour}");
          String budgetDuJour;
          double convertionEnString;
          int pourcentageDepenser;
          //
          if (prefs != null) {
            budgetDuJour = prefs.getString("_montantInitial") ?? "0";
            print("budgetDuJour");
            convertionEnString = double.tryParse(budgetDuJour);
            //
            if (convertionEnString == null || convertionEnString == 0) {
              convertionEnString = 0;
              pourcentageDepenser = 0;
            } else {
              pourcentageDepenser =
                  ((depenseDuJour / convertionEnString) * 100).floor();
            }
          }
          return CircularPercentIndicator(
            radius: 47.0,
            lineWidth: 1.5,
            percent: 0.0,
            center: new Text(
              "$pourcentageDepenser %",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.grey,
            progressColor: Colors.blue,
          );
        });
  }
}
