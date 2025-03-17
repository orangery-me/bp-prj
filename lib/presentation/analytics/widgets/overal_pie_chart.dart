import 'dart:developer';

import 'package:blood_pressure/data/dtos/pie_chart_measure_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OveralPieChart extends StatelessWidget {
  final PieChartMeasureData data;
  const OveralPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    double total = data.figures.reduce((value, element) => value + element);
    double centerFigure = total != 0 ? (data.figures[0] / total) * 100 : 0;
    log('data.figures for over: ${data.figures} and centerFigure: $centerFigure');
    return SizedBox(
        height: 120,
        child: Stack(
          alignment: Alignment.center,
          children: [
            PieChart(PieChartData(
                sections: List.generate(
                    data.figures.length,
                    (index) => PieChartSectionData(
                        showTitle: false,
                        color: data.colors[index],
                        value: data.figures[index],
                        radius: 10)),
                centerSpaceRadius: 40,
                sectionsSpace: 0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(centerFigure.toInt().toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold)),
                const Text('%',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ],
        ));
  }
}
