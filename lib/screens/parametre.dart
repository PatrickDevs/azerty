import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../uTils.dart';
import 'package:url_launcher/url_launcher.dart';

//Cette interface est celle du parametre de l'appli.
//Elle utilise enormement le fichier uTils.dart.

class ParametreScreen extends StatefulWidget {
  @override
  _ParametreScreenState createState() => _ParametreScreenState();
}

class _ParametreScreenState extends State<ParametreScreen> {
  void _launchURL() async {
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  final _url = "mailto:patosbrowser@gmail.com?subject=Salut&body=News";
  Map code; // Cette nous sevira plus bas pour recuper une list
  // creer dans dans le fichier uTils.dart: ligne 528 a 584.
  String rien = " ";
  int alarm = 1;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          SharedPreferences prefs = snapshot.data;
          int parametreDepenseTotal = prefs.getInt("_nombreDepenses") ?? 0;
          int parametreSommeTotalDepense;

          parametreSommeTotalDepense = prefs.getInt("_sommeTotalDepense") ?? 0;

          return Scaffold(
            backgroundColor: Colors.brown[50],
            appBar: AppBar(
              backgroundColor: Colors.blueGrey[50],
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(
                "Paramètres",
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.save_alt),
                  onPressed: () {},
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text(
                            "Budget",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialogBudget(context);
                            },
                            child: FutureBuilder<SharedPreferences>(
                              future: SharedPreferences.getInstance(),
                              builder: (context, snapshot) {
                                SharedPreferences prefs = snapshot.data;
                                String parametreBudgetJournalier;
                                int parametreBudgetJournalierEntier;

                                if (prefs != null) {
                                  parametreBudgetJournalier =
                                      prefs.getString("_montantInitial") ?? "0";

                                  parametreBudgetJournalierEntier =
                                      int.tryParse(parametreBudgetJournalier) ??
                                          0;
                                }
                                return ListTile(
                                  title: Text("Votre budget journalier"),
                                  trailing: Text(
                                      "$parametreBudgetJournalierEntier f"),
                                );
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              return _launchURL();
                            },
                            child: ListTile(
                              title: Text("Sauvegarder les dépenses"),
                              subtitle: Text("dans votre mail"),
                            ),
                          ),
                          ListTile(
                            title: Text("Nombre total des dépenses"),
                            subtitle: Text(
                                "$parametreDepenseTotal dépenses sur 3 jour(s)"),
                            trailing: Text("0.00/j"),
                          ),
                          ListTile(
                            title: Text("Somme totale dépensée"),
                            subtitle: Text(
                                " $parametreSommeTotalDepense f sur 3 jour(s)"),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text(
                            "Notifications",
                            style: TextStyle(fontSize: 15),
                          ),
                          Spacer(),
                          Icon(Icons.notifications),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheetFunct(
                            //recupere le choix de l'utilisateur et le stock
                            // pour le afficher la ensuite dans une ListTile.
                            //regarder plus bas:ligne 159.
                            context,
                            (arg) {
                              setState(() {
                                //la variable "code" est de type MAP.
                                //Elle est creer plus haut: Ligne:21 de ce fichier.
                                code = arg;
                              });
                            },
                          );
                          prefs.setInt("_nombreDeNotification", code["code"]);
                        },
                        child: ListTile(
                          //..ICI
                          title: Text("Définissez le nombre de fois"),
                          subtitle: Text(
                              " qu'un rappel d'enregistrement sera effectué "),
                          trailing: code == null
                              ? null
                              : Text('${code["code"] ?? rien}x'),
                        ),
                        //...................................................
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text(
                            "Stockage",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: GestureDetector(
                        onTap: () {},
                        child: ListTile(
                          title: Text(" Utilisation du stockage "),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text(
                            "Autres",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(" Faites un don "),
                          ),
                          ListTile(
                            title: Text(" Copyright "),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
