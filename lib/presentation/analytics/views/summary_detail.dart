import 'package:blood_pressure/common/enums/bp_status.dart';
import 'package:blood_pressure/common/extensions/data_analyze_extension.dart';
import 'package:blood_pressure/common/theme/text_custom_style.dart';
import 'package:blood_pressure/data/dtos/pie_chart_measure_data.dart';
import 'package:blood_pressure/data/models/measurement.dart';
import 'package:blood_pressure/data/repositories/measurement_repository.dart';
import 'package:blood_pressure/presentation/analytics/widgets/detail_pie_chart.dart';
import 'package:blood_pressure/presentation/measurements/bloc/measurements/measurement_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SummaryDetailPage extends StatelessWidget {
  final int profileId;
  const SummaryDetailPage({super.key, required this.profileId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MeasurementBloc(MeasurementRepository()),
      child: SummaryDetail(profileId: profileId),
    );
  }
}

class SummaryDetail extends StatefulWidget {
  final int profileId;

  const SummaryDetail({super.key, required this.profileId});

  @override
  State<SummaryDetail> createState() => _SummaryDetailState();
}

class _SummaryDetailState extends State<SummaryDetail> {
  int tab = 0;
  int duration = 7;
  List<double> percentages = [];
  int centerFigure = 0;

  @override
  void initState() {
    super.initState();
    updateDataForChart(tab);
  }

  void loadDataForChart(List<Measurement> measurements) {
    int lowpb = 0, normalpb = 0, elevatedpb = 0, hyper1 = 0, hyper2 = 0;
    for (var element in measurements) {
      int status =
          DataAnalyzeExtension.getBPStatus(element.systolis, element.diastolis);
      if (status == BpStatus.lowBp.num) {
        lowpb++;
      } else if (status == BpStatus.normalBp.num) {
        normalpb++;
      } else if (status == BpStatus.elevatedBp.num) {
        elevatedpb++;
      } else if (status == BpStatus.hypertension1.num) {
        hyper1++;
      } else if (status == BpStatus.hypertension2.num) {
        hyper2++;
      }
    }
    percentages = [
      measurements.isNotEmpty ? lowpb / measurements.length : 0,
      measurements.isNotEmpty ? normalpb / measurements.length : 0,
      measurements.isNotEmpty ? elevatedpb / measurements.length : 0,
      measurements.isNotEmpty ? hyper1 / measurements.length : 0,
      measurements.isNotEmpty ? hyper2 / measurements.length : 0,
    ];
    centerFigure = ((percentages[1] + percentages[2]) * 100).toInt();
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
        .add(GetMeasurementsInRange(widget.profileId, start, end));
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
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
        child: BlocBuilder<MeasurementBloc, MeasurementState>(
          builder: (context, state) {
            if (state.status == MeasurementStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              loadDataForChart(state.measurementsInRange);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  Expanded(
                    child: Column(
                      children: [
                        DetailPieChart(
                            centerFigure: centerFigure,
                            data: PieChartMeasureData(
                                figures: percentages,
                                colors: chartColor.values.toList())),
                        const SizedBox(height: 40),
                        Text(
                            '$centerFigure% of measurements are within the health ranges',
                            style: TextCustomStyle.smallText
                                .copyWith(color: Colors.grey[400])),
                        const SizedBox(height: 40),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ...chartColor.keys.map((e) => Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: chartColor[e],
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        padding: const EdgeInsets.all(3),
                                        child: const Icon(Icons.circle,
                                            color: Colors.white, size: 10),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        BpStatus.values[e].status,
                                        style: TextStyle(
                                          color: chartColor[e],
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        ' - ${(percentages[e] * 100).toInt()}%',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  // DetailPieChart(data: )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
