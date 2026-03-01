# 📓 Mobile Report

> Application mobile Flutter pour enregistrer et suivre les résumés journaliers de stage.

---

## 📌 Description

**Mobile Report** est une application mobile développée avec **Flutter** permettant aux stagiaires de rédiger et enregistrer un résumé de leur journée de stage. L'application est connectée à **Firebase** pour la gestion des données en temps réel et l'authentification.

Grâce à sa nature multiplateforme, l'application fonctionne sur Android, iOS, Web, Linux, macOS et Windows.

---

## 🎯 Objectif

Offrir aux stagiaires un outil simple et pratique pour :

- ✍️ Rédiger un résumé de leur journée de stage
- 📅 Suivre l'historique de leurs rapports journaliers
- ☁️ Sauvegarder leurs données de manière sécurisée via Firebase

---

## 🛠️ Technologies utilisées

| Technologie | Rôle |
|---|---|
| **Flutter / Dart** | Framework principal de l'application |
| **Firebase** | Base de données, authentification et backend |
| **Android / iOS** | Plateformes mobiles cibles |
| **Web / Desktop** | Support multiplateforme (Linux, macOS, Windows) |

---

## 🚀 Installation

### Prérequis

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installé
- Un émulateur Android/iOS ou un appareil physique
- Un projet Firebase configuré

### Étapes

```bash
# Cloner le dépôt
git clone https://github.com/AmbiNtsoah/Mobile-report.git

# Se déplacer dans le répertoire
cd Mobile-report

# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run
```

---

## 📁 Structure du projet

```
Mobile-report/
├── android/        # Configuration Android
├── ios/            # Configuration iOS
├── lib/            # Code source Dart principal
├── linux/          # Support Linux
├── macos/          # Support macOS
├── web/            # Support Web
├── windows/        # Support Windows
├── test/           # Tests unitaires
├── firebase.json   # Configuration Firebase
└── pubspec.yaml    # Dépendances Flutter
```

---

## 👤 Auteur

- [@AmbiNtsoah](https://github.com/AmbiNtsoah)
