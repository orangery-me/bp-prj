import 'package:blood_pressure/common/helpers/hive_box.dart';
import 'package:blood_pressure/data/models/profile.dart';
import 'package:blood_pressure/data/repositories/profile_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc(this._profileRepository) : super(const ProfileState()) {
    on<PostProfile>(_postNewProfile);
    on<GetAllProfiles>(_getAllProfiles);
    on<UpdateProfile>(_updateProfile);
    on<DeleteProfile>(_deleteProfile);
  }
  Future<void> _postNewProfile(
      PostProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await _profileRepository.addProfile(event.profile);
      final newProfile = await _profileRepository.getLatestProfile();
      HiveBox.instance.userBox.put('current_active_profile', newProfile.id);

      emit(state.copyWith(
          profiles: [event.profile, ...state.profiles],
          status: ProfileStatus.success));

      add(GetAllProfiles());
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.error));
    }
  }

  Future<void> _getAllProfiles(
    GetAllProfiles event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      final List<Profile> profiles = await _profileRepository.getAllProfiles();
      emit(state.copyWith(profiles: profiles, status: ProfileStatus.success));
    } catch (e, stackTrace) {
      debugPrint('Error in _getAllProfiles: $e');
      debugPrint(stackTrace.toString());

      emit(state.copyWith(status: ProfileStatus.error));
    }
  }

  Future<void> _deleteProfile(
    DeleteProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      _profileRepository.deleteProfile(event.profileId);
      emit(state.copyWith(status: ProfileStatus.success));
      add(GetAllProfiles());
    } catch (e, stackTrace) {
      debugPrint('Error in _getAllProfiles: $e');
      debugPrint(stackTrace.toString());
    }
  }

  Future<void> _updateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      _profileRepository.updateProfile(event.profile);
      emit(state.copyWith(status: ProfileStatus.success));
      add(GetAllProfiles());
    } catch (e, stackTrace) {
      debugPrint('Error in Update: $e');
      debugPrint(stackTrace.toString());
    }
  }
}
