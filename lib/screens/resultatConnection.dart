import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:my_budget/screens/components/circurlarPasDeDepense.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../uTils.dart';
import 'components/CircularPourcentage.dart';

//
//Partie inferieur de l'application .
//Cette Zone affiche la liste liers a l'affichage des depences effectue.
//Par defaut vous aurez le text("PAS DE DEPENSE") si aucune connnection internet n'est etablie..

class ResultatConnection extends StatefulWidget {
  final String date;
  final Function onResult;

  ResultatConnection({
    this.onResult,
    @required this.date,
  });

  @override
  _ResultatConnectionState createState() => _ResultatConnectionState();
}

class _ResultatConnectionState extends State<ResultatConnection> {
  Widget resultatVide = CircularPasDeDepense();
  List<QueryDocumentSnapshot<Map<String, dynamic>>> depenses;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("Depenses")
              .where("date", isEqualTo: widget.date) //
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return IconButton(
                icon: Icon(Icons.replay),
                onPressed: () {},
              );
            }
            depenses = snapshot.data?.docs ??
                []; //si snapshot.data est null alors return

            if (depenses.isEmpty) {
              return resultatVide;
            }
            int total = 0;

            depenses.forEach(
              (dep) {
                total += int.tryParse(dep["montant"]);
              },
            );

            widget.onResult(total);
            int nombreDepenses = depenses.length;

            return FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                SharedPreferences prefs = snapshot.data;
                prefs.setInt("_nombreDepenses", nombreDepenses);

                String budgetExcedent;

                int budgetExcedentEntier;

                if (prefs != null) {
                  budgetExcedent = prefs.getString("_montantInitial") ?? "0";
                  budgetExcedentEntier = int.tryParse(budgetExcedent);
                }
                prefs.setInt("_sommeTotalDepense", total);

                return Column(
                  children: [
                    ListTile(
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 1),
                          Text(
                            "$total f",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          SizedBox(height: 0.5),
                          Text("Le nombre de depenses: $nombreDepenses"),
                          Text(
                            "Budget $budgetExcedentEntier f - Excédentaire ",
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          )
                        ],
                      ),
                      trailing: Container(
                        child: CircularPourcentage(toTalduJour: "$total"),
                      ),
                    ),
                    Flexible(
                      child: ListView.separated(
                        itemCount: depenses.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            height: 20,
                            indent: 50,
                            endIndent: 50,
                          );
                        },
                        //
                        itemBuilder: (BuildContext context, int index) {
                          QueryDocumentSnapshot<Map<String, dynamic>>
                              depensesData = depenses[index];

                          DateTime dateEnregistrement =
                              DateTime.fromMillisecondsSinceEpoch(
                            depensesData["createdAt"],
                          );
                          print("ICI ligne:110. -->$dateEnregistrement");
                          print(
                              "widget DATE (resultatConnection ligne:112) -------> ${widget.date}");
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                            ),
                            title: Text('${depensesData["titre"]}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${depensesData["montant"]} f'),
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_alarm,
                                      size: 12,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      '${dateEnregistrement.hour} h : ${dateEnregistrement.minute}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton(
                              icon: Icon(Icons.more_vert),
                              itemBuilder: (ctx) {
                                return [
                                  PopupMenuItem(
                                    child: Text("Editer"),
                                    value: "edit",
                                  ),
                                  PopupMenuItem(
                                    child: Text("Suprimer"),
                                    value: "supression",
                                  )
                                ];
                              },
                              onSelected: (val) {
                                if (val == "edit") {
                                  showDialogFunction_2(context,
                                      donne: depensesData);
                                } else if (val == "supression") {
                                  showDialogSup(context, donne: depensesData);
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
