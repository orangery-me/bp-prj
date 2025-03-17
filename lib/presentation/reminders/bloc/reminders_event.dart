
part of 'reminders_bloc.dart';
class ReminderEvent{}

class PostReminder extends ReminderEvent{
  final Reminder reminder;

  PostReminder(this.reminder);

}

class GetAllReminder extends ReminderEvent{
  GetAllReminder();
}
class UpdateIsActive extends ReminderEvent{
  final Reminder reminder;
  UpdateIsActive(this.reminder);
}

class DeleteReminder extends ReminderEvent{
  final int idReminder;
  DeleteReminder(this.idReminder);
}