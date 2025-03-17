import 'package:flutter/material.dart';

class PieChartMeasureData {
  final List<String>? labels;
  final List<double> figures;
  final List<Color> colors;

  const PieChartMeasureData({
    this.labels,
    required this.figures,
    required this.colors,
  });
}
