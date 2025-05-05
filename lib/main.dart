import 'package:flutter/material.dart';
import 'app.dart';
import 'models/activity.dart';

// Hive
import 'package:hive_ce_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(ActivityAdapter());

  await Hive.openBox<Activity>('activities');

  runApp(const MyApp());
}