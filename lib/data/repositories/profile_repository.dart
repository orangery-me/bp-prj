import 'package:blood_pressure/common/helpers/db_helper.dart';
import 'package:blood_pressure/data/models/profile.dart';
import 'package:sqflite/sqflite.dart';

class ProfileRepository {
  Future<void> addProfile(Profile profile) async {
    final database = await DBHelper.instance.database;
    await database.insert('profiles', profile.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Profile>> getAllProfiles() async {
    final database = await DBHelper.instance.database;
    final List<Map<String, dynamic>> profilesListMap =
        await database.rawQuery('SELECT * FROM profiles');
    return profilesListMap.map((e) => Profile.fromMap(e)).toList();
  }

  Future<void> deleteProfile(int profileId) async {
    final database = await DBHelper.instance.database;
    await database.delete(
      'profiles',
      where: 'id = ?',
      whereArgs: [profileId],
    );
  }
  Future<Profile?> getProfileById(int profileId) async {
    final database = await DBHelper.instance.database;

    final List<Map<String, dynamic>> profileMap = await database.query(
      'profiles',
      where: 'id = ?',
      whereArgs: [profileId],
    );
    if (profileMap.isNotEmpty) {
      return Profile.fromMap(profileMap.first);
    } else {
      return null;
    }
  }
  Future<void> updateProfile(Profile profile) async {
    final database = await DBHelper.instance.database;
    final profileMap = profile.toMap();
    await database.update(
      'profiles',
      profileMap,
      where: 'id = ?',
      whereArgs: [profile.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> isExistsProfile() async {
    final database = await DBHelper.instance.database;

    final List<Map<String, dynamic>> isExistsProfile =
        await database.rawQuery('SELECT COUNT(*) FROM profiles');

    return isExistsProfile.any((e) => e.values.first > 0);
  }

  Future<Profile> getLatestProfile() async {
    final database = await DBHelper.instance.database;
    final List<Map<String, dynamic>> profilesListMap = await database
        .rawQuery('SELECT * FROM profiles ORDER BY id DESC LIMIT 1');
    return profilesListMap.map((e) => Profile.fromMap(e)).first;
  }

  Future<bool> isFirstProfile() async {
    final database = await DBHelper.instance.database;
    final List<Map<String, dynamic>> profileList = await database
    .rawQuery('SELECT * FROM profiles');
    return profileList.length == 1;

  }
}
