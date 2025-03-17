import 'package:hive_flutter/hive_flutter.dart';

class HiveBox {
  HiveBox._internal(); // named constructor

  static final HiveBox instance = HiveBox._internal();

  late Box userBox;

  Future<void> init() async {
    await Hive.initFlutter();
    userBox = await Hive.openBox('user');
  }
}
