import 'package:blood_pressure/common/theme/text_custom_style.dart';
import 'package:blood_pressure/data/models/measurement.dart';
import 'package:blood_pressure/data/models/profile.dart';
import 'package:blood_pressure/presentation/measurements/bloc/measurements/measurement_bloc.dart';
import 'package:blood_pressure/presentation/measurements/views/list_of_measurements/list_measurements_page.dart';
import 'package:blood_pressure/presentation/measurements/views/measurement_detail/measurement_detail.dart';
import 'package:blood_pressure/presentation/measurements/widgets/measurement_overview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class MeasurementDiaryPage extends StatefulWidget {
  final Profile currentProfile;
  const MeasurementDiaryPage({
    super.key,
    required this.currentProfile,
  });

  @override
  State<MeasurementDiaryPage> createState() => _MeasurementDiaryPageState();
}

class _MeasurementDiaryPageState extends State<MeasurementDiaryPage> {
  int profileId = -1;
  DateTime _currentStart = DateTime.now().subtract(const Duration(days: 7));
  DateTime _currentEnd = DateTime.now();

  void updateView() {
    _getLatestMeasurement(profileId);
    _getMeasurementsInRange(_currentStart, _currentEnd);
  }

  void _getLatestMeasurement(int profileId) {
    context.read<MeasurementBloc>().add(GetLatestMeasurement(profileId));
  }

  void _getMeasurementsInRange(DateTime start, DateTime end) {
    // lấy thời điểm cuối ngày
    _currentEnd = DateTime(end.year, end.month, end.day, 23, 59, 59);
    _currentStart = DateTime(start.year, start.month, start.day, 0, 0, 0);
    context
        .read<MeasurementBloc>()
        .add(GetMeasurementsInRange(profileId, start, end));
  }

  void _openMeasurementDetail(BuildContext context, Measurement measurement) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: context.read<MeasurementBloc>(),
        child: MeasurementDetail(
            currentProfile: widget.currentProfile, measurement: measurement),
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    profileId = widget.currentProfile.id!;
    updateView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocConsumer<MeasurementBloc, MeasurementState>(
          listenWhen: (previous, current) =>
              previous.measurements != current.measurements,
          listener: (BuildContext context, MeasurementState state) {
            if (state.status == MeasurementStatus.success) {
              updateView();
            }
          },
          buildWhen: (previous, current) =>
              previous.latestMeasurement != current.latestMeasurement,
          builder: (context, state) {
            if (state.status == MeasurementStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              // log('latestMeasurement: ${state.latestMeasurement}');
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hi, ${widget.currentProfile.fullName}',
                      style: TextCustomStyle.largeTitle),
                  state.latestMeasurement.isEmpty
                      ? Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/NewMeasure.svg',
                                  width: 200,
                                  height: 200,
                                ),
                                const SizedBox(height: 20),
                                Text('The measurement diary is empty',
                                    style: TextCustomStyle.mediumTextIndicator),
                                const Text('Tap + to add a new measurement',
                                    style: TextCustomStyle.mediumText)
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            MeasurementOverviewPage(
                              measurement: state.latestMeasurement[0],
                            ),
                            BlocBuilder<MeasurementBloc, MeasurementState>(
                              buildWhen: (previous, current) =>
                                  previous.measurementsInRange !=
                                  current.measurementsInRange,
                              builder: (context, state) {
                                return ListMeasurementsPage(
                                  profileId: profileId,
                                  onDurationSelected: (p0, p1) =>
                                      _getMeasurementsInRange(p0, p1),
                                  measurementsInRange:
                                      state.measurementsInRange,
                                  onMeasurementSelected: (p0) =>
                                      _openMeasurementDetail(context, p0),
                                );
                              },
                            ),
                          ],
                        )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
