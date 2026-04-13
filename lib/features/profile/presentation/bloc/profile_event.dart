part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {
  final String userId;

  const LoadProfileEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateProfileEvent extends ProfileEvent {
  final String userId;
  final String? name;
  final String? phone;
  final String? bio;

  const UpdateProfileEvent({
    required this.userId,
    this.name,
    this.phone,
    this.bio,
  });

  @override
  List<Object?> get props => [userId, name, phone, bio];
}

class UploadAvatarEvent extends ProfileEvent {
  final String userId;
  final XFile imageFile;

  const UploadAvatarEvent({
    required this.userId,
    required this.imageFile,
  });

  @override
  List<Object?> get props => [userId, imageFile];
}

class DeleteAvatarEvent extends ProfileEvent {
  final String userId;

  const DeleteAvatarEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}
