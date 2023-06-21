import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

//Controller
import '../../auth/controller/auth_controller.dart';

//Theme Data
import '../../../theme/colours.dart';

class UserProfileDrawer extends ConsumerWidget {
  const UserProfileDrawer({super.key});

  void logout(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  void navigateToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/user/$uid');
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.avatar),
              radius: 50.0,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'u/${user.name}',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Divider(),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('User Profile'),
                    leading: const Icon(Icons.person),
                    onTap: () => navigateToUserProfile(context, user.uid),
                  ),
                  Switch.adaptive(
                    value: ref.watch(themeNotifierProvider.notifier).mode ==
                        ThemeMode.dark,
                    onChanged: (value) => toggleTheme(ref),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              onTap: () => logout(ref),
            ),
          ],
        ),
      ),
    );
  }
}
