import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/upload_avatar_usecase.dart';
import '../../domain/usecases/delete_avatar_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final UploadAvatarUseCase uploadAvatarUseCase;
  final DeleteAvatarUseCase deleteAvatarUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.uploadAvatarUseCase,
    required this.deleteAvatarUseCase,
  }) : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<UploadAvatarEvent>(_onUploadAvatar);
    on<DeleteAvatarEvent>(_onDeleteAvatar);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    // Don't emit loading if already loaded (prevent flicker)
    if (state is! ProfileLoaded) {
      emit(ProfileLoading());
    }

    final result = await getProfileUseCase(event.userId);

    result.fold(
      (failure) {
        if (!emit.isDone) emit(ProfileError(failure.message));
      },
      (profile) {
        if (!emit.isDone) emit(ProfileLoaded(profile));
      },
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    final result = await updateProfileUseCase(
      userId: event.userId,
      name: event.name,
      phone: event.phone,
      bio: event.bio,
    );

    result.fold(
      (failure) {
        if (!emit.isDone) emit(ProfileError(failure.message));
      },
      (profile) {
        if (!emit.isDone) emit(ProfileUpdated(profile));
      },
    );
  }

  Future<void> _onUploadAvatar(
    UploadAvatarEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    final result = await uploadAvatarUseCase(event.userId, event.imageFile);

    result.fold(
      (failure) {
        if (!emit.isDone) emit(ProfileError(failure.message));
      },
      (imageUrl) {
        if (!emit.isDone) emit(AvatarUploaded(imageUrl));
      },
    );
  }

  Future<void> _onDeleteAvatar(
    DeleteAvatarEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    final result = await deleteAvatarUseCase(event.userId);

    result.fold(
      (failure) {
        if (!emit.isDone) emit(ProfileError(failure.message));
      },
      (_) {
        if (!emit.isDone) emit(AvatarDeleted());
      },
    );
  }
}
