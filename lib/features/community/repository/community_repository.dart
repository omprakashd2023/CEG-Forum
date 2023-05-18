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
}
