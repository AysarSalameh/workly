part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSaved extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileImagePicked extends ProfileState {
  final File image;
  ProfileImagePicked(this.image);
}

class IdImagePicked extends ProfileState {
  final File image;
  IdImagePicked(this.image);
}
class ProfileUploadProgress extends ProfileState {
  final double progress;
  final bool isProfile; // true: profile image, false: id image
  ProfileUploadProgress(this.progress, {required this.isProfile});
}
