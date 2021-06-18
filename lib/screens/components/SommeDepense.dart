/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//************************************************ */
//Ce fichier est INUTILE mais je laisse quand meme
//Elle etait censé calculer la somme des pense effectuer
//sur une journer avec des appele a FIREBASE.
//
//Elle a ete appeler dans Home_page.dart ligne commenter 194 
//************************************************ */

class SommeDep extends StatefulWidget {
  @override
  _SommeDepState createState() => _SommeDepState();
}

class _SommeDepState extends State<SommeDep> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> depTotal;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection("Depenses").snapshots(),
      builder: (cxt, snapshot) {
        depTotal = snapshot.data?.docs ?? [];

        if (depTotal.isEmpty) {
          return Text("0 f");
        }

        int toTal = 0;

        depTotal.forEach(
          (deP) {
            toTal += int.tryParse(deP["montant"]);
          },
        );

        return Text(
          "$toTal f",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }
}
 */