import 'package:blood_pressure/common/extensions/time_extension.dart';
import 'package:blood_pressure/common/theme/text_custom_style.dart';
import 'package:blood_pressure/data/models/measurement.dart';
import 'package:blood_pressure/presentation/measurements/widgets/bp_analyze_box.dart';
import 'package:flutter/material.dart';

class MeasurementOverviewPage extends StatelessWidget {
  final Measurement measurement;
  const MeasurementOverviewPage({super.key, required this.measurement});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            ListTile(
              title: Text(
                'Last Entry',
                style: TextCustomStyle.mediumText.copyWith(
                  color: Colors.white60,
                ),
              ),
              trailing: Text(
                  '${measurement.date.day} ${TimeExtension.getMonthName(measurement.date.month)} ${TimeOfDay.fromDateTime(measurement.date).format(context)}',
                  style: TextCustomStyle.mediumText.copyWith(
                    color: Colors.white,
                  )),
            ),
            TileElement(
              title: 'Systolic',
              subtitle: 'mmHg',
              value: measurement.systolis.toString(),
            ),
            TileElement(
              title: 'Diastolic',
              subtitle: 'mmHg',
              value: measurement.diastolis.toString(),
            ),
            TileElement(
              title: 'Pulse',
              subtitle: 'BPM',
              value: measurement.pulse.toString(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BpAnalyzeBox(
                      systolis: measurement.systolis,
                      diastolis: measurement.diastolis,
                      color: Colors.white,
                      iconSize: 6,
                      fontSize: 14),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Age: ${measurement.age}  Weight: ${measurement.weight} kg',
                          style: TextCustomStyle.smallText
                              .copyWith(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TileElement extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;

  const TileElement(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextCustomStyle.mediumText.copyWith(color: Colors.white),
      ),
      subtitle: Text(subtitle,
          style: TextCustomStyle.smallText.copyWith(color: Colors.white)),
      trailing: Text(
        value,
        style: TextCustomStyle.largeTitle.copyWith(color: Colors.white),
      ),
    );
  }
}
