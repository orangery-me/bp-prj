import 'package:blood_pressure/common/extensions/time_extension.dart';
import 'package:blood_pressure/common/theme/text_custom_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class TimePickerRow extends StatefulWidget {
  final void Function(DateTime) onSelected;
  const TimePickerRow({super.key, required this.onSelected});

  @override
  State<TimePickerRow> createState() => _TimePickerRowState();
}

class _TimePickerRowState extends State<TimePickerRow> {
  DateTime selectedDayTime = DateTime.now();

  void _onSelectDay(DateTime date) {
    setState(() {
      selectedDayTime = selectedDayTime.copyWith(
          year: date.year, month: date.month, day: date.day);
      widget.onSelected(selectedDayTime);
    });
  }

  void _onSelectTime(DateTime time) {
    setState(() {
      selectedDayTime =
          selectedDayTime.copyWith(hour: time.hour, minute: time.minute);
      widget.onSelected(selectedDayTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Date & Time ', style: TextCustomStyle.mediumTitle),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
                onTap: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      onConfirm: _onSelectDay,
                      currentTime: DateTime.now(),
                      maxTime: DateTime.now(),
                      locale: LocaleType.en);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 246, 246, 250),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                          '${selectedDayTime.day} ${TimeExtension.getMonthName(selectedDayTime.month)}',
                          style: TextCustomStyle.mediumText),
                    ],
                  ),
                )),
            const SizedBox(width: 8),
            GestureDetector(
                onTap: () {
                  DatePicker.showTimePicker(
                    context,
                    showTitleActions: true,
                    onConfirm: _onSelectTime,
                    currentTime: DateTime.now(),
                    locale: LocaleType.en,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 246, 246, 250),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      const Icon(Icons.watch_later_outlined,
                          color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                          TimeOfDay.fromDateTime(selectedDayTime)
                              .format(context),
                          style: TextCustomStyle.mediumText),
                    ],
                  ),
                )),
          ],
        ))
      ],
    );
  }
}
