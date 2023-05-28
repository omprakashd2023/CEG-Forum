import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

//Models
import '../../../models/user_model.dart';

//Repository
import '../repository/auth_repository.dart';

//Utilities
import '../../../core/utils.dart';

final userProvider = StateProvider<UserModel?>(
  (ref) => null,
);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref,
        super(false); // Loading Part

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  //SignIn Function
  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
      (l) {
        showSnackBar(context, l.message);
        Routemaster.of(context).pop();
      },
      (userModel) => _ref.read(userProvider.notifier).update(
            (state) => userModel,
          ),
    );
  }

  //SignIn with Email and Password Function
  void signInWithEmail(BuildContext context, String? username, String email,
      String password) async {
    state = true;
    final user = await _authRepository.signUpWithEmail(
      email: email,
      password: password,
      username: username,
    );
    state = false;
    user.fold((l) {
      showSnackBar(context, l.message);
      Routemaster.of(context).pop();
    }, (userModel) {
      _ref.read(userProvider.notifier).update((state) => userModel);
      Routemaster.of(context).push('/');
    });
  }

  Future<bool> checkUsernameExists(String username) async {
    return _authRepository.checkUsernameExists(username);
  }

  void logout() async {
    _authRepository.logout();
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }
}
