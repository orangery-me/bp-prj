import 'dart:developer';
import 'package:blood_pressure/presentation/profiles/add_profile_screen.dart';
import 'package:blood_pressure/common/helpers/hive_box.dart';
import 'package:blood_pressure/data/models/profile.dart';
import 'package:blood_pressure/data/repositories/measurement_repository.dart';
import 'package:blood_pressure/data/repositories/profile_repository.dart';
import 'package:blood_pressure/presentation/analytics/views/analytics_page.dart';
import 'package:blood_pressure/presentation/home/nav_bar.dart';
import 'package:blood_pressure/presentation/measurements/views/add_measurement_screen1/add_figure_page.dart';
import 'package:blood_pressure/presentation/measurements/bloc/measurements/measurement_bloc.dart';
import 'package:blood_pressure/presentation/measurements/views/measurement_diary_page.dart';
import 'package:blood_pressure/presentation/profiles/bloc/profile_bloc.dart';
import 'package:blood_pressure/presentation/profiles/profile_page.dart';
import 'package:blood_pressure/presentation/setting/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.isProfileExists = true});
  final bool isProfileExists;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MeasurementBloc>(
          create: (context) => MeasurementBloc(MeasurementRepository()),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(ProfileRepository()),
        ),
      ],
      child: MyHomeView(isProfileExists: widget.isProfileExists),
    );
  }
}

class MyHomeView extends StatefulWidget {
  const MyHomeView({super.key, required this.isProfileExists});
  final bool isProfileExists;

  @override
  State<MyHomeView> createState() => _MyHomeViewState();
}

class _MyHomeViewState extends State<MyHomeView> {
  // final ValueNotifier<int> _currentProfileId = ValueNotifier(-1);
  // late int _profileId;
  int _selectedIndex = 0;
  int _currentProfileId = -1;
  late Profile? _currentProfile;

  void _openAddMeasurementScreen(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => BlocProvider.value(
              value: BlocProvider.of<MeasurementBloc>(context),
              child: AddFigurePage(currentProfile: _currentProfile!),
            )));
  }

  Widget _buildPageContent(List<Profile> profiles) {
    return ValueListenableBuilder(
        valueListenable: HiveBox.instance.userBox
            .listenable(keys: ['current_active_profile']),
        builder: (_, box, __) {
          _currentProfileId =
              box.get('current_active_profile', defaultValue: -1);
          _currentProfile = profiles.isNotEmpty
              ? profiles.firstWhere(
                  (element) => element.id == _currentProfileId,
                  orElse: () => profiles.first)
              : null;
          if (_currentProfile != null && _currentProfileId != -1) {
            log('current id: $_currentProfileId');
            switch (_selectedIndex) {
              case 0:
                return MeasurementDiaryPage(currentProfile: _currentProfile!);
              case 1:
                return AnalyticsPage(profileId: _currentProfileId);
              case 2:
                return const ProfilePage();
              case 3:
                return Setting(profileId: _currentProfileId);
              default:
                return const Center(child: Text('Unknown Page'));
            }
          } else {
            return const Center(child: Text('No profile selected'));
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    context.read<ProfileBloc>().add(GetAllProfiles());

    return BlocBuilder<ProfileBloc, ProfileState>(builder: (_, state) {
      if (state.status == ProfileStatus.loading) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return Scaffold(
          bottomNavigationBar: NavBar(
            selectedIndex: _selectedIndex,
            onItemTapped: (index) => setState(() {
              _selectedIndex = index;
            }),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: SizedBox(
            width: 60,
            height: 60,
            child: FloatingActionButton(
                onPressed: () => _openAddMeasurementScreen(context),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40))),
                backgroundColor: const Color(0xFF6650DD),
                child: SvgPicture.asset(
                  'assets/icons/MaterialSymbolsAdd.svg',
                  color: Colors.white,
                )),
          ),
          body: widget.isProfileExists
              ? _buildPageContent(state.profiles)
              : const AddProfile(),
        );
      }
    });
  }
}
