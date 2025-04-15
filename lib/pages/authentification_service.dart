import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home_page.dart';
import 'login_page.dart';

class AuthService {

// Methode qui va gerer l'inscription de l'user
  Future<void> signup({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    
    try {
      // Methode que FIrebase nous donne pour faciliter l'inscription des nouveaux utilisateurs
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
      );

// Ajout d'un délai pendant que Firebase charge les données
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        // Après inscription réussi, user redirigé vers home page
        MaterialPageRoute(
          builder: (BuildContext context) => const Home()
        )
      );
      // Gestion d'érreur FIrebase
    } on FirebaseAuthException catch(e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }
      // Affiche un toast en bas de l'écran pour afficher les érreurs
       Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
    catch(e){

    }

  }

// Methode qui va gerer la connexion de l'user
  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    
    try {
      // Methode que FIrebase nous donne pour faciliter la connexion des nouveaux utilisateurs
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      // Ajoute un dékai pour que FIrebase puisse charger les données
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        // Si connexion réussi, l'user va être redirigé vers la home page
        MaterialPageRoute(
          builder: (BuildContext context) => const Home()
        )
      );
      
    } on FirebaseAuthException catch(e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'No user found for that email.';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user.';
      }
      // Affiche un toast en bas de l'écran pour afficher les érreurs
       Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
    catch(e){

    }

  }

// Métohde qui va gerer la déconnexion de l'user
  Future<void> signout({
    required BuildContext context
  }) async {
    
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>Login()
        )
      );
  }
}