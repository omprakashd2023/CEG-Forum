import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Controllers
import '../../features/auth/controller/auth_controller.dart';

//Constants
import '../constants/constants.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton({
    super.key,
  });

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: InkWell(
        onTap: () => signInWithGoogle(context, ref),
        child: CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 25,
          child: Image.asset(
            Constants.googlePath,
            width: 35,
          ),
        ),
      ),
    );
  }
}
