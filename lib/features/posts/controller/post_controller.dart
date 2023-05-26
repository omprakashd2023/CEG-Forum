import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

//Storage Repository
import '../../../core/providers/storage_repository_provider.dart';

//Utilities
import '../../../core/utils.dart';

//Controller
import '../../auth/controller/auth_controller.dart';

//Repository
import '../repository/post_repository.dart';

//Models
import '../../../models/post_model.dart';
import '../../../models/community_model.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(firebaseStorageProvider);
  return PostController(
    postRepository: postRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  PostController({
    required PostRepository postRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void shareTextPost({
    required BuildContext context,
    required String title,
    required String description,
    required Community community,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final Post post = Post(
      id: postId,
      title: title,
      communityName: community.name,
      communityAvatar: community.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      userName: user.name,
      userId: user.uid,
      type: 'text',
      createdAt: DateTime.now(),
      awards: [],
      description: description,
    );

    final result = await _postRepository.addPost(post);
    state = false;
    result.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posted successfully');
      Routemaster.of(context).pop();
    });
  }

  void shareLinkPost({
    required BuildContext context,
    required String title,
    required String link,
    required Community community,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final Post post = Post(
      id: postId,
      title: title,
      communityName: community.name,
      communityAvatar: community.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      userName: user.name,
      userId: user.uid,
      type: 'link',
      createdAt: DateTime.now(),
      awards: [],
      link: link,
    );

    final result = await _postRepository.addPost(post);
    state = false;
    result.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posted successfully');
      Routemaster.of(context).pop();
    });
  }

  void shareImagePost({
    required BuildContext context,
    required String title,
    required File? image,
    required Community community,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final imageRes = await _storageRepository.storeFile(
      id: postId,
      file: image,
      path: 'posts/${community.name}',
    );

    imageRes.fold(
      (l) => showSnackBar(context, l.message),
      (imageLink) async {
        final Post post = Post(
          id: postId,
          title: title,
          communityName: community.name,
          communityAvatar: community.avatar,
          upvotes: [],
          downvotes: [],
          commentCount: 0,
          userName: user.name,
          userId: user.uid,
          type: 'image',
          createdAt: DateTime.now(),
          awards: [],
          image: imageLink,
        );

        final result = await _postRepository.addPost(post);
        state = false;
        result.fold((l) => showSnackBar(context, l.message), (r) {
          showSnackBar(context, 'Posted successfully');
          Routemaster.of(context).pop();
        });
      },
    );
  }
}
