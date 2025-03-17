import 'package:blood_pressure/data/repositories/reminder_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/reminder.dart';
part 'reminders_event.dart';
part 'reminders_state.dart';
class ReminderBloc extends Bloc<ReminderEvent, ReminderState>{
  final ReminderRepository _reminderRepository;

  ReminderBloc(this._reminderRepository): super(const ReminderState()){
    on<PostReminder> (_postNewReminder);
    on<GetAllReminder> (_getAllReminders);
    on<UpdateIsActive> (_updateIsActive);
    on<DeleteReminder> (_deleteReminder);
  }

  Future<void> _postNewReminder(PostReminder event, Emitter<ReminderState> emit) async{
    emit(state.copyWith(status: ReminderStatus.loading));
    try {
      await _reminderRepository.addReminder(event.reminder);
      emit(state.copyWith(
          reminders: [event.reminder, ...state.reminders],
          status: ReminderStatus.success));
      add(GetAllReminder());
    }
    catch(e){
      emit(state.copyWith(status: ReminderStatus.error));

    }
  }
  Future<void> _getAllReminders(GetAllReminder event, Emitter<ReminderState> emit) async{
    emit(state.copyWith(status: ReminderStatus.loading));
    try{
      final List<Reminder> profiles = await _reminderRepository.getAllReminders();
      emit(state.copyWith(reminders: profiles, status: ReminderStatus.success));
    }
    catch(e, stackTrace){
      debugPrint('Error in _getAllProfiles: $e');
      debugPrint(stackTrace.toString());
      emit(state.copyWith(status: ReminderStatus.error));
    }

  }
  Future<void> _updateIsActive(UpdateIsActive event, Emitter<ReminderState> emit) async {
    try {
      await _reminderRepository.updateIsActive(event.reminder);
      final updatedReminders = state.reminders.map((reminder) {
        if (reminder.id == event.reminder.id) {
          return event.reminder;
        }
        return reminder;
      }).toList();
      emit(state.copyWith(reminders: updatedReminders));
    } catch (e, stackTrace) {
      debugPrint('Error in _updateIsActive: $e');
      debugPrint(stackTrace.toString());
      emit(state.copyWith(status: ReminderStatus.error));
    }
  }

  Future<void> _deleteReminder(DeleteReminder event, Emitter<ReminderState> emit) async{
    try {
      await _reminderRepository.deleteReminder(event.idReminder);
      add(GetAllReminder());
    }
    catch(e, stackTrace){
      debugPrint('Error in _deleteIsActive: $e');
      debugPrint(stackTrace.toString());
      emit(state.copyWith(status: ReminderStatus.error));
    }
  }

}