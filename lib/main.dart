import 'package:flutter/material.dart';
import 'app.dart';
import 'models/activity.dart';

// Hive: base de datos ligera basada en el formato key-value, funciona como 'cajas'
import 'package:hive_ce_flutter/hive_flutter.dart';

void main() async {
  // inicializacion de la app y de hive con la caja 'activities'
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(ActivityAdapter());

  await Hive.openBox<Activity>('activities');

  runApp(const MyApp());
}