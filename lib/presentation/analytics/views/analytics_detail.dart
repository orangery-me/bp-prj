import 'dart:developer';

import 'package:blood_pressure/common/enums/bp_chart.dart';
import 'package:blood_pressure/common/extensions/data_analyze_extension.dart';
import 'package:blood_pressure/common/theme/text_custom_style.dart';
import 'package:blood_pressure/data/dtos/bar_chart_y_data.dart';
import 'package:blood_pressure/data/models/measurement.dart';
import 'package:blood_pressure/data/repositories/measurement_repository.dart';
import 'package:blood_pressure/presentation/analytics/widgets/detail_bar_chart.dart';
import 'package:blood_pressure/presentation/measurements/bloc/measurements/measurement_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalyticsDetailPage extends StatelessWidget {
  final int profileId;
  final ChartType chartType;
  const AnalyticsDetailPage(
      {super.key, required this.chartType, required this.profileId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MeasurementBloc(MeasurementRepository()),
      child: AnalyticsDetail(chartType: chartType, profileId: profileId),
    );
  }
}

class AnalyticsDetail extends StatefulWidget {
  final int profileId;
  final ChartType chartType;
  const AnalyticsDetail(
      {super.key, required this.chartType, required this.profileId});

  @override
  State<AnalyticsDetail> createState() => _AnalyticsDetailState();
}

class _AnalyticsDetailState extends State<AnalyticsDetail> {
  int tab = 0;
  int duration = 7;
  List<dynamic> fromYData = [];
  List<dynamic> toYData = [];
  int averageFromY = 0;
  int averageToY = 0;
  Function categorize = (int value) => 0;

  @override
  void initState() {
    super.initState();
    updateDataForChart(tab);
  }

  void getYDataForChart(List<Measurement> measurements) {
    switch (widget.chartType) {
      case ChartType.bp:
        fromYData = measurements.map((e) => e.diastolis).toList();
        toYData = measurements.map((e) => e.systolis).toList();
        categorize = DataAnalyzeExtension.getBPStatus;
        break;
      case ChartType.map:
        toYData = measurements
            .map((e) => DataAnalyzeExtension.getMAP(e.systolis, e.diastolis))
            .toList();
        categorize = DataAnalyzeExtension.getMAPStatus;
        break;
      case ChartType.hr:
        toYData = measurements.map((e) => e.pulse).toList();
        categorize = DataAnalyzeExtension.getHeartRateStatus;
        break;
      default:
        break;
    }

    if (toYData.isNotEmpty) {
      double y = (toYData.map((e) => e.toDouble()).reduce((a, b) => a + b) /
          toYData.length);
      averageToY = y.toInt();
    } else {
      averageToY = 0; // Hoặc giá trị mặc định
    }

    if (fromYData.isNotEmpty) {
      double x = (fromYData.map((e) => e.toDouble()).reduce((a, b) => a + b) /
          fromYData.length);
      averageFromY = x.toInt();
    } else {
      averageFromY = 0; // Hoặc giá trị mặc định
    }
  }

  void updateDataForChart(int tab) {
    switch (tab) {
      case 0:
        duration = 7;
        break;
      case 1:
        duration = 14;
        break;
      case 2:
        duration = 30;
        break;
    }
    final start = DateTime.now().subtract(Duration(days: duration));
    final end = DateTime.now();
    context
        .read<MeasurementBloc>()
        .add(GetAverageByDayInRange(widget.profileId, start, end));
  }

  Widget tabSelection(context, index, title) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            tab = index;
            updateDataForChart(tab);
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
            color: tab == index ? Colors.white : const Color(0xFFF5F6F9),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: tab == index ? Colors.black : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    log('fromYData: $fromYData');
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
        child: BlocBuilder<MeasurementBloc, MeasurementState>(
          builder: (context, state) {
            if (state.status == MeasurementStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              getYDataForChart(state.averageByDayInRange);
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text('Your Average ${widget.chartType.name.toUpperCase()}',
                        style: TextCustomStyle.mediumTextIndicator),
                    averageFromY != 0
                        ? Text('$averageToY - $averageFromY',
                            style: TextCustomStyle.largeTitle)
                        : Text('$averageToY',
                            style: TextCustomStyle.largeTitle),
                    Text(widget.chartType.unit,
                        style: TextCustomStyle.mediumTextIndicator),
                  ],
                ),
                const SizedBox(height: 40),
                Container(
                  height: 48,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFFF5F6F9),
                  ),
                  child: Row(
                    children: [
                      tabSelection(context, 0, '7 Days'),
                      const SizedBox(width: 20),
                      tabSelection(context, 1, '14 Days'),
                      const SizedBox(width: 20),
                      tabSelection(context, 2, '30 Days'),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                DetailBarChart(
                    barChartYData:
                        BarChartYData(fromYData, toYData, categorize)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Normal ${widget.chartType.name.toUpperCase()} ',
                        style: TextCustomStyle.mediumTextIndicator),
                    Text(
                        '${widget.chartType.bottomNormalIndicator} - ${widget.chartType.topNormalIndicator}',
                        style: TextCustomStyle.mediumTitle),
                    Text(' ${widget.chartType.unit}',
                        style: TextCustomStyle.mediumTextIndicator),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
