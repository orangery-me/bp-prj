enum ChartType {
  overal,
  bp,
  map,
  hr,
}

final chartTypeProperties = {
  ChartType.overal: (
    0,
    'Overal',
    '',
    0,
    0,
  ),
  ChartType.bp: (1, 'BP Trends', 'mmHg', 80, 120),
  ChartType.map: (2, 'MAP Trends', 'mmHg', 70, 100),
  ChartType.hr: (3, 'Heart Rate', 'BPM', 60, 100),
};

extension ChartTypeProperties on ChartType {
  int get num => chartTypeProperties[this]!.$1;
  String get title => chartTypeProperties[this]!.$2;
  String get unit => chartTypeProperties[this]!.$3;
  int get bottomNormalIndicator => chartTypeProperties[this]!.$4;
  int get topNormalIndicator => chartTypeProperties[this]!.$5;
}
