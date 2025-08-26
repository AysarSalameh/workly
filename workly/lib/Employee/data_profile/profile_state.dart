part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSaved extends ProfileState {

}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
class ProfileEdited extends ProfileState {
  final Map<String, dynamic> userData;
  ProfileEdited(this.userData);
}
class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> userData;
  ProfileLoaded(this.userData);
}
class ProfileImagePicked extends ProfileState {
  final File image;
  ProfileImagePicked(this.image);
}

class IdImagePicked extends ProfileState {
  final File image;
  IdImagePicked(this.image);
}
class CompanyLocationPicked extends ProfileState {
  final double latitude;
  final double longitude;

  CompanyLocationPicked(this.latitude, this.longitude);
}
class CompanyLocationLoading extends ProfileState {
}


class ProfileUploadProgress extends ProfileState {
  final double progress;
  final bool isProfile; // true: profile image, false: id image
  ProfileUploadProgress(this.progress, {required this.isProfile});
}
