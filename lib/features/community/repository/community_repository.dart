import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

//Providers
import '../../../core/providers/firebase_providers.dart';

//Constants
import '../../../core/constants/firebase_constants.dart';

//Failure
import '../../../core/failure.dart';

//Typedefs
import '../../../core/type_def.dart';

//Models
import '../../../models/community_model.dart';
import '../../../models/post_model.dart';

final communityRepositoryProvider = Provider((ref) {
  return CommunityRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class CommunityRepository {
  final FirebaseFirestore _firestore;
  CommunityRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid createCommunity(Community community) async {
    try {
      var communityDoc = await _communities.doc(community.name).get();
      if (communityDoc.exists) {
        throw Failure('Community already exists');
      }
      return right(
        _communities.doc(community.name).set(community.toMap()),
      );
    } on FirebaseException catch (err) {
      throw err.message!;
    } catch (err) {
      return left(
        Failure(err.toString()),
      );
    }
  }

  Stream<List<Community>> getUserCommunities(String uid) {
    return _communities
        .where('members', arrayContains: uid)
        .snapshots()
        .map((snapshot) {
      List<Community> communities = [];
      for (var doc in snapshot.docs) {
        communities.add(
          Community.fromMap(doc.data() as Map<String, dynamic>),
        );
      }
      return communities;
    });
  }

  Stream<Community> getCommunityByName(String name) {
    return _communities.doc(name).snapshots().map(
          (snapshot) => Community.fromMap(
            snapshot.data() as Map<String, dynamic>,
          ),
        );
  }

  FutureVoid editCommunity(Community community) async {
    try {
      return right(
        _communities.doc(community.name).update(
              community.toMap(),
            ),
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

  FutureVoid joinCommunity(String communityName, String userId) async {
    try {
      return right(
        _communities.doc(communityName).update(
          {
            'members': FieldValue.arrayUnion([userId])
          },
        ),
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

  FutureVoid leaveCommunity(String communityName, String userId) async {
    try {
      return right(
        _communities.doc(communityName).update(
          {
            'members': FieldValue.arrayRemove([userId])
          },
        ),
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

  Stream<List<Community>> searchCommunity(String query) {
    return _communities
        .where(
          'name',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map(
      (snapshot) {
        List<Community> communities = [];
        for (var doc in snapshot.docs) {
          communities.add(
            Community.fromMap(
              doc.data() as Map<String, dynamic>,
            ),
          );
        }
        return communities;
      },
    );
  }

  FutureVoid addModerators(String communityName, List<String> uids) async {
    try {
      return right(
        _communities.doc(communityName).update({
          'moderators': uids,
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

  Stream<List<Post>> getCommunityPosts(String name) {
    return _posts
        .where('communityName', isEqualTo: name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(
              (doc) => Post.fromMap(
                doc.data() as Map<String, dynamic>,
              ),
            )
            .toList());
  }
}
