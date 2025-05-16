import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive_ce/hive.dart';
import 'package:horas_complementarias/models/activity.dart';

class HoursForm extends StatefulWidget {
  const HoursForm({super.key, required this.title, required this.changeScreen});

  final String title;

  final Function changeScreen;

  @override
  State<HoursForm> createState() => _HoursFormState();
}

class _HoursFormState extends State<HoursForm> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String? _desc;
  int _hours = 0;
  String _type = '';
  DateTime? _initDate;
  DateTime? _endDate;
  String? _filePath;

  final List<String> _activityTypes = [
    'Cultural',
    'Deportiva',
    'Investigación',
    'Emprendimiento',
    'Otra',
  ];

  // Funcion para mostrar un datepicker en el formulario
  Future<void> _selectDate(BuildContext context, bool isInitDate) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        if (isInitDate) {
          _initDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }


  // Funcion para obtener la ruta a un archivo del dispositivo por medio de la dependencia file_picker
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),

                  // Nombre de la Actividad
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nombre de la Actividad',
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obligatorio' : null,
                    onSaved: (value) => _title = value!,
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // Descripción
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Descripción (Opcional)',
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                    maxLines: 3,
                    onSaved: (value) => _desc = value,
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // Tipo de Actividad
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Tipo de actividad',
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                    isExpanded: true,
                    items: _activityTypes.map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    )).toList(),
                    onChanged: (value) => _type = value ?? '',
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Selecciona un tipo' : null,
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // Horas
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Cantidad de Horas',
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final val = int.tryParse(value ?? '');
                      if (val == null || val <= 0) return 'Ingresa un número válido';
                      return null;
                    },
                    onSaved: (value) => _hours = int.parse(value!),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // Fecha de inicio
                  ListTile(
                    title: Text(_initDate == null
                        ? 'Fecha de Inicio'
                        : 'Inicio: ${_initDate!.toLocal().toString().split(' ')[0]}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context, true),
                  ),

                  // Fecha de fin
                  ListTile(
                    title: Text(_endDate == null
                        ? 'Fecha de Termino (opcional)'
                        : 'Fin: ${_endDate!.toLocal().toString().split(' ')[0]}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context, false),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // Archivo adjunto
                  ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Comprobante (Recomendado)'),
                  ),
                  if (_filePath != null) Text('Archivo: ${_filePath!.split('/').last}'),

                  SizedBox(
                    height: 50,
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() && _initDate != null) {
                        _formKey.currentState!.save();

                        // Guarda los campos en un objeto de tipo Activity
                        final newActivity = Activity(
                          title: _title,
                          desc: _desc,
                          hours: _hours,
                          type: _type,
                          initDate: _initDate!,
                          endDate: _endDate,
                          filePath: _filePath,
                        );

                        final box = await Hive.openBox<Activity>('activities');
                        await box.add(newActivity); // Registra el objeto tipo Activity en la caja

                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar( // Muestra una imagen sobre el scaffold para notificar al usuario que se registro con exito la actividad
                          const SnackBar(content: Text('Actividad registrada')),
                        );
                        widget.changeScreen(0);
                      } else if (_initDate == null) { // Verifica que se haya seleccionado una fecha de inicio
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Selecciona una fecha de inicio')),
                        );
                      }
                    },
                    child: SizedBox(
                      width: 100,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.save_outlined),
                          Text('Registrar')
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
