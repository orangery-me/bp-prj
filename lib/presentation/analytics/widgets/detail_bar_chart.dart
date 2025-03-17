import 'dart:developer';

import 'package:blood_pressure/data/dtos/bar_chart_y_data.dart';
import 'package:blood_pressure/common/enums/bp_status.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DetailBarChart extends StatefulWidget {
  final BarChartYData barChartYData;
  const DetailBarChart({super.key, required this.barChartYData});

  @override
  State<DetailBarChart> createState() => _DetailBarChartState();
}

class _DetailBarChartState extends State<DetailBarChart> {
  late double _highestOfToY;
  late double _lowestOfToY;
  late double _lowestOfFromY;

  int getChartStatusColor(double fromY, double toY) {
    return widget.barChartYData.categorizeValue(toY.toInt(), fromY.toInt());
  }

  void getHighestAndLowestPoint() {
    _highestOfToY = widget.barChartYData.toYData
        .reduce((value, element) => value > element ? value : element);
    _lowestOfToY = widget.barChartYData.toYData
        .reduce((value, element) => value < element ? value : element);
    _lowestOfFromY = widget.barChartYData.fromYData
        .reduce((value, element) => value < element ? value : element);
    log('highest: $_highestOfToY, lowest: $_lowestOfToY');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.barChartYData.toYData.isEmpty) {
      return Container(
        height: 300,
        padding: const EdgeInsets.only(bottom: 20),
        child: const Center(
          child: Text('No data available'),
        ),
      );
    } else {
      getHighestAndLowestPoint();
      return Container(
        padding: const EdgeInsets.only(bottom: 20),
        height: 300,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: (widget.barChartYData.toYData.length >= 7)
                ? MediaQuery.of(context).size.width *
                    (widget.barChartYData.toYData.length / 8)
                : MediaQuery.of(context).size.width - 60,
            height: 250,
            child: BarChart(BarChartData(
                backgroundColor: const Color(0xFFF5F6F9),
                borderData: FlBorderData(show: false),
                alignment: BarChartAlignment.start,
                groupsSpace: 100, // set space too big for auto adjustment
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval:
                      ((_highestOfToY - _lowestOfFromY) / 50).round() * 10,
                ),
                titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval:
                          ((_highestOfToY - _lowestOfFromY) / 50).round() * 10,
                      getTitlesWidget: (value, meta) {
                        if (value % 10 == 0 &&
                            value <= ((_highestOfToY / 10).round() + 1) * 10 &&
                            value >= _lowestOfFromY) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                            textDirection: TextDirection.ltr,
                          );
                        }
                        return const SizedBox(); // Hide other titles
                      },
                    ))),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                      direction: TooltipDirection.top,
                      tooltipMargin: 1,
                      getTooltipColor: (group) => Colors.transparent,
                      getTooltipItem: (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                      ) {
                        return BarTooltipItem(
                            rod.toY.toInt().toString(),
                            TextStyle(
                                color: chartColor[getChartStatusColor(
                                    widget.barChartYData.fromYData[groupIndex],
                                    widget.barChartYData.toYData[groupIndex])],
                                fontWeight: FontWeight.bold,
                                fontSize: 14));
                      }),
                  enabled: true,
                ),
                maxY: ((_highestOfToY / 10).round() + 2) * 10,
                minY: _lowestOfFromY == 0
                    ? (((_lowestOfToY / 10).round() - 2) * 10)
                    : ((_lowestOfFromY / 10).round() - 2) * 10,
                barGroups:
                    List.generate(widget.barChartYData.toYData.length, (index) {
                  double fromY = widget.barChartYData.fromYData[index];
                  double toY = widget.barChartYData.toYData[index];

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        width: 6,
                        fromY: fromY,
                        toY: toY,
                        gradient: _lowestOfFromY == 0
                            ? LinearGradient(
                                colors: [
                                  chartColor[getChartStatusColor(fromY, toY)]!,
                                  const Color(0xFFF5F6F9)
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              )
                            : null,
                        color: chartColor[getChartStatusColor(fromY, toY)],
                      ),
                    ],
                    showingTooltipIndicators: [0],
                  );
                }))),
          ),
        ),
      );
    }
  }
}
