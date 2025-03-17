import 'package:blood_pressure/common/helpers/hive_box.dart';
import 'package:blood_pressure/presentation/profiles/add_profile_screen.dart';
import 'package:blood_pressure/presentation/profiles/bloc/profile_bloc.dart';
import 'package:blood_pressure/presentation/profiles/profile_detail.dart';
import 'package:blood_pressure/presentation/profiles/profile_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late int selectedId;

  @override
  void initState() {
    super.initState();
    selectedId = HiveBox.instance.userBox
        .get('current_active_profile', defaultValue: -1);
    context.read<ProfileBloc>().add(GetAllProfiles());
  }

  void changeCurrentUser(int id) {
    HiveBox.instance.userBox.put('current_active_profile', id);
    setState(() {
      selectedId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profiles'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state.status == ProfileStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state.status == ProfileStatus.error) {
                return const Center(
                  child: Text('Error loading profiles!'),
                );
              } else if (state.profiles.isNotEmpty) {
                return ListView.builder(
                  itemCount: state.profiles.length,
                  itemBuilder: (context, index) {
                    final profile = state.profiles[index];
                    return ProfileItems(
                      id: profile.id!,
                      name: profile.fullName,
                      age: profile.getAge(),
                      selectedId: selectedId,
                      onSelect: changeCurrentUser,
                      onTap: () {
                        final profileBloc =
                            BlocProvider.of<ProfileBloc>(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (newContext) => BlocProvider.value(
                              value: profileBloc,
                              child: ProfileDetailScreen(profile: profile),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('No Profiles Found!'),
                );
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (newContext) => BlocProvider.value(
                            value: BlocProvider.of<ProfileBloc>(context),
                            child: const AddProfile(),
                          ),
                        ),
                      );
                    },
                    child: const Text('Add new')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
