import 'package:flutter/material.dart';
import 'package:horas_complementarias/models/activity.dart';
import 'package:hive_ce/hive.dart';
import 'dart:io';

class History extends StatefulWidget {
  const History({super.key, required this.title});

  final String title;

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late Box<Activity> _box;
  late String comprobantePath;

  @override
  void initState() {
    super.initState();
    _box = Hive.box<Activity>('activities');
  }

  @override
  Widget build(BuildContext context) {
    final activities = _box.values.toList();

    void _editarActividad(Activity actividad, String nuevoNombre, int nuevasHoras) {
      actividad.title = nuevoNombre;
      actividad.hours = nuevasHoras;
      actividad.save(); // Hive actualiza automáticamente
      setState(() {});  // Refresca la UI
    }

    void _eliminarActividad(Activity actividad) {
      actividad.delete(); // Hive elimina el registro
      setState(() {});     // Refresca la lista
    }


    void _mostrarDialogoEdicion(BuildContext context, Activity actividad) {
      final nombreController = TextEditingController(text: actividad.title);
      final horasController = TextEditingController(text: actividad.hours.toString());

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Editar Actividad'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: horasController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Horas'),
                ),
              ],

            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Eliminar la actividad
                  _eliminarActividad(actividad);
                  Navigator.of(context).pop();
                },
                child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  _editarActividad(
                    actividad,
                    nombreController.text,
                    int.tryParse(horasController.text) ?? actividad.hours,
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      );
    }


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
      body: activities.isEmpty
          ? Center(child: Text('No hay actividades registradas.'))
          : ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ListTile(
            title: Text(activity.title),
            subtitle: Text(
              '${activity.type} - ${activity.hours} horas',
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () => _mostrarDialogoEdicion(context, activity),
          );
        },
      ),
    );
  }
}
