import 'package:blood_pressure/common/helpers/hive_box.dart';
import 'package:blood_pressure/common/theme/app_theme.dart';
import 'package:blood_pressure/common/helpers/db_helper.dart';
import 'package:blood_pressure/data/repositories/profile_repository.dart';
import 'package:blood_pressure/presentation/home/home_page.dart';
import 'package:blood_pressure/presentation/reminders/notification.dart';
import 'package:blood_pressure/presentation/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DBHelper db = DBHelper.instance;
  await db.initDB();
  await NotificationService.init();
  tz.initializeTimeZones();
  await HiveBox.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  bool _profileExists = false;

  _MyAppState();

  @override
  void initState() {
    super.initState();
    _checkProfile();
  }

  Future<void> _checkProfile() async {
    final ProfileRepository profileRepository = ProfileRepository();
    _profileExists = await profileRepository.isExistsProfile();
    setState(() {
      _isLoading = false;
    });
  }

  void refreshProfile() {
    setState(() {
      _isLoading = true;
    });
    _checkProfile();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const CircularProgressIndicator(); // You can customize this
    }

    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: themes[ThemeMode.light]!.themeData,
      darkTheme: themes[ThemeMode.dark]!.themeData,
      debugShowCheckedModeBanner: false,
      home: _profileExists ? const MyHomePage() : WelcomeScreen(onProfileAdded: refreshProfile,),
    );
  }
}
