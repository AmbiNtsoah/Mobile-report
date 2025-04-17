import 'package:flutter/material.dart';

class RedactionPage extends StatefulWidget {
  const RedactionPage({super.key});

  @override
  State<RedactionPage> createState() => _RedactionPageState();
}

class _RedactionPageState extends State<RedactionPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      debugShowCheckedModeBanner: false,
      title: "Redaction section",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Redaction Section"),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: Center(child: Text("Redaction Page")),
      ),
    );
  }
}
