import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart'; // You will need to add this package

class TaskPieChart extends StatelessWidget {
  final Map<String, int> statusCounts;

  const TaskPieChart({super.key, required this.statusCounts});

  @override
  Widget build(BuildContext context) {
    final dataMap =
        statusCounts.map((key, value) => MapEntry(key, value.toDouble()));
    final colorList = <Color>[
      Colors.blue.shade400,
      Colors.orange.shade400,
      Colors.green.shade400,
      Colors.red.shade400,
      Colors.purple.shade400,
    ];

    if (dataMap.isEmpty) {
      return const Center(child: Text("No task data for chart."));
    }

    return PieChart(
      dataMap: dataMap,
      animationDuration: const Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 32,
      centerText: "STATUS",
      legendOptions: const LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendTextStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
        decimalPlaces: 0,
      ),
    );
  }
}
