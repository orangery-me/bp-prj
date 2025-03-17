import 'package:blood_pressure/data/models/reminder.dart';
import 'package:blood_pressure/presentation/reminders/bloc/reminders_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/select_component/select_components.dart';
import 'notification.dart';

class ReminderList extends StatefulWidget {
  const ReminderList({super.key});

  @override
  State<ReminderList> createState() => _ReminderListState();
}

class _ReminderListState extends State<ReminderList> {
  final List<int> hours = List.generate(12, (index) => index + 1);
  final List<int> minutes = List.generate(60, (index) => index);
  late int currentHour;
  late int currentMinute;
  late String suffix;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<ReminderBloc>(context).add(GetAllReminder());
  }

  void showTimePicker(BuildContext context, Function(String time) onTimeSelected) {
    final now = DateTime.now();
    currentHour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    currentMinute = now.minute;
    suffix = now.hour >= 12 ? 'PM' : 'AM';

    SelectComponents.showPicker(
      context,
      hours.map((hour) => hour.toString()).toList(),
      minutes.map((minute) => minute.toString().padLeft(2, '0')).toList(),
      ['AM', 'PM'],
      currentHour.toString(),
      currentMinute.toString().padLeft(2,'0'),
      suffix,
      'time',
          (Map<String, String> result) {
        String whole = result['whole'] ?? '0';
        String fraction = result['fraction'] ?? '0';
        String unit = result['unit'] ?? '';
        String time = '$whole:$fraction $unit';

        final reminders = BlocProvider.of<ReminderBloc>(context).state.reminders;
        final isDuplicate = reminders.any((reminder) => reminder.time == time);
        if (isDuplicate) {
          Future.microtask(() {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: const Text('A reminder already exists.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          });
        }
        else {
          BlocProvider.of<ReminderBloc>(context).add(
            PostReminder(Reminder(time: time, isActive: true)),
          );
        }
      },
    );
  }

  void showWarningDialog(BuildContext parentContext, int id) {
    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Warning!',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: const Text(
            'Do you want to delete this reminder?',
            style: TextStyle(color: Colors.grey),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    int idReminder = id;
                    BlocProvider.of<ReminderBloc>(parentContext).add(DeleteReminder(idReminder));
                    NotificationService.cancelNotification(idReminder);
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<ReminderBloc, ReminderState>(
          builder: (context, state) {
            return AppBar(
              title: const Text(
                'Reminder',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.white,
              actions: state.reminders.isNotEmpty
                  ? [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.purple),
                  onPressed: () => showTimePicker(context, (time) {
                    BlocProvider.of<ReminderBloc>(context).add(
                      PostReminder(Reminder(time: time, isActive: true)),
                    );
                  }),
                ),
              ] : null,
            );
          },
        ),
      ),
      body: BlocBuilder<ReminderBloc, ReminderState>(
        builder: (context, state) {
          if (state.status == ReminderStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status == ReminderStatus.error) {
            return const Center(
              child: Text('Error loading reminders!'),
            );
          } else if (state.reminders.isNotEmpty) {
            for (var reminder in state.reminders) {
              if (reminder.isActive) {
                List<String> split = reminder.time.split(' ');
                List<String> hhmm = split[0].split(':');
                int hour = int.parse(hhmm[0]);
                int minute = int.parse(hhmm[1]);
                String suffix = split[1];
                if (suffix == 'PM' && hour != 12) hour += 12;
                if (suffix == 'AM' && hour == 12) hour = 0;

                DateTime now = DateTime.now();
                DateTime scheduledTime = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  hour,
                  minute,
                );

                if (scheduledTime.isBefore(now)) {
                  scheduledTime = scheduledTime.add(const Duration(days: 1));
                }
                NotificationService.showScheduleNotification(
                  'Reminder',
                  'Time to input your health data',
                  scheduledTime,
                  reminder.id!,
                );
              }
              else{
                NotificationService.cancelNotification(reminder.id!);
              }
            }
            return ListView.builder(
              itemCount: state.reminders.length,
              itemBuilder: (context, index) {
                final reminder = state.reminders[index];
                return GestureDetector(
                  onLongPress: ()=>showWarningDialog(context, reminder.id!),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          reminder.time,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                            color: reminder.isActive? Colors.black : Colors.grey[700]
                          ),

                        ),
                        Switch(
                          value: reminder.isActive,
                          activeColor: Colors.green,
                          onChanged: (bool value) {
                            setState(() {
                              reminder.isActive = value;
                            });
                            BlocProvider.of<ReminderBloc>(context).add(UpdateIsActive(reminder));
                            NotificationService.cancelNotification(reminder.id!);
                          },
                        )
                      ],
                    ),
                  )
                );
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => showTimePicker(context, (time) {
                      BlocProvider.of<ReminderBloc>(context).add(
                        PostReminder(Reminder(time: time, isActive: true)),
                      );
                    }),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.purple, width: 2),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.purple,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Add a new reminder by\nclicking the + button',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
