import 'package:blood_pressure/common/helpers/db_helper.dart';
import 'package:blood_pressure/data/models/reminder.dart';
import 'package:sqflite/sqflite.dart';

class ReminderRepository {

  Future<void> addReminder(Reminder reminder) async{
    final database = await DBHelper.instance.database;
    await database.insert('reminders', reminder.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Reminder>> getAllReminders() async{
    final database = await DBHelper.instance.database;
    final List<Map<String, dynamic>> remindersList = await database.rawQuery(
      'Select * from reminders'
    );
    return remindersList.map((e)=> Reminder.fromMap(e)).toList();
  }

  Future<void> updateIsActive(Reminder reminder) async {
    final database = await DBHelper.instance.database;
    final reminderMap = reminder.toMap();
    await database.update(
      'reminders',
      reminderMap,
      where: 'id = ?',
      whereArgs: [reminder.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteReminder(int idReminder) async{
    final database = await DBHelper.instance.database;
    await database.delete('reminders',
      where: 'id = ?',
      whereArgs: [idReminder],
    );
  }
}
