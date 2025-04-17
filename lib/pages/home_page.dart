// Importation des packages nécessaires
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:report_internship/pages/redaction_page.dart';
import '../authentification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

// Widget principal de la page d'accueil
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Référence à la collection Firestore pour les rapports quotidiens
  final CollectionReference fetchData = FirebaseFirestore.instance.collection("daily_report");

  // Fonction pour afficher un dialogue d'ajout de journée
  Future<void> addJourney() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return addJourneyDialog(
          context: context,
          onPressed: () {
            // Récupération des données depuis les contrôleurs
            String day = dayController.text;
            String activity = activityController.text;
            String lieu = lieuController.text;
            String skills = skillsController.text;

            // Envoi des données à Firestore
            fetchData.add({
              'day': day,
              'activity': activity,
              'date': FieldValue.serverTimestamp(), // Ajout automatique de la date serveur
              'lieu': lieu,
              'skills': skills,
            });
          },
        );
      },
    );
  }

  // Fonction pour afficher une alerte avant suppression
  Future<void> deleteJourney(String docId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.teal[900],
          title: Text("Supprimer ce rapport ?", style: TextStyle(color: Colors.white)),
          content: Text("Cette action est irréversible.", style: TextStyle(color: Colors.white70)),
          actions: [
            // Bouton pour annuler la suppression
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Annuler", style: TextStyle(color: Colors.grey[300])),
            ),
            // Bouton pour confirmer la suppression
            TextButton(
              onPressed: () async {
                await fetchData.doc(docId).delete();
                Navigator.pop(context);
              },
              child: Text("Supprimer", style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour modifier un rapport existant
  Future<void> editJourney(DocumentSnapshot documentSnapshot) async {
    // Remplissage des champs avec les données existantes
    dayController.text = documentSnapshot['day'];
    activityController.text = documentSnapshot['activity'];
    lieuController.text = documentSnapshot['lieu'];
    skillsController.text = documentSnapshot['skills'];

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return addJourneyDialog(
          context: context,
          onPressed: () async {
            String day = dayController.text;
            String activity = activityController.text;
            String lieu = lieuController.text;
            String skills = skillsController.text;

            // Mise à jour des données dans Firestore
            await fetchData.doc(documentSnapshot.id).update({
              'day': day,
              'activity': activity,
              'lieu': lieu,
              'skills': skills,
            });

            Navigator.pop(context);
          },
        );
      },
    );
  }

  // Contrôleurs pour gérer la saisie utilisateur dans les formulaires
  TextEditingController dayController = TextEditingController();
  TextEditingController activityController = TextEditingController();
  TextEditingController lieuController = TextEditingController();
  TextEditingController skillsController = TextEditingController();

  // Gestion de la navigation dans le menu en bas
  int currentIndex = 0;

  // Pages disponibles via le menu (ici seulement RedactionPage utilisée)
  final List<Widget> pages = [
    RedactionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mobile Report",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
      home: Scaffold(
        // Drawer (menu latéral) avec infos utilisateur et bouton de déconnexion
        drawer: SafeArea(
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.teal[800]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.account_circle, size: 50, color: Colors.white),
                      SizedBox(height: 10),
                      Text('Bienvenue ✨', style: GoogleFonts.raleway(
                        textStyle: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                      Text(
                        FirebaseAuth.instance.currentUser!.email!,
                        style: GoogleFonts.raleway(
                          textStyle: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                // Bouton de déconnexion
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Déconnexion"),
                  onTap: () async {
                    Navigator.pop(context); // Ferme le menu
                    await AuthService().signout(context: context);
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text("Report Internship Activity"),
          centerTitle: true,
        ),
        // Affichage en temps réel des rapports depuis Firestore
        body: StreamBuilder(
          stream: fetchData.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          // Titre avec le jour
                          title: Text(
                            "Jour : ${documentSnapshot['day']}",
                            style: TextStyle(
                              color: Colors.teal,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Sous-titre avec les autres infos
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text("Activités : ${documentSnapshot['activity']}"),
                              Text("Date : ${(documentSnapshot['date'] as Timestamp).toDate()}"),
                              Text("Lieu : ${documentSnapshot['lieu']}"),
                              Text("Compétences : ${documentSnapshot['skills']}"),
                            ],
                          ),
                          // Actions : modifier ou supprimer le rapport
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.teal),
                                onPressed: () {
                                  editJourney(documentSnapshot);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  deleteJourney(documentSnapshot.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            // Affiche un spinner si les données ne sont pas encore chargées
            return Center(child: CircularProgressIndicator());
          },
        ),
        // Bouton flottant pour ajouter un nouveau rapport
        floatingActionButton: FloatingActionButton(
          onPressed: addJourney,
          tooltip: "Add",
          child: Icon(Icons.add),
        ),
        // Barre de navigation inférieure (Home et Rédaction)
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: "Home"),
            NavigationDestination(icon: Icon(Icons.addchart), label: "Redaction"),
          ],
        ),
      ),
    );
  }

  // Composant personnalisé de dialogue pour ajouter ou modifier une journée
  Dialog addJourneyDialog({
    required BuildContext context,
    required VoidCallback onPressed,
  }) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.teal[900],
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // En-tête du dialogue
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Add Journey", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Champs de saisie personnalisés
              dataFirebaseInput("ex: Day 1", "Entrer le jour d'activité", dayController),
              dataFirebaseInput("ex: Monitoring d'une Database", "Activités réalisées", activityController),
              dataFirebaseInput("ex: Ebène, Maurice", "Lieu", lieuController),
              dataFirebaseInput("ex: Flutter, Java", "Compétences acquise", skillsController),
              SizedBox(height: 20),
              ElevatedButton(onPressed: onPressed, child: Text("Ajouter")),
            ],
          ),
        ),
      ),
    );
  }

  // Fonction pour générer les champs de formulaire Firebase (réutilisable)
  Padding dataFirebaseInput(
    String hint,
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.white70),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.tealAccent, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
        ),
      ),
    );
  }
}
