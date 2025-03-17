// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Measurement {
  int? id;
  int profileId;
  DateTime date;
  int systolis;
  int diastolis;
  int pulse;
  double weight;
  int age;
  String feeling;
  String measuredSite;
  String bodyPosition;
  String? note;

  Measurement(
      {this.id,
      required this.profileId,
      required this.date,
      required this.systolis,
      required this.diastolis,
      required this.pulse,
      required this.weight,
      required this.age,
      required this.feeling,
      required this.measuredSite,
      required this.bodyPosition,
      this.note});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'profile_id': profileId,
      'date': date.millisecondsSinceEpoch,
      'systolis': systolis,
      'diastolis': diastolis,
      'pulse': pulse,
      'weight': weight,
      'age': age,
      'feeling': feeling,
      'measured_site': measuredSite,
      'body_position': bodyPosition,
      'note': note,
    };
  }

  String toJson() => json.encode(toMap());

  factory Measurement.fromMap(Map<String, dynamic> map) {
    return Measurement(
      id: map['id'] != null ? map['id'] as int : null,
      profileId: map['profile_id'] as int,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      systolis: map['systolis'] as int,
      diastolis: map['diastolis'] as int,
      pulse: map['pulse'] as int,
      weight: map['weight'] as double,
      age: map['age'] as int,
      feeling: map['feeling'] as String,
      measuredSite: map['measured_site'] as String,
      bodyPosition: map['body_position'] as String,
      note: map['note'] as String,
    );
  }

  factory Measurement.fromJson(String source) =>
      Measurement.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Measurement(id: $id, profileId: $profileId, date: $date, systolis: $systolis, diastolis: $diastolis, pulse: $pulse, weight: $weight, age: $age, feeling: $feeling, measuredSite: $measuredSite, bodyPosition: $bodyPosition, note: $note)';
  }

  Measurement copyWith({
    int? id,
    int? profileId,
    DateTime? date,
    int? systolis,
    int? diastolis,
    int? pulse,
    double? weight,
    int? age,
    String? feeling,
    String? measuredSite,
    String? bodyPosition,
    String? note,
  }) {
    return Measurement(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      date: date ?? this.date,
      systolis: systolis ?? this.systolis,
      diastolis: diastolis ?? this.diastolis,
      pulse: pulse ?? this.pulse,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      feeling: feeling ?? this.feeling,
      measuredSite: measuredSite ?? this.measuredSite,
      bodyPosition: bodyPosition ?? this.bodyPosition,
      note: note ?? this.note,
    );
  }
}
