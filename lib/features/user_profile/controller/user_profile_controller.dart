import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

//Storage Repository
import '../../../core/providers/storage_repository_provider.dart';

//Utilities
import '../../../core/utils.dart';

//Controller
import '../../auth/controller/auth_controller.dart';

//Repository
import '../repository/user_profile_repository.dart';

//Models
import '../../../models/user_model.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(firebaseStorageProvider);
  return UserProfileController(
    userProfileRepository: userProfileRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void editProfile({
    required File? avatarImage,
    required File? bannerImage,
    required String name,
    required BuildContext context,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    if (avatarImage != null) {
      final res = await _storageRepository.storeFile(
        path: 'users/avatar',
        id: user.uid,
        file: avatarImage,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => user = user.copyWith(avatar: r),
      );
    }
    if (bannerImage != null) {
      final res = await _storageRepository.storeFile(
          path: 'users/banner', id: user.uid, file: bannerImage);
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => user = user.copyWith(banner: r),
      );
    }
    user = user.copyWith(name: name);
    final res = await _userProfileRepository.editProfile(user);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProvider.notifier).update((state) => user);
      Routemaster.of(context).pop();
    });
  }
}
