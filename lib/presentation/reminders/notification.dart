import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService{
  //init instance
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static Future<void> onDidReceiveNotification(NotificationResponse notification) async{

  }
  //init plugin
  static Future<void> init() async{
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iOSInitializationSettings = DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings
    );

    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
        onDidReceiveNotificationResponse: onDidReceiveNotification,
    );

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

  }

  //notification instance show
  // static  Future<void> showNotification(String title, String body)async{
  //   //define details
  //   const NotificationDetails platformChanelSpecifics = NotificationDetails(
  //     android: AndroidNotificationDetails(
  //         "ID",
  //         "Name",
  //       importance: Importance.high,
  //       priority: Priority.high
  //     ),
  //     iOS: DarwinNotificationDetails()
  //   );
  //   await flutterLocalNotificationsPlugin.show(0, title, body,platformChanelSpecifics);
  //
  // }

  //schedule notification
  static  Future<void> showScheduleNotification(String title, String body, DateTime schedule, int id)async{
    //define details
    const NotificationDetails platformChanelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
            'channelID',
            'channelName',
            importance: Importance.high,
            priority: Priority.high
        ),
        iOS: DarwinNotificationDetails()
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(id, title, body,
        tz.TZDateTime.from(schedule, tz.local),
        platformChanelSpecifics,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dateAndTime
    );

  }
  //cancel noti
  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}