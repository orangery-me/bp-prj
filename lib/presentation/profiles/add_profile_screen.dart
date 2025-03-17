import 'package:blood_pressure/common/constants/constants.dart';
import 'package:blood_pressure/common/extensions/data_analyze_extension.dart';
import 'package:blood_pressure/data/models/profile.dart';
import 'package:blood_pressure/presentation/profiles/bloc/profile_bloc.dart';
import 'package:blood_pressure/presentation/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/select_component/select_components.dart';
import 'date_picker.dart';

class AddProfile extends StatefulWidget {
  final Profile? profile;
  const AddProfile({super.key, this.profile});

  @override
  State<AddProfile> createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? _selectedGender;
  final List<int> weights = List.generate(250, (index) => index + 1);
  final List<int> height = List.generate(250, (index) => index + 1);
  final List<double> fractions = List.generate(10, (index) => index / 10);
  final Map<String, String> _suffix = {
    'Weight': '',
    'Height': '',
  };
  double? _bmi;
  @override
  void initState() {
    super.initState();
    if (widget.profile != null) {
      final profile = widget.profile!;
      _nameController.text = profile.fullName;
      _selectedDate = profile.birthday;
      _dateController.text =
          '${profile.birthday.year} - ${profile.birthday.month} - ${profile.birthday.day}';
      _selectedGender = ProfileConstants.genders[profile.gender];
      _weightController.text = profile.weight;
      _heightController.text = profile.height;
      _suffix['Weight'] = profile.weightUnit;
      _suffix['Height'] = profile.heightUnit;
      _updateBMI();
      _weightController.addListener(_updateBMI);
      _heightController.addListener(_updateBMI);
    }
  }

  void _updateBMI() {
    double weight = 0;
    int heightInCm = 0;
    if (_suffix['Weight'] == 'Kgs') {
      weight = double.parse(_weightController.text);
    } else {
      weight = DataAnalyzeExtension.convertToKg(
          double.parse(_weightController.text));
    }

    if (_suffix['Height'] == 'Feet/Inches') {
      List<String> height = _heightController.text.split('.');
      int feets = int.parse(height[0]);
      int inches = int.parse(height[1]);
      heightInCm = DataAnalyzeExtension.convertFeetInchesToCm(feets, inches);
    } else if (_heightController.text == 'Inches') {
      heightInCm = DataAnalyzeExtension.convertInchestoCm(
          double.parse(_heightController.text));
    } else {
      heightInCm = double.parse(_heightController.text).round();
    }
    _bmi = DataAnalyzeExtension.getBMI(weight, heightInCm);
  }

  @override
  void dispose() {
    super.dispose();
    _weightController.dispose();
    _heightController.dispose();
  }

  void showDatePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            height: 450,
            child: DatePickerComponent(
              initialDate: _selectedDate,
              onDateSelected: (newDate) {
                setState(() {
                  _selectedDate = newDate;
                  _dateController.text =
                      '${newDate.year} - ${newDate.month} - ${newDate.day}';
                });
              },
            ),
          ),
        );
      },
    );
  }

  void _saveProfile() {
    final name = _nameController.text;
    final dateOfBirth = _selectedDate;
    final gender = ProfileConstants.genders.entries
        .firstWhere(
          (entry) => entry.value == _selectedGender,
          orElse: () => const MapEntry(0, 'Not found'),
        )
        .key;
    final weight =
        _weightController.text.isNotEmpty ? _weightController.text : null;
    final height =
        _heightController.text.isNotEmpty ? _heightController.text : null;

    final weightUnit = _suffix['Weight'] ?? '';
    final heightUnit = _suffix['Height'] ?? '';

    if (name.isEmpty ||
        dateOfBirth == null ||
        gender == 0 ||
        weight == null ||
        height == null) {
      showErrorDialog();
      return;
    }

    final newProfile = Profile(
      id: widget.profile?.id,
      fullName: name,
      birthday: dateOfBirth,
      gender: gender,
      weight: weight,
      weightUnit: weightUnit,
      height: height,
      heightUnit: heightUnit,
    );

    if (widget.profile == null) {
      BlocProvider.of<ProfileBloc>(context).add(PostProfile(newProfile));
    } else {
      BlocProvider.of<ProfileBloc>(context).add(UpdateProfile(newProfile));
      Navigator.pop(context);
    }
    Navigator.pop(context, true);
  }

  void showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Missing Information'),
          content: const Text('Please complete all fields before saving.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            widget.profile == null
                ? 'Add Profile Details'
                : 'Edit Profile Details',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Full Name'),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Full Name',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Date Of Birth (Optional)'),
                const SizedBox(height: 8),
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    hintText: 'Select your date of birth',
                    suffixIcon: const Icon(Icons.calendar_today),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onTap: showDatePicker,
                  readOnly: true,
                ),
                const SizedBox(height: 20),
                const Text('Gender (Optional)'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ProfileConstants.genders.entries.map((entry) {
                    return Expanded(
                      child: Center(
                        child: RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          title: Transform.translate(
                            offset: const Offset(-10, 0),
                            child: Text(
                              entry.value,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          value: entry.value,
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text('Weight'),
                const SizedBox(height: 8),
                TextField(
                  controller: _weightController,
                  decoration: InputDecoration(
                    hintText: 'Select your Weight',
                    suffixText: _suffix['Weight'],
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onTap: () => SelectComponents.showPicker(
                      context,
                      weights.map((e) => e.toString()).toList(),
                      fractions.map((e) => e.toStringAsFixed(1)).toList(),
                      ProfileConstants.weightUnits,
                      widget.profile != null
                          ? _weightController.text.split('.').first
                          : '50',
                      '0.${_weightController.text.split('.').last}', // fraction
                      widget.profile != null ? _suffix['Weight']! : 'Kgs',
                      'Weight', (Map<String, String> result) {
                    setState(() {
                      int whole = result['whole'] != null
                          ? int.parse(result['whole']!)
                          : 0;
                      double fraction = result['whole'] != null
                          ? double.parse(result['fraction']!)
                          : 0;
                      _suffix['Weight'] = result['unit'] ?? '';
                      double res = whole + fraction;
                      _weightController.text = '$res';
                    });
                  }),
                  readOnly: true,
                ),
                const SizedBox(height: 20),
                const Text('Height'),
                const SizedBox(height: 8),
                TextField(
                  controller: _heightController,
                  decoration: InputDecoration(
                    hintText: 'Select your Height',
                    suffixText: _suffix['Height'],
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onTap: () => SelectComponents.showPicker(
                    context,
                    height.map((e) => e.toString()).toList(),
                    fractions.map((e) => e.toStringAsFixed(1)).toList(),
                    ProfileConstants.heightUnits,
                    widget.profile != null
                        ? _heightController.text.split('.').first
                        : '150',
                    '0.${_heightController.text.split('.').last}',
                    widget.profile != null ? _suffix['Height']! : 'Centimeters',
                    'Height',
                    (Map<String, String> result) {
                      setState(() {
                        int whole = result['whole'] != null
                            ? int.parse(result['whole']!)
                            : 0;
                        double fraction = result['fraction'] != null
                            ? double.parse(result['fraction']!)
                            : 0;
                        _suffix['Height'] = result['unit'] ?? '';
                        double res = whole + fraction;
                        _heightController.text = '$res';
                      });
                    },
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 30),
                if (widget.profile != null)
                  Center(
                    child: Text(
                        'Body Mass Index (BMI)- ${_bmi?.toStringAsFixed(1)} Kgm2'),
                  ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE100FF), Color(0xFF7F00FF)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: 150,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
