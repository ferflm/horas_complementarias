import 'package:flutter/material.dart';

class HoursForm extends StatefulWidget {
  const HoursForm({super.key, required this.title});

  final String title;

  @override
  State<HoursForm> createState() => _HoursFormState();
}

class _HoursFormState extends State<HoursForm> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String? _desc;
  int _hours = 0;
  String _type = '';
  String? _subtype;
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
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // Subtipo
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Subtipo (Opcional)',
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // Subtipo
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
