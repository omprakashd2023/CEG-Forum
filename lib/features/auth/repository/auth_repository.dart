import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Firebase Provider
import '../../../core/providers/firebase_providers.dart';

//Typedefs
import '../../../core/type_def.dart';

//Models
import '../../../models/user_model.dart';

//Constants
import '../../../core/constants/constants.dart';
import '../../../core/constants/firebase_constants.dart';

//Failure Class
import '../../../core/failure.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
    firestore: ref.read(firestoreProvider),
  ),
);

class AuthRepository {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  AuthRepository({
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _googleSignIn = googleSignIn,
        _firestore = firestore;
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserModel userModel;

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      if (userCredential.additionalUserInfo!.isNewUser) {
        print('New User');
        userModel = UserModel(
          name: userCredential.user!.displayName!,
          email: userCredential.user!.email!,
          avatar: userCredential.user!.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: userCredential.user!.uid,
          isAuthenticated: 'true',
          karma: 0,
          awards: [],
        );
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        print('Old User');
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (err) {
      throw err.message.toString();
    } catch (err) {
      print(err);
      return left(
        Failure(
          err.toString(),
        ),
      );
    }
  }

  bool isUserExists(String uid) {
    _users.doc(uid).get().then((doc) {
      if (doc.exists) {
        return true;
      } else {
        return false;
      }
    });
    return false;
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
          (snapshot) => UserModel.fromMap(
            snapshot.data() as Map<String, dynamic>,
          ),
        );
  }

  void logout() async{
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
