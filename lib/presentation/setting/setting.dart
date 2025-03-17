import 'package:blood_pressure/data/repositories/measurement_repository.dart';
import 'package:blood_pressure/data/repositories/profile_repository.dart';
import 'package:blood_pressure/presentation/reminders/reminder_provider.dart';
import 'package:flutter/material.dart';
import '../measurements/widgets/calender_slider/full_calendar.dart';
import '../measurements/widgets/calender_slider/types.dart';
import '../share/create_pdf.dart';

class Setting extends StatefulWidget {
  final int profileId;
  const Setting({super.key, required this.profileId});
  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late DateTime _selectedDate;
  late DateTime? _selectedDateEnd;
  final DateTime firstDate = DateTime(2020, 1, 1);
  final DateTime lastDate = DateTime(2030, 12, 31);
  final double padding = 14.0;
  final Color calendarEventColor = Colors.blue;
  final Color calendarEventSelectedColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedDateEnd = null;
  }

  void _formatDate() {
    _selectedDate = DateTime.parse(
        "${_selectedDate.toString().split(" ").first} 00:00:00.000");
    _selectedDateEnd = DateTime.parse(
        "${_selectedDateEnd.toString().split(" ").first} 23:59:59.999");
  }

  void _swapSelectedDate() {
    final temp = _selectedDate;
    _selectedDate = _selectedDateEnd!;
    _selectedDateEnd = temp;
  }

  void _createPDFOfTheDayRange() async {
    if (_selectedDateEnd == null) {
      return;
    }
    _formatDate();
    final measurementRepository = MeasurementRepository();
    final profileRepository = ProfileRepository();
    final profile = await profileRepository.getProfileById(widget.profileId);
    final measurements = await measurementRepository.getMeasurementsInRange(
        1, _selectedDate, _selectedDateEnd!);

    if (measurements.isNotEmpty) {
      try {
        final pdfFile = await CreatePDF.generatePDF(
          measurements,
          profile!,
          _selectedDate,
          _selectedDateEnd!,
        );
        CreatePDF.openPDF(pdfFile);
      } catch (e) {
        _showErrorDialog(
            context, "Error", "An error occurred while generating the PDF: $e");
      }
    } else {
      _showErrorDialog(
          context, "Notice", "No data available to generate the PDF.");
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showFullCalendar(String locale, WeekDay weekday) {
    // double height;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      builder: (BuildContext context) {
        double height;
        DateTime? endDate = lastDate;
        if (firstDate.year == endDate.year &&
            firstDate.month == endDate.month) {
          height = ((MediaQuery.of(context).size.width - 2 * padding) / 7) * 5 +
              100.0;
        } else {
          height = (MediaQuery.of(context).size.height - 100.0);
        }
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SizedBox(
              height: (MediaQuery.of(context).size.height / 6) * 4.3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: 60,
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: const Color(0xFFE0E0E0),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Expanded(
                    child: FullCalendar(
                      startDate: firstDate,
                      endDate: endDate,
                      padding: padding,
                      dateColor: const Color(0xFF3F5266),
                      dateSelectedBg: calendarEventColor,
                      dateSelectedColor: calendarEventSelectedColor,
                      events: const [],
                      selectedDate: _selectedDate,
                      selectedDateEnd: _selectedDateEnd,
                      fullCalendarDay: weekday,
                      calendarScroll: FullCalendarScroll.horizontal,
                      locale: locale,
                      onDateChange: (value) {
                        setModalState(() {
                          if (_selectedDateEnd != null) {
                            _selectedDate = value;
                            _selectedDateEnd = null;
                          } else {
                            _selectedDateEnd = value;
                            if (_selectedDateEnd!.isBefore(_selectedDate)) {
                              _swapSelectedDate();
                            }
                          }
                        });
                      },
                      hideCalendar: () {
                        Navigator.pop(context);
                        _createPDFOfTheDayRange();
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          item(
            icon: Icons.share,
            title: 'Share Measurement',
            onTap: () {
              _showFullCalendar('en', WeekDay.short);
            },
          ),
          item(
            icon: Icons.notifications,
            title: 'Daily Reminders',
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ReminderProvider()),
              )
            },
          ),
          item(
            icon: Icons.apps,
            title: 'Other Apps',
            onTap: () => {},
          ),
          item(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            onTap: () => {},
          ),
          item(
            icon: Icons.shield,
            title: 'Terms & Conditions',
            onTap: () => {},
          ),
          item(
            icon: Icons.email,
            title: 'Contact Us',
            onTap: () => {},
          ),
        ],
      ),
    );
  }

  Widget item({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.grey,
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
