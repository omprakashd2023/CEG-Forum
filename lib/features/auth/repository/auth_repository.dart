import 'dart:core';
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

String generateUsername(String name) {
  final RegExp usernameRegExp = RegExp(r'[^a-zA-Z0-9_]+');
  final String sanitizedName =
      name.toLowerCase().replaceAll(usernameRegExp, '_');
  return sanitizedName;
}

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
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      UserModel userModel;
      if (userCredential.additionalUserInfo!.isNewUser) {
        final String name = generateUsername(
          userCredential.user!.displayName!,
        );
        userModel = UserModel(
          name: name,
          email: userCredential.user!.email!,
          avatar: userCredential.user!.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          description: '',
          uid: userCredential.user!.uid,
          isAuthenticated: 'true',
          karma: 0,
          awards: [
            'awesomeAns',
            'gold',
            'platinum',
            'helpful',
            'plusone',
            'rocket',
            'thankyou',
            'til',
          ],
        );
        await _users.doc(userCredential.user!.uid).set(
              userModel.toMap(),
            );
      } else {
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

  FutureEither<UserModel> signUpWithEmail(
      {String? username,
      required String email,
      required String password}) async {
    UserModel userModel;
    try {
      if (username != null) {
        final UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        userModel = UserModel(
          name: username,
          email: userCredential.user!.email!,
          avatar: Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: userCredential.user!.uid,
          description: '',
          isAuthenticated: 'false',
          karma: 0,
          awards: [
            'awesomeAns',
            'gold',
            'platinum',
            'helpful',
            'plusone',
            'rocket',
            'thankyou',
            'til',
          ],
        );
        await _users.doc(userCredential.user!.uid).set(
              userModel.toMap(),
            );
        await userCredential.user!.sendEmailVerification();
        // Wait for the user to verify their email
        await userCredential.user!.reload();
        final updatedUser = _auth.currentUser;
        if (updatedUser != null && updatedUser.emailVerified) {
          userModel.isAuthenticated = 'true';
        }
      } else {
        final UserCredential userCredential =
            await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        userModel = await getUserData(userCredential.user!.uid).first;
      }

      return right(userModel);
    } on FirebaseException catch (err) {
      throw err.message.toString();
    } catch (err) {
      print(err);
      return left(Failure(err.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
          (snapshot) => UserModel.fromMap(
            snapshot.data() as Map<String, dynamic>,
          ),
        );
  }

  Future<bool> checkUsernameExists(String username) async {
    final snapshot = await _users.where('name', isEqualTo: username).get();
    return snapshot.docs.isNotEmpty;
  }

  void logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
