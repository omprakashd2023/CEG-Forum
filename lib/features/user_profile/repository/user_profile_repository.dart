import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

//Providers
import '../../../core/providers/firebase_providers.dart';

//Models
import '../../../models/user_model.dart';

//Constants
import '../../../core/constants/firebase_constants.dart';

//Typedefs
import '../../../core/type_def.dart';

//Failure
import '../../../core/failure.dart';

final userProfileRepositoryProvider = Provider((ref) {
  return UserProfileRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class UserProfileRepository {
  final FirebaseFirestore _firestore;
  UserProfileRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid editProfile(UserModel user) async {
    try {
      return right(
        _users.doc(user.uid).update(user.toMap()),
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