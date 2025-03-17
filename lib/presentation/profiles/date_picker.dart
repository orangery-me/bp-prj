import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePickerComponent extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const DatePickerComponent({
    super.key,
    this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<DatePickerComponent> createState() => _DatePickerComponentState();
}

class _DatePickerComponentState extends State<DatePickerComponent> {
  late int selectedDay;
  late int selectedMonth;
  late int selectedYear;

  final List<int> days = List.generate(31, (index) => index + 1);
  final List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  final List<int> years =
      List.generate(101, (index) => DateTime.now().year - index);

  @override
  void initState() {
    super.initState();
    final initialDate = widget.initialDate ?? DateTime.now();
    selectedDay = initialDate.day;
    selectedMonth = initialDate.month;
    selectedYear = initialDate.year;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 40, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Select your Date of Birth',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                CustomCupertinoPicker(
                  items: days.map((day) => day.toString()).toList(),
                  initialItem: selectedDay - 1,
                  onSelectedItemChanged: (index) {
                    setState(() => selectedDay = days[index]);
                  },
                ),
                CustomCupertinoPicker(
                  items: months,
                  initialItem: selectedMonth - 1,
                  onSelectedItemChanged: (index) {
                    setState(() => selectedMonth = index + 1);
                  },
                ),
                CustomCupertinoPicker(
                  items: years.map((year) => year.toString()).toList(),
                  initialItem: years.indexOf(selectedYear),
                  onSelectedItemChanged: (index) {
                    setState(() => selectedYear = years[index]);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 150,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE100FF), Color(0xFF7F00FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Text(
                'Done',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (_isDateValid()) {
                  final newDate =
                      DateTime(selectedYear, selectedMonth, selectedDay);
                  widget.onDateSelected(newDate);
                  Navigator.pop(context);
                } else {
                  _showDateInvalidDialog(context);
                }
              },
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  bool _isDateValid() {
    if (selectedMonth == 2) {
      if (selectedYear % 4 == 0 &&
          (selectedYear % 100 != 0 || selectedYear % 400 == 0)) {
        return selectedDay <= 29;
      }
      return selectedDay <= 28;
    } else if ([4, 6, 9, 11].contains(selectedMonth)) {
      return selectedDay <= 30;
    }
    return selectedDay <= 31;
  }

  void _showDateInvalidDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invalid Date'),
          content: const Text(
              'The selected date is invalid. Please choose a valid date.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class CustomCupertinoPicker extends StatelessWidget {
  final List<String> items;
  final int initialItem;
  final ValueChanged<int> onSelectedItemChanged;

  const CustomCupertinoPicker({
    super.key,
    required this.items,
    required this.initialItem,
    required this.onSelectedItemChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(initialItem: initialItem),
        itemExtent: 30.0,
        selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
          capStartEdge: false,
          capEndEdge: false,
        ),
        onSelectedItemChanged: onSelectedItemChanged,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final value = entry.value;
          return Center(
            child: Text(
              value,
              style: TextStyle(
                color: index == initialItem
                    ? const Color(0xFF7F00FF)
                    : CupertinoColors.inactiveGray,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
