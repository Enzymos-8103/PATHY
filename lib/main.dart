import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Views/TripsPageScreen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TripsApp());
}




class TripsApp extends StatelessWidget {
  const TripsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PATHY',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ).copyWith(
          primary: Colors.green[700],
          secondary: Colors.teal[400],
        ),
      ),
      home: const TripsPage(),
    );
  }
}

