import 'package:flutter/material.dart';
import 'package:horas_complementarias/models/activity.dart';
import 'package:hive_ce/hive.dart';
import 'package:open_file/open_file.dart';

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

    // Edita la actividad solo en los campos del titulo y la cantidad de horas
    void _editarActividad(Activity actividad, String nuevoNombre, int nuevasHoras) {
      actividad.title = nuevoNombre;
      actividad.hours = nuevasHoras;
      actividad.save(); // Hive actualiza automáticamente
      setState(() {});  // Refresca la UI
    }

    // Elimina la actividad de la caja
    void _eliminarActividad(Activity actividad) {
      actividad.delete(); // Hive elimina el registro
      setState(() {});     // Refresca la lista
    }

    // Muestra una ventana popup de la actividad seleccionada
    void _mostrarDialogoEdicion(BuildContext context, Activity actividad) {
      final nombreController = TextEditingController(text: actividad.title);
      final horasController = TextEditingController(text: actividad.hours.toString());

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Editar Actividad'),

            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  SizedBox(
                    height: 10,
                  ),
                  if (actividad.filePath != null && actividad.filePath!.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: () {
                        OpenFile.open(actividad.filePath); // Abre el archivo que se asocio a la actividad por medio de la dependencia open_file
                      },
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('Ver comprobante'),
                    ),
                ],
              )
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      // Eliminar la actividad
                      _eliminarActividad(actividad);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Eliminar', style: TextStyle(color: Colors.red, fontSize: 10)),
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
                    child: const Text('Guardar', style: TextStyle(fontSize: 10),),
                  ),
                ],
              )
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
          return ListTile( // Muestra todas las actividades en la caja activities en forma de lista con su titulo, el tipo de actividad y la cantidad de horas
            title: Text(activity.title),
            subtitle: Text(
              '${activity.type} - ${activity.hours} horas',
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () => _mostrarDialogoEdicion(context, activity), // Manda a llamar a la ventana pop up
          );
        },
      ),
    );
  }
}
