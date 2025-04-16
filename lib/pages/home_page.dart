import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// import '../authentification_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class Home extends StatelessWidget {
//   const Home({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Bienvenue ✨',
//                 style: GoogleFonts.raleway(
//                   textStyle: const TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               // Affiche l'email de l'utilisateur connecté
//               Text(
//                 FirebaseAuth.instance.currentUser!.email!.toString(),
//                 style: GoogleFonts.raleway(
//                   textStyle: const TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               _logout(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Widget pour le boutton de déconnexion
//   Widget _logout(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color(0xff0D6EFD),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//         minimumSize: const Size(double.infinity, 60),
//         elevation: 0,
//       ),
//       onPressed: () async {
//         await AuthService().signout(context: context);
//       },
//       child: const Text("Déconnexion"),
//     );
//   }
// }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Specification de la collection
  final CollectionReference fetchData = FirebaseFirestore.instance.collection(
    "daily_report",
  );

  Future<void> addJourney() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddJourneyDialog(context: context, onPressed: () {
          String day = dayController.text;
          String activity = activityController.text;
          String lieu = lieuController.text;
          String skills = skillsController.text;
          
          // DateTime dateFormat = DateF
          fetchData.add({
            'day': day,
            'activity': activity,
            'date': FieldValue.serverTimestamp(),
            'lieu': lieu,
            'skills': skills,
          });
        });
      },
    );
  }

  // Déclaration pour les inputs
  TextEditingController dayController = TextEditingController();
  TextEditingController activityController = TextEditingController();
  TextEditingController lieuController = TextEditingController();
  TextEditingController skillsController = TextEditingController();

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
        drawer: Drawer(),
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text("Report Internship Activity"),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: fetchData.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            "Jour : ${documentSnapshot['day']}",
                            style: TextStyle(
                              color: Colors.teal,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text(
                                "Activités : ${documentSnapshot['activity']}",
                              ),
                              Text(
                                "Date : ${(documentSnapshot['date'] as Timestamp).toDate()}",
                              ),
                              Text("Lieu : ${documentSnapshot['lieu']}"),
                              Text(
                                "Compétences : ${documentSnapshot['skills']}",
                              ),
                            ],
                          ),
                          trailing: Icon(Icons.delete, color: Colors.red),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: addJourney,
          tooltip: "Add",
        ),
        bottomNavigationBar: NavigationBar(
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: "Home"),
            NavigationDestination(
              icon: Icon(Icons.addchart),
              label: "Redaction",
            ),
          ],
        ),
      ),
    );
  }

  // Modal dialogue qui va permettre d'ajouter nos journées.
  Dialog AddJourneyDialog({
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Add Journey",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 10),
              dataFirebaseInput(
                "ex: Day 1",
                "Entrer le jour d'activité",
                dayController,
              ),
              dataFirebaseInput(
                "ex: Monitoring d'une Database",
                "Activités réalisées",
                activityController,
              ),
              dataFirebaseInput("ex: Ebène, Maurice", "Lieu", lieuController),
              dataFirebaseInput(
                "ex: Flutter, Java",
                "Compétences acquise",
                skillsController,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: onPressed,
                child: Text("Ajouter"),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
