import 'dart:io';

import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBHelper {
  DBHelper._(); // Private constructor to prevent instantiation

  static final DBHelper instance = DBHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // If the database does not exist, create it
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    // Initialize FFI (important on desktop platforms)
    sqfliteFfiInit();

    // Set the factory to use FFI
    databaseFactory = databaseFactoryFfi;

    Directory appDocDirectory = await getApplicationSupportDirectory();

    if (!(await appDocDirectory.exists())) {
      await appDocDirectory.create(recursive: true);
    }

    final String path = join(appDocDirectory.path, 'blood-pressure.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        String script = await rootBundle.loadString('assets/db/init_db.sql');
        List<String> scripts = script.split(';');
        for (var v in scripts) {
          if (v.isNotEmpty) {
            // ignore: avoid_print
            print(v.trim());
            db.execute(v.trim());
          }
        }
      },
    );
    
  }
}
