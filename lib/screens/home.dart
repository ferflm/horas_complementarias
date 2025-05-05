import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:horas_complementarias/models/activity.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int totalHours = 0;

  @override
  void initState() {
    super.initState();
    _loadHours();
  }

  void _loadHours() {
    final box = Hive.box<Activity>('activities');
    final activities = box.values;
    setState(() {
      totalHours = activities.fold(0, (sum, a) => sum + a.hours);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double progress = totalHours / 480.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: ColorScheme.of(context).inversePrimary,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Horas completadas:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('$totalHours / 480', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            LinearProgressIndicator(value: progress.clamp(0, 1)),
          ],
        ),
      ),
    );
  }
}
