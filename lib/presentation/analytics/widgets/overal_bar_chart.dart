import 'package:blood_pressure/data/dtos/bar_chart_y_data.dart';
import 'package:blood_pressure/common/enums/bp_status.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OveralBarChart extends StatelessWidget {
  final BarChartYData barChartMeasureData;
  const OveralBarChart({super.key, required this.barChartMeasureData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      height: 150,
      child: IgnorePointer(
        child: BarChart(BarChartData(
          alignment: BarChartAlignment.start,
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          barGroups: List.generate(barChartMeasureData.toYData.length, (index) {
            double fromY = barChartMeasureData.fromYData[index];
            double toY = barChartMeasureData.toYData[index];
            double fromYBackground =
                barChartMeasureData.fromYBackgroundData[index];
            double toYBackground = barChartMeasureData.toYBackgroundData[index];

            return BarChartGroupData(x: index, barRods: [
              BarChartRodData(
                width: 5,
                fromY: fromY,
                toY: toY,
                color: chartColor[barChartMeasureData.categorizeValue(
                    toY.toInt(), fromY.toInt())],
                backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    fromY: fromYBackground,
                    toY: toYBackground,
                    color: Colors.grey[300]),
              ),
            ]);
          }),
        )),
      ),
    );
  }
}
