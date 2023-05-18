import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

//Models
import '../../../models/community_model.dart';

//Controller
import '../../community/controller/community_controller.dart';

//Widgets
import '../../../core/widgets/error_text.dart';
import '../../../core/widgets/loader.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const ListTile(
              title: Text(
                'Your Communities',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              leading: Icon(Icons.group),
            ),
            ref.watch(userCommunityProvider).when(
                  data: (communities) => Expanded(
                    child: ListView.builder(
                      itemCount: communities.length,
                      itemBuilder: (context, index) {
                        final community = communities[index];
                        return ListTile(
                          title: Text('ceg/${community.name}'),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                          ),
                          onTap: () => navigateToCommunity(context, community),
                        );
                      },
                    ),
                  ),
                  error: (error, stackTrace) =>
                      ErrorText(errorText: error.toString()),
                  loading: () => const Loader(),
                ),
            const Divider(),
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
