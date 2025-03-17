part of 'profile_bloc.dart';


class ProfileEvent {}

class PostProfile extends ProfileEvent {
  final Profile profile;

  PostProfile(this.profile);
}
class GetAllProfiles extends ProfileEvent {
  GetAllProfiles();
}
class DeleteProfile extends ProfileEvent {
  final int profileId;
  DeleteProfile(this.profileId);
}
class UpdateProfile extends ProfileEvent {
  final Profile profile;

  UpdateProfile(this.profile);
}

