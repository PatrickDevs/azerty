//---------------------------------IMPORTATION---------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';
//-----------------------------------------------------------------------------------

//-----------------------------------FONCTION----------------------------------------
//
//
//
//-------Affichage d'un toast message-----------
afficher_toast_message(context) {
  Fluttertoast.showToast(
      msg: context,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

//
//
//------Boite de dialogue pour afficher un chargement circulaire---------------
showDialogChargement(context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.only(left: 125, right: 125, top: 15, bottom: 15),
          content: SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(),
          ),
        );
      });
}

//
//
//------Fonction pour ajouts une nouvelle depense------------------
showDialogFunction_2(context,
    {QueryDocumentSnapshot<Map<String, dynamic>> donne}) {
  TextEditingController _montant = TextEditingController(text: "0");
  TextEditingController _titre = TextEditingController();
  TextEditingController _commentaire = TextEditingController();
  if (donne != null) {
    _montant.text = donne['montant'];
    _titre.text = donne["titre"];
    _commentaire.text = donne["commentaire"];
  }

  showDialog(
    context: context,
    builder: (ctx) {
      return Center(
        child: Container(
          padding: EdgeInsets.only(top: 100, left: 25.0, right: 25.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          //
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Container(
                height: 400,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                padding: EdgeInsets.only(top: 30, left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Ajouter une depense",
                      style: TextStyle(fontSize: 20),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Divider(
                      height: 2,
                      color: Colors.grey,
                      //thickness: 2,
                      indent: 0,
                      endIndent: 0,
                    ),

                    SizedBox(
                      height: 15,
                    ),

                    //
                    TextFormField(
                      controller: _titre,
                      decoration: InputDecoration(labelText: "Un titre"),
                    ),

                    //
                    TextFormField(
                      controller: _montant,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Le montant",
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp("[0-9]"),
                        ),
                      ],
                    ),
                    //

                    TextFormField(
                      controller: _commentaire,
                      decoration: InputDecoration(
                        labelText: "Commentaire...",
                      ),
                    ),

                    SizedBox(
                      height: 30,
                    ),

                    Container(
                      padding: EdgeInsets.all(7.0),
                      child: Row(
                        children: [
                          Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Annuler",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          TextButton(
                            onPressed: () {
                              //Conversion des chaines de caractere en entier
                              String t = _montant.text
                                  .trim(); //D'abord on enleve les espaces entre les mots avec la methode trim(). trim() est une methode prope au type String
                              int n = int.tryParse(t) ??
                                  0; // ici on convertie la chaine de caractere t en entier qu'on stocker dans n.

                              if (_titre.text.isNotEmpty &&
                                  _montant.text.trim().isNotEmpty &&
                                  n > 0) {
                                if (donne != null) {
                                  //voici comment modifier un champ
                                  donne.reference.update({
                                    "titre": _titre.text,
                                    "montant": _montant.text,
                                    "commentaire": _commentaire.text
                                  }).then((value) {
                                    print("DONNEES ENREGISTRER ");
                                    Navigator.pop(context);
                                    afficher_toast_message("ok");
                                    _titre.text = "";
                                    _montant.text = "0";
                                    _commentaire.text = "";
                                  }).catchError((e) {
                                    print(
                                        "VOUS ETES DANS UN CATCH_ERROR: DONNEES NON ENREGISTRER");
                                    afficher_toast_message("NOT_ok");
                                  });
                                } else {
                                  //voici comment ajouter un champ
                                  DateTime now = DateTime
                                      .now(); //on creer une variable de type DateTime. DateTime.now() permet de stocker la date d'aujourd'hui.
                                  FirebaseFirestore.instance
                                      .collection("Depenses")
                                      .add({
                                    //voici comment creer et ajouter des champs dans FireBase.
                                    "titre": _titre.text,
                                    "montant": _montant.text,
                                    "commentaire": _commentaire.text,
                                    "date":
                                        "${now.day}-${now.month}-${now.year}", //stockage de la date qu'on formate. now est la variable qui contient la date du jour.
                                    "createdAt": DateTime.now()
                                        .millisecondsSinceEpoch, // DateTime.now() est recuperer en milliseconds
                                  }).then((value) {
                                    //Si la tache est effectuer : then((value){}).
                                    print("DONNEES ENREGISTRER ");
                                    Navigator.pop(context);
                                    afficher_toast_message("ok");
                                    _titre.text = "";
                                    _montant.text = "0";
                                    _commentaire.text = "";
                                  }).catchError((e) {
                                    //S'il y'a une erreur.
                                    print(
                                        "VOUS ETES DANS UN CATCH_ERROR: DONNEES NON ENREGISTRER");
                                    afficher_toast_message("NOT_ok");
                                  });
                                }
                              }
                            },
                            child: Text(
                              "Enregistrer",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

//
//
//---------Fonction pour suprimer un enregistrement----------------
showDialogSup(context, {QueryDocumentSnapshot<Map<String, dynamic>> donne}) {
  showDialog(
    context: context,
    builder: (cxt) {
      return AlertDialog(
        title: Text("Alert"),
        content: Text("Voulez-vous vraiment suprimer l'enregistrement ?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showDialogChargement(context);

              donne.reference.delete().then((value) {
                Navigator.pop(context);
                afficher_toast_message("Supression reuissit");
              }).catchError((erreur) {
                afficher_toast_message("Erreur: supression non faite");
              });
            },
            child: Text("Oui"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Non"),
          ),
        ],
      );
    },
  );
}

//
//
//-------------------------
showDialogFunction_Graphique(context) {
  showDialog(
    context: context,
    builder: (ctx) {
      return Center(
        child: Container(
          height: 430,
          padding: EdgeInsets.only(top: 10, left: 50.0, right: 50.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          //
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green[50],
                ),
                padding: EdgeInsets.only(top: 30, left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Center(
                        child: CircularPercentIndicator(
                          radius: 150.0,
                          lineWidth: 100.0,
                          percent: 0.0,
                          footer: Container(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Column(
                              children: [
                                new Text(
                                  "Il vous reste...",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          backgroundColor: Colors.green,
                          progressColor: Colors.blue,
                        ),
                      ),
                    ),

                    SizedBox(height: 50),

                    //

                    Container(
                      child: Center(
                        child: CircularPercentIndicator(
                          radius: 150.0,
                          lineWidth: 100.0,
                          percent: 0.0,
                          footer: Container(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Column(
                              children: [
                                new Text(
                                  "Il vous reste...",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          backgroundColor: Colors.blueAccent,
                          progressColor: Colors.blue,
                        ),
                      ),
                    ),
                    //

                    SizedBox(height: 50),

                    //

                    Container(
                      child: Center(
                        child: CircularPercentIndicator(
                          radius: 150.0,
                          lineWidth: 100.0,
                          percent: 0.0,
                          footer: Container(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Column(
                              children: [
                                new Text(
                                  "Il vous reste...",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          backgroundColor: Colors.greenAccent,
                          progressColor: Colors.blue,
                        ),
                      ),
                    ),

                    //

                    SizedBox(height: 50),

                    //

                    Container(
                      child: Center(
                        child: CircularPercentIndicator(
                          radius: 150.0,
                          lineWidth: 100.0,
                          percent: 0.0,
                          footer: Container(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Column(
                              children: [
                                new Text(
                                  "Il vous reste...",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          backgroundColor: Colors.brown,
                          progressColor: Colors.blue,
                        ),
                      ),
                    ),

                    //

                    SizedBox(height: 50),

//

                    Container(
                      child: Center(
                        child: CircularPercentIndicator(
                          radius: 150.0,
                          lineWidth: 100.0,
                          percent: 0.0,
                          footer: Container(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Column(
                              children: [
                                new Text(
                                  "Il vous reste...",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          backgroundColor: Colors.grey,
                          progressColor: Colors.blue,
                        ),
                      ),
                    ),

                    //

                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

//
//
//----Alerte dialogue pour la page PARAMETRE: < votre budget journalier > ---
showDialogBudget(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  TextEditingController _montantBudget =
      TextEditingController(text: prefs.getString("_montantInitial") ?? "0");

  showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Le montant du budget journalier"),
          content: TextField(
            controller: _montantBudget,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Le montant",
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp("[0-9]"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                prefs.setString("_montantInitial", _montantBudget.text);
                Navigator.pop(context);
              },
              child: Text("Oui"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Non"),
            ),
          ],
        );
      });
}

//
//
//---------Fonction pour definir et afficher ne nombre de fois qu'un rappel sera effectuer.Elle est utiliser dans la page PARAMETRE----------------

showModalBottomSheetFunct(context, Function onTap) {
  List<dynamic> tabs = [
    {"label": "une seul fois par jour", "code": 1},
    {"label": "deux fois par jour", "code": 2},
    {"label": "trois fois par jour", "code": 3},
    {"label": "quatre fois par jour", "code": 4},
    {"label": "cinq seul fois par jour", "code": 5}
  ];

  showModalBottomSheet(
    context: context,
    builder: (ctx) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: tabs.map((el) {
            return ListTile(
              title: Text(el["label"]),
              onTap: () {
                onTap(el); //Cette fonction est utiliser dans le fichier
                //parametre.dart: ligne 148.
                prefs.setInt("alarm", el["code"]);
                Navigator.pop(context);
              },
              trailing:
                  prefs.getInt("alarm") == el["code"] ? Icon(Icons.done) : null,
            );
          }).toList(),
        ),
      );
    },
  );
}
