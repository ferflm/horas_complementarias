import 'package:hive_ce/hive.dart';

part 'activity.g.dart';


// Clase para construir la "caja" con sus campos a guardar
@HiveType(typeId: 0)
class Activity extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String? desc; // Descripcion de la actividad (opcional)

  @HiveField(2)
  int hours;

  @HiveField(3)
  String type; // Cultura, deportiva, emprendimiento, investigación, otra

  @HiveField(4)
  DateTime initDate;

  @HiveField(5)
  DateTime? endDate; // Opcional

  @HiveField(6)
  String? filePath; // Ruta a un archivo o foto como comprobante

  Activity({
    required this.title,
    this.desc,
    required this.hours,
    required this.type,
    required this.initDate,
    this.endDate,
    this.filePath,
  });
}