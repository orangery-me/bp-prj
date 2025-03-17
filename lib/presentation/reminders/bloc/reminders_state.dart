part of 'reminders_bloc.dart';

enum ReminderStatus {initial, loading, success, error}

final class ReminderState extends Equatable{
  final List<Reminder> reminders;
  final ReminderStatus status;

  const ReminderState({
    this.reminders = const [],
    this.status = ReminderStatus.initial,
  });

  ReminderState copyWith({
    List<Reminder>? reminders,
    ReminderStatus? status,

}) {
    return ReminderState(
      reminders: reminders ?? this.reminders,
      status: status?? this.status,
    );
  }
  @override
  List<Object?> get props => [reminders, status];


}