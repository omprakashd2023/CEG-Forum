import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

//Models
import '../../../models/community_model.dart';

//Controller
import '../../auth/controller/auth_controller.dart';
import '../../community/controller/community_controller.dart';

//Widgets
import '../../../core/widgets/sign_in_button.dart';
import '../../../core/widgets/error_text.dart';
import '../../../core/widgets/loader.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/ceg/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = user.isAuthenticated == 'false' ? true : false;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            isGuest
                ? const SignInButton()
                : const ListTile(
                    title: Text(
                      'Your Communities',
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    leading: Icon(Icons.group),
                  ),
            if (!isGuest)
              ref.watch(userCommunityProvider(user.uid)).when(
                    data: (communities) => Expanded(
                      child: ListView.builder(
                        itemCount: communities.length,
                        itemBuilder: (context, index) {
                          final community = communities[index];
                          print(community.name);
                          return ListTile(
                            title: Text('ceg/${community.name}'),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(community.avatar),
                            ),
                            onTap: () =>
                                navigateToCommunity(context, community),
                          );
                        },
                      ),
                    ),
                    error: (error, stackTrace) =>
                        ErrorText(errorText: error.toString()),
                    loading: () => const Loader(),
                  ),
            const Divider(),
            if (!isGuest)
              ListTile(
                title: const Text('Create a Community'),
                leading: const Icon(Icons.add),
                onTap: () => navigateToCreateCommunity(context),
              ),
          ],
        ),
      ),
    );
  }
}
