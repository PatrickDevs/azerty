import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:my_budget/screens/parametre.dart';
import 'package:my_budget/screens/resultatConnection.dart';
import 'package:my_budget/uTils.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/searchPage.dart';

//Interface Home............................................
//Partie superieur de la page Home
//Elle affiche un cercle de consomation des depences avec a son centre
//les depenses effectuer(Consomme: 0 f, Budjet journalier: 0 f par defaut.) et
//une TabBar qui affiche une liste horizontal des historiques de depence journaliere qui se
//decremente de 1 jour.
//

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedDate;

  int totalAfficher = 0;
  int nbTab = 6; //Nombre d'onglet a afficher
  List tabVide = [];
  ValueNotifier totalCtrl = ValueNotifier(0);

  @override
  void initState() {
    //Voici la fonction qui affiche la liste des depenses
    //dans la TabBar. Les prints sont present que pour debugage..
    //Je les laisses quand meme ....
    print("InitState");
    super.initState();
    DateTime now = DateTime.now();
    now = now.add(Duration(days: 1));
    String formatageDate;
    for (int i = 0; i < nbTab; i++) {
      now = now.subtract(
        Duration(days: 1),
      );
      print("Ici_DATE--->$now");
      formatageDate = "${now.day}-${now.month}-${now.year}";

      tabVide.add(
        {
          "label": "$formatageDate",
          "isLast": i + 1 == nbTab,
        },
      );

      if (i + 1 == nbTab) {
        selectedDate = formatageDate;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: StatefulBuilder(
        builder: (context, s) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(280),
              child: Container(
                //
                decoration: BoxDecoration(
                  //border: Border.all(width: 2, color: Colors.black),
                  image: DecorationImage(
                    alignment: Alignment.center,
                    image: new ExactAssetImage(
                      "assets/finance4.jpg",
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.white38,
                      BlendMode.dstATop,
                    ),
                  ),
                ),
                //
                child: Container(
                  color: Colors.white.withOpacity(0.2),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black12,
                        ),
                        padding: EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.list),
                              onPressed: () {
                                showDialogFunction_Graphique(context);
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              " Mon cahier budgétaire",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.search, color: Colors.black45),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return SearchPage();
                                    },
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.settings, color: Colors.black45),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ParametreScreen();
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: FutureBuilder<SharedPreferences>(
                            future: SharedPreferences.getInstance(),
                            builder: (context, snapshot) {
                              SharedPreferences prefs = snapshot.data;

                              //
                              String budgetJournalier;

                              int budgetJournalierEntier = 0;

                              //
                              print(
                                  " **---> ICI ligne:154(Home_page)--> $budgetJournalierEntier");

                              if (prefs != null) {
                                budgetJournalier =
                                    prefs.getString("_montantInitial") ?? "0";

                                budgetJournalierEntier =
                                    int.tryParse(budgetJournalier) ?? 0;
                              }

                              //

                              DateTime maintenant = DateTime.now();

                              return Center(
                                child: CircularPercentIndicator(
                                  radius: 140.0,
                                  lineWidth: 5.0,
                                  percent: 0.0,
                                  center: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(1.5),
                                        child: Text("Consomme"),
                                      ),
                                      //SommeDep(),
                                      ValueListenableBuilder(
                                        valueListenable: totalCtrl,
                                        builder: (context, value, child) {
                                          return Text(" $totalAfficher f");
                                        },
                                      ),
                                      SizedBox(height: 2),
                                      Padding(
                                        padding: const EdgeInsets.all(1.5),
                                        child: Text("Budget journalier"),
                                      ),
                                      Text(
                                        " ${budgetJournalier ?? 0} f", //IMPORTANT---------------------
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  footer: Container(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Column(
                                      children: [
                                        new Text(
                                          "Il vous reste ${(budgetJournalierEntier ?? 0) - (totalAfficher ?? 0)} f à dépenser ",
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        new Text(
                                          "ce  ${maintenant.day}-${maintenant.month}-${maintenant.year}",
                                        ),
                                      ],
                                    ),
                                  ),
                                  backgroundColor: Colors.orange,
                                  progressColor: Colors.blue,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(0),
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          width: double.infinity,
                          child: TabBar(
                            labelColor: Colors.black,
                            indicatorColor: Colors.blueGrey,
                            isScrollable: true,
                            indicatorWeight: 2,
                            indicatorSize: TabBarIndicatorSize.tab,
                            tabs: tabVide.map<Widget>(
                              (item) {
                                return item["isLast"]
                                    ? Container(
                                        padding: EdgeInsets.only(left: 10),
                                        decoration: BoxDecoration(
                                            //border: Border.all(color: Colors.red),
                                            ),
                                        height: 15,
                                        child: DropdownButton(
                                          iconSize: 20,
                                          elevation: 0,
                                          //itemHeight: 10,
                                          underline: SizedBox(height: 1),
                                          selectedItemBuilder: ((context) {
                                            return [
                                              Text(
                                                "          $selectedDate          ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ];
                                          }),
                                          value: "select",
                                          onChanged: (v) {
                                            if (v == "select") {
                                              showDatePicker(
                                                context: context,
                                                initialDate:
                                                    DateTime.now().subtract(
                                                  Duration(days: 6),
                                                ),
                                                lastDate:
                                                    DateTime.now().subtract(
                                                  Duration(days: 5),
                                                ),
                                                firstDate:
                                                    DateTime.now().subtract(
                                                  Duration(days: 365 * 2),
                                                ),
                                              ).then((r) {
                                                setState(
                                                  () {
                                                    String resultat =
                                                        "${r.day}-${r.month}-${r.year}";

                                                    selectedDate = resultat;
                                                  },
                                                );
                                              });
                                            }
                                          },
                                          items: [
                                            DropdownMenuItem(
                                              child: Text(
                                                "Selectionner une date",
                                              ),
                                              value: "select",
                                            ),
                                          ],
                                        ),
                                      )
                                    : Tab(
                                        text: item["label"],
                                      );
                              },
                            ).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            //
            body: TabBarView(
              children: tabVide.map<Widget>(
                (item) {
                  return ResultatConnection(
                    onResult: (t) {
                      totalAfficher = t;
                      totalCtrl.value = totalAfficher;

                      print(totalAfficher);
                    },
                    date: item["label"],
                  );
                },
              ).toList(),
            ),

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialogFunction_2(context);
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.blueGrey,
            ),
          );
        },
      ),
    );
  }
}
