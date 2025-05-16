import 'package:flutter/material.dart';

// Navigator
import 'package:horas_complementarias/nav.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Establece Nav como 'home' y el esquema de colores en indigo con modo dark
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: Nav(),
    );
  }
}