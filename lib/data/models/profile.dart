import 'package:blood_pressure/common/extensions/data_analyze_extension.dart';

class Profile {
  int? id;
  String fullName;
  DateTime birthday;
  int gender;
  String weight;
  String weightUnit;
  String height;
  String heightUnit;

  Profile({
    this.id,
    required this.fullName,
    required this.birthday,
    required this.gender,
    required this.weight,
    required this.weightUnit,
    required this.height,
    required this.heightUnit,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'full_name': fullName,
      'birthday': birthday.microsecondsSinceEpoch,
      'gender': gender,
      'weight': weight,
      'weight_unit': weightUnit,
      'height': height,
      'height_unit': heightUnit,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] != null ? map['id'] as int : null,
      fullName: map['full_name'] as String,
      birthday: DateTime.fromMicrosecondsSinceEpoch(map['birthday'] as int),
      gender: map['gender'] as int,
      weight: map['weight'].toString(),
      weightUnit: map['weight_unit'] as String,
      height: map['height'].toString(),
      heightUnit: map['height_unit'] as String,
    );
  }
  @override
  String toString() {
    return 'Profile(id: $id, fullName: $fullName, birthday: $birthday, gender: $gender, weight: $weight, weightUnit: $weightUnit, height: $height, heightUnit: $heightUnit)';
  }

  int getAge() {
    DateTime now = DateTime.now();
    int age = now.year - birthday.year;
    if (now.month < birthday.month ||
        (now.month == birthday.month && now.day < birthday.day)) {
      age--;
    }
    return age;
  }

  int getHeightInCm() {
    int heightInCm = 0;
    if (heightUnit == 'Feet/Inches') {
      List<String> heightInFeet = height.split('.');
      int feets = int.parse(heightInFeet[0]);
      int inches = int.parse(heightInFeet[1]);
      heightInCm = DataAnalyzeExtension.convertFeetInchesToCm(feets, inches);
    } else if (height == 'Inches') {
      heightInCm = DataAnalyzeExtension.convertInchestoCm(double.parse(height));
    } else {
      heightInCm = double.parse(height).round();
    }
    return heightInCm;
  }
}
