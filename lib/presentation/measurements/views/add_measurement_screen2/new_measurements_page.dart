import 'package:blood_pressure/common/constants/constants.dart';
import 'package:blood_pressure/common/extensions/data_analyze_extension.dart';
import 'package:blood_pressure/common/theme/text_custom_style.dart';
import 'package:blood_pressure/data/models/measurement.dart';
import 'package:blood_pressure/data/models/profile.dart';
import 'package:blood_pressure/presentation/measurements/views/add_measurement_screen2/data_picker_row.dart';
import 'package:blood_pressure/presentation/measurements/views/add_measurement_screen2/time_picker_row.dart';
import 'package:blood_pressure/presentation/measurements/bloc/measurements/measurement_bloc.dart';
import 'package:blood_pressure/presentation/measurements/widgets/bp_analyze_box.dart';
import 'package:blood_pressure/presentation/widgets/gradient_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewMeasurementsPage extends StatefulWidget {
  final int systolis;
  final int diastolis;
  final int pulse;
  final double weight;
  final Profile currentProfile;
  final Measurement? edittedMeasurement;

  const NewMeasurementsPage(
      {super.key,
      required this.systolis,
      required this.diastolis,
      required this.pulse,
      required this.weight,
      required this.currentProfile,
      this.edittedMeasurement});

  @override
  State<NewMeasurementsPage> createState() => _NewMeasurementsPageState();
}

class _NewMeasurementsPageState extends State<NewMeasurementsPage> {
  late int pp;
  late double map;
  late double bmi;
  late String feeling;
  late String measuredSite;
  late String bodyPosition;
  late DateTime date;
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    pp = DataAnalyzeExtension.getPP(widget.systolis, widget.diastolis);
    map = DataAnalyzeExtension.getMAP(widget.systolis, widget.diastolis);
    int height = widget.currentProfile.getHeightInCm();
    bmi = DataAnalyzeExtension.getBMI(widget.weight, height);
    feeling =
        widget.edittedMeasurement?.feeling ?? MeasurementConstants.feelings[0];
    measuredSite = widget.edittedMeasurement?.measuredSite ??
        MeasurementConstants.measuredSites[0];
    bodyPosition = widget.edittedMeasurement?.bodyPosition ??
        MeasurementConstants.bodyPositions[0];
    noteController.text = widget.edittedMeasurement?.note ?? '';
    date = widget.edittedMeasurement?.date ?? DateTime.now();
  }

  void _saveOrUpdate(BuildContext context) {
    Measurement measurement = Measurement(
        profileId: widget.currentProfile.id!,
        age: widget.currentProfile.getAge(),
        systolis: widget.systolis,
        diastolis: widget.diastolis,
        pulse: widget.pulse,
        weight: widget.weight,
        feeling: feeling,
        measuredSite: measuredSite,
        bodyPosition: bodyPosition,
        note: noteController.text,
        date: date);

    if (widget.edittedMeasurement != null) {
      measurement = measurement.copyWith(id: widget.edittedMeasurement!.id);
      context.read<MeasurementBloc>().add(UpdateMeasurement(measurement));
    } else {
      context.read<MeasurementBloc>().add(PostMeasurement(measurement));
    }
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.edittedMeasurement == null
                ? 'New Measurement'
                : 'Edit Measurement',
            style: TextStyle(
                color: Colors.grey[500], fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Center(
          child: Column(
            children: [
              Card.filled(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.transparent)),
                color: const Color.fromARGB(255, 246, 246, 250),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CardElement(
                          title: '${widget.systolis} - ${widget.diastolis}',
                          subtitle: 'Sys - Dia',
                          thirdLine: BpAnalyzeBox(
                              systolis: widget.systolis,
                              diastolis: widget.diastolis)),
                      CardElement(
                        title: '${widget.pulse}',
                        subtitle: 'Pulse',
                        thirdLine: const Text('Age: 23',
                            style: TextCustomStyle.smallText),
                      ),
                      CardElement(
                        title: '${widget.weight}',
                        subtitle: 'Weight',
                      ),
                    ],
                  ),
                ),
              ),
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
              TimePickerRow(
                onSelected: (selected) {
                  if (selected.compareTo(DateTime.now()) > 0) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text('Can not chose the date time in the future')));
                    return;
                  }
                  date = selected;
                },
              ),
              const SizedBox(height: 20),
              DataPickerRow(
                title: 'Feeling',
                items: MeasurementConstants.feelings,
                onSelected: (selected) {
                  feeling = selected;
                },
              ),
              const SizedBox(height: 20),
              DataPickerRow(
                title: 'Measured Site',
                items: MeasurementConstants.measuredSites,
                onSelected: (selected) {
                  measuredSite = selected;
                },
              ),
              const SizedBox(height: 20),
              DataPickerRow(
                title: 'Body Position',
                items: MeasurementConstants.bodyPositions,
                onSelected: (selected) {
                  bodyPosition = selected;
                },
              ),
              const SizedBox(height: 20),
              TextField(
                maxLines: 5,
                minLines: 5,
                controller: noteController,
                decoration: const InputDecoration(
                    hintText: 'Add Note',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 246, 246, 250)),
              ),
              const SizedBox(height: 20),
              GradientOutlinedButton(
                onPressed: () => _saveOrUpdate(context),
                text: 'Save',
                isEnable: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FigureBox extends StatelessWidget {
  final String figure;
  final String unit;

  const FigureBox({super.key, required this.figure, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        height: 40.0,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 246, 246, 250),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Text(figure, style: TextCustomStyle.mediumTitle),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                alignment: Alignment.center,
                child: Text(unit, style: TextCustomStyle.mediumTitle),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CardElement extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? thirdLine;

  const CardElement(
      {super.key, required this.title, required this.subtitle, this.thirdLine});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(subtitle,
              style: TextStyle(fontSize: 16, color: Colors.grey[500])),
          const SizedBox(height: 12),
          thirdLine ?? Container(),
        ],
      ),
    );
  }
}
