part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, success, error }

final class ProfileState extends Equatable {
  final List<Profile> profiles;
  final ProfileStatus status;

  const ProfileState({
    this.profiles = const [],
    this.status = ProfileStatus.initial,
  });

  ProfileState copyWith({
    List<Profile>? profiles,
    ProfileStatus? status,
  }) {
    return ProfileState(
      profiles: profiles ?? this.profiles,
      status: status ?? this.status,
    );
  }
  @override
  List<Object?> get props => [profiles, status];
}
