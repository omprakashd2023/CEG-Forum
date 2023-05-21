import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Controller
import '../../auth/controller/auth_controller.dart';

//Widgets
import '../widgets/community_list_drawer.dart';
import '../widgets/user_profile_drawer.dart';

//Delegates
import '../delegates/search_community_delegate.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void showSearchDelegate(BuildContext context, WidgetRef ref) {
    showSearch(
      context: context,
      delegate: SearchCommunityDelegate(
        ref: ref,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => displayDrawer(context),
            );
          }
        ),
        actions: [
          IconButton(
            onPressed: () => showSearchDelegate(context, ref),
            icon: const Icon(Icons.search),
          ),
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () => displayEndDrawer(context),
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user.avatar),
                ),
              );
            }
          ),
        ],
      ),
      drawer: const CommunityListDrawer(),
      endDrawer: const UserProfileDrawer(),
    );
  }
}
