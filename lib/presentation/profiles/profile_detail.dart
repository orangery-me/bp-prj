import 'package:blood_pressure/common/extensions/data_analyze_extension.dart';
import 'package:blood_pressure/presentation/profiles/add_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/profile.dart';
import 'bloc/profile_bloc.dart';

class ProfileDetailScreen extends StatelessWidget {
  final Profile profile;
  const ProfileDetailScreen({super.key, required this.profile});

  void showWarningDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Warning!',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: const Text(
            'Do you want to delete this profile?',
            style: TextStyle(color: Colors.grey),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    int id = profile.id!;
                    BlocProvider.of<ProfileBloc>(parentContext)
                        .add(DeleteProfile(id));
                    Navigator.of(context).pop();
                    Navigator.of(parentContext).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String gender = profile.gender == 1
        ? 'Male'
        : profile.gender == 2
            ? 'Female'
            : 'Others';
    double weight = 0;
    int heightInCm = 0;
    if (profile.weightUnit == 'Kgs') {
      weight = double.parse(profile.weight);
    } else {
      weight = DataAnalyzeExtension.convertToKg(double.parse(profile.weight));
    }

    if (profile.heightUnit == 'Feet/Inches') {
      List<String> height = profile.height.split('.');
      int feets = int.parse(height[0]);
      int inches = int.parse(height[1]);
      heightInCm = DataAnalyzeExtension.convertFeetInchesToCm(feets, inches);
    } else if (profile.heightUnit == 'Inches') {
      heightInCm =
          DataAnalyzeExtension.convertInchestoCm(double.parse(profile.height));
    } else {
      heightInCm = double.parse(profile.height).round();
    }
    String date = profile.birthday.toString().split(' ')[0];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildDetailRow('Full Name', profile.fullName),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailRow('Date Of Birth', date),
                Text(
                  '${profile.getAge()} years old',
                  style: const TextStyle(color: Colors.purple, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Gender', gender),
            const SizedBox(height: 16),
            _buildDetailRow(
                'Weight', '${profile.weight} ${profile.weightUnit}'),
            const SizedBox(height: 16),
            _buildDetailRow(
                'Height', '${profile.height} ${profile.heightUnit}'),
            const SizedBox(height: 16),
            _buildDetailRow(
              'Body Mass Index (BMI) - Metric Units',
              '${DataAnalyzeExtension.getBMI(weight, heightInCm).toStringAsFixed(1)} kg/m2',
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
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
                    onPressed: () {
                      final profileBloc = BlocProvider.of<ProfileBloc>(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (newContext) => BlocProvider.value(
                            value: profileBloc,
                            child: AddProfile(profile: profile),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: 150,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      showWarningDialog(context);
                      // int id = profile.id!;
                      //BlocProvider.of<ProfileBloc>(context).add(DeleteProfiles(id));
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
