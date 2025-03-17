import 'package:blood_pressure/common/extensions/data_analyze_extension.dart';
import 'package:blood_pressure/common/theme/text_custom_style.dart';
import 'package:blood_pressure/data/models/measurement.dart';
import 'package:blood_pressure/data/models/profile.dart';
import 'package:blood_pressure/presentation/measurements/bloc/measurements/measurement_bloc.dart';
import 'package:blood_pressure/presentation/measurements/views/add_measurement_screen1/add_figure_page.dart';
import 'package:blood_pressure/presentation/measurements/views/add_measurement_screen2/new_measurements_page.dart';
import 'package:blood_pressure/presentation/measurements/widgets/measurement_overview_page.dart';
import 'package:blood_pressure/presentation/widgets/common_alert_dialog.dart';
import 'package:blood_pressure/presentation/widgets/gradient_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MeasurementDetail extends StatefulWidget {
  final Profile currentProfile;
  final Measurement measurement;
  const MeasurementDetail(
      {super.key, required this.measurement, required this.currentProfile});

  @override
  State<MeasurementDetail> createState() => _MeasurementDetailState();
}

class _MeasurementDetailState extends State<MeasurementDetail> {
  TextEditingController noteController = TextEditingController();
  late int pp;
  late double map;
  late double bmi;

  @override
  void initState() {
    super.initState();
    pp = DataAnalyzeExtension.getPP(
        widget.measurement.systolis, widget.measurement.diastolis);
    map = DataAnalyzeExtension.getMAP(
        widget.measurement.systolis, widget.measurement.diastolis);
    bmi = DataAnalyzeExtension.getBMI(
        widget.measurement.weight, widget.currentProfile.getHeightInCm());
    noteController.text = widget.measurement.note ?? '';
  }

  void _deleteCurrentMeasurement(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return CommonAlertDialog(
            title: 'Warning!',
            content: 'Do you want to delete this measurement?',
            onButtonPressed: () {
              context
                  .read<MeasurementBloc>()
                  .add(DeleteMeasurement(widget.measurement.id!));
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          );
        });
  }

  void _editCurrentMeasurement(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => BlocProvider.value(
              value: BlocProvider.of<MeasurementBloc>(context),
              child: AddFigurePage(
                currentProfile: widget.currentProfile,
                measurement: widget.measurement,
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Details', style: TextCustomStyle.mediumTitle),
          backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          child: Column(
            children: [
              MeasurementOverviewPage(measurement: widget.measurement),
              const SizedBox(height: 20),
              Row(
                children: [
                  FigureBox(figure: pp.toString(), unit: 'PP'),
                  const SizedBox(width: 16),
                  FigureBox(figure: map.round().toString(), unit: 'MAP'),
                  const SizedBox(width: 16),
                  FigureBox(figure: bmi.round().toString(), unit: 'BMI'),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Feeling', style: TextCustomStyle.mediumTitle),
                  Text(widget.measurement.feeling,
                      style: TextCustomStyle.mediumText
                          .copyWith(fontWeight: FontWeight.w400)),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Measured Site',
                      style: TextCustomStyle.mediumTitle),
                  Text(widget.measurement.measuredSite,
                      style: TextCustomStyle.mediumText
                          .copyWith(fontWeight: FontWeight.w400)),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Body Position',
                      style: TextCustomStyle.mediumTitle),
                  Text(widget.measurement.bodyPosition,
                      style: TextCustomStyle.mediumText
                          .copyWith(fontWeight: FontWeight.w400)),
                ],
              ),
              const SizedBox(height: 40),
              TextField(
                maxLines: 5,
                minLines: 5,
                controller: noteController,
                decoration: InputDecoration(
                    enabled: false,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide.none,
                    ),
                    hintText: noteController.text.isEmpty ? 'No Note' : null,
                    filled: true,
                    fillColor: const Color.fromARGB(255, 246, 246, 250)),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GradientOutlinedButton(
                      onPressed: () => _editCurrentMeasurement(context),
                      text: 'Edit',
                      isEnable: true,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _deleteCurrentMeasurement(context),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide.none,
                        ),
                      ),
                      child: const Text('Delete',
                          style: TextCustomStyle.mediumText),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
