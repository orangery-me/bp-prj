import 'package:blood_pressure/common/enums/bp_chart.dart';
import 'package:blood_pressure/common/enums/bp_status.dart';
import 'package:blood_pressure/common/extensions/data_analyze_extension.dart';
import 'package:blood_pressure/common/theme/text_custom_style.dart';
import 'package:blood_pressure/data/dtos/bar_chart_y_data.dart';
import 'package:blood_pressure/data/dtos/pie_chart_measure_data.dart';
import 'package:blood_pressure/data/models/measurement.dart';
import 'package:blood_pressure/presentation/analytics/views/analytics_detail.dart';
import 'package:blood_pressure/presentation/analytics/views/summary_detail.dart';
import 'package:blood_pressure/presentation/analytics/widgets/overal_bar_chart.dart';
import 'package:blood_pressure/presentation/analytics/widgets/overal_pie_chart.dart';
import 'package:blood_pressure/presentation/measurements/bloc/measurements/measurement_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalyticsPage extends StatefulWidget {
  final int profileId;
  const AnalyticsPage({super.key, required this.profileId});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  late List<Measurement?> _aveMeasurementsIn7Days;
  late List<Measurement?> _measurementsIn7Days;
  late List<int> _systolis;
  late List<int> _diastolis;
  late List<double> _map;
  late List<int> _heartRate;
  late int _rest;
  late int _numberOfNormalBP;

  @override
  void initState() {
    super.initState();
    final start = DateTime.now().subtract(const Duration(days: 7));
    final end = DateTime.now();
    context
        .read<MeasurementBloc>()
        .add(GetAverageByDayInRange(widget.profileId, start, end));
    context
        .read<MeasurementBloc>()
        .add(GetMeasurementsInRange(widget.profileId, start, end));
  }

  void getMeasurementDataForOveralChart() {
    _numberOfNormalBP = 0;
    for (var element in _measurementsIn7Days) {
      if (element != null) {
        int status = DataAnalyzeExtension.getBPStatus(
            element.systolis, element.diastolis);
        if (status == BpStatus.normalBp.num ||
            status == BpStatus.elevatedBp.num) {
          _numberOfNormalBP++;
        }
      }
    }
    _rest = _measurementsIn7Days.length - _numberOfNormalBP;
    _systolis = _aveMeasurementsIn7Days.map((e) => e?.systolis ?? 0).toList();
    _diastolis = _aveMeasurementsIn7Days.map((e) => e?.diastolis ?? 0).toList();
    _map = _aveMeasurementsIn7Days
        .map((e) =>
            DataAnalyzeExtension.getMAP(e?.systolis ?? 0, e?.diastolis ?? 0))
        .toList();
    _heartRate = _aveMeasurementsIn7Days.map((e) => e?.pulse ?? 0).toList();
  }

  Widget analyticsCard(ChartType chartType, BarChartYData barChartYData) {
    return Expanded(
        child: GestureDetector(
      onTap: () {
        showModalBottomSheet(
            backgroundColor: Colors.white,
            isScrollControlled: true,
            useSafeArea: true,
            context: context,
            builder: (_) => AnalyticsDetailPage(
                profileId: widget.profileId, chartType: chartType));
      },
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(chartType.title, style: TextCustomStyle.mediumTitle),
            OveralBarChart(barChartMeasureData: barChartYData),
          ],
        ),
      ),
    ));
  }

  Widget summaryCard() {
    return Expanded(
        child: GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: Colors.white,
            builder: (_) => SummaryDetailPage(profileId: widget.profileId));
      },
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [
                  Color(0xFF9B5CED),
                  Color(0xFF9658F4),
                  Color(0xFF6650DD),
                  Color(0xFF5C50C0)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.3, 0.7, 0.9]),
            borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OveralPieChart(
              data: PieChartMeasureData(
                  figures: [_numberOfNormalBP.toDouble(), _rest.toDouble()],
                  colors: [const Color(0xFF75FBFD), const Color(0xFFF7D277)]),
            ),
            const Text('of Measurements are within the health range',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          children: [
            const Text(
              'Analytics Data',
              style: TextCustomStyle.largeTitle,
            ),
            const SizedBox(height: 20),
            BlocBuilder<MeasurementBloc, MeasurementState>(
              builder: (context, state) {
                if (state.status == MeasurementStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  _aveMeasurementsIn7Days = state.averageByDayInRange;
                  _measurementsIn7Days = state.measurementsInRange;
                  getMeasurementDataForOveralChart();
                }
                return Expanded(
                    child: Column(
                  children: [
                    Flexible(
                        child: Row(
                      children: [
                        summaryCard(),
                        const SizedBox(width: 20),
                        analyticsCard(
                            ChartType.bp,
                            BarChartYData(_diastolis, _systolis,
                                DataAnalyzeExtension.getBPStatus)),
                      ],
                    )),
                    const SizedBox(height: 30),
                    Flexible(
                        child: Row(
                      children: [
                        analyticsCard(
                            ChartType.map,
                            BarChartYData(
                                null, _map, DataAnalyzeExtension.getMAPStatus)),
                        const SizedBox(width: 20),
                        analyticsCard(
                            ChartType.hr,
                            BarChartYData(null, _heartRate,
                                DataAnalyzeExtension.getHeartRateStatus)),
                      ],
                    ))
                  ],
                ));
              },
            )
          ],
        ),
      ),
    );
  }
}
