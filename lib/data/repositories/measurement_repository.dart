import 'dart:developer';

import 'package:blood_pressure/common/helpers/db_helper.dart';
import 'package:blood_pressure/data/models/measurement.dart';
import 'package:sqflite/sqflite.dart';

class MeasurementRepository {
  Future<List<Measurement>> getAllMeasurements(int profileId) async {
    final database = await DBHelper.instance.database;
    final List<
        Map<String,
            dynamic>> measurementsListMap = await database.rawQuery(
        'SELECT * FROM measurements WHERE profile_id = $profileId AND is_deleted = 0 ORDER BY date DESC');

    return measurementsListMap.map((e) => Measurement.fromMap(e)).toList();
  }

  Future<Measurement> addMeasurement(Measurement measurement) async {
    final database = await DBHelper.instance.database;

    int id = await database.insert('measurements', measurement.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    Measurement? newMeasurement = await getMeasurementById(id);
    if (newMeasurement == null) {
      throw Exception('Failed to add new measurement');
    }
    return newMeasurement;
  }

  Future<List<Measurement>> getTheLastestMeasurement(int profileId) async {
    final database = await DBHelper.instance.database;
    final List<Map<String, dynamic>> latestMeasurement = await database.query(
        'measurements',
        where: 'profile_id = ? AND is_deleted = 0',
        whereArgs: [profileId],
        orderBy: 'date DESC',
        limit: 1);

    if (latestMeasurement.isEmpty) {
      return [];
    }

    return [Measurement.fromMap(latestMeasurement.first)];
  }

  Future<List<Measurement>> getMeasurementsInRange(
      int profileId, DateTime startDate, DateTime endDate) async {
    final database = await DBHelper.instance.database;

    int timeStart = startDate.millisecondsSinceEpoch;
    int timeEnd = endDate.millisecondsSinceEpoch;

    final List<Map<String, dynamic>> measurements = await database.query(
      'measurements',
      where: 'profile_id = ? AND date BETWEEN ? AND ? AND is_deleted = 0',
      orderBy: 'date DESC',
      whereArgs: [profileId, timeStart, timeEnd],
    );

    return measurements.map((e) => Measurement.fromMap(e)).toList();
  }

  Future<List<Measurement>> getAverageByDayInRange(
      int profileId, DateTime startDate, DateTime endDate) async {
    List<Measurement> average = [];
    List<Measurement> measurements =
        await getMeasurementsInRange(profileId, startDate, endDate);

    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      List<Measurement> measurementsByDay = measurements.where((element) {
        return element.date.day == startDate.add(Duration(days: i)).day;
      }).toList();

      log('measurementsByDay: $measurementsByDay');

      if (measurementsByDay.isNotEmpty) {
        int aveSystolis = 0;
        int aveDiastolis = 0;
        int avePulse = 0;
        for (Measurement measurement in measurementsByDay) {
          aveSystolis += measurement.systolis;
          aveDiastolis += measurement.diastolis;
          avePulse += measurement.pulse;
        }
        aveSystolis = aveSystolis ~/ measurementsByDay.length;
        aveDiastolis = aveDiastolis ~/ measurementsByDay.length;
        avePulse = avePulse ~/ measurementsByDay.length;

        average.add(measurementsByDay.last.copyWith(
            systolis: aveSystolis, diastolis: aveDiastolis, pulse: avePulse));
      }
    }
    return average;
  }

  Future<Measurement?> getMeasurementById(int id) async {
    final database = await DBHelper.instance.database;
    final List<Map<String, dynamic>> measurement = await database.query(
      'measurements',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (measurement.isEmpty) {
      return null;
    }
    return Measurement.fromMap(measurement.first);
  }

  Future<Measurement?> deleteMeasurement(int id) async {
    final database = await DBHelper.instance.database;
    await database.update('measurements', {'is_deleted': 1},
        where: 'id = ?', whereArgs: [id]);
    return getMeasurementById(id);
  }

  Future<Measurement> updateMeasurement(Measurement measurement) async {
    final database = await DBHelper.instance.database;
    await database.update('measurements', measurement.toMap(),
        where: 'id = ?', whereArgs: [measurement.id]);
    return measurement;
  }
}
