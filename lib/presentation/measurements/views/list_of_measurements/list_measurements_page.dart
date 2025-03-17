import 'package:blood_pressure/common/extensions/time_extension.dart';
import 'package:blood_pressure/common/theme/text_custom_style.dart';
import 'package:blood_pressure/data/models/measurement.dart';
import 'package:blood_pressure/presentation/measurements/widgets/bp_analyze_box.dart';
import 'package:blood_pressure/presentation/measurements/widgets/calender_slider/calendar_slider.dart';
import 'package:flutter/material.dart';

class ListMeasurementsPage extends StatefulWidget {
  final int profileId;
  final List<Measurement> measurementsInRange;
  final Function(DateTime, DateTime) onDurationSelected;
  final Function(Measurement) onMeasurementSelected;
  const ListMeasurementsPage(
      {super.key,
      required this.onDurationSelected,
      required this.onMeasurementSelected,
      required this.measurementsInRange,
      required this.profileId});

  @override
  State<ListMeasurementsPage> createState() => _ListMeasurementsPageState();
}

class _ListMeasurementsPageState extends State<ListMeasurementsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 250,
        ),
        child: Column(
          children: [
            CalendarSlider(
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                onDurationSelected: widget.onDurationSelected),
            widget.measurementsInRange.isEmpty
                ? const Expanded(
                    child: Center(
                      child: Text('No Data Found!',
                          style: TextCustomStyle.mediumText),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemBuilder: (_, index) {
                          Measurement item = widget.measurementsInRange[index];
                          return GestureDetector(
                            onTap: () => widget.onMeasurementSelected(item),
                            child: MeasurementItem(
                                date: item.date,
                                systolis: item.systolis,
                                diastolis: item.diastolis,
                                pulse: item.pulse),
                          );
                        },
                        itemCount: widget.measurementsInRange.length),
                  )
          ],
        ),
      ),
    );
  }
}

class MeasurementItem extends StatelessWidget {
  final int? id;
  final DateTime date;
  final int systolis;
  final int diastolis;
  final int pulse;

  const MeasurementItem(
      {super.key,
      this.id,
      required this.date,
      required this.systolis,
      required this.diastolis,
      required this.pulse});

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.transparent)),
      color: const Color.fromARGB(255, 245, 246, 249),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${date.day} ${TimeExtension.getMonthName(date.month)} ${TimeOfDay.fromDateTime(date).format(context)}',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  BpAnalyzeBox(systolis: systolis, diastolis: diastolis)
                ],
              ),
            ),
            CardElement(subtitle: 'Sys - Dia', title: '$systolis - $diastolis'),
            const SizedBox(width: 20),
            CardElement(title: '$pulse', subtitle: 'Pulse'),
          ],
        ),
      ),
    );
  }
}

class CardElement extends StatelessWidget {
  final String title;
  final String subtitle;

  const CardElement({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(subtitle,
            style: const TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.w500)),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
