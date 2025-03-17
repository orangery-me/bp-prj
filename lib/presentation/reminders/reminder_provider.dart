import 'package:blood_pressure/presentation/reminders/bloc/reminders_bloc.dart';
import 'package:blood_pressure/presentation/reminders/reminder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/reminder_repository.dart';

class ReminderProvider extends StatelessWidget {
  const ReminderProvider({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final reminderRepository = ReminderRepository();
    return BlocProvider(
        create: (context) => ReminderBloc(reminderRepository),
        child: const ReminderList());
  }
}
