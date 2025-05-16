import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:horas_complementarias/models/activity.dart';
import 'package:fl_chart/fl_chart.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Pagina principal de la aplicación, muestra el progreso
class _MyHomePageState extends State<MyHomePage> {
  int totalHours = 0;


  // Función para contar la cantidad de horas por tipo de actividad
  Map<String, double> _getHoursByType(Iterable<Activity> activities) {
    final Map<String, double> data = {};
    for (var a in activities) {
      data[a.type] = (data[a.type] ?? 0) + a.hours.toDouble();
    }
    return data;
  }

  // Funcion para obtener la cantidad de horas registradas por fecha
  List<FlSpot> _getDailyHours(List<Activity> activities) {
    if (activities.isEmpty) return [];

    final Map<DateTime, double> dailyTotals = {};
    for (var a in activities) {
      final date = DateTime(a.initDate.year, a.initDate.month, a.initDate.day);
      dailyTotals[date] = (dailyTotals[date] ?? 0) + a.hours.toDouble();
    }

    final sortedDates = dailyTotals.keys.toList()..sort();
    final startDate = sortedDates.first;

    return sortedDates.map((date) {
      final x = date.difference(startDate).inDays.toDouble();
      final y = dailyTotals[date]!;
      return FlSpot(x, y);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadHours();
  }

  // Suma el total de las horas registradas
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

    final box = Hive.box<Activity>('activities');
    final activities = box.values;
    final hoursByType = _getHoursByType(activities);

    // Paleta de colores para los gráficos
    final indigoShades = [
      Colors.indigo.shade600,
      Colors.indigo.shade700,
      Colors.indigo.shade800,
      Colors.indigo.shade900,
      Colors.indigo.shade500,
    ];

    final colors = {
      'Cultural': indigoShades[0],
      'Deportiva': indigoShades[1],
      'Emprendimiento': indigoShades[2],
      'Investigación': indigoShades[3],
      'Otra': indigoShades[4],
    };


    // Establece cada campo en el pie chart, el valor, etiqueta de la activad y el color en forma de lista
    final pieSections = hoursByType.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value,
        title: entry.key,
        radius: 40,
        color: colors[entry.key] ?? Colors.grey,
        showTitle: true,
      );
    }).toList();

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
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              // Barra de progreso de las horas completadas
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Horas completadas:', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('$totalHours / 480', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  LinearProgressIndicator(value: progress.clamp(0, 1)),
                ],
              ),


              SizedBox(
                height: 100,
              ),
              Row(
                children: [
                  // Expanded para ajustarse al tamaño de la pantalla del dispositivo
                  Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        // Renderizado del piechart
                        child: PieChart(
                            PieChartData(
                              sections: pieSections,
                            )
                        ),
                      )
                  ),
                  SizedBox(
                    width: 20,
                  ),

                  Expanded(
                      child: AspectRatio( // Mantiene la proporcion del grafico
                          aspectRatio: 1,
                          child: LineChart(LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: _getDailyHours(activities.toList()),
                                isCurved: false,
                                color: Colors.indigo.shade400,
                                barWidth: 4,
                                dotData: FlDotData(show: false),
                                belowBarData: BarAreaData( // Dibuja el area debajo de la linea
                                  show: true,
                                  color: Colors.indigo.shade200.withOpacity(0.3),
                                ),
                              ),
                            ],
                            minY: 0,
                            titlesData: FlTitlesData(
                              show: true,
                              leftTitles: AxisTitles( // Modifica el label en Y
                                sideTitles: SideTitles(showTitles: false),
                                axisNameWidget: Text('Horas registradas'),
                                axisNameSize: 24,
                              ),
                              bottomTitles: AxisTitles( // Modifica el label en Y
                                sideTitles: SideTitles(showTitles: false),
                                axisNameWidget: Text('Día'),
                                axisNameSize: 24,
                              ),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            gridData: FlGridData( // Dibuja un grid para mejorar la visualizacion del grafico
                              show: true,
                              drawVerticalLine: true,
                              drawHorizontalLine: true,
                              getDrawingHorizontalLine: (value) => FlLine(
                                color: Theme.of(context).colorScheme.outline,
                                strokeWidth: 1,
                              ),
                              getDrawingVerticalLine: (value) => FlLine(
                                color: Theme.of(context).colorScheme.outlineVariant,
                                strokeWidth: 1,
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            lineTouchData: LineTouchData( // Tooltip para mostrar la cantidad de horas registradas en cada dia
                              enabled: true,
                              touchTooltipData: LineTouchTooltipData(
                                tooltipRoundedRadius: 10,
                                fitInsideHorizontally: true,
                                fitInsideVertically: true,
                                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                                  return touchedSpots.map((spot) {
                                    return LineTooltipItem(
                                      '${spot.y.toInt()} horas',
                                      TextStyle(
                                        color: Colors.indigo.shade900, // color del texto
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                          ))
                      )
                  ),
                ],
              )
            ],
          )
        ]
      ),
    );
  }
}
