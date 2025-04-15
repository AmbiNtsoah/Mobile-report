import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'authentification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        appBar: AppBar(
          title: Text("Report Internship Activity"),
          centerTitle: true,
        ),
        // Creation de Card qui va display nos Journey
        // body: Padding(
        //   padding: const EdgeInsets.all(20.0),
        //   child: Column(
        //     children: [
        //       Container(
        //         width: double.infinity,
        //         child: Padding(
        //           padding: EdgeInsets.symmetric(vertical: 10.0),
        //           child: Card(
        //             child: Padding(
        //               padding: EdgeInsets.all(20.0),
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Text(
        //                     "Day 1",
        //                     style: TextStyle(
        //                       fontSize: 18,
        //                       fontWeight: FontWeight.bold,
        //                       color: Colors.teal,
        //                     ),
        //                   ),
        //                   Text("Description of activities in the company "),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
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
                              Text("Activités : ${documentSnapshot['activity']}"),
                              Text("Date : ${documentSnapshot['date']}"),
                              Text("Lieu : ${documentSnapshot['lieu']}"),
                              Text("Compétences : ${documentSnapshot['skills']}"),
                            ],
                          ),
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
          onPressed: () {},
          child: Icon(Icons.add),
          tooltip: "Add",
        ),
        bottomNavigationBar: NavigationBar(
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: "Home"),
            NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
