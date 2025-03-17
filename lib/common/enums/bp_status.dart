import 'package:flutter/material.dart';

enum BpStatus {
  lowBp,
  normalBp,
  elevatedBp,
  hypertension1,
  hypertension2,
}

final bpStatusProperties = {
  BpStatus.lowBp: (0, 'Low Bp', Colors.blue),
  BpStatus.normalBp: (1, 'Normal', Colors.green),
  BpStatus.elevatedBp: (2, 'Elevated Bp', Colors.yellow),
  BpStatus.hypertension1: (3, 'Hypertension 1', Colors.purple),
  BpStatus.hypertension2: (4, 'Hypertension 2', Colors.pink),
};

extension BpStatusProperties on BpStatus {
  int get num => bpStatusProperties[this]!.$1;
  String get status => bpStatusProperties[this]!.$2;
  Color get color => bpStatusProperties[this]!.$3;
}

final Map<int, Color> chartColor = {
  0: const Color(0xFF4AA5DA),
  1: const Color(0xFF61D2A3),
  2: const Color(0xFFF7D277),
  3: const Color(0xFFB277EA),
  4: const Color(0xFFDC5672),
};
