import 'package:hive_ce/hive.dart';

part 'activity.g.dart';

@HiveType(typeId: 0)
class Activity extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String? desc;

  @HiveField(2)
  int hours;

  @HiveField(3)
  String type; // ej: 'Cultural', 'Deportiva', ...

  @HiveField(4)
  String? subtype; // ej: 'Visita a museo', 'Feria de emprendimiento', 'Conferencias'

  @HiveField(5)
  DateTime initDate;

  @HiveField(6)
  DateTime? endDate;

  @HiveField(7)
  String? filePath; // Ruta a un archivo o foto como comprobante

  Activity({
    required this.title,
    this.desc,
    required this.hours,
    required this.type,
    this.subtype,
    required this.initDate,
    this.endDate,
    this.filePath,
  });
}