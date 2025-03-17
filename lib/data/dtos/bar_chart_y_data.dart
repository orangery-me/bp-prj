class BarChartYData {
  final List<double> fromYData;
  final List<double> toYData;
  final List<double> fromYBackgroundData;
  final List<double> toYBackgroundData;
  final Function categorize;

  BarChartYData(List<dynamic>? fromY, List<dynamic> toY, this.categorize)
      : fromYData = (fromY == null || fromY.isEmpty)
            ? List.filled(toY.length, 0.0)
            : fromY.map((e) => (e is num ? e.toDouble() : 0.0)).toList(),
        toYData = toY.map((e) => (e is num ? e.toDouble() : 0.0)).toList(),
        fromYBackgroundData = [],
        toYBackgroundData = [] {
    fromYBackgroundData.addAll(List.generate(toYData.length, (index) {
      return fromYData[index] <= 30 ? 0.0 : fromYData[index] - 30;
    }));

    toYBackgroundData.addAll(List.generate(toYData.length, (index) {
      return toYData[index] + 50;
    }));
  }

  int categorizeValue(int a, [int? b]) {
    if (categorize is int Function(int, int)) {
      return (categorize as int Function(int, int))(a, b ?? 0);
    } else if (categorize is int Function(int)) {
      return (categorize as int Function(int))(a);
    } else {
      throw Exception('Invalid categorize function type');
    }
  }
}
