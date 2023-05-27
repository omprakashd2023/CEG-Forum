import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

//Enums
import '../../../core/enums/enums.dart';

//Storage Repository
import '../../../core/providers/storage_repository_provider.dart';

//Utilities
import '../../../core/utils.dart';

//Controller
import '../../user_profile/controller/user_profile_controller.dart';
import '../../auth/controller/auth_controller.dart';

//Repository
import '../repository/post_repository.dart';

//Models
import '../../../models/post_model.dart';
import '../../../models/community_model.dart';
import '../../../models/comment_model.dart';

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

final userPostProvider =
    StreamProvider.family((ref, List<Community> communities) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts(communities);
});

final getLatestPostsProvider = StreamProvider((ref) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchLatestPosts();
});

final getPostByIdProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostById(postId);
});

final getPostCommentsProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchPostComments(postId);
});

final getSearchPostsProvider = StreamProvider.family((ref, String query) {
  return ref.watch(postControllerProvider.notifier).searchPosts(query);
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
    required Community? community,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final Post post = Post(
      id: postId,
      title: title,
      communityName: community?.name,
      communityAvatar: community?.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      userName: user.name,
      userId: user.uid,
      userAvatar: user.avatar,
      type: 'text',
      createdAt: DateTime.now(),
      awards: [],
      description: description,
    );
    final result = await _postRepository.addPost(post);
    state = false;
    result.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProfileControllerProvider.notifier).updateUserKarma(
            UserKarma.textPost,
            context,
          );
      showSnackBar(context, 'Posted successfully');
      Routemaster.of(context).pop();
    });
  }

  void shareLinkPost({
    required BuildContext context,
    required String title,
    required String link,
    required Community? community,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final Post post = Post(
      id: postId,
      title: title,
      communityName: community?.name,
      communityAvatar: community?.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      userName: user.name,
      userAvatar: user.avatar,
      userId: user.uid,
      type: 'link',
      createdAt: DateTime.now(),
      awards: [],
      link: link,
    );

    final result = await _postRepository.addPost(post);
    state = false;
    result.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProfileControllerProvider.notifier).updateUserKarma(
            UserKarma.linkPost,
            context,
          );
      showSnackBar(context, 'Posted successfully');
      Routemaster.of(context).pop();
    });
  }

  void shareImagePost({
    required BuildContext context,
    required String title,
    required File? image,
    required Community? community,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final path = community != null
        ? 'posts/community/${community.name}'
        : 'posts/users/${user.uid}';
    final imageRes = await _storageRepository.storeFile(
      id: postId,
      file: image,
      path: path,
    );

    imageRes.fold(
      (l) => showSnackBar(context, l.message),
      (imageLink) async {
        final Post post = Post(
          id: postId,
          title: title,
          communityName: community?.name,
          communityAvatar: community?.avatar,
          upvotes: [],
          downvotes: [],
          commentCount: 0,
          userName: user.name,
          userAvatar: user.avatar,
          userId: user.uid,
          type: 'image',
          createdAt: DateTime.now(),
          awards: [],
          image: imageLink,
        );

        final result = await _postRepository.addPost(post);
        state = false;
        result.fold((l) => showSnackBar(context, l.message), (r) {
          _ref.read(userProfileControllerProvider.notifier).updateUserKarma(
                UserKarma.imagePost,
                context,
              );
          showSnackBar(context, 'Posted successfully');
          Routemaster.of(context).pop();
        });
      },
    );
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPosts(communities);
    }
    return Stream.value([]);
  }

  Stream<List<Post>> fetchLatestPosts() {
    return _postRepository.fetchLatestPosts();
  }

  void deletePost(BuildContext context, Post post) async {
    final result = await _postRepository.deletePost(post);
    result.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProfileControllerProvider.notifier).updateUserKarma(
            UserKarma.deletePost,
            context,
          );
      showSnackBar(context, 'Post deleted successfully');
    });
  }

  Stream<List<Post>> searchPosts(String query) {
    return _postRepository.searchPosts(query);
  }

  void upvotePost(Post post) async {
    final userId = _ref.read(userProvider)!.uid;
    _postRepository.upvotePost(post, userId);
  }

  void downvotePost(Post post) async {
    final userId = _ref.read(userProvider)!.uid;
    _postRepository.downvotePost(post, userId);
  }

  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  void addComment({
    required BuildContext context,
    required String text,
    required Post post,
  }) async {
    final user = _ref.read(userProvider)!;
    final commentId = const Uuid().v1();
    Comment comment = Comment(
      id: commentId,
      comment: text,
      createdAt: DateTime.now(),
      postId: post.id,
      userName: user.name,
      userId: user.uid,
      userAvatar: user.avatar,
    );
    final result = await _postRepository.addComment(comment);
    result.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProfileControllerProvider.notifier).updateUserKarma(
            UserKarma.comment,
            context,
          );
      showSnackBar(context, 'Comment added successfully');
    });
  }

  Stream<List<Comment>> fetchPostComments(String postId) {
    return _postRepository.fetchPostComments(postId);
  }

  void awardPost({
    required BuildContext context,
    required Post post,
    required String award,
  }) async {
    final user = _ref.read(userProvider)!;
    final result = await _postRepository.awardPost(
      post,
      award,
      user.uid,
    );
    result.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProfileControllerProvider.notifier).updateUserKarma(
            UserKarma.awardPost,
            context,
          );
      _ref.read(userProvider.notifier).update(
        (state) {
          state!.awards.remove(award);
          print(state.awards);
          return state;
        },
      );
      Routemaster.of(context).pop();
      showSnackBar(context, 'Awarded successfully');
    });
  }
}
