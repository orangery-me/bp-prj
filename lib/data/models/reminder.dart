class Reminder {
  int? id;
  String time;
  bool isActive;

  Reminder({this.id, required this.time, required this.isActive});

  Map<String, dynamic> toMap(){
    return<String, dynamic>{
      'id': id,
      'time': time,
      'isActive': isActive ? 1: 0,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map){
    return Reminder(
    id: map['id'] != null ? map['id'] as int : null,
    time: map['time'] as String,
    isActive: map['isActive']  == 1 ? true : false
    );
  }

}
