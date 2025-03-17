import 'package:blood_pressure/data/models/measurement.dart';
import 'package:blood_pressure/data/models/profile.dart';
import 'package:blood_pressure/presentation/measurements/views/add_measurement_screen2/new_measurements_page.dart';
import 'package:blood_pressure/presentation/measurements/views/add_measurement_screen1/tile_element.dart';
import 'package:blood_pressure/presentation/measurements/bloc/measurements/measurement_bloc.dart';
import 'package:blood_pressure/presentation/widgets/gradient_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddFigurePage extends StatefulWidget {
  final Profile currentProfile;
  final Measurement? measurement;
  const AddFigurePage(
      {super.key, required this.currentProfile, this.measurement});

  @override
  State<AddFigurePage> createState() => _AddFigurePageState();
}

class _AddFigurePageState extends State<AddFigurePage> {
  TextEditingController systolicController = TextEditingController();
  TextEditingController diastolicController = TextEditingController();
  TextEditingController pulseController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  int systolis = 0;
  int diastolis = 0;
  int pulse = 0;
  double weight = 0.0;
  bool isFilled = false;

  @override
  void initState() {
    super.initState();

    if (widget.measurement != null) {
      systolicController.text = widget.measurement!.systolis.toString();
      diastolicController.text = widget.measurement!.diastolis.toString();
      pulseController.text = widget.measurement!.pulse.toString();
      weightController.text = widget.measurement!.weight.toString();
    } else {
      weightController.text = widget.currentProfile.weight.toString();
    }
    validate();
  }

  void validate() {
    if (systolicController.text.isNotEmpty &&
        diastolicController.text.isNotEmpty &&
        pulseController.text.isNotEmpty &&
        weightController.text.isNotEmpty) {
      isFilled = true;
    } else {
      isFilled = false;
    }
    setState(() {});
  }

  void getValue() {
    systolis = int.parse(systolicController.text);
    diastolis = int.parse(diastolicController.text);
    pulse = int.parse(pulseController.text);
    weight = double.parse(weightController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.measurement == null ? 'New Measurement' : 'Edit Measurement',
            style: TextStyle(
                color: Colors.grey[500], fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 32.0),
        child: Column(
          children: [
            Expanded(
                child: Column(
              children: [
                TileElement(
                  title: 'SYSTOLIC',
                  subtitle: 'mmHg',
                  hintText: '120',
                  controller: systolicController,
                  validate: validate,
                ),
                TileElement(
                  title: 'DIASTOLIC',
                  subtitle: 'mmHg',
                  hintText: '80',
                  controller: diastolicController,
                  validate: validate,
                ),
                TileElement(
                  title: 'PULSE',
                  subtitle: 'BPM',
                  hintText: '60',
                  controller: pulseController,
                  validate: validate,
                ),
                TileElement(
                  title: 'WEIGHT',
                  subtitle: 'kgs',
                  hintText: '50.4',
                  controller: weightController,
                  validate: validate,
                ),
              ],
            )),
            GradientOutlinedButton(
              onPressed: () {
                getValue();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                              value: BlocProvider.of<MeasurementBloc>(context),
                              child: NewMeasurementsPage(
                                  systolis: systolis,
                                  diastolis: diastolis,
                                  pulse: pulse,
                                  weight: weight,
                                  currentProfile: widget.currentProfile,
                                  edittedMeasurement: widget.measurement),
                            )));
              },
              isEnable: isFilled,
              text: 'Continue',
            ),
          ],
        ),
      ),
    );
  }
}
