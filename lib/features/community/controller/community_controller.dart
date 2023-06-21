import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';

//Constants
import '../../../core/constants/constants.dart';

//Storage Repository
import '../../../core/providers/storage_repository_provider.dart';

//Failure
import '../../../core/failure.dart';

//Utilities
import '../../../core/utils.dart';

//Controller
import '../../auth/controller/auth_controller.dart';

//Repository
import '../repository/community_repository.dart';

//Models
import '../../../models/post_model.dart';
import '../../../models/community_model.dart';

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  final storageRepository = ref.watch(firebaseStorageProvider);
  return CommunityController(
    communityRepository: communityRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

final userCommunityProvider = StreamProvider.family((ref, String uid) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities(uid);
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

final searchCommunityProvider = StreamProvider.family((ref, String query) {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(query);
});

final getCommunityPostsProvider = StreamProvider.family((ref, String family) {
  return ref
      .read(communityControllerProvider.notifier)
      .getCommunityPosts(family);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  CommunityController({
    required CommunityRepository communityRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _communityRepository = communityRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  Stream<List<Community>> getUserCommunities(String uid) {
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  Stream<List<Post>> getCommunityPosts(String name) {
    return _communityRepository.getCommunityPosts(name);
  }

  void createCommunity(
      String name, String description, String username, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Community community = Community(
      id: name,
      name: name,
      description: description,
      admin: username,
      avatar: Constants.avatarDefault,
      banner: Constants.bannerDefault,
      members: [uid],
      moderators: [uid],
    );
    final result = await _communityRepository.createCommunity(community);
    state = false;
    result.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Community created successfully');
        Routemaster.of(context).pop();
      },
    );
  }

  void editCommunity({
    required File? avatarImage,
    required File? bannerImage,
    required Community community,
    required BuildContext context,
  }) async {
    state = true;
    if (avatarImage != null) {
      final res = await _storageRepository.storeFile(
          path: 'communities/avatar', id: community.name, file: avatarImage);
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => community = community.copyWith(avatar: r),
      );
    }
    if (bannerImage != null) {
      final res = await _storageRepository.storeFile(
          path: 'communities/banner', id: community.name, file: bannerImage);
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => community = community.copyWith(banner: r),
      );
    }
    state = false;
    final res = await _communityRepository.editCommunity(community);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  void joinCommunity(Community community, BuildContext context) async {
    final user = _ref.read(userProvider)!;
    Either<Failure, void> result;
    if (community.members.contains(user.uid)) {
      result =
          await _communityRepository.leaveCommunity(community.name, user.uid);
    } else {
      result =
          await _communityRepository.joinCommunity(community.name, user.uid);
    }
    result.fold(
      (l) => showSnackBar(context, l.message),
      (r) => showSnackBar(
        context,
        community.members.contains(user.uid)
            ? 'You left the community'
            : 'You joined the community',
      ),
    );
  }

  void addModerators(
      String communityName, List<String> uids, BuildContext context) async {
    final result =
        await _communityRepository.addModerators(communityName, uids);
    result.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Moderators added successfully');
        Routemaster.of(context).pop();
      },
    );
  }
}
