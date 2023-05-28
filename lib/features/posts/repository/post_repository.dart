import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

//Failure
import '../../../core/failure.dart';

//Typedefs
import '../../../core/type_def.dart';

//Constants
import '../../../core/constants/firebase_constants.dart';

//Providers
import '../../../core/providers/firebase_providers.dart';

//Models
import '../../../models/community_model.dart';
import '../../../models/post_model.dart';
import '../../../models/comment_model.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  CollectionReference get _comments =>
      _firestore.collection(FirebaseConstants.commentsCollection);

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (err) {
      throw err.message!;
    } catch (err) {
      return left(
        Failure(
          err.toString(),
        ),
      );
    }
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    return _posts
        .where('communityName',
            whereIn: communities.map((community) => community.name).toList())
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (post) => Post.fromMap(
                  post.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  Stream<List<Post>> fetchLatestPosts() {
    return _posts.orderBy('createdAt', descending: true).snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (post) => Post.fromMap(
                  post.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  FutureVoid deletePost(Post post) async {
    try {
      return right(
        _posts.doc(post.id).delete(),
      );
    } on FirebaseException catch (err) {
      throw err.message!;
    } catch (err) {
      return left(
        Failure(
          err.toString(),
        ),
      );
    }
  }

  void upvotePost(Post post, String userId) async {
    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
    }
    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  void downvotePost(Post post, String userId) async {
    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
    }
    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  Stream<Post> getPostById(String postId) {
    return _posts.doc(postId).snapshots().map(
          (snapshot) => Post.fromMap(
            snapshot.data() as Map<String, dynamic>,
          ),
        );
  }

  Stream<List<Post>> searchPosts(String query) {
    final lowercaseQuery = query.toLowerCase();

    return _posts.snapshots().map((snapshot) {
      List<Post> posts = [];
      for (var doc in snapshot.docs) {
        var postData = doc.data() as Map<String, dynamic>;
        var post = Post.fromMap(postData);
        if (post.title.toLowerCase().contains(lowercaseQuery)) {
          posts.add(post);
        }
      }
      return posts;
    });
  }


  FutureVoid addComment(Comment comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());
      return right(_posts.doc(comment.postId).update({
        'commentCount': FieldValue.increment(1),
      }));
    } on FirebaseException catch (err) {
      throw err.message!;
    } catch (err) {
      return left(
        Failure(
          err.toString(),
        ),
      );
    }
  }

  Stream<List<Comment>> fetchPostComments(String postId) {
    return _comments
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (comment) => Comment.fromMap(
                  comment.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  FutureVoid awardPost(Post post, String award, String senderId) async {
    try {
      _posts.doc(post.id).update({
        'awards': FieldValue.arrayUnion([award]),
      });
      _users.doc(senderId).update({
        'awards': award,
      });
      return right(
        _users.doc(post.userId).update({
          'awards': FieldValue.arrayUnion([award]),
        }),
      );
    } on FirebaseException catch (err) {
      throw err.message!;
    } catch (err) {
      return left(
        Failure(
          err.toString(),
        ),
      );
    }
  }
}
