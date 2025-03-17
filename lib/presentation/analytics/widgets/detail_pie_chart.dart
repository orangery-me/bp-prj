import 'package:blood_pressure/data/dtos/pie_chart_measure_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DetailPieChart extends StatelessWidget {
  final PieChartMeasureData data;
  final int centerFigure;
  const DetailPieChart(
      {super.key, required this.data, required this.centerFigure});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 250,
        child: Stack(
          alignment: Alignment.center,
          children: [
            PieChart(PieChartData(
                sections: List.generate(
                    data.figures.length,
                    (index) => PieChartSectionData(
                        showTitle: false,
                        color: data.colors[index].withOpacity(0.5),
                        value: data.figures[index],
                        borderSide: BorderSide(
                            color: data.colors[index],
                            width: 8,
                            strokeAlign: BorderSide.strokeAlignOutside),
                        radius: 55)),
                centerSpaceRadius: 60,
                sectionsSpace: 5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(centerFigure.toString(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold)),
                const Text('%',
                    style: TextStyle(color: Colors.black, fontSize: 12)),
              ],
            ),
          ],
        ));
  }
}
